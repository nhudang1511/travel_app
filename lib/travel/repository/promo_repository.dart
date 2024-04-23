import 'dart:developer';

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
      log(e.toString());
      rethrow;
    }
  }
}