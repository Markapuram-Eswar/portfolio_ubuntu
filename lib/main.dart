import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'screens/desktop_screen.dart';

void main() {
  // Set preferred orientations
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);

  // Hide status bar
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ubuntu Portfolio',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFFE95420)), // Ubuntu orange
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: const DesktopScreen(),
    );
  }
}
