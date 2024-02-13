class Seat{
  final String? name;
  final String? type;

  Seat({this.name, this.type});

  static Seat fromDocument(Map<String, dynamic> doc) {
    return Seat(
      name: doc['name'] as String?,
      type: doc['type'] as String?
    );
  }

  Map<String, dynamic> toDocument() {
    return {
      'name':name,
      'type':type
    };
  }

}