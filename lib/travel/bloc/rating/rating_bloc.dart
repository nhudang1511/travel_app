import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_nhu_nguyen/config/shared_preferences.dart';


import 'package:flutter_nhu_nguyen/travel/model/rating_model.dart';
import 'package:flutter_nhu_nguyen/travel/repository/repository.dart';

part 'rating_event.dart';
part 'rating_state.dart';

class RatingBloc extends Bloc<RatingEvent, RatingState> {
  final RatingRepository _ratingRepository;
  RatingBloc(this._ratingRepository) : super(RatingLoading()) {
    on<AddRating>(_onAddRating);
    on<LoadRating>(_onRatingLoaded);
  }

  void _onAddRating(event, Emitter<RatingState> emit) async{
    try {
      print('------------------------------');
      final rating = RatingModel(
        comment: event.comment,
        hotel: event.hotel,
        photos: event.photos,
        ratedTime: event.ratedTime,
        rates: event.rates,
        user: event.user
      );
      print('------------------------------');
      print( SharedService.getUserId());
      final ratingModel = await _ratingRepository.createRating(rating.toDocument());
      final bookingRepository = BookingRepository();
      await bookingRepository.editAddReviewBooking(event.booking, ratingModel.id??'');
      final userRepository = UserRepository(); 
      await userRepository.addPromoUserById();
      emit(RatingAdded(ratingModel: ratingModel));
    } catch (e) {
      emit(RatingFailure());
    }
  }

  void _onRatingLoaded(event, Emitter<RatingState> emit) async {
    try {
      List<int> ratingCount= List.filled(5, 0);
      List<RatingModel> ratingModel = await _ratingRepository.getRatingByHotel(event.hotelId);
      int ratingTotal = 0;
      ratingModel.forEach((rating) {
        ratingTotal+= rating.rates!;
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
        emit(RatingLoaded(ratings: ratingModel, ratingCount: ratingCount, ratingTotal: ratingTotal));
      }
    } catch (e) {
      emit(RatingFailure());
    }
  }
}