import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter_nhu_nguyen/travel/model/rating_model.dart';
import 'package:flutter_nhu_nguyen/travel/repository/repository.dart';

part 'rating_event.dart';
part 'rating_state.dart';

class RatingBloc extends Bloc<RatingEvent, RatingState> {
  final RatingRepository _ratingRepository;
  RatingBloc(this._ratingRepository) : super(RatingLoading()) {
    on<LoadRating>(_onRatingLoaded);
  }

  void _onRatingLoaded(event, Emitter<RatingState> emit) async {
    try {
      List<int> ratingCount= List.filled(5, 0);
      List<RatingModel> ratingModel = await _ratingRepository.getRatingByHotel(event.hotelId);
      ratingModel.forEach((rating) {
        switch(rating.rates) {
          case 1: 
            ratingCount[0]++;
            break;
          case 2: 
            ratingCount[1]++;
            break;
          case 3: 
            ratingCount[2]++;
            break;
          case 4: 
            ratingCount[3]++;
            break;
          case 5: 
            ratingCount[4]++;
            break;
          default:
            break;
        }
       });
      if(ratingModel.isEmpty){
        emit(RatingEmpty());
      }else{
        emit(RatingLoaded(ratings: ratingModel, ratingCount: ratingCount));
      }
    } catch (e) {
      emit(RatingFailure());
    }
  }
}