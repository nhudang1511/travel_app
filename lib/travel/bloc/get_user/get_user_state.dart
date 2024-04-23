part of 'get_user_bloc.dart';
abstract class GetUserState{
  const GetUserState();
}
class GetUserLoading extends GetUserState{
}
class GetUserLoaded extends GetUserState{
  final User user;

  const GetUserLoaded({required this.user});
}
class GetUserFailure extends GetUserState{
}

class GetUsergEmpty extends GetUserState {
}