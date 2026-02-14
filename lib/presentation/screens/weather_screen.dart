import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:weather_app/core/error/error_handler.dart';
import 'package:weather_app/core/helpers/weather_icon_helper.dart';
import 'package:weather_app/data/models/weather_model.dart';
import 'package:weather_app/data/services/weather_api_service.dart';
import 'package:weather_app/presentation/Components/custom_app_bar.dart';
import 'package:weather_app/presentation/Components/weather_background.dart';
import 'package:weather_app/core/helpers/text_color_helper.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  Future<WeatherResponse?>? _weatherFuture;
  final _citySearch = TextEditingController();
  bool isSearching = false;
  String currentLocation = "Asansol";

  Future<void> _refreshWeather() async {
    setState(() {
      _weatherFuture = fetchWeather(context, currentLocation);
    });

    await _weatherFuture;
  }

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
    Gradient gradient = getBackgroundGradient("Clear", DateTime.now());
    String lastSearchedCity = currentLocation;
    Color textColor = Colors.white;

    return Container(
      decoration: BoxDecoration(gradient: gradient),
      child: Padding(
        padding: const EdgeInsets.only(top: 16.0),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            // transparent: true,
            backgroundColor: Colors.transparent,
            title: isSearching
                ? Padding(
                  padding: const EdgeInsets.only(left: 16.0),
                  child: CupertinoSearchTextField(
                      controller: _citySearch,
                      style: TextStyle(color: textColor),
                      itemColor: textColor,
                      backgroundColor: textColor.withOpacity(0.1),
                      key: ValueKey(lastSearchedCity),
                      autofocus: true,
                      onSubmitted: (value) {
                        setState(() {
                          currentLocation = value;
                          _citySearch.text.trim() == ''
                              ? lastSearchedCity
                              : _searchWeather(value);
                          isSearching = false;
                        });
                      },
                    ),
                )
                : Container(
                    padding: const EdgeInsets.only(left: 16.0),
                    child: Text(
                      currentLocation,
                      style: TextStyle(fontSize: 24, color: textColor),
                    ),
                  ),

            actions: [
              Container(
                padding: const EdgeInsets.only(right: 16.0),
                child: IconButton(
                  iconSize: 24,
                  color: textColor,
                  icon: Icon(isSearching ? Icons.close : CupertinoIcons.search),
                  onPressed: () {
                    setState(() {
                      isSearching = !isSearching;
                    });
                  },
                ),
              ),
            ],
          ),
          body: LayoutBuilder(
            builder: (context, constraints) {
              return RefreshIndicator(
                onRefresh: _refreshWeather,
                color: Colors.white,
                backgroundColor: Colors.black.withOpacity(0.3),
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Center(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight: constraints.maxHeight,
                      ),
                      child: FutureBuilder(
                        future: _weatherFuture,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                              child: CircularProgressIndicator(
                                color: Colors.white,
                              ),
                            );
                          } else if (snapshot.hasError) {
                            ErrorHandler.showErrorHandler(
                              context,
                              'Error : ${snapshot.error}',
                            );
                          } else if (!snapshot.hasData ||
                              snapshot.data == null) {
                            return const Center(
                              child: Text(
                                "No data available",
                                style: TextStyle(color: Colors.white),
                              ),
                            );
                          }

                          final weather = snapshot.data!;

                          return Padding(
                            padding: const EdgeInsets.all(32.0),
                            child: Container(
                              alignment: Alignment.topLeft,  
                              child: const Text("Weather data loaded"),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
