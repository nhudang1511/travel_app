part of 'hotel_bloc.dart';
abstract class HotelEvent {
}

class LoadHotels extends HotelEvent {
}
class LoadHotelByBooking extends HotelEvent{
  final String destination;
  final int maxGuest;
  final int maxRoom;
  LoadHotelByBooking(this.maxGuest, this.maxRoom, this.destination);
}
class SortHotel extends HotelEvent{
  final String sort;
  SortHotel(this.sort);
}
class LoadMore extends HotelEvent{
  final int limit;
  final HotelModel hotelModel;
  LoadMore(this.limit, this.hotelModel);
}

class HotelEventStart extends HotelEvent {
}

class HotelEventLoad extends HotelEvent {
  final List<List<HotelModel>> flight;

  HotelEventLoad(this.flight);
}

class HotelEventFetchMore extends HotelEvent {
}