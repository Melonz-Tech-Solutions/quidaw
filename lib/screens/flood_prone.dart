import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:convert';

class FloodProne extends StatefulWidget {
  const FloodProne({super.key});

  @override
  State<FloodProne> createState() => _FloodProneState();
}

class _FloodProneState extends State<FloodProne> {
  LatLng? _currentLocation;
  final MapController _mapController = MapController();
  List<Marker> _markers = [];

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
    _loadMarkers();
  }

  Future<void> _getCurrentLocation() async {
    LocationPermission permission = await Geolocator.requestPermission();

    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      // Show a message to the user or handle lack of permission.
      return;
    }

    Position position = await Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
      ),
    );

    setState(() {
      _currentLocation = LatLng(position.latitude, position.longitude);
    });
  }

  Future<void> _loadMarkers() async {
    final String response =
        await rootBundle.loadString('lib/assets/flood_prone_areas.json');
    final List<dynamic> data = json.decode(response);

    setState(() {
      _markers = data.map((item) {
        return Marker(
          point: LatLng(item['latitude'], item['longitude']),
          width: 80.0,
          height: 80.0,
          alignment: Alignment.centerLeft,
          child: GestureDetector(
            onTap: () {
              showModalBottomSheet(
                isScrollControlled: true,
                context: context,
                builder: (context) {
                  return Container(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          item['name'],
                          style: const TextStyle(fontSize: 20),
                        ),
                        const SizedBox(height: 10),
                        // TextButton(
                        //   onPressed: () {},
                        //   child: const Row(
                        //     mainAxisSize: MainAxisSize.min,
                        //     children: [
                        //       Icon(Icons.directions, color: Colors.blueAccent),
                        //       SizedBox(width: 5),
                        //       Text(
                        //         'Get Directions',
                        //         style: TextStyle(
                        //             color: Colors.blueAccent, fontSize: 20),
                        //       ),
                        //     ],
                        //   ),
                        // ),
                      ],
                    ),
                  );
                },
              );
            },
            child: const Icon(
              Icons.surfing,
              size: 55.0,
              color: Colors.red,
            ),
          ),
        );
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.white, //change your color here
        ),
        backgroundColor: Colors.red,
        title: const Text(
          'Flood-prone Areas',
          style: TextStyle(color: Colors.white),
        ),
        // automaticallyImplyLeading: false,
        centerTitle: true,
      ),
      backgroundColor: Colors.white,
      body: _currentLocation == null
          ? const Center(child: CircularProgressIndicator())
          : content(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (_currentLocation != null) {
            _mapController.move(_currentLocation!, 15.0);
          }
        },
        backgroundColor: Colors.red,
        child: const Icon(Icons.my_location, color: Colors.white),
      ),
    );
  }

  Widget content() {
    return FlutterMap(
      mapController: _mapController,
      options: MapOptions(
        initialCenter:
            _currentLocation ?? const LatLng(11.6978351, 122.6217542),
        initialZoom: 15.0,
        interactionOptions:
            const InteractionOptions(flags: ~InteractiveFlag.doubleTapZoom),
      ),
      children: [
        openStreetMapTileLayer,
        MarkerLayer(
          markers: [
            Marker(
              point: _currentLocation ?? const LatLng(6.9545859, 121.9560282),
              width: 80.0,
              height: 80.0,
              alignment: Alignment.centerLeft,
              child: GestureDetector(
                onTap: () {
                  showModalBottomSheet(
                    isScrollControlled: true,
                    context: context,
                    builder: (context) {
                      return Container(
                        padding: const EdgeInsets.all(16.0),
                        child: const Text('Current Location',
                            style: TextStyle(fontSize: 20)),
                      );
                    },
                  );
                },
                child: const CircleAvatar(
                  backgroundColor: Color.fromARGB(128, 255, 189, 195),
                  radius: 20.0,
                  child: Icon(
                    Icons.location_on,
                    color: Colors.red,
                    size: 20.0,
                  ),
                ),
              ),
            ),
            ..._markers,
          ],
        ),
      ],
    );
  }
}

TileLayer get openStreetMapTileLayer => TileLayer(
      urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
      userAgentPackageName: 'dev.leaflet.flutter_map.example',
    );
