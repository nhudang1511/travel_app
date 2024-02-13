import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../model/user_model.dart';

class UserRepository {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  Future<User> getUserById(String uId) async {
    try {
      var querySnapshot = await _firebaseFirestore
          .collection('user')
          .doc(uId) // Specify the document ID
          .get();
      var data = querySnapshot.data() as Map<String, dynamic>;
      return User(id: uId).fromDocument(data, uId);
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  Future<List<User>> getAllUser() async {
    try {
      var querySnapshot = await _firebaseFirestore.collection('user').get();
      return querySnapshot.docs.map((doc) {
        var data = doc.data();
        var id = doc.id;
        return User(id: id).fromDocument(data, id);
      }).toList();
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }
}