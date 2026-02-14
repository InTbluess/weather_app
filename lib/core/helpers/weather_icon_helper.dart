import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

IconData getIcon(String weather, DateTime time) {
  int hour = time.hour;
  bool isNight = hour >= 0 && hour < 6;
  if (isNight) {
    switch (weather) {
      case "Clear":
        return CupertinoIcons.moon_stars;
      case "Clouds":
        return CupertinoIcons.cloud_moon;
      case "Mist":
      case "Fog":
        return CupertinoIcons.cloud_fog;
      case "Rain":
        return CupertinoIcons.cloud_moon_rain;
      case "Thunderstrom":
        return CupertinoIcons.cloud_moon_bolt;
      default:
        return CupertinoIcons.moon_stars;
    }
  }

  switch (weather) {
    case "Clear":
      return CupertinoIcons.sun_max;
    case "Clouds":
      return CupertinoIcons.cloud;
    case "Mist":
    case "Fog":
      return CupertinoIcons.cloud_fog;
    case "Rain":
      return CupertinoIcons.cloud_rain;
    case "Thunderstrom":
      return CupertinoIcons.cloud_bolt;
    default:
      return CupertinoIcons.sun_max;
  }
  
}
