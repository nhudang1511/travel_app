part of 'promo_bloc.dart';
abstract class PromoState{
  const PromoState();
}

class PromoLoading extends PromoState{
}
class PromoLoaded extends PromoState{
  final Promo? promo;

  const PromoLoaded({required this.promo});
}
class PromoFailure extends PromoState{
}
