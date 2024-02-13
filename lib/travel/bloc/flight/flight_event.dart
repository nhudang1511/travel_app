part of 'flight_bloc.dart';
abstract class FlightEvent {
  const FlightEvent();
}

class LoadFlight extends FlightEvent{
}

class SearchFlight extends FlightEvent{
  final String? fromPlace;
  final String? toPlace;
  SearchFlight({this.fromPlace, this.toPlace,});
}
