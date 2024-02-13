part of 'flight_bloc.dart';
abstract class FlightState{
  const FlightState();
}

class FlightLoading extends FlightState{
  
}
class FlightLoaded extends FlightState{
  final List<FlightModel> flights;

  const FlightLoaded({this.flights = const <FlightModel>[]});
 
}
class FlightFailure extends FlightState{
  
}
