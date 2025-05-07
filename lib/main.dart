import 'package:flutter/material.dart';
import 'screens/splash_screen.dart'; // Import the SplashScreen

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Portfolio Ubuntu',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Ubuntu', // Set default font to Ubuntu
      ),
      debugShowCheckedModeBanner: false, // Disable the debug banner
      home: const SplashScreen(),
    );
  }
}
