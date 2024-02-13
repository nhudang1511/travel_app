import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../repository/authentication_repository.dart';

part 'forgotPassword_state.dart';

class ForgotPasswordCubit extends Cubit<ForgotPasswordState> {
  final AuthRepository _authRepository;

  ForgotPasswordCubit(this._authRepository)
      :super(ForgotPasswordState.initial());

  void emailChanged(String value) {
    emit(state.copyWith(email: value, status: ForgotPasswordStatus.initial));
  }

  Future<void> forgotPassword() async {
    if (state.status == ForgotPasswordStatus.submitting) return;
    emit(state.copyWith(status: ForgotPasswordStatus.submitting));
    try {
      final result = await _authRepository.forgotPassword(state.email);
      if (result == true) {
        emit(state.copyWith(status: ForgotPasswordStatus.success));
      } else {
        emit(state.copyWith(status: ForgotPasswordStatus.error));
      }
    } catch (e) {
      emit(state.copyWith(status: ForgotPasswordStatus.error));
    }
  }
}
