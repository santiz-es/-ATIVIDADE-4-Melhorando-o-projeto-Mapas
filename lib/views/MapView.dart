import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_mapas_osm/viewmodels/LocationViewModel.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import 'package:geocoding/geocoding.dart';

class MapView extends StatefulWidget {
  const MapView({super.key});

  @override
  State<MapView> createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  final MapController _mapController = MapController();
  final TextEditingController _searchController = TextEditingController();
  LatLng? _lastLocation;

  Future<void> _searchAddress(String query) async {
    try {
      List<Location> locations = await locationFromAddress(query);
      if (locations.isNotEmpty) {
        final loc = locations.first;
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _mapController.move(LatLng(loc.latitude, loc.longitude), 16);
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Endereço não encontrado.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LocationViewModel>(
      builder: (context, viewModel, child) {
        if (viewModel.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        final location = viewModel.location;
        if (location == null) {
          return const Center(
            child: Text('Não foi possível obter a localização.'),
          );
        }

        final currentLatLng = LatLng(location.latitude, location.longitude);

        
        if (_lastLocation == null ||
            (_lastLocation!.latitude != currentLatLng.latitude ||
                _lastLocation!.longitude != currentLatLng.longitude)) {
          _lastLocation = currentLatLng;
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _mapController.move(currentLatLng, 16);
          });
        }

        return Column(
          children: [
            // Barra de búsqueda
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Buscar endereço...',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onSubmitted: _searchAddress,
              ),
            ),
            // Mapa
            Expanded(
              child: FlutterMap(
                mapController: _mapController,
                options: MapOptions(
                  initialCenter: currentLatLng,
                  initialZoom: 16,
                ),
                children: [
                  TileLayer(
                    urlTemplate:
                        'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                    subdomains: const ['a', 'b', 'c'],
                    userAgentPackageName:
                        'br.edu.ifsul.flutter_mapas_osm',
                  ),
                  MarkerLayer(
                    markers: [
                      Marker(
                        point: currentLatLng,
                        width: 40,
                        height: 40,
                        child: const Icon(
                          Icons.location_pin,
                          color: Colors.red,
                          size: 40,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
