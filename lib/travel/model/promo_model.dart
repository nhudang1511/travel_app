import 'package:flutter_nhu_nguyen/travel/model/custom_model.dart';

class Promo extends CustomModel{
  final String? id;
  final String? code;
  final String? endow;
  final String? image;
  final num? price;

  Promo({this.id, this.code, this.endow, this.image, this.price});
  @override
  Promo fromDocument(Map<String, dynamic> doc) {
    return Promo(
      id: doc['id'],
      code: doc['code'] as String?,
      endow: doc['endow'] as String?,
      image: doc['image'] as String?,
      price: doc['price'] as num?,
    );
  }

  @override
  Map<String, dynamic> toDocument() {
   return {
     'code':code,
     'endow':endow,
     "image":image,
     'price':price,
   };
  }

}