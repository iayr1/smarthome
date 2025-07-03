class Weather {
  final double temperature;
  final String condition;
  final String iconCode;
  final int humidity;
  final double windSpeed;

  Weather({
    required this.temperature,
    required this.condition,
    required this.iconCode,
    required this.humidity,
    required this.windSpeed,
  });

  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(
      temperature: json['main']['temp'].toDouble(),
      condition: json['weather'][0]['main'],
      iconCode: json['weather'][0]['icon'],
      humidity: json['main']['humidity'],
      windSpeed: json['wind']['speed'].toDouble(),
    );
  }

  double get temperatureInFahrenheit => (temperature * 9/5) + 32;

  String getTemperatureString(bool isCelsius) {
    if (isCelsius) {
      return '${temperature.round()}°C';
    } else {
      return '${temperatureInFahrenheit.round()}°F';
    }
  }
}