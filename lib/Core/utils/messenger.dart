import 'package:flutter/material.dart';

void _showSnackBar(
  BuildContext context, {
  required String message,
  required Color backgroundColor,
  required IconData icon,
}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      backgroundColor: backgroundColor,
      behavior: SnackBarBehavior.floating,
      content: Row(
        children: [
          Expanded(child: Text(message)),
          Icon(icon, size: 20, color: Colors.white),
        ],
      ),
    ),
  );
}

void showSuccessSnackBar(BuildContext context, String message) => _showSnackBar(
      context,
      message: message,
      backgroundColor: Colors.green,
      icon: Icons.check_circle_rounded,
    );

void showErrorSnackBar(BuildContext context, String message) => _showSnackBar(
      context,
      message: message,
      backgroundColor: Colors.red,
      icon: Icons.cancel_rounded,
    );
