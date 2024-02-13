import 'package:flutter_nhu_nguyen/travel/model/custom_model.dart';

class HotelModel extends CustomModel{
  HotelModel(
      {required String id,
      this.hotelImage,
      this.hotelName,
      this.location,
      this.star,
      this.numberOfReview,
      this.price,
      this.location_description,
      this.information}) : super(id: id);

  final String? hotelImage;
  final String? hotelName;
  final String? location;
  final String? location_description;
  final String? information;
  final double? star;
  final int? numberOfReview;
  final int? price;


  @override
  HotelModel fromDocument(Map<String, dynamic> doc, String id) {
    return HotelModel(
        id: id,
        hotelImage: doc['image'] as String,
        hotelName: doc['name'] as String,
        location: doc['location'] as String,
        star: doc['rating'] as double,
        numberOfReview: doc['total_review'] as int,
        price: doc['price'] as int,
        location_description: doc['location_description'] as String,
        information: doc['information'] as String);
  }

  @override
  Map<String, dynamic> toDocument() {
    return {
      'id': id,
      'image': hotelImage,
      'name': hotelName,
      'location': location,
      'rating': star,
      'total_review': numberOfReview,
      'price': price,
      'location_description': location_description,
      'information': information
    };
  }
}
