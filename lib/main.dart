import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:quidaw/components/navigation.dart';

void main() {
  runApp(DevicePreview(
    // White background looks professional in website embedding
    backgroundColor: Colors.white,

    // Enable preview by default for web demo
    enabled: true,

    // Start with Galaxy A50 as it's a common Android device
    defaultDevice: Devices.ios.iPhone13ProMax,

    // Show toolbar to let users test different devices
    isToolbarVisible: true,

    // Keep English only to avoid confusion in demos
    availableLocales: const [Locale('en', 'US')],

    // Customize preview controls
    tools: const [
      // Device selection controls
      DeviceSection(
        model: true, // Option to change device model to fit your needs
        orientation: false, // Lock to portrait for consistent demo
        frameVisibility: false, // Hide frame options
        virtualKeyboard: false, // Hide keyboard
      ),

      // Theme switching section
      SystemSection(
        locale: false, // Hide language options - we're keeping it English only
        theme: false, // Show theme switcher if your app has dark/light modes
      ),

      // Disable accessibility for demo simplicity
      AccessibilitySection(
        boldText: false,
        invertColors: false,
        textScalingFactor: false,
        accessibleNavigation: false,
      ),

      // Hide extra settings to keep demo focused
      SettingsSection(
        backgroundTheme: false,
        toolsTheme: false,
      ),
    ],

    // Curated list of devices for comprehensive preview
    devices: [
      ...Devices.all, // uncomment to see all devices
    ],

    builder: (context) => const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quidaw',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.red),
        useMaterial3: true,
      ),
      home: const Navigation(),
    );
  }
}
