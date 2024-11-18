import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:url_launcher/url_launcher.dart';

class Hotlines extends StatefulWidget {
  const Hotlines({super.key});

  @override
  State<Hotlines> createState() => _HotlinesState();
}

class _HotlinesState extends State<Hotlines> {
  final _searchController = TextEditingController();
  List<dynamic> _hotlines = [];
  List<dynamic> _filteredHotlines = [];

  Future<void> _loadHotlines() async {
    final jsonString = await rootBundle.loadString('lib/assets/hotlines.json');
    final jsonMap = jsonDecode(jsonString);
    setState(() {
      _hotlines = jsonMap['hotlines'];
      _filteredHotlines = _hotlines;
    });
  }

  @override
  void initState() {
    super.initState();
    _loadHotlines();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _searchHotlines() {
    setState(() {
      final searchQuery = _searchController.text.toLowerCase();
      _filteredHotlines = _hotlines
          .where(
              (hotline) => hotline['name'].toLowerCase().contains(searchQuery))
          .toList();
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
          'Hotlines',
          style: TextStyle(color: Colors.white),
        ),
        // automaticallyImplyLeading: false,
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              onChanged: (value) => _searchHotlines(),
              decoration: const InputDecoration(
                labelText: 'Search',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _filteredHotlines.length,
              itemBuilder: (context, index) {
                return Card(
                  color: Colors.white,
                  child: ListTile(
                    leading: const Icon(Icons.phone, color: Colors.red),
                    title: Text(_filteredHotlines[index]['name']),
                    subtitle: Text(_filteredHotlines[index]['contactNo']),
                    onTap: () async {
                      final phoneNumber = _filteredHotlines[index]['contactNo'];
                      final uri = Uri(scheme: 'tel', path: phoneNumber);
                      if (await canLaunchUrl(uri)) {
                        await launchUrl(uri);
                      } else {
                        // Show error if phone dialer is unavailable
                        // ignore: use_build_context_synchronously
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('Could not launch phone dialer')),
                        );
                      }
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
