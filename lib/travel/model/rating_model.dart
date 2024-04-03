import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_nhu_nguyen/travel/model/custom_model.dart';

class RatingModel extends CustomModel{
  final String? id;
  final String? comment;
  final String? hotel;
  final List<String>? photos;
  final Timestamp? ratedTime;
  final int? rates;
  final String? user;
  
  RatingModel({this.id, this.comment, this.hotel, this.photos, this.ratedTime, this.rates, this.user});
  @override
  RatingModel fromDocument(Map<String, dynamic> doc) {
    return RatingModel(
      id: doc['id'],
      comment: doc['comment'] as String?,
      hotel: doc['hotel'] as String?,
      // photos: doc['photos'] as List<String>?,
      photos: List.of(doc["photos"])
            .map((i) => i as String)
            .toList(),
      ratedTime: doc['rated_time'] as Timestamp?,
      rates: doc['rates'] as int?,
      user: doc['user'] as String?,
    );
  }
  
  @override
  Map<String, dynamic> toDocument() {
    return {
      'id': id,
      'comment': comment,
      'hotel': hotel,
      'photos': photos,
      'rated_time': ratedTime,
      'rates': rates,
      'user': user
    };
  }
}