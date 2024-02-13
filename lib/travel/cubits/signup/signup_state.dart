part of "signup_cubit.dart";

enum SignupStatus { initial, submitting, success, emailExists, error }

class SignupState extends Equatable {
  final String country;
  final String name;
  final String phone;
  final String email;
  final String password;
  final SignupStatus status;

  const SignupState({
    required this.country,
    required this.name,
    required this.phone,
    required this.email,
    required this.password,
    required this.status,
  });

  factory SignupState.initial() {
    return const SignupState(
      country: "",
      name: "",
      phone: "",
      email: "",
      password: '',
      status: SignupStatus.initial,
    );
  }

  SignupState copyWith({
    String? country,
    String? name,
    String? phone,
    String? email,
    String? password,
    SignupStatus? status,
  }) {
    return SignupState(
      country: country ?? this.country,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      password: password ?? this.password,
      status: status ?? this.status,
    );
  }

  @override
  List<Object?> get props => [country,name, phone, email, password, status];
}
