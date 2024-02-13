part of 'card_bloc.dart';
abstract class CardState{
  const CardState();
}

class CardLoading extends CardState{
}
class CardLoaded extends CardState{
  final CardModel? card;

  const CardLoaded({required this.card});
}
class CardFailure extends CardState{
}
