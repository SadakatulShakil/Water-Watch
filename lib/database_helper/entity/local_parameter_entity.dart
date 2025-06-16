import 'package:floor/floor.dart';

@entity
class ParameterEntity {
  @primaryKey
  final String id;
  final String title;

  ParameterEntity({required this.id, required this.title});

  factory ParameterEntity.fromJson(Map<String, dynamic> json) {
    return ParameterEntity(
      id: json['id'],
      title: json['title'],
    );
  }
}
