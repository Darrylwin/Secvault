import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:secvault/features/secured_files/presentation/bloc/secured_file_bloc.dart';
import 'package:secvault/features/secured_files/presentation/bloc/secured_file_event.dart';
import 'package:secvault/features/secured_files/presentation/bloc/secured_file_state.dart';
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
  @override
  void initState() {
    super.initState();
    context.read<SecuredFileBloc>().add(ListSecuredFilesEvent(widget.vaultId));
  }

  @override
  Widget build(BuildContext context) {
    void Function()? onDeleteVaultTapped() {
      showDialog(
        context: context,
        builder: (context) => ConfirmVaultDeleteDialog(
          onPressed: () {
            context.read<VaultBloc>().add(DeleteVault(widget.vaultId));
            Navigator.of(context).pop();
            Navigator.of(context).pop();
          },
        ),
      );
    }

    return Scaffold(
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
                                    'Created on ${DateFormat('MMM dd, yyyy').format(widget.createdAt)}',
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
                              color: Theme.of(context)
                                  .colorScheme
                                  .primary
                                  .withOpacity(0.1),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.folder,
                              color: Theme.of(context).colorScheme.primary,
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
                    onTap: () {},
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
                                    Theme.of(context).colorScheme.primary,
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
                                file.fileName.split('.').last.toLowerCase();
                            return FileCard(
                              fileExtension: fileExtension,
                              fileName: file.fileName,
                              uploaAt: file.uploadedAt,
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
        onPressed: () {
          // Add file action
        },
        icon: const Icon(Icons.add),
        label: const Text('Add File'),
      ),
    );
  }
}
