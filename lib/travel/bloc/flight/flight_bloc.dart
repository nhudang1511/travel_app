import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../model/filght_model.dart';
import '../../repository/flight_repository.dart';

part 'flight_event.dart';

part 'flight_state.dart';

class FlightBloc extends Bloc<FlightEvent, FlightState> {
  final FlightRepository _flightRepository;

  FlightBloc(this._flightRepository) : super(FlightLoading()) {
    on<LoadFlight>(_onLoadFlight);
    on<LoadFlightByDes>(_onLoadFlightByDes);
    on<SortFlightBy>(_onSortFlight);
  }

  void _onLoadFlight(event, Emitter<FlightState> emit) async {
    try {
      List<FlightModel> flights = await _flightRepository.getAllFlight();
      emit(FlightLoaded(flights: flights));
    } catch (e) {
      emit(FlightFailure());
    }
  }

  void _onLoadFlightByDes(event, Emitter<FlightState> emit) async {
    try {
      List<FlightModel> flights =
          await _flightRepository.getAllFlightByDes(event.from, event.to);
      emit(FlightLoaded(flights: flights));
    } catch (e) {
      emit(FlightFailure());
    }
  }

  void _onSortFlight(event, Emitter<FlightState> emit) async {
    try {
      List<FlightModel> flights = await _flightRepository.sortFlightBy(
          event.sort,
          event.start,
          event.end,
          event.services,
          event.transStart,
          event.transEnd);
      emit(FlightLoaded(flights: flights));
    } catch (e) {
      emit(FlightFailure());
    }
  }
}
