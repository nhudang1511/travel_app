import 'dart:ffi';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

final FirebaseStorage _storage = FirebaseStorage.instance;
final FirebaseFirestore firestore = FirebaseFirestore.instance;

class StoreData {
  Future<String> uploadImageToStorage(String childName, String id, Uint8List file) async {
    Reference ref = _storage.ref().child(childName).child(id);
    UploadTask uploadTask = ref.putData(file);
    TaskSnapshot snapshot = await uploadTask;
    String downloadUrl = await snapshot.ref.getDownloadURL();
    return downloadUrl;
  }
  //
  // Future<String> saveData({ required String name, required String bio, required Uint8List file}) async {
  //   String resp = "Some Errors Occured...";
  //   try {
  //     String imageUrl = await uploadImageToStorage("profileImage", file);
  //     resp = imageUrl;
  //   } catch (err) {
  //     resp = err.toString();
  //   }
  //   return resp;
  // }
}