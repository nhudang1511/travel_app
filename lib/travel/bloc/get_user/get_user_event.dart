part of 'get_user_bloc.dart';

abstract class GetUserEvent {
  const GetUserEvent();
}

class LoadUserEvent extends GetUserEvent{
  final String Id;

  const LoadUserEvent(this.Id);
}

