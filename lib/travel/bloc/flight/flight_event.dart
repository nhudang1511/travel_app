part of 'flight_bloc.dart';

abstract class FlightEvent {
  const FlightEvent();
}

class LoadFlight extends FlightEvent {}

class LoadAllFlight extends FlightEvent {}

class LoadFlightByDes extends FlightEvent {
  final String from;
  final String to;
  final DateTime selectedDate;
  final int passengers;

  LoadFlightByDes(
      {required this.from,
      required this.to,
      required this.selectedDate,
      required this.passengers});
}

class SortFlightBy extends FlightEvent {
  final String sort;
  final num start;
  final num end;
  final List<String> services;
  final num transStart;
  final num transEnd;

  SortFlightBy(
      {required this.sort,
      required this.start,
      required this.end,
      required this.services,
      required this.transStart,
      required this.transEnd});
}

class EditFlight extends FlightEvent {
  final String flightId;
  final List<Seat> seat;

  EditFlight(
      {required this.flightId,
      required this.seat});
}
