import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:secvault/features/secured_files/data/models/secured_file_model.dart';
import 'package:secvault/core/helpers/encryption_helper.dart';
import 'package:secvault/features/secured_files/data/datasources/remote/secured_file_remote_datasource.dart';
import 'package:secvault/features/secured_files/domain/errors/secured_file_failure.dart';

class SecuredFileRemoteDatasourceImpl implements SecuredFileRemoteDatasource {
  final FirebaseFirestore firestore;
  final FirebaseStorage storage;

  SecuredFileRemoteDatasourceImpl({
    required this.firestore,
    required this.storage,
  });

  @override
  Future<void> uploadSecuredFile({
    required String fileName,
    required String vaultId,
    required List<int> rawData,
  }) async {
    final encryptedData = EncryptionHelper.encryptData(rawData);
    final fileId = firestore.collection('vaults').doc(vaultId).collection('files').doc().id;

    await firestore
        .collection('vaults')
        .doc(vaultId)
        .collection('files')
        .doc(fileId)
        .set({
      'fileId': fileId,
      'fileName': fileName,
      'vaultId': vaultId,
      'encryptedData': base64Encode(encryptedData),
      'uploadedAt': DateTime.now().toIso8601String(),
    });
  }

  @override
  Future<void> deleteSecuredFile({
    required String fileId,
    required String vaultId,
  }) async {
    await firestore
        .collection('vaults')
        .doc(vaultId)
        .collection('files')
        .doc(fileId)
        .delete();
  }

  @override
  Future<List<SecuredFileModel>> listSecuredFiles({required String vaultId}) async {
    final snapshot = await firestore
        .collection('vaults')
        .doc(vaultId)
        .collection('files')
        .get();

    return snapshot.docs
        .map((doc) => SecuredFileModel.fromJson(doc.data()))
        .toList();
  }

  @override
  Future<SecuredFileModel> downloadSecuredFile({
    required String fileId,
    required String vaultId,
  }) async {
    final doc = await firestore
        .collection('vaults')
        .doc(vaultId)
        .collection('files')
        .doc(fileId)
        .get();

    if (!doc.exists) {
      throw SecuredFileFailure.notFound();
    }

    return SecuredFileModel.fromJson(doc.data()!);
  }
}
