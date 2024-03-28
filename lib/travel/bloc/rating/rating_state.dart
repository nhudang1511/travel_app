part of 'rating_bloc.dart';
abstract class RatingState{
  const RatingState();
}
class RatingLoading extends RatingState{
}
class RatingLoaded extends RatingState{
  final List<RatingModel> ratings;
  final List<int> ratingCount;

  const RatingLoaded({this.ratings =  const <RatingModel>[], required this.ratingCount});
}
class RatingFailure extends RatingState{
}

class RatingEmpty extends RatingState {
}
