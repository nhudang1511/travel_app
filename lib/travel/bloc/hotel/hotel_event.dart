part of 'hotel_bloc.dart';

abstract class HotelEvent {}

class LoadHotels extends HotelEvent {}

class LoadHotelByBooking extends HotelEvent {
  final String destination;
  final int maxGuest;
  final int maxRoom;

  LoadHotelByBooking(this.maxGuest, this.maxRoom, this.destination);
}

class SortHotel extends HotelEvent {
  final String sort;

  SortHotel(this.sort);
}

class RateHotel extends HotelEvent {
  final num rate;

  RateHotel(this.rate);
}

class SortHotelByBudget extends HotelEvent {
  final num start;
  final num end;

  SortHotelByBudget({required this.start, required this.end});
}

class SortHotelByServices extends HotelEvent {
  final List<String> services;

  SortHotelByServices({required this.services});
}

class SortHotelByProperty extends HotelEvent {
  final String property;

  SortHotelByProperty({required this.property});
}

class SortHotelBy extends HotelEvent {
  final String sort;
  final num rate;
  final num start;
  final num end;
  final List<String> services;
  final String property;

  SortHotelBy(
      {required this.sort,
      required this.rate,
      required this.start,
      required this.end,
      required this.services,
      required this.property});
}
