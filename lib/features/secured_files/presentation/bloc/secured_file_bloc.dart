import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:secvault/features/secured_files/domain/usecases/delete_secured_file_usecase.dart';
import 'package:secvault/features/secured_files/domain/usecases/upload_secured_file_usecase.dart';

import '../../domain/usecases/download_secured_file_usecase.dart';
import '../../domain/usecases/list_secured_files_usecase.dart';
import 'secured_file_event.dart';
import 'secured_file_state.dart';

class SecuredFileBloc extends Bloc<SecuredFileEvent, SecuredFileState> {
  final DeleteSecuredFileUsecase deleteFile;
  final DownloadSecuredFileUsecase downloadSecuredFileUsecase;
  final ListSecuredFilesUsecase listSecuredFilesUsecase;
  final UploadSecuredFileUsecase uploadSecuredFileUsecase;

  SecuredFileBloc(
    this.deleteFile,
    this.downloadSecuredFileUsecase,
    this.listSecuredFilesUsecase,
    this.uploadSecuredFileUsecase,
  ) : super(SecuredFileInitial()) {
    on<UploadSecuredFileEvent>(_onUploadSecuredFile);
    on<DeleteSecuredFileEvent>(_onDeleteSecuredFile);
    on<ListSecuredFilesEvent>(_onListSecuredFiles);
    on<DownloadSecuredFileEvent>(_onDownloadSecuredFile);
  }

  FutureOr<void> _onUploadSecuredFile(
      UploadSecuredFileEvent event, Emitter<SecuredFileState> emit) {}
}
