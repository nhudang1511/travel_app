import 'package:flutter_nhu_nguyen/travel/model/custom_model.dart';

class HotelModel extends CustomModel {
  HotelModel(
      {this.id,
      this.hotelImage,
      this.hotelName,
      this.location,
      this.star,
      this.numberOfReview,
      this.price,
      this.location_description,
      this.information,
        this.typePrice
      });

  final String? id;
  final String? hotelImage;
  final String? hotelName;
  final String? location;
  final String? location_description;
  final String? information;
  final num? star;
  final int? numberOfReview;
  final int? price;
  final String? typePrice;

  @override
  HotelModel fromDocument(Map<String, dynamic> doc) {
    return HotelModel(
        id: doc['id'],
        hotelImage: doc['image'] as String,
        hotelName: doc['name'] as String,
        location: doc['location'] as String,
        star: doc['rating'] as num,
        numberOfReview: doc['total_review'] as int,
        price: doc['price'] as int,
        location_description: doc['location_description'] as String,
        information: doc['information'] as String,
        typePrice: doc['type_price'] as String
    );
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
      'information': information,
      'type_price': typePrice
    };
  }
}
