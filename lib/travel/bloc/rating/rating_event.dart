part of 'rating_bloc.dart';

//import 'package:flutter_nhu_nguyen/travel/model/rating_model.dart';

abstract class RatingEvent {
  const RatingEvent();
}

class LoadRating extends RatingEvent{
  final String hotelId;

  const LoadRating(this.hotelId);
}