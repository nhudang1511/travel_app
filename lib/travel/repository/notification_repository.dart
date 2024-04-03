import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../model/notification_model.dart';

class NotificationRepository {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  Future<NotificationModel> addNotification(Map<String, dynamic> notificationData) async {
    final notification =
    await _firebaseFirestore.collection('notification').add(notificationData);
    var querySnapshot = await _firebaseFirestore
        .collection('notification')
        .doc(notification.id) // Specify the document ID
        .get();
    var data = querySnapshot.data() as Map<String, dynamic>;
    data['id'] = notification.id;
    return NotificationModel().fromDocument(data);
  }

  Future<List<NotificationModel>> getAllNotificationById(String uId) async {
    try {
      var querySnapshot = await _firebaseFirestore
          .collection('notification').where('userId', isEqualTo: uId)
          .get();
      return querySnapshot.docs.map((doc) {
        var data = doc.data();
        data['id'] = doc.id;
        return NotificationModel().fromDocument(data);
      }).toList();
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }
}