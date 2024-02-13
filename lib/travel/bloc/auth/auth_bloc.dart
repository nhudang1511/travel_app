import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../model/user_model.dart';
import '../../repository/authentication_repository.dart';
part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _authRepository;
  StreamSubscription? _authUserSubscription;

  AuthBloc(this._authRepository,
  ): super (AuthInitial()){
    on<AuthEventStarted>(_onAuthEventStarted);
    on<AuthEventChanged>(_onAuthEventChanged);
    on<AuthEventLoggedOut>(_onAuthEventLoggedOut);
  }
  void _onAuthEventStarted(
      AuthEventStarted event, Emitter<AuthState> emit) async {
    _authUserSubscription = _authRepository.user.listen((User? authUser) {
      if (authUser != null) {
        add(AuthEventChanged(authUser));
      } else {
        add(const AuthEventChanged(null));
      }
    });
  }
  void _onAuthEventChanged(
      AuthEventChanged event, Emitter<AuthState> emit) async {
    if (event.authUser != null) {
      emit(AuthenticateState(authUser: event.authUser));
    } else {
      emit(UnAuthenticateState());
    }
  }

  void _onAuthEventLoggedOut(
      AuthEventLoggedOut event, Emitter<AuthState> emit) async {
    unawaited(_authRepository.logOut());
  }

  @override
  Future<void> close() {
    _authUserSubscription?.cancel();
    return super.close();
  }
}
