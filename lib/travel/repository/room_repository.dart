import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../model/room_model.dart';

class RoomRepository {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  Future<List<RoomModel>> getAllRoom() async {
    try {
      var querySnapshot = await _firebaseFirestore.collection('room').get();
      return querySnapshot.docs.map((doc) {
        var data = doc.data();
        var id = doc.id;
        return RoomModel(id: id).fromDocument(data, id);
      }).toList();
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  Future<List<RoomModel>> getAllRoomByHotelId(String hotelId) async {
    try {
      var querySnapshot = await _firebaseFirestore
          .collection('room')
          .where('hotel', isEqualTo: hotelId)
          .get();
      return querySnapshot.docs.map((doc) {
        var data = doc.data();
        var id = doc.id;
        return RoomModel(id: id).fromDocument(data, id);
      }).toList();
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  Future<List<RoomModel>> getAllRoomByHotelIdRoomGuest(
      String hotelId, int guest, int room) async {
    try {
      var querySnapshot = await _firebaseFirestore
          .collection('room')
          .where('hotel', isEqualTo: hotelId)
          .get();
      List<RoomModel> rooms = querySnapshot.docs.map((doc) {
        var data = doc.data();
        var id = doc.id;
        return RoomModel(id: id).fromDocument(data, id);
      }).toList();
      rooms = rooms.where((element) => element.total! >= room && element.maxGuest! * room >= guest).toList();
      return rooms;
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }
}
