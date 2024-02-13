part of'user_bloc.dart';

abstract class UserEvent{
  const UserEvent();
}

class LoadUser extends UserEvent {
}
class UpdateUser extends UserEvent{
  final User user;

  const UpdateUser(this.user);
}