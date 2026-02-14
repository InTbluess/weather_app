import 'dart:convert';

import 'package:flutter/foundation.dart';

// ! WEATHER RESPONSE MODEL
class WeatherResponse {
  final CurrentWeather current;
  final List<HourlyWeather> hourly;
  final String cityName;

  WeatherResponse({
    required this.current,
    required this.hourly,
    required this.cityName,
  });

  WeatherResponse copyWith({
    CurrentWeather? currentWeather,
    List<HourlyWeather>? hourlyWeather,
    String? cityName,
  }) {
    return WeatherResponse(
      current: currentWeather ?? this.current,
      hourly: hourlyWeather ?? this.hourly,
      cityName: cityName ?? this.cityName,
    );
  }

  factory WeatherResponse.fromJson(Map<String, dynamic> json) {
    return WeatherResponse(
      current: CurrentWeather.fromMap(json['list'][0] as Map<String, dynamic>),
      hourly: List<HourlyWeather>.from(
        json['List']?.map(
          (x) => HourlyWeather.fromJson(x as Map<String, dynamic>),
        ),
      ),
      cityName: (json['city'] as Map<String, dynamic>)['name'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'current': current.toJson(),
      'hourly': hourly.map((x) => x.toJson()).toList(),
      'cityName': cityName,
    };
  }

  @override
  String toString() =>
      'WeatherResponse(current: $current, hourly: $hourly, cityName: $cityName)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is WeatherResponse &&
        other.current == current &&
        listEquals(other.hourly, hourly) &&
        other.cityName == cityName;
  }

  @override
  int get hashCode => current.hashCode ^ hourly.hashCode ^ cityName.hashCode;
}

//  ! CURRENT WEATHER
class CurrentWeather {
  final double temp;
  final String sky;
  final int humidity;
  final int pressure;
  final double windSpeed;

  const CurrentWeather({
    required this.temp,
    required this.sky,
    required this.humidity,
    required this.pressure,
    required this.windSpeed,
  });

  CurrentWeather copyWith({
    double? temp,
    String? sky,
    int? humidity,
    int? pressure,
    double? windSpeed,
  }) {
    return CurrentWeather(
      temp: temp ?? this.temp,
      sky: sky ?? this.sky,
      humidity: humidity ?? this.humidity,
      pressure: pressure ?? this.pressure,
      windSpeed: windSpeed ?? this.windSpeed,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'temp': temp,
      'sky': sky,
      'humidity': humidity,
      'pressure': pressure,
      'windSpeed': windSpeed,
    };
  }

  factory CurrentWeather.fromMap(Map<String, dynamic> map) {
    return CurrentWeather(
      temp: (map['main']['temp'] ?? 0).toDouble(),
      sky: map['weather'][0]['main'] ?? 'Clear',
      humidity: map['main']['humidity'] ?? 0,
      pressure: map['main']['pressure'] ?? 0,
      windSpeed: (map['wind']['speed'] ?? 0).toDouble(),
    );
  }

  String toJson() => json.encode(toMap());

  factory CurrentWeather.fromJson(String source) => CurrentWeather.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'CurrentWeather(temp: $temp, sky: $sky, humidity: $humidity, pressure: $pressure, windSpeed: $windSpeed)';
  }

  @override
  bool operator ==(covariant CurrentWeather other) {
    if (identical(this, other)) return true;
  
    return 
      other.temp == temp &&
      other.sky == sky &&
      other.humidity == humidity &&
      other.pressure == pressure &&
      other.windSpeed == windSpeed;
  }

  @override
  int get hashCode {
    return temp.hashCode ^
      sky.hashCode ^
      humidity.hashCode ^
      pressure.hashCode ^
      windSpeed.hashCode;
  }
}

// ! HOURLY WEATHER

class HourlyWeather {
  final DateTime time;
  final double temp;
  final String sky;

  const HourlyWeather({
    required this.time,
    required this.temp,
    required this.sky,
  });

  HourlyWeather copyWith({DateTime? time, double? temp, String? sky}) {
    return HourlyWeather(
      time: time ?? this.time,
      temp: temp ?? this.temp,
      sky: sky ?? this.sky,
    );
  }

  // Map<String, dynamic> toMap() {
  //   return <String, dynamic>{
  //     'time': time.millisecondsSinceEpoch,
  //     'temp': temp,
  //     'sky': sky,
  //   };
  // }

  factory HourlyWeather.fromJson(Map<String, dynamic> json) {
    return HourlyWeather(
      time: DateTime.parse(json['dt_txt'] ?? DateTime.now().toString()),
      temp: (json['main']['temp'] ?? 0).toDouble(),
      sky: json['weather'][0]['main'] ?? 'Clear',
    );
  }

  Map<String, dynamic> toJson() {
    return {'time': time.millisecondsSinceEpoch, 'temp': temp, 'sky': sky};
  }

  // String toJson() => json.encode(toMap());

  // factory HourlyWeather.fromJson(String source) => HourlyWeather.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'HourlyWeather(time: $time, temp: $temp, sky: $sky)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is HourlyWeather &&
        other.time == time &&
        other.temp == temp &&
        other.sky == sky;
  }

  @override
  int get hashCode => time.hashCode ^ temp.hashCode ^ sky.hashCode;
}
