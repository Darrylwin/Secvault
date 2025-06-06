import 'dart:io';
import 'package:cross_file_picker/cross_file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:secvault/core/helpers/encryption_helper.dart';
import 'package:secvault/features/secured_files/domain/entities/secured_file.dart';
import 'package:secvault/features/secured_files/presentation/bloc/secured_file_bloc.dart';
import 'package:secvault/features/secured_files/presentation/bloc/secured_file_event.dart';
import 'package:secvault/features/secured_files/presentation/bloc/secured_file_state.dart';
import 'package:secvault/features/secured_files/presentation/widgets/confirm_file_delete_dialog.dart';
import 'package:secvault/features/secured_files/presentation/widgets/file_card.dart';
import 'package:secvault/features/vaults/presentation/bloc/vault_bloc.dart';
import 'package:secvault/features/vaults/presentation/bloc/vault_event.dart';
import 'package:secvault/features/vaults/presentation/widgets/confirm_vault_delete_dialog.dart';
import 'package:secvault/features/vaults/presentation/widgets/my_action_button.dart';

class VaultDetails extends StatefulWidget {
  const VaultDetails({
    super.key,
    required this.vaultId,
    required this.vaultName,
    required this.createdAt,
  });

  final String vaultId;
  final String vaultName;
  final DateTime createdAt;

  @override
  State<VaultDetails> createState() => _VaultDetailsState();
}

class _VaultDetailsState extends State<VaultDetails> {
  late final BlocListener<SecuredFileBloc, SecuredFileState> _blocListener;

  @override
  void initState() {
    super.initState();
    context.read<SecuredFileBloc>().add(ListSecuredFilesEvent(widget.vaultId));
    _setupBlocListener();
  }

  void _setupBlocListener() {
    _blocListener = BlocListener<SecuredFileBloc, SecuredFileState>(
      listenWhen: (previous, current) => current is SecuredFileDownloadSuccess,
      listener: (context, state) async {
        if (state is SecuredFileDownloadSuccess) {
          if (state.forDownloadOnly == true) {
            //just download the file without opening it
            await _downloadFile(
              context,
              file: state.file,
              vaultId: widget.vaultId,
            );
          } else {
            //open file after download
            await _openDownloadedFile(state.file);
          }
        }
      },
    );
  }

  void _onFileCardTapped({
    required String fileId,
    required String fileName,
  }) async {
    String filePath;
    if (Platform.isWindows) {
      final tempPath = '${Platform.environment['TEMP']}\\secvault_temp';
      filePath = '$tempPath\\$fileName';
    } else {
      final tempDir = await getTemporaryDirectory();
      filePath = '${tempDir.path}/$fileName';
    }

    final fileObj = File(filePath);
    if (await fileObj.exists()) {
      //open file directly in local
      await _openDownloadedFileLocal(filePath);
    } else {
      //download and open
      context.read<SecuredFileBloc>().add(
        DownloadSecuredFileEvent(
            vaultId: widget.vaultId,
            fileId: fileId,
            forDownloadOnly:
            false // false means we want to open the file after download
        ),
      );
    }
  }

  Future<void> _downloadFile(BuildContext context, {
    required SecuredFile file,
    required String vaultId,
  }) async {
    String filePath;
    if (Platform.isWindows) {
      final tempPath = '${Platform.environment['TEMP']}\\secvault_temp';
      filePath = '$tempPath\\${file.fileName}';
    } else {
      final tempDir = await getTemporaryDirectory();
      filePath = '${tempDir.path}/${file.fileName}';
    }
    final decryptedData = EncryptionHelper.decryptData(file.encryptedData);
    final fileObj = File(filePath);
    await fileObj.writeAsBytes(decryptedData);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('File sucessfully downloaded')),
    );
    context.read<SecuredFileBloc>().add(ListSecuredFilesEvent(vaultId));
  }

  Future<void> _openDownloadedFileLocal(filePath) async {
    try {
      if (Platform.isWindows) {
        await _openFileWithWindowsShell(filePath);
      } else {
        final result = await OpenFile.open(filePath);
        debugPrint('Opening result: ${result.type} - ${result.message}');
        if (result.type != ResultType.done) {
          debugPrint("Error opening file locally: ${result.message}");
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text("Error opening file locally: ${result.message}")),
          );
        }
      }
      debugPrint("File opened successfully");
      // Après l'ouverture du fichier
      context
          .read<SecuredFileBloc>()
          .add(ListSecuredFilesEvent(widget.vaultId));
    } catch (e) {
      debugPrint("Error opening file locally: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error opening file locally: $e")),
      );
    }
  }

  Future<void> _openFileWithWindowsShell(String filePath) async {
    try {
      await Process.start('explorer', [filePath]);
    } catch (e) {
      debugPrint('Error while opening ile with explorer: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error while opening ile with explorer: $e')),
      );
    }
  }

  Future<void> _openDownloadedFile(SecuredFile file) async {
    debugPrint('Starting file opening process');
    try {
      debugPrint(
          'File to open: ${file.fileName}, encrypted size: ${file.encryptedData
              .length}');
      debugPrint(
          'encryptedData (start): ${file.encryptedData.substring(0, 30)}');

      String filePath;

      if (Platform.isWindows) {
        final tempPath = '${Platform.environment['TEMP']}\\secvault_temp';
        final directory = Directory(tempPath);
        if (!await directory.exists()) {
          await directory.create(recursive: true);
        }
        filePath = '$tempPath\\${file.fileName}';
      } else {
        final tempDir = await getTemporaryDirectory();
        filePath = '${tempDir.path}/${file.fileName}';
      }

      debugPrint("Attempting to open file. Path: $filePath");

      // Déchiffrement
      final decryptedData = EncryptionHelper.decryptData(file.encryptedData);
      debugPrint("Decrypted data size: ${decryptedData.length} bytes");

      final fileObj = File(filePath);
      await fileObj.writeAsBytes(decryptedData);

      if (await fileObj.exists()) {
        debugPrint(
            'File created successfully (size: ${await fileObj
                .length()} bytes)');
      } else {
        debugPrint('Error: File was not created');
        return;
      }

      if (Platform.isWindows) {
        await _openFileWithWindowsShell(filePath);
      } else {
        final result = await OpenFile.open(filePath);
        debugPrint('Opening result: ${result.type} - ${result.message}');
        if (result.type != ResultType.done) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Error opening file: ${result.message}")),
          );
        }
      }
      debugPrint("File opened successfully");
      // Après l'ouverture du fichier
      context
          .read<SecuredFileBloc>()
          .add(ListSecuredFilesEvent(widget.vaultId));
    } catch (e) {
      debugPrint("Error opening file: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error opening file: $e")),
      );
    }
  }

  Future<void Function()?> _onDownloadPressed({
    required String fileId,
    required String fileName,
  }) async {
    // just download the file without open it
    context.read<SecuredFileBloc>().add(DownloadSecuredFileEvent(
      vaultId: widget.vaultId,
      fileId: fileId,
      forDownloadOnly: true,
    ));
  }

  void Function()? _onDeletePressed(String fileId) {
    showDialog(
      context: context,
      builder: (context) =>
          ConfirmFileDeleteDialog(
            onPressed: () {
              final bloc = context.read<SecuredFileBloc>();
              Navigator.of(context).pop();
              bloc.add(
                DeleteSecuredFileEvent(
                  vaultId: widget.vaultId,
                  fileId: fileId,
                ),
              );
            },
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    void Function()? onDeleteVaultTapped() {
      showDialog(
        context: context,
        builder: (context) =>
            ConfirmVaultDeleteDialog(
              onPressed: () {
                context.read<VaultBloc>().add(DeleteVault(widget.vaultId));
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
            ),
      );
    }

    Future<void Function()?> uploadFile() async {
      try {
        final picker = CrossFilePicker();
        final result = await picker.pickSingleFile(type: FileType.any);

        if (result != null) {
          final fileName = result.name;
          final fileBytes = await result.readAsBytes();

          context.read<SecuredFileBloc>().add(
            UploadSecuredFileEvent(
              vaultId: widget.vaultId,
              fileName: fileName,
              rawData: fileBytes,
            ),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString())),
        );
      }
    }

    return BlocListener<SecuredFileBloc, SecuredFileState>(
      listenWhen: _blocListener.listenWhen,
      listener: _blocListener.listener,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0,
          title: const Text(
            "Vault Details",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontSize: 20,
            ),
          ),
          centerTitle: true,
          actions: [
            IconButton(
              icon: const Icon(Icons.more_vert, color: Colors.white),
              onPressed: () {
                // Show options menu
              },
            ),
          ],
        ),
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Vault info card
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 15),
                child: Card(
                  elevation: 4,
                  shadowColor: Colors.black26,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.vaultName,
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.calendar_today,
                                      size: 14,
                                      color: Colors.grey[600],
                                    ),
                                    const SizedBox(width: 5),
                                    Text(
                                      'Created on ${DateFormat('MMM dd, yyyy')
                                          .format(widget.createdAt)}',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Theme
                                    .of(context)
                                    .colorScheme
                                    .primary
                                    .withOpacity(0.1),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.folder,
                                color: Theme
                                    .of(context)
                                    .colorScheme
                                    .primary,
                                size: 28,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // Action buttons
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    MyActionButton(
                      icon: Icons.upload_file,
                      label: 'Upload',
                      onTap: uploadFile,
                    ),
                    MyActionButton(
                      icon: Icons.people,
                      label: 'Members',
                      onTap: () {
                        Navigator.of(context).pushNamed(
                          '/vault-members',
                          arguments: widget.vaultId,
                        );
                      },
                    ),
                    MyActionButton(
                      icon: Icons.person_add,
                      label: 'Invite',
                      onTap: () {},
                    ),
                    MyActionButton(
                      icon: Icons.delete_outline,
                      label: 'Delete',
                      onTap: onDeleteVaultTapped,
                    ),
                  ],
                ),
              ),

              BlocBuilder<SecuredFileBloc, SecuredFileState>(
                builder: (context, state) {
                  if (state is SecuredFileLoading) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (state is SecuredFileListSuccess) {
                    final files = state.files;
                    if (files.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.folder_off_outlined,
                              size: 80,
                              color: Colors.grey[400],
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'No secured files yet',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.grey[600],
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Upload files to secure them in this vault',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[500],
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                    return Center(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // Files header
                          Padding(
                            padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Secured Files',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                CircleAvatar(
                                  backgroundColor:
                                  Theme
                                      .of(context)
                                      .colorScheme
                                      .primary,
                                  radius: 12,
                                  child: Text(
                                    '${files.length}',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // Files list
                          ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            padding: const EdgeInsets.fromLTRB(16, 8, 16, 80),
                            itemCount: files.length,
                            itemBuilder: (context, index) {
                              final file = files[index];
                              final String fileExtension =
                              file.fileName
                                  .split('.')
                                  .last
                                  .toLowerCase();
                              return FileCard(
                                fileExtension: fileExtension,
                                fileName: file.fileName,
                                uploadedAt: file.uploadedAt,
                                onDeletePressed: () =>
                                    _onDeletePressed(file.fileId),
                                onDownloadPressed: () =>
                                    _onDownloadPressed(
                                      fileId: file.fileId,
                                      fileName: file.fileName,
                                    ),
                                onFileCardTapped: () =>
                                    _onFileCardTapped(
                                      fileId: file.fileId,
                                      fileName: file.fileName,
                                    ),
                              );
                            },
                          ),
                        ],
                      ),
                    );
                  } else if (state is SecuredFileError) {
                    return Center(
                      child: Text(
                        'Error loading files: ${state.message}',
                        style: const TextStyle(color: Colors.red),
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: uploadFile,
          icon: const Icon(Icons.add),
          label: const Text('Add File'),
        ),
      ),
    );
  }
}
