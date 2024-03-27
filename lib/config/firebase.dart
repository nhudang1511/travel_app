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

  Future<Uint8List?> getImageFromFirebase(String? imageUrl) async {
    //Tải ảnh từ Firebase về dưới dạng Uint8List
    try {
      Reference ref = _storage.ref().child("https://firebasestorage.googleapis.com/v0/b/travoapps-b31c4.appspot.com/o/profileImage%2F1071110835?alt=media&token=2bca6aed-9203-428b-aa0e-188028698d20");
      final data = await ref.getData();
      return data;
    } catch(error) {
      print(error);
      return Uint8List(0);
    }
  }
}