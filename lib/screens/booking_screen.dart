import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geocoding/geocoding.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:kaar/components/colors.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

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
  String _selectedAddress = '';

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
        _fetchAddress(_selectedLocation); // Fetch address for default location
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
          _fetchAddress(
              _selectedLocation); // Fetch address for default location
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
        _fetchAddress(_selectedLocation); // Fetch address for default location
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

      _fetchAddress(_selectedLocation); // Fetch address for current location
    } catch (e) {
      setState(() {
        _errorMessage = 'Error getting location: ${e.toString()}';
        _isLoading = false;
        _selectedLocation = LatLng(24.7136, 46.6753); // Default to Riyadh
      });
      _fetchAddress(_selectedLocation); // Fetch address for default location
    }
  }

  Future<void> _fetchAddress(LatLng location) async {
    await dotenv.load(fileName: "lib/.env");
    String apiKey = dotenv.env['API_KEY']!;

    // const String apiKey =
    //     'AIzaSyBc_i0jSnGtiiz0P7ClxyM8VVpaVrDUrHY'; // Replace with your API key
    final String url =
        'https://maps.googleapis.com/maps/api/geocode/json?latlng=${location.latitude},${location.longitude}&key=$apiKey';

    try {
      setState(() {
        _selectedAddress = 'Fetching address...'; // Show a loading message
      });

      // Make the API request
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['status'] == 'OK' && data['results'].isNotEmpty) {
          // Use the formatted address directly
          final formattedAddress = data['results'][0]['formatted_address'];

          setState(() {
            _selectedAddress = formattedAddress;
          });
        } else {
          setState(() {
            _selectedAddress = 'No address found for this location.';
          });
        }
      } else {
        setState(() {
          _selectedAddress =
              'Error fetching address: ${response.statusCode} ${response.reasonPhrase}';
        });
      }
    } catch (e) {
      setState(() {
        _selectedAddress = 'Error fetching address: ${e.toString()}';
      });
    }
  }

  void _handleMapTap(LatLng latlng) async {
    setState(() {
      _selectedLocation = latlng;
      _selectedAddress = 'Fetching address...'; // Show a loading message
    });

    _fetchAddress(latlng); // Fetch address for the tapped location
  }

  void _bookNow() {
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
            Text('Address: $_selectedAddress'),
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
              _saveBooking(); // Call the booking function
              // Show a confirmation message
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

  Future<void> _saveBooking() async {
    final bookingData = {
      'userId':
          'usert888', // Replace with the actual user ID from Firebase Auth
      'service': widget.serviceName,
      'location': {
        'latitude': _selectedLocation.latitude,
        'longitude': _selectedLocation.longitude,
        'address': _selectedAddress,
      },
      'description': _descriptionController.text,
      'status': 'pending',
      'createdAt': FieldValue.serverTimestamp(),
    };

    try {
      await FirebaseFirestore.instance.collection('bookings').add(bookingData);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Booking saved successfully!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error saving booking: $e')),
      );
    }
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
                  // Display the Address
                  const Text(
                    'Address:',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: AppColors.primary),
                  ),
                  Text(
                    _selectedAddress.isNotEmpty
                        ? _selectedAddress
                        : 'No address selected.',
                    style: TextStyle(color: AppColors.primary),
                  ),
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
