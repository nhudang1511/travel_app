part of 'auth_bloc.dart';

abstract class AuthState {
  const AuthState();
}

class AuthInitial extends AuthState {}

class AuthenticateState extends AuthState {
  final User? authUser;
  const AuthenticateState({required this.authUser});

  @override
  String toString() {
    return 'AuthenticateState{authUser: ${authUser?.email}}';
  }
}

class UnAuthenticateState extends AuthState {}
