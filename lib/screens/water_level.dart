import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WaterLevel extends StatefulWidget {
  const WaterLevel({super.key});

  @override
  State<WaterLevel> createState() => _WaterLevelState();
}

class _WaterLevelState extends State<WaterLevel> {
  // https://src.meteopilipinas.gov.ph/repo/mtsat-colored/24hour/latest-him-colored.gif
  final controller = WebViewController()
    ..setJavaScriptMode(JavaScriptMode.unrestricted)
    ..loadRequest(Uri.parse("https://zcwd.gov.ph/level/level.php"));

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: WebViewWidget(
      controller: controller,
    ));
  }
}
