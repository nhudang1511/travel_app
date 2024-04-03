import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_nhu_nguyen/travel/model/notification_model.dart';

import '../../repository/notification_repository.dart';

part 'notification_event.dart';

part 'notification_state.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  final NotificationRepository _notificationRepository;

  NotificationBloc(this._notificationRepository)
      : super(NotificationLoading()) {
    on<AddNotification>(_onAddNotification);
    on<LoadNotification>(_onLoadNotification);
  }

  void _onAddNotification(event, Emitter<NotificationState> emit) async {
    try {
      NotificationModel? notificationModel = await _notificationRepository
          .addNotification(event.notification.toDocument());
      emit(NotificationAdded(notification: notificationModel));
    } catch (e) {
      print('failure: $e}');
      emit(NotificationFailure());
    }
  }

  void _onLoadNotification(event, Emitter<NotificationState> emit) async {
    try {
      List<NotificationModel> notificationModel =
          await _notificationRepository.getAllNotificationById(event.uId);

      emit(NotificationLoaded(notifications: notificationModel));
    } catch (e) {
      emit(NotificationFailure());
    }
  }
}
