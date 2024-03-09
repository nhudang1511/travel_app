part of 'flight_bloc.dart';
abstract class FlightEvent {
  const FlightEvent();
}
class FlightEventStart extends FlightEvent {
}

class FlightEventLoad extends FlightEvent {
  final List<List<FlightModel>> flight;

  const FlightEventLoad(this.flight);
}

class FlightEventFetchMore extends FlightEvent {
}