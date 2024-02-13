import 'package:flutter_nhu_nguyen/travel/model/custom_model.dart';

class PlaceModel extends CustomModel {
  final String? image;
  final String? name;
  final num? rating;

  PlaceModel(
      {required String id,
      this.image,
      this.name,
      this.rating})
      : super(id: id);

  @override
  PlaceModel fromDocument(Map<String, dynamic> doc, String id) {
    return PlaceModel(
      id: id,
      image: doc['image'] as String?,
      name: doc['name'] as String?,
      rating: doc['rating'] as num?,
    );
  }

  @override
  Map<String, dynamic> toDocument() {
    return {
      'id': id,
      'image': image,
      'name': name,
      'rating': rating,
    };
  }
}
