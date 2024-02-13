part of 'place_bloc.dart';
abstract class PlaceState extends Equatable{
  const PlaceState();
  @override
  List<Object?> get props => [];
}

class PlaceLoading extends PlaceState{
  @override
  List<Object?> get props => [];
}
class PlaceLoaded extends PlaceState{
  final List<PlaceModel> places;

  const PlaceLoaded({this.places = const <PlaceModel>[]});
  @override
  List<Object?> get props => [places];
}
class PlaceFailure extends PlaceState{
  @override
  List<Object?> get props => [];
}
