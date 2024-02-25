import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../config/failure.dart';
import '../../model/user_model.dart';
import '../../repository/authentication_repository.dart';

part 'signup_state.dart';

class SignupCubit extends Cubit<SignupState> {
  final AuthRepository _authRepository;
  User? newUser;

  SignupCubit(this._authRepository) : super(SignupState.initial()) {}

  void fullNameChanged(String value) {
    emit(
      state.copyWith(
        name: value,
        status: SignupStatus.initial,
      ),
    );
  }

  void phoneNumberChanged(String value) {
    emit(
      state.copyWith(
        phone: value,
        status: SignupStatus.initial,
      ),
    );
  }

  void emailChanged(String value) {
    emit(
      state.copyWith(
        email: value,
        status: SignupStatus.initial,
      ),
    );
  }

  void countryChanged(String value) {
    emit(
      state.copyWith(
        country: value,
        status: SignupStatus.initial,
      ),
    );
  }

  void passwordChanged(String value) {
    emit(
      state.copyWith(
        password: value,
        status: SignupStatus.initial,
      ),
    );
  }

  Future<void> signUpWithEmailAndPassword() async {
    if (state.status == SignupStatus.submitting) return;
    emit(state.copyWith(status: SignupStatus.submitting));
    try {
      await _authRepository.signUp(
          name: state.name,
          country: state.country,
          phone: state.phone,
          email: state.email,
          password: state.password);
      emit(state.copyWith(status: SignupStatus.success));
    } on SignUpWithEmailAndPasswordFailure catch (e) {
      emit(state.copyWith(status: SignupStatus.emailExists));
    } catch (_) {
      emit(state.copyWith(status: SignupStatus.error));
    }
  }
}
