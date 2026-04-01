import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:fl_chart/fl_chart.dart';

import 'package:weather_app/core/error/error_handler.dart';
import 'package:weather_app/core/helpers/capitalizer.dart';
import 'package:weather_app/core/helpers/locator.dart';
import 'package:weather_app/core/helpers/weather_icon_helper.dart';
import 'package:weather_app/data/models/weather_model.dart';
import 'package:weather_app/data/services/weather_api_service.dart';
import 'package:weather_app/presentation/Components/glass_tile.dart';
import 'package:weather_app/presentation/Components/hourly_glass_card.dart';
import 'package:weather_app/presentation/Components/weather_background.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  Future<WeatherResponse?>? _weatherFuture = Future.delayed(
    const Duration(milliseconds: 10),
    () => null,
  );

  final TextEditingController _citySearch = TextEditingController();

  bool isSearching = false;
  String currentLocation = "";
  Gradient? _lastGradient;

bool _showTimeoutError = false;

  Future<void> _initLocation() async {
  _showTimeoutError = false;

  // Start timeout timer
  Future.delayed(const Duration(seconds: 10), () {
    if (mounted && (_weatherFuture == null)) {
      setState(() {
        _showTimeoutError = true;
      });
    }
  });

  String city = await LocationService.getCityName();

  if (!mounted) return;

  setState(() {
    currentLocation = city;
    _weatherFuture = fetchWeather(context, currentLocation);
  });
}

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      _initLocation();
    });
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

  Widget temperatureChart(List hourly) {
    final temps = hourly.take(8).map((e) => e.temp.toDouble()).toList();

    final minTemp = temps.reduce((a, b) => a < b ? a : b);
    final maxTemp = temps.reduce((a, b) => a > b ? a : b);
    final range = maxTemp - minTemp;
    final interval = (range / 4).ceilToDouble().clamp(1, double.infinity);

    return Padding(
      padding: const EdgeInsets.only(right: 16.0),
      child: SizedBox(
        height: 200,
        child: LineChart(
          LineChartData(
            minY: (temps.reduce((a, b) => a < b ? a : b)).floorToDouble() - 2,
            maxY: (temps.reduce((a, b) => a > b ? a : b)).ceilToDouble() + 2,

            gridData: FlGridData(show: true),
            borderData: FlBorderData(show: false),

            titlesData: FlTitlesData(
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  interval: interval,
                  getTitlesWidget: (value, meta) {
                    if (value == meta.max || value == meta.min) {
                      return const SizedBox();
                    }
                    return Text(
                      "${value.toInt()}",
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 10,
                      ),
                    );
                  },
                ),
              ),
              topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
              rightTitles: AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: (value, meta) {
                    int index = value.toInt();
                    if (index < 0 || index >= hourly.length) {
                      return const SizedBox();
                    }

                    final time = TimeOfDay.fromDateTime(
                      hourly[index].time,
                    ).format(context);

                    return Text(
                      index == 0 ? "Now" : time,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 10,
                      ),
                    );
                  },
                ),
              ),
            ),

            lineBarsData: [
              LineChartBarData(
                isCurved: false,
                spots: List.generate(
                  temps.length,
                  (i) => FlSpot(i.toDouble(), temps[i]),
                ),
                color: Colors.white,
                barWidth: 2,
                dotData: FlDotData(show: true),

                belowBarData: BarAreaData(
                  show: true,
                  gradient: LinearGradient(
                    colors: [Colors.white.withOpacity(0.3), Colors.transparent],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<WeatherResponse?>(
      future: _weatherFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return AnimatedContainer(
            duration: const Duration(milliseconds: 800),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
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

        if (snapshot.connectionState == ConnectionState.waiting ||
    !snapshot.hasData) {
  // If timeout reached → show error
  if (_showTimeoutError) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
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
          child: Text(
            "No data available",
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }

  // Otherwise → keep showing loader
  return AnimatedContainer(
    duration: const Duration(milliseconds: 800),
    decoration: const BoxDecoration(
      gradient: LinearGradient(
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

        final weather = snapshot.data!;

        final gradient = getBackgroundGradient(
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
                        childAspectRatio: 2.0,
                        children: [
                          glassTile(
                            Icons.water_drop,
                            "Humidity",
                            "${weather.current.humidity}%",
                          ),
                          glassTile(
                            Icons.air,
                            "Wind",
                            "${weather.current.windSpeed} m/s",
                          ),
                          glassTile(
                            Icons.speed,
                            "Pressure",
                            "${weather.current.pressure} hPa",
                          ),
                          glassTile(
                            Icons.cloud,
                            "Clouds",
                            "${weather.current.cloudiness}%",
                          ),
                          glassTile(
                            Icons.visibility,
                            "Visibility",
                            "${(weather.current.visibility / 1000).toStringAsFixed(1)} km",
                          ),
                          glassTile(
                            Icons.air,
                            "Wind Gust",
                            "${weather.current.windGust} m/s",
                          ),
                        ],
                      ),

                      const SizedBox(height: 26),

                      Text(
                        "Hourly Forecast",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: textColor,
                        ),
                      ),

                      const SizedBox(height: 20),

                      SizedBox(
                        height: 140,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: weather.hourly.take(8).length,
                          itemBuilder: (context, index) {
                            final hour = weather.hourly[index];

                            return hourlyGlassCard(
                              time: index == 0
                                  ? "Now"
                                  : TimeOfDay.fromDateTime(
                                      hour.time,
                                    ).format(context),
                              icon: getIcon(hour.sky, hour.time),
                              temp: hour.temp.toInt(),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 32),
                      temperatureChart(weather.hourly),
                      const SizedBox(height: 32),
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
