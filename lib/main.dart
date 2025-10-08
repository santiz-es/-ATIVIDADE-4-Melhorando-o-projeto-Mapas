import 'package:flutter/material.dart';
import 'package:flutter_mapas_osm/viewmodels/LocationViewModel.dart';
import 'package:flutter_mapas_osm/views/MapView.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) {
        final viewModel = LocationViewModel();
        viewModel.fetchLocation();
        viewModel.startLocationUpdates(); 
        return viewModel;
      },
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Mapa OSM',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.teal,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Localização no Mapa'),
          centerTitle: true,
        ),
        body: const MapView(),
      ),
    );
  }
}
