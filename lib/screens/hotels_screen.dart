import 'package:flutter/material.dart';
import 'package:gosaudi/components/custom_container.dart';
import 'package:webview_flutter/webview_flutter.dart';

// This is the hotels booking screen

final String screenName = 'Hotels';

class HotelsScreen extends StatefulWidget {
    static String id = 'hotels_screen';
  HotelsScreen({Key key}) : super(key: key);

  @override
  _HotelsScreenState createState() => _HotelsScreenState();
}

class _HotelsScreenState extends State<HotelsScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
          child: CustomContainer(
            title: Text(screenName),
         body: 
         // Using webView to connect to Almosafer Website.
         WebView(
                    initialUrl: 'https://www.almosafer.com/ar/hotels-home',
                    javascriptMode: JavascriptMode.unrestricted,
                    gestureNavigationEnabled: true,
                  ),
      ),
    );
  }
}