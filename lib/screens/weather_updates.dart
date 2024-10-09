import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'dart:async';

class WeatherUpdates extends StatefulWidget {
  const WeatherUpdates({super.key});

  @override
  State<WeatherUpdates> createState() => _WeatherUpdatesState();
}

class _WeatherUpdatesState extends State<WeatherUpdates> {
  // https://src.meteopilipinas.gov.ph/repo/mtsat-colored/24hour/latest-him-colored-hourly.gif
  // https://src.meteopilipinas.gov.ph/repo/mtsat-colored/24hour/latest-him-colored.gif
  final controller = WebViewController()
    ..setJavaScriptMode(JavaScriptMode.unrestricted)
    ..loadRequest(Uri.parse(
        "https://src.meteopilipinas.gov.ph/repo/mtsat-colored/24hour/latest-him-colored-hourly.gif"));

  Timer? _timer;

  @override
  void initState() {
    super.initState();

    // Refresh every 1 minute
    _timer = Timer.periodic(const Duration(minutes: 1), (Timer timer) {
      controller.reload();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: WebViewWidget(
      controller: controller,
    ));
  }
}
