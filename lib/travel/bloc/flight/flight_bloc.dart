import 'package:flutter_bloc/flutter_bloc.dart';
import '../../model/filght_model.dart';
import '../../repository/flight_repository.dart';

part 'flight_event.dart';

part 'flight_state.dart';

class FlightBloc extends Bloc<FlightEvent, FlightState> {
  final FlightRepository _flightRepository;

  FlightBloc(this._flightRepository) : super(FlightLoading()) {
    on<LoadFlight>(_onLoadFlight);
    on<SearchFlight>(_onSearchFlight);
  }

  void _onLoadFlight(event, Emitter<FlightState> emit) async {
    try {
      List<FlightModel> flight = await _flightRepository.getAllFlight();
      emit(FlightLoaded(flights: flight));
    } catch (e) {
      emit(FlightFailure());
    }
  }

  void _onSearchFlight(event, Emitter<FlightState> emit) async {
    try {
      List<FlightModel> flight = await _flightRepository.searchFlight(
          event.fromPlace, event.toPlace);
      emit(FlightLoaded(flights: flight));
    } catch (e) {
      print(e);
      emit(FlightFailure());
    }
  }
}
