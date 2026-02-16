import 'package:weather_app/core/constants/api_constants.dart';
import 'package:weather_app/core/error/error_handler.dart';
import 'package:weather_app/data/models/weather_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';

final Dio dio = Dio(
  BaseOptions(
    baseUrl: ApiConstants.baseUrl,
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 10),
    sendTimeout: const Duration(seconds: 10),
  ),
);

Future<WeatherResponse?> fetchWeather(BuildContext context, String city) async {
  try {
    final response = await dio.get(
      ApiConstants.forecastEndpoint,
      queryParameters: {
        'q': city,
        'appid': ApiConstants.apiKey,
        'units': 'metric',
      },
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = response.data as Map<String, dynamic>;
      return WeatherResponse.fromJson(data);
    } else {
      ErrorHandler.showErrorHandler(context, 'Something went wrong');
    }
  } on DioException catch (e) {
    String errorMessage = '';

    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout) {
      errorMessage = 'Connection timed out. Please try again later.';
    } else if (e.response != null) {
      final statusCode = e.response?.statusCode;

      if (statusCode == 404) {
        errorMessage = 'City not found';
      } else if (statusCode == 401) {
        errorMessage = 'Invalid API key';
      } else {
        errorMessage = 'Something went wrong. Please try again.';
      }
    } else {
      errorMessage = 'An unexpected error occurred.';
    }

    throw Exception(errorMessage);
  }
  return null;
}
