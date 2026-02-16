import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:weather_app/core/error/error_handler.dart';
import 'package:weather_app/core/helpers/capitalizer.dart';
import 'package:weather_app/core/helpers/weather_icon_helper.dart';
import 'package:weather_app/data/models/weather_model.dart';
import 'package:weather_app/data/services/weather_api_service.dart';
import 'package:weather_app/presentation/Components/weather_background.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  Future<WeatherResponse?>? _weatherFuture;
  final TextEditingController _citySearch = TextEditingController();

  bool isSearching = false;
  String currentLocation = "New York";
  Gradient? _lastGradient;

  // @override
  // void initState() {
  //   super.initState();
  //   _searchWeather(currentLocation);
  // }

  @override
  void initState() {
    super.initState();
    _weatherFuture = fetchWeather(context, currentLocation);
  }

  @override
  void dispose() {
    _citySearch.dispose();
    super.dispose();
  }

  Future<void> _refreshWeather() async {
    setState(() {
      _weatherFuture = fetchWeather(context, currentLocation);
    });

    await _weatherFuture;
  }

  void _searchWeather(String city) async {
    if (city.trim().isEmpty) {
      ErrorHandler.showErrorHandler(context, 'Please enter a city name');
      return;
    }

    setState(() {
      isSearching = false;
    });

    try {
      final result = await fetchWeather(context, city);

      if (result != null) {
        setState(() {
          currentLocation = city;
          _weatherFuture = Future.value(result);
        });
      }
    } catch (e) {
      ErrorHandler.showErrorHandler(
        context,
        e.toString().replaceFirst('Exception: ', ''),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<WeatherResponse?>(
      future: _weatherFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return AnimatedContainer(
            duration: const Duration(milliseconds: 1000),
            curve: Curves.easeInOutCubicEmphasized,
            decoration: BoxDecoration(
              gradient:
                  _lastGradient ??
                  const LinearGradient(
                    colors: [
                      Color.fromARGB(255, 25, 49, 59),
                      Color.fromARGB(255, 13, 22, 29),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
            ),
            child: const Scaffold(
              backgroundColor: Colors.transparent,
              body: Center(
                child: CircularProgressIndicator(color: Colors.white),
              ),
            ),
          );
        }

        // if (snapshot.hasError) {
        //   WidgetsBinding.instance.addPostFrameCallback((_) {
        //     ErrorHandler.showErrorHandler(
        //       context,
        //       snapshot.error.toString().replaceFirst('Exception: ', ''),
        //     );
        //   });

        //   return Container(
        //     decoration: BoxDecoration(
        //       gradient:
        //           _lastGradient ??
        //           getBackgroundGradient("Clear", DateTime.now()),
        //     ),
        //     child: const Scaffold(backgroundColor: Colors.transparent),
        //   );
        // }

        if (!snapshot.hasData || snapshot.data == null) {
          return const Scaffold(
            body: Center(
              child: Text(
                "No data available",
                style: TextStyle(color: Colors.white),
              ),
            ),
          );
        }

        final weather = snapshot.data!;

        final gradient = getBackgroundGradient(
          // "Rain",
          weather.current.sky,
          DateTime.now(),
        );

        _lastGradient = gradient;

        final textColor = Colors.white;

        return AnimatedContainer(
          duration: const Duration(milliseconds: 1200),
          curve: Curves.easeInOutCubic,
          decoration: BoxDecoration(gradient: gradient),
          child: Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              toolbarHeight: 120,
              backgroundColor: Colors.transparent,
              elevation: 0,
              title: isSearching
                  ? Padding(
                      padding: const EdgeInsets.only(left: 16.0),
                      child: CupertinoSearchTextField(
                        controller: _citySearch,
                        style: TextStyle(color: textColor),
                        itemColor: textColor,
                        backgroundColor: textColor.withOpacity(0.15),
                        autofocus: true,
                        onSubmitted: (value) {
                          _searchWeather(value);
                        },
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.only(left: 14.0),
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 6.0),
                            child: Icon(
                              size: 32,
                              Icons.location_on_rounded,
                              color: textColor,
                            ),
                          ),
                          Text(
                            capitalizeWords(currentLocation),
                            style: TextStyle(
                              fontSize: 32,
                              color: textColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
              actions: [
                Padding(
                  padding: const EdgeInsets.only(right: 16.0),
                  child: IconButton(
                    icon: Icon(
                      isSearching ? Icons.close : CupertinoIcons.search,
                      color: textColor,
                    ),
                    onPressed: () {
                      setState(() {
                        isSearching = !isSearching;
                      });
                    },
                  ),
                ),
              ],
            ),
            body: RefreshIndicator(
              onRefresh: _refreshWeather,
              color: Colors.white,
              backgroundColor: Colors.black.withOpacity(0.3),
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32.0,
                    vertical: 0,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.alphabetic,
                        children: [
                          Text(
                            "${weather.current.temp.toInt()}",
                            style: TextStyle(
                              fontSize: 72,
                              fontWeight: FontWeight.bold,
                              color: textColor,
                            ),
                          ),
                          Text(
                            "°C",
                            style: TextStyle(fontSize: 32, color: textColor),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(
                            getIcon(weather.current.sky, DateTime.now()),
                            size: 32,
                            color: textColor,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            weather.current.sky,
                            style: TextStyle(fontSize: 24, color: textColor),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        "Humidity: ${weather.current.humidity}%",
                        style: TextStyle(fontSize: 18, color: textColor),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "Pressure: ${weather.current.pressure} hPa",
                        style: TextStyle(fontSize: 18, color: textColor),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "Wind Speed: ${weather.current.windSpeed} m/s",
                        style: TextStyle(fontSize: 18, color: textColor),
                      ),
                      // const SizedBox(height: 8),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
