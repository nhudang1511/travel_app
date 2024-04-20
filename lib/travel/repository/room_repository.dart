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
        data['id'] = doc.id;
        return RoomModel().fromDocument(data);
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
        data['id'] = doc.id;
        return RoomModel().fromDocument(data);
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
        data['id'] = doc.id;
        return RoomModel().fromDocument(data);
      }).toList();
      rooms = rooms
          .where((element) =>
              element.total! >= room && element.maxGuest! * room >= guest)
          .toList();
      return rooms;
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

Future<RoomModel?> removeRoomById(
    String roomId, int maxGuest, int maxRoom) async {
  try {
    var roomDoc =
        await _firebaseFirestore.collection('room').doc(roomId).get();
    if (roomDoc.exists) {
      var data = roomDoc.data();
      //print('guest: $maxGuest');
      //print('max: ${(data?['max_guest'] as int) - maxGuest}');
      if (data != null) {
        int currentMaxGuest = data['max_guest'] as int;
        int currentMaxRoom = data['total'] as int;
        int newMaxGuest = currentMaxGuest - maxGuest;
        int newMaxRoom = currentMaxRoom - maxRoom;

        // Sử dụng `.update()` để cập nhật dữ liệu trong Firestore
        await _firebaseFirestore.collection('room').doc(roomId).update({
          'max_guest': newMaxGuest,
          'total': newMaxRoom,
        });

        // Tạo đối tượng RoomModel từ dữ liệu đã cập nhật
        data['id'] = roomDoc.id;
        data['max_guest'] = newMaxGuest;
        data['total'] = newMaxRoom;
        return RoomModel().fromDocument(data);
      }
    } else {
      return null; // Return null if hotel not found
    }
  } catch (e) {
    log(e.toString());
    rethrow;
  }
  return null;
}

Future<RoomModel?> addRoomById(
    String roomId, int maxGuest, int maxRoom) async {
  try {
    var roomDoc =
    await _firebaseFirestore.collection('room').doc(roomId).get();
    if (roomDoc.exists) {
      var data = roomDoc.data();
      //print('guest: $maxGuest');
      //print('max: ${(data?['max_guest'] as int) - maxGuest}');
      if (data != null) {
        int currentMaxGuest = data['max_guest'] as int;
        int currentMaxRoom = data['total'] as int;
        int newMaxGuest = currentMaxGuest + maxGuest;
        int newMaxRoom = currentMaxRoom + maxRoom;
        // Sử dụng `.update()` để cập nhật dữ liệu trong Firestore
        await _firebaseFirestore.collection('room').doc(roomId).update({
          'max_guest': newMaxGuest,
          'total': newMaxRoom,
        });

        // Tạo đối tượng RoomModel từ dữ liệu đã cập nhật
        data['id'] = roomDoc.id;
        data['max_guest'] = newMaxGuest;
        data['total'] = newMaxRoom;
        return RoomModel().fromDocument(data);
      }
    } else {
      return null; // Return null if hotel not found
    }
  } catch (e) {
    log(e.toString());
    rethrow;
  }
  return null;
}
}
