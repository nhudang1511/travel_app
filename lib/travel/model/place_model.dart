import 'package:flutter_nhu_nguyen/travel/model/custom_model.dart';

class PlaceModel extends CustomModel {
  final String? id;
  final String? image;
  final String? name;
  final num? rating;
  final String? desc;

  PlaceModel(
      {this.id, this.image, this.name, this.rating, this.desc});

  @override
  PlaceModel fromDocument(Map<String, dynamic> doc) {
    return PlaceModel(
        id: doc['id'],
        image: doc['image'] as String?,
        name: doc['name'] as String?,
        rating: doc['rating'] as num?,
        desc: doc['desc'] as String?);
  }

  @override
  Map<String, dynamic> toDocument() {
    return {
      'id': id,
      'image': image,
      'name': name,
      'rating': rating,
      'desc': desc
    };
  }
}
