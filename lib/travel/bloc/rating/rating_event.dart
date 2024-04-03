part of 'rating_bloc.dart';

//import 'package:flutter_nhu_nguyen/travel/model/rating_model.dart';

abstract class RatingEvent {
  const RatingEvent();
}

class LoadRating extends RatingEvent{
  final String hotelId;

  const LoadRating(this.hotelId);
}

class AddRating extends RatingEvent{
  final String? comment;
  final String? hotel;
  final List<String>? photos;
  final Timestamp? ratedTime;
  final int? rates;
  final String? user;

  AddRating({this.comment, this.hotel, this.photos, this.ratedTime, this.rates, this.user});
}