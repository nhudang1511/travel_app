part of 'hotel_bloc.dart';
abstract class HotelState{
  const HotelState();
}

class HotelLoading extends HotelState{
}

class HotelLoaded extends HotelState{
  final List<HotelModel> hotels;
  const HotelLoaded({this.hotels = const <HotelModel>[]});
}

class HotelFailure extends HotelState{
}

// class HotelStateLoading extends HotelState {
// }
//
// class HotelStateEmpty extends HotelState {
// }
//
// class HotelStateLoadSuccess extends HotelState {
//   final List<HotelModel> hotel;
//   final bool hasMoreHotel;
//
//   const HotelStateLoadSuccess(this.hotel, this.hasMoreHotel);
// }