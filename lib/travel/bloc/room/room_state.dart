part of 'room_bloc.dart';
abstract class RoomState{
  const RoomState();
  
}

class RoomLoading extends RoomState{
  
}
class RoomLoaded extends RoomState{
  final List<RoomModel> rooms;

  const RoomLoaded({this.rooms = const <RoomModel>[]});
}
class RoomFailure extends RoomState{
  final String error;
  const RoomFailure({required this.error});
}
class RoomRemoved extends RoomState{
  final RoomModel room;
  const RoomRemoved({required this.room});
}

class RoomAdded extends RoomState{
  final RoomModel room;
  const RoomAdded({required this.room});
}