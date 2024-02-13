part of 'room_bloc.dart';
abstract class RoomEvent{
  const RoomEvent();
}

class LoadRoom extends RoomEvent{
}
class LikeRoom extends RoomEvent {
  final String placeId;

  const LikeRoom({
    required this.placeId,
  });
}
class LoadRoomByHotelId extends RoomEvent{
  final String hotelId;
  LoadRoomByHotelId(this.hotelId);
}
class LoadRoomByHotelIdGuestRoom extends RoomEvent{
  final String hotelId;
  final int guest;
  final int room;
  LoadRoomByHotelIdGuestRoom(this.hotelId, this.guest, this.room);
}

