import 'dart:convert';

class Localizacaomodel {
  double latitude;
  double longitude;
  Localizacaomodel({
    required this.latitude,
    required this.longitude,
  });

  static Localizacaomodel getMock() {
    return Localizacaomodel(
      latitude: 0,
      longitude: 0,
    );
  }

  Localizacaomodel copyWith({
    double? latitude,
    double? longitude,
  }) {
    return Localizacaomodel(
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'latitude': latitude,
      'longitude': longitude,
    };
  }

  factory Localizacaomodel.fromMap(Map<String, dynamic> map) {
    return Localizacaomodel(
      latitude: map['latitude']?.toDouble() ?? 0.0,
      longitude: map['longitude']?.toDouble() ?? 0.0,
    );
  }

  String toJson() => json.encode(toMap());

  factory Localizacaomodel.fromJson(String source) =>
      Localizacaomodel.fromMap(json.decode(source));

  @override
  String toString() =>
      'Localizacaomodel(latitude: $latitude, longitude: $longitude)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Localizacaomodel &&
        other.latitude == latitude &&
        other.longitude == longitude;
  }

  @override
  int get hashCode => latitude.hashCode ^ longitude.hashCode;
}
