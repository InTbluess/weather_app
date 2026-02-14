import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class ErrorHandler {
  static void showErrorHandler(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: const Text('Error'),
        content: Text(
          message,
          style: const TextStyle(fontSize: 14.0, color: Color.fromARGB(255, 179, 10, 10)),
        ),
        actions: [
          CupertinoDialogAction(
            child: const Text('OK'),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }
}
