import 'package:flutter/material.dart';

class ToastService {
  static void showSuccess(String message) {
    // Using SnackBar for now - can replace with fluttertoast or another package
    _showSnackBar(
      message,
      backgroundColor: Colors.green,
      icon: Icons.check_circle,
    );
  }

  static void showError(String message) {
    _showSnackBar(
      message,
      backgroundColor: Colors.red,
      icon: Icons.error,
    );
  }

  static void _showSnackBar(
    String message, {
    required Color backgroundColor,
    required IconData icon,
  }) {
    // This would need a BuildContext in real usage
    // For now, we'll create a simple implementation
    debugPrint('TOAST: $message');
    
    // In a real app, you'd use:
    // ScaffoldMessenger.of(context).showSnackBar(
    //   SnackBar(
    //     content: Row(
    //       children: [
    //         Icon(icon, color: Colors.white),
    //         SizedBox(width: 8),
    //         Expanded(child: Text(message)),
    //       ],
    //     ),
    //     backgroundColor: backgroundColor,
    //   ),
    // );
  }
}