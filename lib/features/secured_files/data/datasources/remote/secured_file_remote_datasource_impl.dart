import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:secvault/features/secured_files/data/datasources/remote/secured_file_remote_datasource.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:secvault/features/secured_files/data/models/secured_file_model.dart';
import 'package:secvault/features/secured_files/domain/errors/secured_file_failure.dart';

class SecuredFileRemoteDatasourceImpl implements SecuredFileRemoteDatasource {
  final FirebaseFirestore firestore;
  final FirebaseStorage storage;

  SecuredFileRemoteDatasourceImpl({
    required this.storage,
    required this.firestore,
  });

  @override
  Future<void> uploadSecuredFile({
    required String fileName,
    required String vaultId,
    required List<int> rawData,
  }) async {
    try {
      //Generate a unique ID for the file
      final docRef =
          firestore.collection('vaults').doc(vaultId).collection('files').doc();
      final fileId = docRef.id;

      //upload encrypted data to Firebase Storage
      final strorageRef = storage.ref().child("vaults/$vaultId/$fileId");
      await strorageRef.putData(Uint8List.fromList(rawData));

      //save metadata in firebase
      await docRef.set({
        'fileId': fileId,
        'fileName': fileName,
        'vaultId': vaultId,
        'uploadedAt': Timestamp.now(),
      });
    } catch (e) {
      throw SecuredFileFailure('Failed to upload secured file: $e');
    }
  }

  @override
  Future<void> deleteSecuredFile({
    required String fileId,
    required vaultId,
  }) async {
    try {
      // delete file from firebase storage
      final storageRef = storage.ref().child('vaults/$vaultId/$fileId');
      await storageRef.delete();

      //delete metadata from firestore
      await firestore
          .collection('vaults')
          .doc(vaultId)
          .collection('files')
          .doc(fileId)
          .delete();
    } catch (e) {
      throw SecuredFileFailure('Failed to delete secured file: $e');
    }
  }
}
