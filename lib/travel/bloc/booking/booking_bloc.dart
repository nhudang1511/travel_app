import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_nhu_nguyen/travel/model/booking_model.dart';

import '../../model/card_model.dart';
import '../../model/guest_model.dart';
import '../../repository/repository.dart';

part 'booking_event.dart';

part 'booking_state.dart';

class BookingBloc extends Bloc<BookingEvent, BookingState> {
  final BookingRepository _bookingRepository;

  BookingBloc(this._bookingRepository) : super(BookingLoading()) {
    on<AddBooking>(_onAddBooking);
    on<LoadBooking>(_onLoadBooking);
    on<LoadBookingById>(_onLoadBookingById);
    on<GetBookingByLessDay>(_onGetBookingByLessDay);
    on<GetBookingByMoreDay>(_onGetBookingByMoreDay);
    on<EditBooking>(_onEditBooking);

  }

  void _onAddBooking(event, Emitter<BookingState> emit) async {
    try {
      final bookingModel =
          await _bookingRepository.createBooking(event.bookingModel.toDocument());
      emit(BookingAdded(bookingModel: bookingModel));
    } catch (e) {
      print(e.toString());
      emit(BookingFailure());
    }
  }
  void _onLoadBooking(event, Emitter<BookingState> emit) async {
    try {
      List<BookingModel> bookingModel = await _bookingRepository.getAllBooking();

      emit(BookingLoaded(bookingModel: bookingModel));
    } catch (e) {
      emit(BookingFailure());
    }
  }
  void _onLoadBookingById(event, Emitter<BookingState> emit) async {
    try {
      BookingModel bookingModel = await _bookingRepository.getBookingById(event.id);

      emit(BookingLoadedById(bookingModel: bookingModel));
    } catch (e) {
      emit(BookingFailure());
    }
  }
  void _onGetBookingByLessDay(event, Emitter<BookingState> emit) async {
    try {
      List<BookingModel> bookingModel = await _bookingRepository.getExpiredLess();
      emit(BookingLoaded(bookingModel: bookingModel));
    } catch (e) {
      emit(BookingFailure());
    }
  }
  void _onGetBookingByMoreDay(event, Emitter<BookingState> emit) async {
    try {
      List<BookingModel> bookingModel = await _bookingRepository.getExpiredMore();
      emit(BookingLoaded(bookingModel: bookingModel));
    } catch (e) {
      emit(BookingFailure());
    }
  }
  void _onEditBooking(event, Emitter<BookingState> emit) async {
    try {
      BookingModel bookingModel = await _bookingRepository.getBookingById(event.id);
      //print(bookingModel.id);
      await _bookingRepository.editBooking(bookingModel);
      emit(BookingLoaded(bookingModel: [bookingModel]));
    } catch (e) {
      print(e);
      emit(BookingFailure());
    }
  }
}
