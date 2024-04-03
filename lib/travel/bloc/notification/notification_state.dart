part of 'notification_bloc.dart';
abstract class NotificationState {
}
class NotificationLoading extends NotificationState{}
class NotificationAdded extends NotificationState{
  final NotificationModel? notification;
  NotificationAdded({required this.notification});
}
class NotificationLoaded extends NotificationState{
  final List<NotificationModel> notifications;
  NotificationLoaded({required this.notifications});
}
class NotificationFailure extends NotificationState{}