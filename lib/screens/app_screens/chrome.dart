import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class ChromeBrowser extends StatefulWidget {
  final Offset initialPosition;
  final VoidCallback onClose;

  const ChromeBrowser({
    Key? key,
    required this.initialPosition,
    required this.onClose,
  }) : super(key: key);

  @override
  _ChromeBrowserState createState() => _ChromeBrowserState();
}

class _ChromeBrowserState extends State<ChromeBrowser> {
  late Offset position;

  @override
  void initState() {
    super.initState();
    position = widget.initialPosition;
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: position.dx,
      top: position.dy,
      width: 800,
      height: 600,
      child: GestureDetector(
        onPanUpdate: (details) {
          setState(() {
            position += details.delta;
          });
        },
        child: Material(
          elevation: 8,
          color: Colors.white,
          child: Column(
            children: [
              Container(
                height: 40,
                color: Colors.grey[300],
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text('Google Chrome'),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: widget.onClose,
                    ),
                  ],
                ),
              ),
              Expanded(
                child: WebViewWidget(
                  controller: WebViewController()
                    ..setJavaScriptMode(JavaScriptMode.unrestricted)
                    ..loadRequest(Uri.parse('https://www.google.com')),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
