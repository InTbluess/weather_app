import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

Gradient getBackgroundGradient(String weather, DateTime time) {
  final hour = time.hour;
  final isNight = hour >= 0 && hour < 6;
  // final isNight = true; // For testing night gradients without waiting for nighttime

  if (isNight) {
    switch (weather) {
      case "Clear":
        return const LinearGradient(
          colors: [
            Color.fromARGB(255, 15, 147, 199),
            Color.fromARGB(255, 3, 32, 54),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        );

      case "Clouds":
        return const LinearGradient(
          colors: [
            Color.fromARGB(255, 172, 184, 189),
            Color.fromARGB(221, 3, 47, 83),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        );

      case "Rain":
        return const LinearGradient(
          colors: [
            Color.fromARGB(255, 79, 110, 194),
            Color.fromARGB(255, 11, 17, 27),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        );
      case "Snow":
        return const LinearGradient(
          colors: [
            Color.fromARGB(255, 166, 181, 224),
            Color.fromARGB(255, 15, 26, 46),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        );

      case "Thunderstorm":
        return const LinearGradient(
          colors: [Colors.deepPurple, Colors.black],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        );

      default:
        return const LinearGradient(
          colors: [Colors.black87, Colors.black],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        );
    }
  }

  // Daytime
  switch (weather) {
    case "Clear":
      return const LinearGradient(
        colors: [
          Color.fromARGB(221, 153, 213, 253),
          Color.fromARGB(255, 4, 77, 136),
        ],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      );

    case "Clouds":
      return const LinearGradient(
        colors: [
          Color.fromARGB(255, 15, 43, 51),
          Color.fromARGB(255, 15, 77, 105),
        ],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      );

    case "Rain":
      return const LinearGradient(
        colors: [
          Color.fromARGB(255, 94, 122, 136),
          Color.fromARGB(255, 37, 48, 107),
        ],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      );
      
    case "Snow":
      return const LinearGradient(
        colors: [
          Color.fromARGB(255, 167, 184, 230),
          Color.fromARGB(255, 44, 69, 112),
        ],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      );

    case "Thunderstorm":
      return const LinearGradient(
        colors: [Colors.deepPurple, Colors.grey],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      );

    default:
      return const LinearGradient(
        colors: [Colors.blue, Colors.lightBlueAccent],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      );
  }
}
