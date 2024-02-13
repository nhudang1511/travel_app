import 'custom_model.dart';

class User extends CustomModel {
  final String? name;
  final String? country;
  final String? phone;
  final String? email;

  User({required String id, this.name, this.country, this.phone, this.email})
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
