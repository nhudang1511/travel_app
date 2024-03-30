import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_nhu_nguyen/config/shared_preferences.dart';

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
      return User().fromDocument(data);
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
        data['id'] = doc.id;
        return User().fromDocument(data);
      }).toList();
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  Future<void> editUserById(User user) async {
    try {
      await _firebaseFirestore.collection("user").doc(user.id).update({
        "name": user.name,
        "phoneNumber": user.phone,
        "country": user.country,
        "avatar": user.avatar
      });

      final querySnapshot = await _firebaseFirestore.collection("user").doc(user.id).get();
      var data = querySnapshot.data() as Map<String, dynamic>;
      var newUser = User(id: user.id).fromDocument(data);

      setSP(newUser);
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  Future setSP(User user) async {
    //Uint8List? _avatar;
    SharedService.setUserId(user.id ?? '');
    SharedService.setEmail(user.email ?? '');
    SharedService.setName(user.name ?? '');
    SharedService.setPhone(user.phone ?? '');
    SharedService.setPassword(user.password ?? '');
    SharedService.setCountry(user.country ?? '');
    SharedService.setAvatar(user.avatar ?? '');
  }
}