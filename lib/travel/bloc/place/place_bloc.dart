import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_nhu_nguyen/travel/model/place_model.dart';
import '../../repository/place_repository.dart';

part 'place_event.dart';
part 'place_state.dart';

class PlaceBloc extends Bloc<PlaceEvent, PlaceState> {
  final PlaceRepository _placeRepository;

  PlaceBloc(this._placeRepository)
      :super(PlaceLoading()){
    on<LoadPlace>(_onLoadPlace);
    on<SearchPlace>(_onSearchPlace);
  }
  void _onLoadPlace(event, Emitter<PlaceState> emit) async{
   try{
     List<PlaceModel> place = await _placeRepository.getAllPlace();
     emit(PlaceLoaded(places: place));
   }
   catch(e){
     emit(PlaceFailure());
   }
  }
  void _onSearchPlace(event, Emitter<PlaceState> emit) async{
    try{
      List<PlaceModel> place = await _placeRepository.getAllPlaceByName(event.name);
      emit(PlaceLoaded(places: place));
    }
    catch(e){
      emit(PlaceFailure());
    }
  }
}
