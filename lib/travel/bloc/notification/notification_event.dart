part of 'notification_bloc.dart';
abstract class NotificationEvent {}

class LoadNotification extends NotificationEvent {
  final String uId;
  LoadNotification({required this.uId});
}
class AddNotification extends NotificationEvent{
  final NotificationModel notification;
  AddNotification({required this.notification});
}