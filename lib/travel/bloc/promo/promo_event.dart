part of 'promo_bloc.dart';
abstract class PromoEvent{
  const PromoEvent();
}
class LoadPromo extends PromoEvent {
  final String? code;
  const LoadPromo(this.code);
}
