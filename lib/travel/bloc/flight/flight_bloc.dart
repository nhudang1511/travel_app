import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../model/filght_model.dart';
import '../../repository/flight_repository.dart';

part 'flight_event.dart';

part 'flight_state.dart';

class FlightBloc extends Bloc<FlightEvent, FlightState> {


  FlightBloc() : super(FlightStateLoading()) {
    on<FlightEventStart>(_onFlightEventStart);
    on<FlightEventLoad>(_onFlightEventLoad);
    on<FlightEventFetchMore>(_onFlightEventFetchMore);
  }

  List<StreamSubscription> subscriptions = [];
  List<List<FlightModel>> flights = [];
  bool hasMoreFlight = true;
  DocumentSnapshot? lastDoc;

  void _onFlightEventStart(event, Emitter<FlightState> emit) async{
    // Clean up our variables
    hasMoreFlight = true;
    lastDoc = null;
    for (var sub in subscriptions) {
      sub.cancel();
    }
    flights.clear();
    subscriptions.clear();
    subscriptions.add(
        FlightRepository().getFlight().listen((event) {
          handleStreamEvent(0, event);
        })
    );
  }
  void _onFlightEventLoad(event, Emitter<FlightState> emit) async{
    final elements = flights.expand((i) => i).toList();

    if (elements.isEmpty) {
      emit(FlightStateEmpty());
    } else {
      emit(FlightStateLoadSuccess(elements, hasMoreFlight));
    }
  }
  void _onFlightEventFetchMore(event, Emitter<FlightState> emit) async{
    if (lastDoc == null) {
      throw Exception("Last doc is not set");
    }
    final index = flights.length;
    subscriptions.add(
        FlightRepository().getPostsPage(lastDoc!).listen((event) {
          handleStreamEvent(index, event);
        })
    );
  }
  @override
  onChange(change) {
    //print(change);
    super.onChange(change);
  }

  @override
  Future<void> close() async {
    for (var s in subscriptions) {
      s.cancel();
    }
    super.close();
  }
  handleStreamEvent(int index, QuerySnapshot snap) {
    if (snap.docs.length < 3) {
      hasMoreFlight = false;
    }

    // If the snapshot is empty, there's nothing for us to do
    if (snap.docs.isEmpty) return;

    if (index == flights.length) {
      // Set the last document we pulled to use as a cursor
      lastDoc = snap.docs[snap.docs.length - 1];
    }
    // Turn the QuerySnapshot into a List of flights
    List<FlightModel> newList = [];
    for (var doc in snap.docs) {
      var data = doc.data();
      if (data != null) {
        final newItems = FlightModel().fromDocument(data as Map<String, dynamic>);
        newList.add(newItems);
      }
    }


    // Update the flights list
    if (flights.length <= index) {
      flights.add(newList);
    } else {
      flights[index].clear();
      flights[index] = newList;
    }
    add(FlightEventLoad(flights));
  }
  
}
