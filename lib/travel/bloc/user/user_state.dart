part of'user_bloc.dart';

abstract class UserState{
  const UserState();
}

class UserLoading extends UserState{
}
class UserLoaded extends UserState{
  final User user;

  const UserLoaded({required this.user});
}
class UserFailure extends UserState{
}