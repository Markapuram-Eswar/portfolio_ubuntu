import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

// Constants for standard icon size and layout
const double standardIconSize = 48.0;
const double labelWidth = 64.0;
const double estimatedTextHeight = 32.0; // for two lines of text
const double gapBetweenIconAndText = 4.0;
const double iconPaddingTopBottom = 16.0; // 8.0 * 2 for top and bottom padding
const double estimatedIconHeight = standardIconSize +
    gapBetweenIconAndText +
    estimatedTextHeight +
    iconPaddingTopBottom;
const double spacingBetweenIcons = 24.0;
const double slotHeight = estimatedIconHeight + spacingBetweenIcons;
const double sidebarWidth = 60.0;
const double navbarHeight = 30.0;
const double navbarBuffer = 15.0; // Buffer to ensure window stays below navbar

class DesktopScreen extends StatefulWidget {
  const DesktopScreen({super.key});

  @override
  State<DesktopScreen> createState() => _DesktopScreenState();
}

class _DesktopScreenState extends State<DesktopScreen> {
  final String wallpaper = 'assets/images/wallpapers/wall-2.webp';
  late String _currentTime;
  late Timer _timer;

  final Map<String, String> desktopIcons = {
    'assets/themes/Yaru/apps/chrome.png': 'Google Chrome',
    'assets/themes/Yaru/apps/gnome-control-center.png': 'About Vivek',
    'assets/themes/Yaru/status/user-trash-symbolic.svg': 'Trash',
    'assets/themes/Yaru/apps/gedit.png': 'Contact Me',
    'assets/themes/Yaru/apps/github.png': 'GitHub',
    'assets/themes/Yaru/apps/tars.svg': 'Ask Tars',
  };

  final Map<String, String> sidebarIcons = {
    'assets/themes/Yaru/apps/chrome.png': 'Chrome',
    'assets/themes/Yaru/apps/calc.png': 'Calculator',
    'assets/themes/Yaru/apps/bash.png': 'Terminal',
    'assets/themes/Yaru/apps/vscode.png': 'VS Code',
    'assets/themes/Yaru/apps/spotify.png': 'Spotify',
  };

  // List to store open windows
  final List<Map<String, dynamic>> _openWindows = [];

  @override
  void initState() {
    super.initState();
    _currentTime = _formatDateTime(DateTime.now());
    _timer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      setState(() {
        _currentTime = _formatDateTime(DateTime.now());
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  String _formatDateTime(DateTime dateTime) {
    return DateFormat('E MMM d h:mm a').format(dateTime);
  }

  Future<void> _launchUrl(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      print('Could not launch $url');
    }
  }

  void _openWindow(String title, Widget content, Offset initialPosition) {
    // Check if a window with the same title is already open
    if (_openWindows.any((window) => window['title'] == title)) {
      return; // Do nothing if the window is already open
    }

    // Ensure the initial position is below the navbar
    final adjustedY = initialPosition.dy < (navbarHeight + navbarBuffer)
        ? navbarHeight + navbarBuffer
        : initialPosition.dy;
    final adjustedPosition = Offset(initialPosition.dx, adjustedY);

    setState(() {
      _openWindows.add({
        'title': title,
        'content': content,
        'position': adjustedPosition,
        'size': const Size(600, 400),
        'id': UniqueKey().toString(),
      });
    });
  }

  void _closeWindow(String id) {
    setState(() {
      _openWindows.removeWhere((window) => window['id'] == id);
    });
  }

  void _updateWindowPosition(String id, Offset newPosition) {
    setState(() {
      final index = _openWindows.indexWhere((window) => window['id'] == id);
      if (index != -1) {
        _openWindows[index]['position'] = newPosition;
      }
    });
  }

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
        child: Column(
          children: [
            _buildTopPanel(),
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildSidebar(),
                  Expanded(
                    child: Stack(
                      children: [
                        _buildDesktopIcons(),
                        ..._openWindows.map((window) => AppWindow(
                              key: ValueKey(window['id']),
                              title: window['title'],
                              content: window['content'],
                              initialPosition: window['position'],
                              initialSize: window['size'],
                              onClose: () => _closeWindow(window['id']),
                              onPositionChanged: (position) =>
                                  _updateWindowPosition(window['id'], position),
                            )),
                      ],
                    ),
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
      width: sidebarWidth,
      color: Colors.black38,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(height: 10),
          ...sidebarIcons.entries
              .map((entry) => _buildSidebarIconImage(entry.key, entry.value)),
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
      height: navbarHeight,
      color: Colors.black54,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          const Text(
            "Activities",
            style: TextStyle(color: Colors.white),
          ),
          const Spacer(),
          Text(
            _currentTime,
            style: const TextStyle(color: Colors.white),
          ),
          const SizedBox(width: 16),
          const Icon(Icons.wifi, color: Colors.white, size: 16),
          const SizedBox(width: 8),
          const Icon(Icons.volume_up, color: Colors.white, size: 16),
          const SizedBox(width: 8),
          const Icon(Icons.battery_full, color: Colors.white, size: 16),
          const SizedBox(width: 8),
          PopupMenuButton<String>(
            onSelected: (String value) {
              switch (value) {
                case 'Show Projects':
                  _openWindow(
                    'Projects',
                    const Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Text(
                          'Here are my projects! (Add your project details here.)'),
                    ),
                    const Offset(100, 100),
                  );
                  break;
                case 'Toggle Theme':
                  print('Toggling theme (implement theme switch logic)');
                  break;
                case 'Open Resume':
                  _launchUrl('https://your-resume-url.com');
                  break;
              }
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              const PopupMenuItem<String>(
                value: 'Show Projects',
                child: Text(
                  'Show Projects',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              const PopupMenuItem<String>(
                value: 'Toggle Theme',
                child: Text(
                  'Toggle Theme',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              const PopupMenuItem<String>(
                value: 'Open Resume',
                child: Text(
                  'Open Resume',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
            color: Colors.grey[850],
            child: const Icon(
              Icons.more_vert,
              color: Colors.white70,
              size: 20,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDesktopIcons() {
    return Padding(
      padding: const EdgeInsets.only(top: 10, right: 20, left: 0),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final availableHeight = constraints.maxHeight - 40;
          final iconsPerColumn = (availableHeight / slotHeight)
              .floor()
              .clamp(1, desktopIcons.length);

          final entries = desktopIcons.entries.toList();
          final totalColumns = (entries.length / iconsPerColumn).ceil();
          final columns = <Widget>[];

          for (var colIndex = 0; colIndex < totalColumns; colIndex++) {
            final start = colIndex * iconsPerColumn;
            final slice = entries.skip(start).take(iconsPerColumn).toList();

            columns.add(
              Padding(
                padding:
                    EdgeInsets.only(left: colIndex < totalColumns - 1 ? 24 : 0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: slice.map((entry) {
                    return Padding(
                      padding:
                          const EdgeInsets.only(bottom: spacingBetweenIcons),
                      child: _buildDesktopIconWithFunction(
                        label: entry.value,
                        iconPath: entry.key,
                        onTap: () {
                          switch (entry.value) {
                            case 'Google Chrome':
                              _openWindow(
                                'Google Chrome',
                                const Padding(
                                  padding: EdgeInsets.all(16.0),
                                  child: Text(
                                      'Web browser placeholder. Would launch https://www.google.com'),
                                ),
                                const Offset(100, 100),
                              );
                              break;
                            case 'About Vivek':
                              _openWindow(
                                'About Vivek',
                                const Padding(
                                  padding: EdgeInsets.all(16.0),
                                  child: Text(
                                      'Hi, I\'m Vivek! I\'m a passionate developer with experience in Flutter and web development. (Add more details here.)'),
                                ),
                                const Offset(100, 100),
                              );
                              break;
                            case 'Trash':
                              _openWindow(
                                'Trash',
                                const Padding(
                                  padding: EdgeInsets.all(16.0),
                                  child: Text('The trash is currently empty.'),
                                ),
                                const Offset(100, 100),
                              );
                              break;
                            case 'Contact Me':
                              _openWindow(
                                'Contact Me',
                                const Padding(
                                  padding: EdgeInsets.all(16.0),
                                  child: Text(
                                      'Reach out via email: vivek@example.com\nOr connect on LinkedIn: linkedin.com/in/vivek'),
                                ),
                                const Offset(100, 100),
                              );
                              break;
                            case 'GitHub':
                              _openWindow(
                                'GitHub',
                                const Padding(
                                  padding: EdgeInsets.all(16.0),
                                  child: Text(
                                      'GitHub placeholder. Would launch https://github.com/your-username'),
                                ),
                                const Offset(100, 100),
                              );
                              break;
                            case 'Ask Tars':
                              _openWindow(
                                'Ask Tars',
                                const Padding(
                                  padding: EdgeInsets.all(16.0),
                                  child: Text(
                                      'Hello! I\'m Tars, your virtual assistant. How can I help you today?'),
                                ),
                                const Offset(100, 100),
                              );
                              break;
                          }
                        },
                      ),
                    );
                  }).toList(),
                ),
              ),
            );
          }

          return Align(
            alignment: Alignment.topRight,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              reverse: false,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: columns.reversed.toList(),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildDesktopIconWithFunction({
    required String label,
    required String iconPath,
    required VoidCallback onTap,
  }) {
    return _DesktopIcon(
      label: label,
      iconPath: iconPath,
      onTap: onTap,
    );
  }
}

class _DesktopIcon extends StatefulWidget {
  final String label;
  final String iconPath;
  final VoidCallback onTap;

  const _DesktopIcon({
    required this.label,
    required this.iconPath,
    required this.onTap,
  });

  @override
  _DesktopIconState createState() => _DesktopIconState();
}

class _DesktopIconState extends State<_DesktopIcon> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: BackdropFilter(
            filter: ImageFilter.blur(
              sigmaX: _isHovered ? 5.0 : 0.0,
              sigmaY: _isHovered ? 5.0 : 0.0,
            ),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: _isHovered
                    ? Colors.white.withOpacity(0.3)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    width: standardIconSize,
                    height: standardIconSize,
                    child: widget.iconPath.endsWith('.svg')
                        ? SvgPicture.asset(widget.iconPath, fit: BoxFit.contain)
                        : Image.asset(widget.iconPath, fit: BoxFit.contain),
                  ),
                  const SizedBox(height: gapBetweenIconAndText),
                  SizedBox(
                    width: labelWidth,
                    child: Text(
                      widget.label,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class AppWindow extends StatefulWidget {
  final String title;
  final Widget content;
  final Offset initialPosition;
  final Size initialSize;
  final VoidCallback onClose;
  final Function(Offset) onPositionChanged;

  const AppWindow({
    super.key,
    required this.title,
    required this.content,
    required this.initialPosition,
    required this.initialSize,
    required this.onClose,
    required this.onPositionChanged,
  });

  @override
  _AppWindowState createState() => _AppWindowState();
}

class _AppWindowState extends State<AppWindow> {
  late Offset _position;
  late Size _size;
  bool _isDragging = false;

  @override
  void initState() {
    super.initState();
    _position = widget.initialPosition;
    _size = widget.initialSize;
  }

  void _updatePosition(DragUpdateDetails details) {
    setState(() {
      _position += details.delta;
      // Clamp position within boundaries
      final screenSize = MediaQuery.of(context).size;
      final minX = sidebarWidth;
      final minY = navbarHeight + navbarBuffer;
      final maxX = screenSize.width - _size.width;
      final maxY = screenSize.height - _size.height;

      _position = Offset(
        _position.dx.clamp(minX, maxX),
        _position.dy.clamp(minY, maxY),
      );
    });
  }

  void _onDragEnd() {
    widget.onPositionChanged(_position);
    setState(() {
      _isDragging = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: _position.dx,
      top: _position.dy,
      child: GestureDetector(
        onPanUpdate: (details) {
          _updatePosition(details);
        },
        onPanStart: (_) {
          setState(() {
            _isDragging = true;
          });
        },
        onPanEnd: (_) {
          _onDragEnd();
        },
        child: _buildWindowContent(),
      ),
    );
  }

  Widget _buildWindowContent() {
    return Container(
      width: _size.width,
      height: _size.height,
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: _isDragging ? Colors.black87 : Colors.black45,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Window title bar with drag functionality
          GestureDetector(
            onPanUpdate: (details) {
              _updatePosition(details);
            },
            onPanStart: (_) {
              setState(() {
                _isDragging = true;
              });
            },
            onPanEnd: (_) {
              _onDragEnd();
            },
            child: Container(
              height: 40,
              decoration: const BoxDecoration(
                color: Colors.black54,
                borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
              ),
              child: Row(
                children: [
                  const SizedBox(width: 16),
                  Text(
                    widget.title,
                    style: const TextStyle(color: Colors.white, fontSize: 14),
                  ),
                  const Spacer(),
                  IconButton(
                    icon:
                        const Icon(Icons.close, color: Colors.white, size: 20),
                    onPressed: widget.onClose,
                  ),
                ],
              ),
            ),
          ),
          // Window content
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(8),
              child: widget.content,
            ),
          ),
        ],
      ),
    );
  }
}
