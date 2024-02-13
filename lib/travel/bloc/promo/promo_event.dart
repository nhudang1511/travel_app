part of 'promo_bloc.dart';
abstract class PromoEvent{
  const PromoEvent();
}
class LoadPromo extends PromoEvent {
  final String? promo;
  const LoadPromo(this.promo);
}
