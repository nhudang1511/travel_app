part of 'flight_bloc.dart';
abstract class FlightEvent {
  const FlightEvent();
}
class FlightEventStart extends FlightEvent {
  final String from;
  final String to;
  FlightEventStart(this.from, this.to);
}

class FlightEventLoad extends FlightEvent {
  final List<List<FlightModel>> flight;

  const FlightEventLoad(this.flight);
}

class FlightEventFetchMore extends FlightEvent {
  final String from;
  final String to;
  const FlightEventFetchMore(this.from, this.to);
}