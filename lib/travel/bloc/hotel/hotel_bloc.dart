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
    on<RateHotel>(_onRateHotel);
    on<SortHotelByBudget>(_onSortHotelByBudget);
    on<SortHotelByServices>(_onSortHotelByServices);
    on<SortHotelByProperty>(_onSortHotelByProperty);
    on<SortHotelBy>(_onSortHotelBy);
    on<AddReviewsHotel>(_onAddReviewsHotel);
  }

  void _onLoadHotel(event, Emitter<HotelState> emit) async {
    try {
      List<HotelModel> hotels = await _hotelRepository.getAllHotel();
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

  void _onRateHotel(event, Emitter<HotelState> emit) async {
    try {
      List<HotelModel> hotels =
      await _hotelRepository.getHotelsByRating(event.rate);

      emit(HotelLoaded(hotels: hotels));
    } catch (e) {
      emit(HotelFailure());
    }
  }

  void _onSortHotelByBudget(event, Emitter<HotelState> emit) async {
    try {
      List<HotelModel> hotels =
      await _hotelRepository.getHotelsByBudget(event.start, event.end);
      emit(HotelLoaded(hotels: hotels));
    } catch (e) {
      emit(HotelFailure());
    }
  }

  void _onSortHotelByServices(event, Emitter<HotelState> emit) async {
    try {
      List<HotelModel> hotels =
      await _hotelRepository.getHotelsByServices(event.services);
      emit(HotelLoaded(hotels: hotels));
    } catch (e) {
      emit(HotelFailure());
    }
  }

  void _onSortHotelByProperty(event, Emitter<HotelState> emit) async {
    try {
      List<HotelModel> hotels =
      await _hotelRepository.getHotelsByType(event.property);
      emit(HotelLoaded(hotels: hotels));
    } catch (e) {
      emit(HotelFailure());
    }
  }

  void _onSortHotelBy(event, Emitter<HotelState> emit) async {
    try {
      List<HotelModel> hotels = await _hotelRepository.sortHotelBy(event.sort,
          event.rate, event.start, event.end, event.services, event.property);
      emit(HotelLoaded(hotels: hotels));
    } catch (e) {
      emit(HotelFailure());
    }
  }

  void _onAddReviewsHotel(event, Emitter<HotelState> emit) async {
    try {
      HotelModel? hotelModel = await _hotelRepository.addHotelReviews(
          event.hotelId, event.rating);
      emit(HotelLoaded(hotels: [hotelModel ?? HotelModel()]));
    } catch (e) {
      print(e.toString());
      emit(HotelFailure());
    }
  }
}
