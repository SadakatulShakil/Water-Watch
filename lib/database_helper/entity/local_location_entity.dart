import 'package:floor/floor.dart';

@entity
class LocationEntity {
  @primaryKey
  final String id;
  final String title;
  final String subtitle;

  LocationEntity({required this.id, required this.title, required this.subtitle});

  factory LocationEntity.fromJson(Map<String, dynamic> json) {
    return LocationEntity(
      id: json['id'],
      title: json['title'],
      subtitle: json['subtitle'],
    );
  }
}
