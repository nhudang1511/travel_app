import 'package:flutter_nhu_nguyen/travel/model/custom_model.dart';

class Promo extends CustomModel{
  final String? code;
  final String? endow;
  final String? image;
  final num? price;

  Promo({required String id, this.code, this.endow, this.image, this.price}): super(id: id);
  @override
  Promo fromDocument(Map<String, dynamic> doc, String id) {
    return Promo(
      id: id,
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