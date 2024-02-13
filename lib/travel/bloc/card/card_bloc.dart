import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_nhu_nguyen/travel/model/card_model.dart';

part 'card_event.dart';

part 'card_state.dart';

class CardBloc extends Bloc<CardEvent, CardState> {
  CardBloc() : super(CardLoading()) {
    on<LoadCard>(_onCardLoaded);
  }

  void _onCardLoaded(event, Emitter<CardState> emit) async {
    try {
      emit(CardLoaded(card: event.card));
    } catch (e) {
      emit(CardFailure());
    }
  }
}
