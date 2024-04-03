import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_nhu_nguyen/travel/model/custom_model.dart';

class NotificationModel extends CustomModel {
  final String? title;
  final String? body;
  final Timestamp? dateTime;
  final String? userId;

  NotificationModel({this.title, this.body, this.userId, this.dateTime});

  @override
  NotificationModel fromDocument(Map<String, dynamic> doc) {
    return NotificationModel(
      title: doc['title'] as String?,
      body: doc['body'] as String?,
      userId: doc['userId'] as String?,
      dateTime: doc['dateTime'] as Timestamp?,
    );
  }

  @override
  Map<String, dynamic> toDocument() {
    return {
      'title': title,
      'body': body,
      'userId': userId,
      'dateTime': dateTime,
    };
  }
}
