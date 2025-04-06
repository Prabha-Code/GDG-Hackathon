import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  String weatherInfo = "Fetching weather data...";

  @override
  void initState() {
    super.initState();
    fetchWeather();
  }

  Future<void> fetchWeather() async {
    try {
      final response = await http.get(Uri.parse('http://127.0.0.1:5000/weather')); // Change this

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          weatherInfo = "🌡 Temp: ${data['temperature']}°C\n💧 Humidity: ${data['humidity']}%\n🌬 Wind: ${data['wind_speed']} km/h";
        });
      } else {
        setState(() {
          weatherInfo = "Error fetching weather data.";
        });
      }
    } catch (e) {
      setState(() {
        weatherInfo = "Connection error: $e";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Weather Forecast")),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            weatherInfo,
            style: const TextStyle(fontSize: 18),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}

