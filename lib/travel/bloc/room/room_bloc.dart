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
    on<RemoveInRoom>(_onRemoveInRoom);
    on<AddInRoom>(_onAddInRoom);
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

  void _onRemoveInRoom(event, Emitter<RoomState> emit) async {
    try {
      RoomModel? room = await _roomRepository.removeRoomById(
          event.roomId, event.maxRoom);
      emit(RoomRemoved(room: room ?? RoomModel()));
    } catch (e) {
      emit(RoomFailure(error: e.toString()));
    }
  }

  void _onAddInRoom(event, Emitter<RoomState> emit) async {
    try {
      RoomModel? room = await _roomRepository.addRoomById(
          event.roomId, event.maxRoom);
      emit(RoomAdded(room: room ?? RoomModel()));
    } catch (e) {
      emit(RoomFailure(error: e.toString()));
    }
  }
}
