
import 'package:flutter/material.dart';
import 'package:weather/weather.dart';
import 'package:acm_app_project/consts.dart';
import 'package:intl/intl.dart';


class searchPage extends StatefulWidget {
  @override
  _searchPageState createState() => _searchPageState();
}

class _searchPageState extends State<searchPage> {
  final WeatherFactory _weatherFactory = WeatherFactory(OPENWEATHER_API_KEY);
  Weather? _weather;
  TextEditingController _searchController = TextEditingController();

  void _fetchWeather(String city) {
    _weatherFactory.currentWeatherByCityName(city).then((weather) {
      setState(() {
        _weather = weather;
      });
    }).catchError((e) {
      print('Error fetching weather: $e');
      setState(() {
        _weather = null; // Reset weather if there's an error
      });
    });
  }

  void _searchLocation() {
    String searchTerm = _searchController.text.trim();
    if (searchTerm.isNotEmpty) {
      _fetchWeather(searchTerm);
      _searchController.clear(); // Clear the search field after fetching
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Location'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search for a city',
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: _searchLocation,
                ),
                border: const OutlineInputBorder(),
              ),
              onSubmitted: (value) => _searchLocation(),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: _weather != null ? _buildWeatherInfo() : const Center(child: Text('No weather data')),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWeatherInfo() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          _weather!.areaName ?? "",
          style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 20),
        Text(
          "${_weather!.temperature?.celsius?.toStringAsFixed(0)}° C",
          style: const TextStyle(fontSize: 60, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 10),
        Text(_weather!.weatherDescription ?? ""),
        const SizedBox(height: 10),
        Image.network(
          "http://openweathermap.org/img/wn/${_weather!.weatherIcon}@2x.png",
        ),
      ],
    );
  }
}
