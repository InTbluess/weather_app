import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

Gradient getBackgroundGradient(String weather, DateTime time) {
  final hour = time.hour;
  final isNight = hour >= 0 && hour < 6;

  if (isNight) {
    switch (weather) {
      case "Clear":
        return const LinearGradient(
          colors: [
            Color.fromARGB(195, 14, 126, 170),
            Color.fromARGB(255, 3, 44, 78),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        );

      case "Clouds":
        return const LinearGradient(
          colors: [Colors.blueGrey, Color.fromARGB(221, 3, 47, 83)],
        );

      case "Rain":
        return const LinearGradient(colors: [Colors.indigo, Colors.black]);

      case "Thunderstorm":
        return const LinearGradient(colors: [Colors.deepPurple, Colors.black]);

      default:
        return const LinearGradient(colors: [Colors.black87, Colors.black]);
    }
  }

  // Daytime
  switch (weather) {
    case "Clear":
      return const LinearGradient(
        colors: [
          Color.fromARGB(221, 1, 204, 255),
          Color.fromARGB(255, 0, 57, 104),
        ],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      );

    case "Clouds":
      return const LinearGradient(
        colors: [
          Color.fromARGB(255, 124, 167, 180),
          Color.fromARGB(255, 15, 77, 105),
        ],
      );

    case "Rain":
      return const LinearGradient(
        colors: [
          Color.fromARGB(255, 94, 122, 136),
          Color.fromARGB(255, 37, 48, 107),
        ],
      );

    case "Thunderstorm":
      return const LinearGradient(colors: [Colors.deepPurple, Colors.grey]);

    default:
      return const LinearGradient(
        colors: [Colors.blue, Colors.lightBlueAccent],
      );
  }
}
