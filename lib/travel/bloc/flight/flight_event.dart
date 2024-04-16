part of 'flight_bloc.dart';
abstract class FlightEvent {
  const FlightEvent();
}
class LoadFlight extends FlightEvent {
}
class LoadFlightByDes extends FlightEvent {
  final String from;
  final String to;
  LoadFlightByDes({required this.from, required this.to});
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
        required this.transEnd
      });
}

// class FlightEventStart extends FlightEvent {
//   final String from;
//   final String to;
//   FlightEventStart(this.from, this.to);
// }
//
// class FlightEventLoad extends FlightEvent {
//   final List<List<FlightModel>> flight;
//
//   const FlightEventLoad(this.flight);
// }
//
// class FlightEventFetchMore extends FlightEvent {
//   final String from;
//   final String to;
//   const FlightEventFetchMore(this.from, this.to);
// }