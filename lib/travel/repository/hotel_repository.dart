import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_nhu_nguyen/travel/repository/repository.dart';

import '../model/hotel_model.dart';
import '../model/room_model.dart';

class HotelRepository {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  final RoomRepository _roomRepository;

  HotelRepository(this._roomRepository);

  Future<List<HotelModel>> getAllHotel() async {
    try {
      var querySnapshot = await _firebaseFirestore.collection('hotel').get();
      return querySnapshot.docs.map((doc) {
        var data = doc.data();
        data['id'] = doc.id;
        return HotelModel().fromDocument(data);
      }).toList();
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  Future<List<HotelModel>> getAllHotelByBooking(
      int maxGuest, int maxRoom, String destination) async {
    try {
      List<RoomModel> room = await _roomRepository.getAllRoom();
      var querySnapshot = await _firebaseFirestore.collection('hotel').get();
      List<HotelModel> hotels = querySnapshot.docs.map((doc) {
        var data = doc.data();
        data['id'] = doc.id;
        return HotelModel().fromDocument(data);
      }).toList();
      if (destination != 'All') {
        hotels = hotels
            .where((element) => element.location!.contains(destination))
            .toList();
      }
      if (maxRoom > 1 || maxGuest > 1) {
        hotels = hotels.where((hotel) {
          List<RoomModel> hotelRooms = room
              .where((room) =>
                  room.hotel == hotel.id &&
                  room.total! >= maxRoom &&
                  (maxRoom * room.maxGuest!) >= maxGuest)
              .toList();
          return hotelRooms.isNotEmpty;
        }).toList();
      }
      return hotels;
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  Future<List<HotelModel>> sortHotel(String sort) async {
    try {
      var querySnapshot = await _firebaseFirestore
          .collection('hotel')
          .orderBy(sort, descending: true)
          .get();
      return querySnapshot.docs.map((doc) {
        var data = doc.data();
        data['id'] = doc.id;
        return HotelModel().fromDocument(data);
      }).toList();
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  Future<List<HotelModel>> getHotels(int limit, HotelModel hotelModel) async {
    try {
      DocumentSnapshot? documentSnapshot;

      // Kiểm tra xem hotelModel có ID không
      if (hotelModel.id != null) {
        // Nếu có, thì lấy DocumentSnapshot tương ứng
        documentSnapshot = await _firebaseFirestore
            .collection('hotel')
            .doc(hotelModel.id)
            .get();
      }

      var query = _firebaseFirestore.collection('hotel').limit(limit);

      // Nếu DocumentSnapshot tồn tại, thêm điều kiện startAfterDocument vào truy vấn
      if (documentSnapshot != null && documentSnapshot.exists) {
        query = query.startAfterDocument(documentSnapshot);
      }

      var querySnapshot = await query.get();

      return querySnapshot.docs.map((doc) {
        var data = doc.data();
        data['id'] = doc.id;
        return HotelModel().fromDocument(data);
      }).toList();
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  final CollectionReference _hotelCollection = FirebaseFirestore.instance
      .collection('hotel');
  Stream<QuerySnapshot> getHotel() {
    Query query = _hotelCollection.limit(3);
    return query.snapshots();
  }
  Stream<QuerySnapshot> getHotelPage(DocumentSnapshot lastDoc) {
    Query query = _hotelCollection.limit(3);
    query = query.startAfterDocument(lastDoc);
    return query.snapshots();
  }

}
