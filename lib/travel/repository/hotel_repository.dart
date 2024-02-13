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
        var id = doc.id;
        return HotelModel(id: id).fromDocument(data, id);
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
        var id = doc.id;
        return HotelModel(id: id).fromDocument(data, id);
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
        var id = doc.id;
        return HotelModel(id: id).fromDocument(data, id);
      }).toList();
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }
}
