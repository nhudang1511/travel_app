part of 'flight_bloc.dart';
abstract class FlightState {
  const FlightState();
}
class FlightStateLoading extends FlightState {
}

class FlightStateEmpty extends FlightState {
}

class FlightStateLoadSuccess extends FlightState {
  final List<FlightModel> flight;
  final bool hasMoreFlight;

  const FlightStateLoadSuccess(this.flight, this.hasMoreFlight);
}