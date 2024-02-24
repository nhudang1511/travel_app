import 'dart:convert';

import 'custom_model.dart';
User userFromJson(String str) => User.fromJson(json.decode(str));
String userToJson(User data) => json.encode(data.toJson);
class User extends CustomModel {
  final String? name;
  final String? country;
  final String? phone;
  final String? email;
  final String? password;

  User({required String id, this.name, this.country, this.phone, this.email, this.password})
      : super(id: id);

  @override
  User fromDocument(Map<String, dynamic> doc, String id) {
    return User(
      id: id,
      phone: doc['phoneNumber'] as String?,
      name: doc['name'] as String?,
      country: doc['country'] as String?,
      email: doc['email'] as String?,
    );
  }
  factory User.fromJson(Map<String, dynamic> json) => User(
      id: '',
      name: json['name'],
      password: json['password']
  );
  Map<String, dynamic> toJson() {
    return {
      'name':name,
      'password':password
    };
  }
  @override
  Map<String, dynamic> toDocument() {
    return {
      'phoneNumber': phone,
      'name': name,
      'country': country,
      'email': email
    };
  }
}
