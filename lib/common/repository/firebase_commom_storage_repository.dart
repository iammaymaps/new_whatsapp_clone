import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:riverpod/riverpod.dart';

final commomFirebaseStorageRepositoryProvider = Provider((ref) =>
    CommomFirebaseStorageRepository(firebaseStorage: FirebaseStorage.instance));

class CommomFirebaseStorageRepository {
  final FirebaseStorage firebaseStorage;
  CommomFirebaseStorageRepository({
    required this.firebaseStorage,
  });
  Future<String> storeFileToFirebase(String ref, File file) async {
    UploadTask uploadTask = firebaseStorage.ref().child(ref).putFile(file);
    TaskSnapshot sanp = await uploadTask;
    String downloadUrl = await sanp.ref.getDownloadURL();
    return downloadUrl;
  }
}
