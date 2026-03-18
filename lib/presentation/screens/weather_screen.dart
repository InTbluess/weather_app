import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:weather_app/core/error/error_handler.dart';
import 'package:weather_app/core/helpers/capitalizer.dart';
import 'package:weather_app/core/helpers/weather_icon_helper.dart';
import 'package:weather_app/data/models/weather_model.dart';
import 'package:weather_app/data/services/weather_api_service.dart';
import 'package:weather_app/presentation/Components/weather_background.dart';
import 'package:weather_app/presentation/Components/weather_info_tile.dart';
import 'package:weather_app/presentation/Components/hourly_forecast_card.dart';

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
                      padding: const EdgeInsets.only(left: 10.0),
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
                  padding: const EdgeInsets.only(right: 14.0),
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
                    horizontal: 28.0,
                    vertical: 0,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
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
                                  height: 1,
                                ),
                              ),
                              Text(
                                "°C",
                                style: TextStyle(
                                  fontSize: 32,
                                  color: textColor,
                                ),
                              ),
                            ],
                          ),
                          Text(
                            "Feels like ${weather.current.feelsLike.toInt()}°",
                            style: TextStyle(fontSize: 18, color: textColor),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Icon(Icons.arrow_upward, color: textColor),
                          Text(
                            "${weather.current.maxTemp.toInt()}°",
                            style: TextStyle(fontSize: 22, color: textColor),
                          ),
                          SizedBox(width: 5),
                          Text(
                            "/",
                            style: TextStyle(fontSize: 22, color: textColor),
                          ),
                          SizedBox(width: 5),
                          Icon(Icons.arrow_downward, color: textColor),
                          Text(
                            "${weather.current.minTemp.toInt()}°",
                            style: TextStyle(fontSize: 22, color: textColor),
                          ),
                        ],
                      ),

                      const SizedBox(height: 28),

                      Row(
                        children: [
                          Icon(
                            getIcon(weather.current.sky, DateTime.now()),
                            size: 40,
                            color: textColor,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            capitalizeWords(weather.current.description),
                            style: TextStyle(fontSize: 28, color: textColor),
                          ),
                        ],
                      ),

                      const SizedBox(height: 32),

                      GridView.count(
                        crossAxisCount: 2,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        mainAxisSpacing: 14,
                        crossAxisSpacing: 14,
                        childAspectRatio: 3.2,
                        children: [
                          WeatherInfoTile(
                            icon: Icons.water_drop,
                            label: "Humidity",
                            value: "${weather.current.humidity} %",
                          ),

                          WeatherInfoTile(
                            icon: Icons.air,
                            label: "Wind",
                            value: "${weather.current.windSpeed} m/s",
                          ),

                          WeatherInfoTile(
                            icon: Icons.speed,
                            label: "Pressure",
                            value: "${weather.current.pressure} hPa",
                          ),

                          WeatherInfoTile(
                            icon: Icons.cloud,
                            label: "Clouds",
                            value: "${weather.current.cloudiness} %",
                          ),

                          WeatherInfoTile(
                            icon: Icons.visibility,
                            label: "Visibility",
                            value:
                                "${(weather.current.visibility / 1000).toStringAsFixed(1)} km",
                          ),

                          WeatherInfoTile(
                            icon: Icons.air,
                            label: "Wind Gust",
                            value: "${weather.current.windGust} m/s",
                          ),
                        ],
                      ),
                      const SizedBox(height: 26 ),

                      Text(
                        "Hourly Forecast",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: textColor,
                        ),
                      ),

                      const SizedBox(height: 16),

                      Container(
                        height: 237,
                        child: ListView.builder(

                          shrinkWrap: true,
                          // physics: const NeverScrollableScrollPhysics(),
                          itemCount: weather.hourly.take(8).length,
                          itemBuilder: (context, index) {
                            final hour = weather.hourly[index];
                        
                            return HourlyForecastTile(
                              time: TimeOfDay.fromDateTime(
                                hour.time,
                              ).format(context),
                              icon: getIcon(hour.sky, hour.time),
                              temp: hour.temp.toInt(),
                            );
                          },
                        ),
                      ),
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
