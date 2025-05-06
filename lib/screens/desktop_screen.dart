import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'app_screens/chrome.dart';

class DesktopScreen extends StatefulWidget {
  const DesktopScreen({super.key});

  @override
  State<DesktopScreen> createState() => _DesktopScreenState();
}

class _DesktopScreenState extends State<DesktopScreen> {
  final String wallpaper = 'assets/images/wallpapers/wall-2.webp';
  bool isChromeOpen = false;
  Offset chromePosition = const Offset(100, 100);

  final Map<String, String> desktopIcons = {
    'assets/themes/Yaru/apps/chrome.png': 'Google Chrome',
    'assets/themes/Yaru/apps/gnome-control-center.png': 'About Vivek',
    'assets/images/logos/fevicon.png': 'Trash',
    'assets/themes/Yaru/apps/gedit.png': 'Contact Me',
    'assets/themes/Yaru/apps/github.png': 'GitHub',
    'assets/themes/Yaru/apps/tars.svg': 'Ask Tars',
  };

  final Map<String, String> sidebarIcons = {
    'assets/images/logos/fevicon.png': 'Ubuntu',
    'assets/themes/Yaru/apps/calc.png': 'Calculator',
    'assets/themes/Yaru/apps/bash.png': 'Terminal',
    'assets/themes/Yaru/apps/vscode.png': 'VS Code',
    'assets/themes/Yaru/apps/spotify.png': 'Spotify',
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(wallpaper),
            fit: BoxFit.cover,
          ),
        ),
        child: Row(
          children: [
            _buildSidebar(),
            Expanded(
              child: Stack(
                children: [
                  _buildDesktopIcons(),
                  if (isChromeOpen)
                    ChromeBrowser(
                      initialPosition: chromePosition,
                      onClose: () {
                        setState(() {
                          isChromeOpen = false;
                        });
                      },
                    ),
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    child: _buildTopPanel(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSidebar() {
    return Container(
      width: 60,
      color: Colors.black38,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(height: 10),
          ...sidebarIcons.entries
              .map((entry) => _buildSidebarIconImage(entry.key, entry.value))
              .toList(),
          const Spacer(),
          _buildSidebarIcon(Icons.apps, "App Grid", Colors.white),
        ],
      ),
    );
  }

  Widget _buildSidebarIcon(IconData icon, String tooltip, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Tooltip(
        message: tooltip,
        child: Icon(
          icon,
          color: color,
          size: 30,
        ),
      ),
    );
  }

  Widget _buildSidebarIconImage(String iconPath, String tooltip) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Tooltip(
        message: tooltip,
        child: SizedBox(
          width: 30,
          height: 30,
          child: iconPath.endsWith('.svg')
              ? SvgPicture.asset(iconPath)
              : Image.asset(iconPath, fit: BoxFit.contain),
        ),
      ),
    );
  }

  Widget _buildTopPanel() {
    return Container(
      height: 30,
      color: Colors.black54,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          const Text("Activities", style: TextStyle(color: Colors.white)),
          const Spacer(),
          const Text(
            "Tue May 6 10:50 AM",
            style: TextStyle(color: Colors.white),
          ),
          const SizedBox(width: 16),
          const Icon(Icons.wifi, color: Colors.white, size: 16),
          const SizedBox(width: 8),
          const Icon(Icons.volume_up, color: Colors.white, size: 16),
          const SizedBox(width: 8),
          const Icon(Icons.battery_full, color: Colors.white, size: 16),
        ],
      ),
    );
  }

  Widget _buildDesktopIcons() {
    return Padding(
      padding: const EdgeInsets.only(top: 40, right: 20),
      child: Align(
        alignment: Alignment.topRight, // Align to top right
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.end, // Align icons and labels right
          children: desktopIcons.entries.map((entry) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 24),
              child: _buildDesktopIconWithFunction(
                entry.value,
                entry.key,
                () {
                  if (entry.value == 'Google Chrome') {
                    setState(() {
                      isChromeOpen = true;
                    });
                  }
                  // Add more actions if needed
                },
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildDesktopIconWithFunction(
      String label, String iconPath, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: Colors.white24,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: iconPath.endsWith('.svg')
                  ? SvgPicture.asset(iconPath)
                  : Image.asset(iconPath, fit: BoxFit.contain),
            ),
          ),
          const SizedBox(height: 4),
          SizedBox(
            width: 60,
            child: Text(
              label,
              style: const TextStyle(color: Colors.white, fontSize: 12),
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center, // Center label under icon
              maxLines: 1,
            ),
          ),
        ],
      ),
    );
  }
}
