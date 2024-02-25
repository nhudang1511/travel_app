import 'dart:convert';

import 'custom_model.dart';



class User extends CustomModel {
  final String? name;
  final String? country;
  final String? phone;
  final String? email;
  final String? password;

  User(
      {required String id,
      this.name,
      this.country,
      this.phone,
      this.email,
      this.password})
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

  factory User.fromJson(Map<String, dynamic> json) =>  User(
    id: '',
    password: json['password'] as String?,
    phone: json['phoneNumber'] as String?,
    name: json['name'] as String?,
    country: json['country'] as String?,
    email: json['email'] as String?,
  );

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'password': password,
      'email': email,
      'phone': phone,
      'country': country
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
