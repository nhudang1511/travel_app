import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../model/promo_model.dart';

class PromoRepository {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  Future<Promo> getPromoByCode(String promoCode) async {
    try {
      var querySnapshot = await _firebaseFirestore
          .collection('promo')
          .where("code", isEqualTo: promoCode)
          .limit(1) // Giới hạn số lượng kết quả trả về thành 1
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        var data = querySnapshot.docs.first.data();
        return Promo().fromDocument(data);
      } else {
        // Trả về null hoặc xử lý theo ý của bạn khi không tìm thấy promo
        return Promo();
      }
    } catch (e) {
      //log(e.toString());
      rethrow;
    }
  }

  Future<Promo> getRandomPromo() async {
    try {
      var querySnapshot =
      await _firebaseFirestore.collection('promo').get();

      if (querySnapshot.docs.isNotEmpty) {
        // Lấy danh sách các tài liệu promo
        var promoDocuments = querySnapshot.docs.map((doc) => doc.data())
            .toList();

        // Chọn ngẫu nhiên một tài liệu từ danh sách
        var randomPromoData = promoDocuments[Random().nextInt(
            promoDocuments.length)];

        // Tạo một đối tượng Promo từ dữ liệu ngẫu nhiên đã chọn
        return Promo().fromDocument(randomPromoData);
      } else {
        // Trả về null hoặc xử lý theo ý của bạn khi không tìm thấy promo
        return Promo();
      }
    } catch (e) {
      rethrow;
    }
  }
}