import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quidaw/screens/water_level.dart';
import 'package:quidaw/screens/weather_updates.dart';

class Navigation extends StatelessWidget {
  const Navigation({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(NavigationController());

    return Scaffold(
      bottomNavigationBar: Obx(
        () => NavigationBar(
            backgroundColor: const Color.fromARGB(255, 255, 116, 116),
            indicatorColor: const Color.fromARGB(255, 255, 50, 50),
            height: 80,
            elevation: 0,
            selectedIndex: controller.selectedIndex.value,
            onDestinationSelected: (index) =>
                controller.selectedIndex.value = index,
            destinations: const [
              NavigationDestination(
                icon: Icon(
                  Icons.water,
                  color: Color.fromARGB(255, 255, 255, 255),
                ),
                label: 'Water Level',
              ),
              NavigationDestination(
                  icon: Icon(
                    Icons.air_sharp,
                    color: Color.fromARGB(255, 255, 255, 255),
                  ),
                  label: 'Weather'),
              NavigationDestination(
                  icon: Icon(
                    Icons.surfing,
                    color: Color.fromARGB(255, 255, 255, 255),
                  ),
                  label: 'Flood-prone'),
              NavigationDestination(
                  icon: Icon(
                    Icons.phone,
                    color: Color.fromARGB(255, 255, 255, 255),
                  ),
                  label: 'Hotlines'),
            ]),
      ),
      body: Obx(() => controller.screens[controller.selectedIndex.value]),
    );
  }
}

class NavigationController extends GetxController {
  final Rx<int> selectedIndex = 0.obs;

  final screens = [
    const WaterLevel(),
    const WeatherUpdates(),
    Container(),
    Container(),
  ];
}
