import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:kaar/components/colors.dart';

class BookingScreen extends StatefulWidget {
  final String serviceName;
  final String optionName;

  const BookingScreen({
    super.key,
    required this.serviceName,
    required this.optionName,
  });

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  LatLng _selectedLocation = LatLng(0, 0); // Default location
  final TextEditingController _descriptionController = TextEditingController();
  bool _isLoading = true;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    try {
      // Check if location services are enabled
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        setState(() {
          _errorMessage = 'Location services are disabled. Please enable them.';
          _isLoading = false;
          _selectedLocation = LatLng(24.7136, 46.6753); // Default to Riyadh
        });
        return;
      }

      // Check permissions
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          setState(() {
            _errorMessage = 'Location permissions are denied';
            _isLoading = false;
            _selectedLocation = LatLng(24.7136, 46.6753); // Default to Riyadh
          });
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        setState(() {
          _errorMessage =
              'Location permissions are permanently denied. Please enable them in app settings.';
          _isLoading = false;
          _selectedLocation = LatLng(24.7136, 46.6753); // Default to Riyadh
        });
        // Optionally open app settings
        // await openAppSettings();
        return;
      }

      // Get current position
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best,
      );

      setState(() {
        _selectedLocation = LatLng(position.latitude, position.longitude);
        _isLoading = false;
        _errorMessage = '';
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Error getting location: ${e.toString()}';
        _isLoading = false;
        _selectedLocation = LatLng(24.7136, 46.6753); // Default to Riyadh
      });
    }
  }

  

  void _handleMapTap(LatLng latlng) {
    setState(() {
      _selectedLocation = latlng;
    });
  }

  void _bookNow() {
    // if (_descriptionController.text.isEmpty) {
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     const SnackBar(content: Text('Please enter description')),
    //   );
    //   return;
    // }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Booking'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Service: ${widget.serviceName}'),
            Text('Option: ${widget.optionName}'),
            const SizedBox(height: 10),
            Text('Location:'),
            Text('Lat: ${_selectedLocation.latitude.toStringAsFixed(4)}'),
            Text('Lng: ${_selectedLocation.longitude.toStringAsFixed(4)}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Booking confirmed!')),
              );
            },
            child: const Text('Confirm'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        title: Text('Book ${widget.optionName}'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (_errorMessage.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: Text(
                        _errorMessage,
                        style: TextStyle(color: Colors.red),
                      ),
                    ),

                  // Service Info
                  Text(
                    '${widget.serviceName} - ${widget.optionName}',
                    style: TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                        fontSize: 24),
                  ),
                  const SizedBox(height: 20),

                  // Map Container
                  Container(
                    height: 300,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: FlutterMap(
                        options: MapOptions(
                          center: _selectedLocation,
                          zoom: 15.0,
                          onTap: (_, latlng) => _handleMapTap(latlng),
                        ),
                        children: [
                          TileLayer(
                            urlTemplate:
                                'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                            subdomains: const ['a', 'b', 'c'],
                            userAgentPackageName: 'com.example.kaar',
                          ),
                          MarkerLayer(
                            markers: [
                              Marker(
                                width: 40,
                                height: 40,
                                point: _selectedLocation,
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
                  ),
                  const SizedBox(height: 16),

                  // Location Coordinates
                  const Text(
                    'Selected Location:',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: AppColors.primary),
                  ),
                  Text(
                    'Latitude: ${_selectedLocation.latitude.toStringAsFixed(6)}',
                    style: TextStyle(color: AppColors.primary),
                  ),
                  Text(
                    'Longitude: ${_selectedLocation.longitude.toStringAsFixed(6)}',
                    style: TextStyle(color: AppColors.primary),
                  ),
                  const SizedBox(height: 20),

                  // Description Field
                  const Text(
                    'Additional Details:',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: AppColors.primary),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _descriptionController,
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Describe your requirements...',
                        hintStyle: TextStyle(color: AppColors.primary)),
                    maxLines: 3,
                  ),
                  const SizedBox(height: 24),

                  // Book Now Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        backgroundColor: AppColors.primary,
                      ),
                      onPressed: _bookNow,
                      child: const Text(
                        'BOOK NOW',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.background,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }
}
