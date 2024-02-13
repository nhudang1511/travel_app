class Guest{
  final String? name;
  final String? country;
  final String? phone;
  final String? email;
  Guest({this.name, this.country, this.phone, this.email});
  static Guest fromDocument(Map<String, dynamic> doc) {
    return Guest(
      name: doc['name'] as String?,
      country: doc['country'] as String?,
      phone: doc['phoneNumber'] as String?,
      email: doc['email'] as String?,
    );
  }


  Map<String, dynamic> toDocument() {
    return {
      'phoneNumber': phone,
      'name': name,
      'country': country,
      'email': email
    };
  }

}