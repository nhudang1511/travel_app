class Seat{
  final String? name;
  final String? type;
  final int? col;
  final int? row;

  Seat({this.name, this.type, this.col, this.row});

  static Seat fromDocument(Map<String, dynamic> doc) {
    return Seat(
      name: doc['name'] as String?,
      type: doc['type'] as String?,
      col: doc['col'] as int?,
      row: doc['row'] as int?
    );
  }

  Map<String, dynamic> toDocument() {
    return {
      'name':name,
      'type':type,
      'col':col,
      'row':row
    };
  }

}