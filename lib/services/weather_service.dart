import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/weather.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class WeatherService {
  static final String _apiKey = dotenv.env['API_KEY'] ?? '';
  static const String _baseUrl = 'https://api.openweathermap.org/data/2.5/weather';
  static const String _defaultCity = 'Mumbai';

  Future<Weather> getCurrentWeather({String? city}) async {
    final cityName = city ?? _defaultCity;
    final url = '$_baseUrl?q=$cityName&appid=$_apiKey&units=metric';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        return Weather.fromJson(data);
      } else {
        try {
          final errorData = json.decode(response.body);
          final errorMessage = errorData['message'] ?? 'Unknown error';
          throw Exception('Weather API Error (${response.statusCode}): $errorMessage');
        } catch (e) {
          throw Exception('Weather API Error (${response.statusCode}): ${response.body}');
        }
      }
    } catch (e) {
      if (e is Exception) {
        rethrow;
      } else {
        throw Exception('Weather API Error: $e');
      }
    }
  }

  Future<Weather> getWeatherByCoordinates(double lat, double lon) async {
    final url = '$_baseUrl?lat=$lat&lon=$lon&appid=$_apiKey&units=metric';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        return Weather.fromJson(data);
      } else {
        try {
          final errorData = json.decode(response.body);
          final errorMessage = errorData['message'] ?? 'Unknown error';
          throw Exception('Weather API Error (${response.statusCode}): $errorMessage');
        } catch (e) {
          throw Exception('Weather API Error (${response.statusCode}): ${response.body}');
        }
      }
    } catch (e) {
      if (e is Exception) {
        rethrow;
      } else {
        throw Exception('Weather API Error: $e');
      }
    }
  }
}