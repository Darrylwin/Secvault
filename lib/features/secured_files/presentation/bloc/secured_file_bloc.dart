import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:secvault/features/secured_files/domain/usecases/delete_secured_file_usecase.dart';
import 'package:secvault/features/secured_files/domain/usecases/upload_secured_file_usecase.dart';

import '../../domain/usecases/download_secured_file_usecase.dart';
import '../../domain/usecases/list_secured_files_usecase.dart';
import 'secured_file_event.dart';
import 'secured_file_state.dart';

class SecuredFileBloc extends Bloc<SecuredFileEvent, SecuredFileState> {
  final DeleteSecuredFileUsecase deleteSecuredFileUsecase;
  final DownloadSecuredFileUsecase downloadSecuredFileUsecase;
  final ListSecuredFilesUsecase listSecuredFilesUsecase;
  final UploadSecuredFileUsecase uploadSecuredFileUsecase;

  SecuredFileBloc({
    required this.deleteSecuredFileUsecase,
    required this.downloadSecuredFileUsecase,
    required this.listSecuredFilesUsecase,
    required this.uploadSecuredFileUsecase,
  }) : super(SecuredFileInitial()) {
    on<UploadSecuredFileEvent>(_onUploadSecuredFile);
    on<DeleteSecuredFileEvent>(_onDeleteSecuredFile);
    on<ListSecuredFilesEvent>(_onListSecuredFiles);
    on<DownloadSecuredFileEvent>(_onDownloadSecuredFile);
  }

  Future<void> _onUploadSecuredFile(
    UploadSecuredFileEvent event,
    Emitter<SecuredFileState> emit,
  ) async {
    emit(SecuredFileLoading());
    final result = await uploadSecuredFileUsecase(
      vaultId: event.vaultId,
      fileName: event.fileName,
      rawData: event.rawData,
    );

    await result.fold(
      (error) async {
        debugPrint('SecuredFileBloc: Failed to upload file: ${error.message}');
        emit(SecuredFileError(error.message));
      },
      (success) async {
        debugPrint(
            "SecurdFileBloc uploaded files: ${event.fileName} to vault: ${event.vaultId}");
        // apres que le fichier at été uploadé on doit affcher la nouvelle lste des files
        final result = await listSecuredFilesUsecase(vaultId: event.vaultId);
        await result.fold(
          (error) async {
            debugPrint(
                "SecuredFileBloc failed to list files: ${error.message}");
            emit(SecuredFileError(error.message));
          },
          (files) async {
            debugPrint(
                "SecuredFileBloc listed files: ${files.length} files from vault: ${event.vaultId}");
            emit(SecuredFileListSuccess(files));
          },
        );
      },
    );
  }

  Future<void> _onDeleteSecuredFile(
    DeleteSecuredFileEvent event,
    Emitter<SecuredFileState> emit,
  ) async {
    emit(SecuredFileLoading());
    final result = await deleteSecuredFileUsecase(
      vaultId: event.vaultId,
      fileId: event.fileId,
    );

    await result.fold(
      (error) async {
        debugPrint("SecuredFileBloc: Failed to delete file: ${error.message}");
        emit(SecuredFileError(error.message));
      },
      (success) async {
        debugPrint(
            "SecuredFileBloc deleted file ${event.fileId} from vault ${event.vaultId}");
        // apres que le fichier at été supprimé on doit affcher la nouvelle lste des files
        final result = await listSecuredFilesUsecase(vaultId: event.vaultId);
        await result.fold(
          (error) async {
            debugPrint(
                "SecuredFileBloc failed to list files: ${error.message}");
            emit(SecuredFileError(error.message));
          },
          (files) async {
            debugPrint(
                "SecuredFileBloc listed files: ${files.length} files from vault: ${event.vaultId}");
            emit(SecuredFileListSuccess(files));
          },
        );
      },
    );
  }

  Future<void> _onListSecuredFiles(
    ListSecuredFilesEvent event,
    Emitter<SecuredFileState> emit,
  ) async {
    final result = await listSecuredFilesUsecase(vaultId: event.vaultId);
    result.fold(
      (error) {
        debugPrint("SecuredFileBloc failed to list files: ${error.message}");
        emit(SecuredFileError(error.message));
      },
      (files) {
        debugPrint(
            "SecuredFileBloc listed files: ${files.length} files from vault: ${event.vaultId}");
        emit(SecuredFileListSuccess(files));
      },
    );
  }

  Future<void> _onDownloadSecuredFile(
      DownloadSecuredFileEvent event, Emitter<SecuredFileState> emit) async {
    final result = await downloadSecuredFileUsecase(
      vaultId: event.vaultId,
      fileId: event.fileId,
    );

    result.fold(
      (error) {
        debugPrint(
            "SecuredFileBloc failed downloading file ${event.fileId} from vault ${event.vaultId}");
        emit(SecuredFileError(error.message));
      },
      (file) {
        debugPrint(
            "SecuredFileBloc downloaded file: ${file.fileName} from vault: ${event.vaultId}");
        emit(SecuredFileDownloadSuccess(
          file: file,
          forDownloadOnly: true,
        ));
      },
    );
  }
}
