part of'auth_bloc.dart';

abstract class AuthEvent{
  const AuthEvent();
}

class AuthEventStarted extends AuthEvent {}
class AuthEventChanged extends AuthEvent {
  final User? authUser;
  const AuthEventChanged(this.authUser);
}
class AuthEventLoggedOut extends AuthEvent {}



