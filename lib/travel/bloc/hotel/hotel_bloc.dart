import 'package:flutter_bloc/flutter_bloc.dart';

import '../../model/hotel_model.dart';
import '../../repository/hotel_repository.dart';

part 'hotel_event.dart';

part 'hotel_state.dart';

class HotelBloc extends Bloc<HotelEvent, HotelState> {
  final HotelRepository _hotelRepository;

  HotelBloc(this._hotelRepository) : super(HotelLoading()) {
    on<LoadHotels>(_onLoadHotel);
    on<LoadHotelByBooking>(_onLoadHotelByBooking);
    on<SortHotel>(_onSortHotel);
    on<LoadMore>(_onLoadMore);
  }

  void _onLoadHotel(event, Emitter<HotelState> emit) async {
    try {
      List<HotelModel> hotels = await _hotelRepository.getAllHotel();
      emit(HotelLoaded(hotels: hotels));
    } catch (e) {
      emit(HotelFailure());
    }
  }

  void _onLoadMore(event, Emitter<HotelState> emit) async {
    try {
      List<HotelModel> hotels =
          await _hotelRepository.getHotels(event.limit, event.hotelModel);
      emit(HotelLoaded(hotels: hotels));
    } catch (e) {
      emit(HotelFailure());
    }
  }

  void _onLoadHotelByBooking(event, Emitter<HotelState> emit) async {
    try {
      List<HotelModel> hotels = await _hotelRepository.getAllHotelByBooking(
          event.maxGuest, event.maxRoom, event.destination);

      emit(HotelLoaded(hotels: hotels));
    } catch (e) {
      emit(HotelFailure());
    }
  }

  void _onSortHotel(event, Emitter<HotelState> emit) async {
    try {
      List<HotelModel> hotels = await _hotelRepository.sortHotel(event.sort);

      emit(HotelLoaded(hotels: hotels));
    } catch (e) {
      emit(HotelFailure());
    }
  }
}
