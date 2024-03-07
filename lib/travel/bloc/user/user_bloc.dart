import 'package:flutter_bloc/flutter_bloc.dart';
import '../../model/user_model.dart';
import '../../repository/repository.dart';

part 'user_event.dart';

part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final AuthRepository _authRepository;
  final UserRepository _userRepository;

  UserBloc(this._authRepository, this._userRepository)
      :super(UserLoading()) {
    on<LoadUser>(_onLoadUser);
    on<UpdateUser>(_onEditUser);
  }

  void _onLoadUser(LoadUser event, Emitter<UserState> emit) async {
    await for (User? authUser in _authRepository.user) {
      if (authUser != null) {
        User user = await _userRepository.getUserById(authUser.id ?? '');
        emit(UserLoaded(user: user));
      }
    }
    // List<User> user = await _userRepository.getAllUser();
    // emit(UserLoaded(user: user));
  }

  void _onEditUser(UpdateUser event, Emitter<UserState> emit) async {
    emit(UserLoading());
    try {
      await _userRepository.editUserById(event.user);
      emit(UserLoaded(user: event.user));
    } catch (e) {
      print(e);
      emit(UserFailure());
    }
    // List<User> user = await _userRepository.getAllUser();
    // emit(UserLoaded(user: user));
  }

}
