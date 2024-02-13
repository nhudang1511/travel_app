part of 'card_bloc.dart';

abstract class CardEvent {
  const CardEvent();
}

class LoadCard extends CardEvent {
  final CardModel card;

  const LoadCard(
      {required this.card});
}
