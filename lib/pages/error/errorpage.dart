// Not used by main.dart used by article.dart
import 'package:flutter/material.dart';

class ErrorPage extends StatelessWidget {
  final double height;
  final Function() onPress;
  const ErrorPage({required this.height, required this.onPress, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFeff1f3),
      body: Column(
        children: [
          Image.asset(
            'assets/images/error.png',
            frameBuilder: (BuildContext context, Widget child, int? frame,
                bool wasSynchronouslyLoaded) {
              if (frame == null) {
                return Container(height: 0.75449 * height);
              }
              return child;
            },
          ),
          Container(
            alignment: Alignment.center,
            child: TextButton(
              style: TextButton.styleFrom(
                backgroundColor: const Color(0xFF94c388),
                foregroundColor: const Color(0xFF474747),
                padding: const EdgeInsets.all(20),
                elevation: 2,
              ),
              onPressed: onPress,
              child: const Text('Refresh'),
            ),
          ),
        ],
      ),
    );
  }
}
