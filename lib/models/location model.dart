class LocationModel {
  final String title;
  final String subtitle;

  LocationModel({required this.title, required this.subtitle});

  factory LocationModel.fromJson(Map<String, dynamic> json) {
    return LocationModel(
      title: json['title'],
      subtitle: json['subtitle'],
    );
  }
}
