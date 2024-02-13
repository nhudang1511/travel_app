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
