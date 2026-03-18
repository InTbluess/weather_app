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
    CurrentWeather? current,
    List<HourlyWeather>? hourly,
    String? cityName,
  }) {
    return WeatherResponse(
      current: current ?? this.current,
      hourly: hourly ?? this.hourly,
      cityName: cityName ?? this.cityName,
    );
  }

  factory WeatherResponse.fromJson(Map<String, dynamic> json) {
    return WeatherResponse(
      current: CurrentWeather.fromMap(json['list'][0] as Map<String, dynamic>),
      hourly: List<HourlyWeather>.from(
        json['list']?.map(
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
  final double minTemp;
  final double maxTemp;
  final double feelsLike;

  final String sky;
  final String description;
  final String icon;

  final int humidity;
  final int pressure;

  final double windSpeed;
  final int windDeg;
  final double windGust;

  final int cloudiness;
  final int visibility;

  const CurrentWeather({
    required this.temp,
    required this.minTemp,
    required this.maxTemp,
    required this.feelsLike,
    required this.sky,
    required this.description,
    required this.icon,
    required this.humidity,
    required this.pressure,
    required this.windSpeed,
    required this.windDeg,
    required this.windGust,
    required this.cloudiness,
    required this.visibility,
  });

  CurrentWeather copyWith({
    double? temp,
    double? minTemp,
    double? maxTemp,
    double? feelsLike,
    String? sky,
    String? description,
    String? icon,
    int? humidity,
    int? pressure,
    double? windSpeed,
    int? windDeg,
    double? windGust,
    int? cloudiness,
    int? visibility,
  }) {
    return CurrentWeather(
      temp: temp ?? this.temp,
      minTemp: minTemp ?? this.minTemp,
      maxTemp: maxTemp ?? this.maxTemp,
      feelsLike: feelsLike ?? this.feelsLike,
      sky: sky ?? this.sky,
      description: description ?? this.description,
      icon: icon ?? this.icon,
      humidity: humidity ?? this.humidity,
      pressure: pressure ?? this.pressure,
      windSpeed: windSpeed ?? this.windSpeed,
      windDeg: windDeg ?? this.windDeg,
      windGust: windGust ?? this.windGust,
      cloudiness: cloudiness ?? this.cloudiness,
      visibility: visibility ?? this.visibility,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'temp': temp,
      'mintemp': minTemp,
      'maxtemp': maxTemp,
      'feelsLike': feelsLike,
      'sky': sky,
      'description': description,
      'icon': icon,
      'humidity': humidity,
      'pressure': pressure,
      'windSpeed': windSpeed,
      'windDeg': windDeg,
      'windGust': windGust,
      'cloudiness': cloudiness,
      'visibility': visibility,
    };
  }

factory CurrentWeather.fromMap(Map<String, dynamic> map) {
  return CurrentWeather(
    temp: (map['main']['temp'] ?? 0).toDouble(),
    minTemp: (map['main']['temp_min'] ?? 0).toDouble(),
    maxTemp: (map['main']['temp_max'] ?? 0).toDouble(),
    feelsLike: (map['main']['feels_like'] ?? 0).toDouble(),

    sky: (map['weather']?[0]?['main']) ?? 'Clear',
    description: (map['weather']?[0]?['description']) ?? '',
    icon: (map['weather']?[0]?['icon']) ?? '01d',

    humidity: map['main']['humidity'] ?? 0,
    pressure: map['main']['pressure'] ?? 0,

    windSpeed: (map['wind']['speed'] ?? 0).toDouble(),
    windDeg: map['wind']['deg'] ?? 0,
    windGust: (map['wind']['gust'] ?? 0).toDouble(),

    cloudiness: map['clouds']['all'] ?? 0,
    visibility: map['visibility'] ?? 0,
  );
}
  String toJson() => json.encode(toMap());

  factory CurrentWeather.fromJson(String source) =>
      CurrentWeather.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return '''CurrentWeather(
      temp: $temp,
      minTemp: $minTemp,
      maxTemp: $maxTemp,
      feelsLike: $feelsLike, 
      sky: $sky, 
      description: $description, 
      icon: $icon, 
      humidity: $humidity, 
      pressure: $pressure, 
      windSpeed: $windSpeed, 
      windDeg: $windDeg, 
      windGust: $windGust, 
      cloudiness: $cloudiness, 
      visibility: $visibility
    )''';
  }

  @override
  bool operator ==(covariant CurrentWeather other) {
    if (identical(this, other)) return true;

    return other.temp == temp &&
        other.minTemp == minTemp &&
        other.maxTemp == maxTemp &&
        other.feelsLike == feelsLike &&
        other.sky == sky &&
        other.description == description &&
        other.icon == icon &&
        other.humidity == humidity &&
        other.pressure == pressure &&
        other.windSpeed == windSpeed &&
        other.windDeg == windDeg &&
        other.windGust == windGust &&
        other.cloudiness == cloudiness &&
        other.visibility == visibility;
  }

  @override
  int get hashCode {
    return temp.hashCode ^
        minTemp.hashCode ^
        maxTemp.hashCode ^
        feelsLike.hashCode ^
        sky.hashCode ^
        description.hashCode ^
        icon.hashCode ^
        humidity.hashCode ^
        pressure.hashCode ^
        windSpeed.hashCode ^
        windDeg.hashCode ^
        windGust.hashCode ^
        cloudiness.hashCode ^
        visibility.hashCode;
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
