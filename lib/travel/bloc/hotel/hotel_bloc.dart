import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../model/hotel_model.dart';
import '../../repository/hotel_repository.dart';

part 'hotel_event.dart';

part 'hotel_state.dart';

class HotelBloc extends Bloc<HotelEvent, HotelState> {
  final HotelRepository _hotelRepository;

  HotelBloc(this._hotelRepository) : super(HotelStateLoading()) {
    on<LoadHotels>(_onLoadHotel);
    on<LoadHotelByBooking>(_onLoadHotelByBooking);
    on<SortHotel>(_onSortHotel);
    on<LoadMore>(_onLoadMore);
    on<HotelEventStart>(_onHotelEventStart);
    on<HotelEventLoad>(_onHotelEventLoad);
    on<HotelEventFetchMore>(_onHotelEventFetchMore);
  }

  void _onLoadHotel(event, Emitter<HotelState> emit) async {
    try {
      List<HotelModel> hotels = await _hotelRepository.getAllHotel();
      emit(HotelLoaded(hotels: hotels));
    } catch (e) {
      emit(HotelFailure());
    }
  }

  void _onLoadMore(event, Emitter<HotelState> emit) async {
    try {
      List<HotelModel> hotels =
          await _hotelRepository.getHotels(event.limit, event.hotelModel);
      emit(HotelLoaded(hotels: hotels));
    } catch (e) {
      emit(HotelFailure());
    }
  }

  void _onLoadHotelByBooking(event, Emitter<HotelState> emit) async {
    try {
      List<HotelModel> hotels = await _hotelRepository.getAllHotelByBooking(
          event.maxGuest, event.maxRoom, event.destination);

      emit(HotelLoaded(hotels: hotels));
    } catch (e) {
      emit(HotelFailure());
    }
  }

  void _onSortHotel(event, Emitter<HotelState> emit) async {
    try {
      List<HotelModel> hotels = await _hotelRepository.sortHotel(event.sort);

      emit(HotelLoaded(hotels: hotels));
    } catch (e) {
      emit(HotelFailure());
    }
  }

  List<StreamSubscription> subscriptions = [];
  List<List<HotelModel>> hotels = [];
  bool hasMoreHotel = true;
  DocumentSnapshot? lastDoc;

  void _onHotelEventStart(event, Emitter<HotelState> emit) async{
    // Clean up our variables
    hasMoreHotel = true;
    lastDoc = null;
    for (var sub in subscriptions) {
      sub.cancel();
    }
    hotels.clear();
    subscriptions.clear();
    subscriptions.add(
        _hotelRepository.getHotel().listen((event) {
          handleStreamEvent(0, event);
        })
    );
  }
  void _onHotelEventLoad(event, Emitter<HotelState> emit) async{
    final elements = hotels.expand((i) => i).toList();

    if (elements.isEmpty) {
      emit(HotelStateEmpty());
    } else {
      emit(HotelStateLoadSuccess(elements, hasMoreHotel));
    }
  }
  void _onHotelEventFetchMore(event, Emitter<HotelState> emit) async{
    if (lastDoc == null) {
      throw Exception("Last doc is not set");
    }
    final index = hotels.length;
    subscriptions.add(
       _hotelRepository.getHotelPage(lastDoc!).listen((event) {
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
      hasMoreHotel = false;
    }

    // If the snapshot is empty, there's nothing for us to do
    if (snap.docs.isEmpty) return;

    if (index == hotels.length) {
      // Set the last document we pulled to use as a cursor
      lastDoc = snap.docs[snap.docs.length - 1];
    }
    // Turn the QuerySnapshot into a List of hotels
    List<HotelModel> newList = [];
    for (var doc in snap.docs) {
      var data = doc.data() as Map<String, dynamic>;
      data['id'] = doc.id;
      final newItems = HotelModel().fromDocument(data);
      newList.add(newItems);
        }


    // Update the hotels list
    if (hotels.length <= index) {
      hotels.add(newList);
    } else {
      hotels[index].clear();
      hotels[index] = newList;
    }
    add(HotelEventLoad(hotels));
  }
}
