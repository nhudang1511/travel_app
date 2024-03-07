import 'custom_model.dart';
class User extends CustomModel {
  final String? id;
  final String? name;
  final String? country;
  final String? phone;
  final String? email;
  final String? password;

  User(
      {this.id,
      this.name,
      this.country,
      this.phone,
      this.email,
      this.password});

  @override
  User fromDocument(Map<String, dynamic> doc) {
    return User(
      id: doc['id'],
      phone: doc['phoneNumber'] as String?,
      name: doc['name'] as String?,
      country: doc['country'] as String?,
      email: doc['email'] as String?,
    );
  }

  factory User.fromJson(Map<String, dynamic> json) =>  User(
    id: '',
    password: json['password'] as String?,
    phone: json['phoneNumber'] as String?,
    name: json['name'] as String?,
    country: json['country'] as String?,
    email: json['email'] as String?,
  );
  @override
  Map<String, dynamic> toDocument() {
    return {
      'name': name,
      'password': password,
      'email': email,
      'phone': phone,
      'country': country
    };
  }
}
