import 'dart:async';

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

  SecuredFileBloc(
    this.deleteSecuredFileUsecase,
    this.downloadSecuredFileUsecase,
    this.listSecuredFilesUsecase,
    this.uploadSecuredFileUsecase,
  ) : super(SecuredFileInitial()) {
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

    result.fold(
      (error) => emit(SecuredFileError(error.message)),
      (success) => emit(SecuredFileSuccess()),
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

    result.fold(
      (error) => emit(SecuredFileError(error.message)),
      (success) => emit(SecuredFileSuccess()),
    );
  }

  Future<void> _onListSecuredFiles(
    ListSecuredFilesEvent event,
    Emitter<SecuredFileState> emit,
  ) async {
    final result = await listSecuredFilesUsecase(vaultId: event.vaultId);
    result.fold(
      (error) => emit(SecuredFileError(error.message)),
      (files) => emit(SecuredFileListSuccess(files)),
    );
  }

  Future<void> _onDownloadSecuredFile(
      DownloadSecuredFileEvent event, Emitter<SecuredFileState> emit) async {
    final result = await downloadSecuredFileUsecase(
      vaultId: event.vaultId,
      fileId: event.fileId,
    );

    result.fold(
      (error) => emit(SecuredFileError(error.message)),
      (file) => emit(SecuredFileDownloadSuccess(file)),
    );
  }
}
