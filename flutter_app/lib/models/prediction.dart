class Prediction {
  final double lon;
  final double lat;

  Prediction({required this.lon, required this.lat});

  factory Prediction.fromJson(Map<String, dynamic> json) {
    return Prediction(
      lon: json['lon'],
      lat: json['lat'],
    );
  }
}
