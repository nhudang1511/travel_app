part of 'rating_bloc.dart';
abstract class RatingState{
  const RatingState();
}
class RatingLoading extends RatingState{
}
class RatingLoaded extends RatingState{
  final List<RatingModel> ratings;
  final List<int> ratingCount;
  final int ratingTotal;

  const RatingLoaded({this.ratings =  const <RatingModel>[], required this.ratingCount, required this.ratingTotal});
}
class RatingFailure extends RatingState{
}

class RatingEmpty extends RatingState {
}
class RatingAdded extends RatingState {
  final RatingModel ratingModel;

  RatingAdded({required this.ratingModel});
}