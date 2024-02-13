import 'package:flutter_bloc/flutter_bloc.dart';
import '../../model/promo_model.dart';
import '../../repository/promo_repository.dart';

part 'promo_event.dart';

part 'promo_state.dart';

class PromoBloc extends Bloc<PromoEvent, PromoState> {
  final PromoRepository _promoRepository;

  PromoBloc(this._promoRepository) : super(PromoLoading()) {
    on<LoadPromo>(_onPromoLoaded);
  }

  void _onPromoLoaded(event, Emitter<PromoState> emit) async {
    try {
      Promo? promo = await _promoRepository.getPromoById(event.promo);
      emit(PromoLoaded(promo: promo));
    } catch (e) {
      emit(PromoFailure());
    }
  }
}
