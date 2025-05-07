import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart'; // Add this for SVG support
import 'desktop_screen.dart'; // Import your DesktopScreen

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    print('SplashScreen: initState called');
    // Simulate a loading delay of 3 seconds, then navigate to DesktopScreen
    Future.delayed(const Duration(seconds: 3), () {
      print('SplashScreen: Navigating to DesktopScreen');
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const DesktopScreen()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    print('SplashScreen: build called');
    return Scaffold(
      body: Container(
        color: Colors.black, // Black background
        child: Stack(
          children: [
            // Main content (logo, loading indicator, Ubuntu text)
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Ubuntu logo (Circle of Friends)
                  Image.asset(
                    'assets/images/logos/Ubuntu-Emblema.png',
                    width: 300,
                    height: 250,
                    errorBuilder: (context, error, stackTrace) {
                      print('Error loading Ubuntu logo: $error');
                      return const Text(
                        'Ubuntu Logo failed to load',
                        style: TextStyle(color: Colors.white),
                      );
                    },
                  ),
                  const SizedBox(height: 20),
                  // Loading indicator
                  const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      strokeWidth: 2,
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Ubuntu wordmark
                  SvgPicture.asset(
                    'assets/themes/Yaru/status/ubuntu_white_hex.svg',
                    width: 300,
                    height: 250,
                    placeholderBuilder: (context) => const Text(
                      'Ubuntu Wordmark failed to load',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
            // Footer with linkedin | github
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        print('Tapped on linkedin');
                        // Add LinkedIn navigation logic if needed
                      },
                      child: const Text(
                        'linkedin',
                        style: TextStyle(
                          fontFamily: 'Ubuntu',
                          fontSize: 14,
                          color: Colors.white70,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    const Text(
                      '|',
                      style: TextStyle(
                        fontFamily: 'Ubuntu',
                        fontSize: 14,
                        color: Colors.white70,
                      ),
                    ),
                    const SizedBox(width: 10),
                    GestureDetector(
                      onTap: () {
                        print('Tapped on github');
                        // Add GitHub navigation logic if needed
                      },
                      child: const Text(
                        'github',
                        style: TextStyle(
                          fontFamily: 'Ubuntu',
                          fontSize: 14,
                          color: Colors.white70,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
