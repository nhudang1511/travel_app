import 'package:flutter_bloc/flutter_bloc.dart';

import '../../model/room_model.dart';
import '../../repository/room_repository.dart';

part 'room_event.dart';

part 'room_state.dart';

class RoomBloc extends Bloc<RoomEvent, RoomState> {
  final RoomRepository _roomRepository;

  RoomBloc(this._roomRepository) : super(RoomLoading()) {
    on<LoadRoom>(_onLoadRoom);
    on<LoadRoomByHotelId>(_onLoadRoomByHotelId);
    on<LoadRoomByHotelIdGuestRoom>(_onLoadRoomByHotelIdGuestRoom);
  }

  void _onLoadRoom(event, Emitter<RoomState> emit) async {
    try {
      List<RoomModel> room = await _roomRepository.getAllRoom();
      emit(RoomLoaded(rooms: room));
    } catch (e) {
      emit(RoomFailure(error: e.toString()));
    }
  }

  void _onLoadRoomByHotelId(event, Emitter<RoomState> emit) async {
    try {
      List<RoomModel> room =
          await _roomRepository.getAllRoomByHotelId(event.hotelId);
      emit(RoomLoaded(rooms: room));
    } catch (e) {
      emit(RoomFailure(error: e.toString()));
    }
  }

  void _onLoadRoomByHotelIdGuestRoom(event, Emitter<RoomState> emit) async {
    try {
      List<RoomModel> room = await _roomRepository.getAllRoomByHotelIdRoomGuest(
          event.hotelId, event.guest, event.room);
      emit(RoomLoaded(rooms: room));
    } catch (e) {
      emit(RoomFailure(error: e.toString()));
    }
  }
}
