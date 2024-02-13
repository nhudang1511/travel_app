part of 'place_bloc.dart';
abstract class PlaceEvent{
  const PlaceEvent();
}
class LoadPlace extends PlaceEvent{
}
class SearchPlace extends PlaceEvent{
  String name;
  SearchPlace({required this.name});
}
