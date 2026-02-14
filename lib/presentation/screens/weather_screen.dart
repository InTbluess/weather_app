import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:weather_app/core/error/error_handler.dart';
import 'package:weather_app/core/helpers/weather_icon_helper.dart';
import 'package:weather_app/data/models/weather_model.dart';
import 'package:weather_app/data/services/weather_api_service.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  Future<WeatherResponse?>? _weatherFuture;
  final _citySearch = TextEditingController();

  void _searchWeather(String city) {
    setState(() {
      if (city.isNotEmpty) {
        _weatherFuture = fetchWeather(context, city);
      } else {
        ErrorHandler.showErrorHandler(context, 'Please enter a city name');
      }
    });
  }

  @override
  void initState() {
    _searchWeather('Asansol');
    super.initState();
  }

  @override
  void dispose() {
    _citySearch.dispose();
    _weatherFuture = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
    );
  }
}
