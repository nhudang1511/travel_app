abstract class CustomModel{
  final String id;

  CustomModel({required this.id});

  CustomModel fromDocument(Map<String, dynamic> doc, String id);
  Map<String, dynamic> toDocument();
}