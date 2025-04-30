import 'package:flutter/material.dart';

class CustomScaffold extends StatelessWidget {
  const CustomScaffold({super.key, this.child});
final Widget? child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
  backgroundColor: Colors.transparent,
  elevation: 0, // Removes shadow
),
extendBodyBehindAppBar: true,
body: Stack(
  children: [
    Positioned.fill(
      child: Image.asset(
        'assets/images/dashboard.jpg',
        fit: BoxFit.cover, // Makes image cover full screen
      ),
    ),
    SafeArea(
      child: Center(
        child: child!,    ),
    ),
  ]
)
);
  }
}