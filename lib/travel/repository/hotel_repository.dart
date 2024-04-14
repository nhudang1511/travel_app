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
        hotels = hotels
            .where((element) =>
                element.maxRoom! >= maxRoom && element.maxGuest! >= maxGuest)
            .toList();
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

  Future<List<HotelModel>> getHotelsByRating(num rate) async {
    try {
      var querySnapshot = await _firebaseFirestore
          .collection('hotel')
          .where('rating', isEqualTo: rate)
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

  Future<List<HotelModel>> getHotelsByBudget(num start, num end) async {
    try {
      var querySnapshot = await _firebaseFirestore
          .collection('hotel')
          .where('price',
              isGreaterThanOrEqualTo: start, isLessThanOrEqualTo: end)
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

  Future<List<HotelModel>> getHotelsByServices(List<String> services) async {
    try {
      List<RoomModel> rooms = await _roomRepository.getAllRoom();
      var querySnapshot = await _firebaseFirestore.collection('hotel').get();
      List<HotelModel> hotels = querySnapshot.docs.map((doc) {
        var data = doc.data();
        data['id'] = doc.id;
        return HotelModel().fromDocument(data);
      }).toList();

      if (services.isNotEmpty) {
        hotels = hotels.where((hotel) {
          // Lặp qua từng phòng của từng khách sạn
          List<RoomModel> hotelRooms =
              rooms.where((room) => room.hotel == hotel.id).toList();

          // Lặp qua từng phòng của khách sạn để kiểm tra dịch vụ
          for (var room in hotelRooms) {
            // Nếu danh sách dịch vụ của phòng chứa tất cả các dịch vụ cần thiết
            if (services.every((service) => room.services!.contains(service))) {
              return true; // Trả về true, tức là khách sạn này phù hợp với danh sách dịch vụ
            }
          }
          return false; // Trả về false nếu không tìm thấy phòng phù hợp với danh sách dịch vụ
        }).toList();
      }

      return hotels;
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  Future<List<HotelModel>> getHotelsByType(String type) async {
    try {
      var querySnapshot = await _firebaseFirestore
          .collection('hotel')
          .where('type_price', isEqualTo: type)
          .get();
      List<HotelModel> hotels = querySnapshot.docs.map((doc) {
        var data = doc.data();
        data['id'] = doc.id;
        return HotelModel().fromDocument(data);
      }).toList();
      return hotels;
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  Future<List<HotelModel>> sortHotelBy(String? sort, num? rate, num? start,
      num? end, List<String> services, String? type) async {
    try {
      List<RoomModel> rooms = await _roomRepository.getAllRoom();
      Query hotelsQuery = _firebaseFirestore.collection('hotel');
      if (sort != null && sort != 'All' && sort != '') {
        hotelsQuery = hotelsQuery.orderBy(sort, descending: true);
      }
      var querySnapshot = await hotelsQuery.get();
      List<HotelModel> hotels = querySnapshot.docs.map((doc) {
        var data = doc.data();
        if (data is Map<String, dynamic>) { // Kiểm tra xem 'data' có phải là một Map không
          data['id'] = doc.id;
          return HotelModel().fromDocument(data);
        } else {
          // Xử lý trường hợp 'data' không phải là một Map
          throw Exception("Document data is not a Map");
        }
      }).toList();

      if (rate != null && rate != 0) {
        hotels = hotels.where((element) => element.star == rate).toList();
      }
      if (start != null && end != null && start >= 0 && end > 0) {
        hotels = hotels
            .where((element) => element.price! >= start && element.price! <= end)
            .toList();
      }

      if (type != null && type != '') {
        hotels = hotels.where((element) => element.typePrice == type).toList();
      }

      if (services.isNotEmpty) {
        hotels = hotels.where((hotel) {
          // Lặp qua từng phòng của từng khách sạn
          List<RoomModel> hotelRooms =
              rooms.where((room) => room.hotel == hotel.id).toList();

          // Lặp qua từng phòng của khách sạn để kiểm tra dịch vụ
          for (var room in hotelRooms) {
            // Nếu danh sách dịch vụ của phòng chứa tất cả các dịch vụ cần thiết
            if (services.every((service) => room.services!.contains(service))) {
              return true; // Trả về true, tức là khách sạn này phù hợp với danh sách dịch vụ
            }
          }
          return false; // Trả về false nếu không tìm thấy phòng phù hợp với danh sách dịch vụ
        }).toList();
      }

      return hotels;
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

// Future<List<HotelModel>> getHotels(int limit, HotelModel hotelModel) async {
//   try {
//     DocumentSnapshot? documentSnapshot;
//
//     // Kiểm tra xem hotelModel có ID không
//     if (hotelModel.id != null) {
//       // Nếu có, thì lấy DocumentSnapshot tương ứng
//       documentSnapshot = await _firebaseFirestore
//           .collection('hotel')
//           .doc(hotelModel.id)
//           .get();
//     }
//
//     var query = _firebaseFirestore.collection('hotel').limit(limit);
//
//     // Nếu DocumentSnapshot tồn tại, thêm điều kiện startAfterDocument vào truy vấn
//     if (documentSnapshot != null && documentSnapshot.exists) {
//       query = query.startAfterDocument(documentSnapshot);
//     }
//
//     var querySnapshot = await query.get();
//
//     return querySnapshot.docs.map((doc) {
//       var data = doc.data();
//       data['id'] = doc.id;
//       return HotelModel().fromDocument(data);
//     }).toList();
//   } catch (e) {
//     log(e.toString());
//     rethrow;
//   }
// }

// final Query<Map<String, dynamic>> _hotelCollection = FirebaseFirestore
//     .instance
//     .collection('hotel')
//     .where('max_room', isGreaterThanOrEqualTo: 12);
//
// Stream<QuerySnapshot> getHotel(
//     int maxGuest, int maxRoom, String destination) {
//   Query query = _hotelCollection.limit(3);
//   // if (destination != 'All') {
//   //   // Thêm điều kiện cho điểm đến
//   //   query = query.where('location', isEqualTo: destination);
//   // }
//   // if (maxRoom > 1) {
//   //   query = query.where('max_room', isGreaterThanOrEqualTo: maxRoom);
//   // }
//   // if (maxGuest > 1){
//   //   query = query.where('max_guest', isGreaterThanOrEqualTo: maxGuest);
//   // }
//   return query.snapshots();
// }
//
// Stream<QuerySnapshot> getHotelPage(
//   DocumentSnapshot lastDoc,
//   int maxGuest,
//   int maxRoom,
//   String destination,
// ) {
//   Query query = _hotelCollection.limit(3);
//   // if (destination != 'All') {
//   //   // Thêm điều kiện cho điểm đến
//   //   query = query.where('location', isEqualTo: destination);
//   // }
//   // if (maxRoom > 1) {
//   //   query = query.where('max_room', isGreaterThanOrEqualTo: maxRoom);
//   // }
//   // if (maxGuest > 1){
//   //   query = query.where('max_guest', isGreaterThanOrEqualTo: maxGuest);
//   // }
//   query = query.startAfterDocument(lastDoc);
//   return query.snapshots();
// }
}
