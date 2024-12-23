import 'package:flutter/material.dart';

class NotificationBox {
  static void show({
    required BuildContext context,
    required int status,
    required String message,
  }) {
    final overlay = Overlay.of(context);

    if (true) {
      final overlayEntry = OverlayEntry(
        builder: (context) => Positioned(
          top: 50.0,
          left: MediaQuery.of(context).size.width * 0.1,
          width: MediaQuery.of(context).size.width * 0.8,
          child: Material(
            color: Colors.transparent,
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 20.0),
              decoration: BoxDecoration(
                color: (status == 400 || status == 500) ? Colors.red : Colors.green,
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Text(
                message,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
      );

      // Insert the notification into the overlay
      overlay.insert(overlayEntry);

      // Automatically remove the notification after 3 seconds
      Future.delayed(Duration(seconds: 3), () {
        overlayEntry.remove();
      });
    }
  }
}
