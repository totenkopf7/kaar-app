import 'package:flutter/material.dart';
import 'package:kaar/components/appbar.dart';
import 'package:kaar/components/dashboard_tile.dart';
import 'package:kaar/components/colors.dart';
import 'package:kaar/components/image_swiper.dart';
import 'package:kaar/screens/booking_screen.dart';
import 'package:kaar/screens/profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Service data - could be moved to a separate file if it grows large
  final Map<String, Map<String, dynamic>> services = {
    'Glass': {
      'image': 'lib/assets/images/glass.png',
      'icon': Icons.window,
      'options': [
        {'title': 'Installation', 'icon': Icons.install_desktop},
        {'title': 'Repair', 'icon': Icons.handyman},
      ],
    },
    'Air Condition': {
      'image': 'lib/assets/images/ac2.png',
      'icon': Icons.ac_unit,
      'options': [
        {'title': 'Installation', 'icon': Icons.install_desktop},
        {'title': 'Maintenance', 'icon': Icons.build},
        {'title': 'Repair', 'icon': Icons.handyman},
      ],
    },
    'Cleaning': {
      'image': 'lib/assets/images/cleaning.png',
      'icon': Icons.cleaning_services,
      'options': [
        {'title': 'Home Cleaning', 'icon': Icons.home},
        {'title': 'Office Cleaning', 'icon': Icons.work},
      ],
    },
    'Satellite': {
      'image': 'lib/assets/images/satellite.png',
      'icon': Icons.satellite,
      'options': [
        {'title': 'Installation', 'icon': Icons.install_desktop},
        {'title': 'Maintenance', 'icon': Icons.build},
        {'title': 'Repair', 'icon': Icons.handyman},
      ],
    },
    'Car Wash': {
      'image': 'lib/assets/images/carwash.png',
      'icon': Icons.wash,
      'options': [
        {'title': 'Washing the car', 'icon': Icons.wash},
      ],
    },
    'Painting': {
      'image': 'lib/assets/images/painting.png',
      'icon': Icons.brush,
      'options': [
        {'title': 'Installation', 'icon': Icons.install_desktop},
        {'title': 'Maintenance', 'icon': Icons.build},
        {'title': 'Repair', 'icon': Icons.handyman},
      ],
    },
    'Car Service': {
      'image': 'lib/assets/images/car_service.png',
      'icon': Icons.car_repair,
      'options': [
        {'title': 'Oil Change', 'icon': Icons.oil_barrel},
        {'title': 'Battery Change', 'icon': Icons.battery_2_bar},
        {'title': 'Tire Replacement', 'icon': Icons.tire_repair},
      ],
    },
    'Curtains': {
      'image': 'lib/assets/images/curtains.png',
      'icon': Icons.curtains,
      'options': [
        {'title': 'Installing', 'icon': Icons.curtains_sharp},
        {'title': 'Designing', 'icon': Icons.design_services_rounded},
      ],
    },
    'Medical Service': {
      'image': 'lib/assets/images/medical_service.png',
      'icon': Icons.medical_services,
      'options': [
        {'title': 'Blood Pressure', 'icon': Icons.medical_services_rounded},
        {'title': 'Blood Tests', 'icon': Icons.bloodtype},
        {'title': 'Doctor Visit', 'icon': Icons.health_and_safety},
      ],
    },
    'Security Camera': {
      'image': 'lib/assets/images/security_camera.png',
      'icon': Icons.camera_outdoor,
      'options': [
        {'title': 'Install', 'icon': Icons.install_desktop},
        {'title': 'Maintenance', 'icon': Icons.handyman},
      ],
    },
    'Plumbing': {
      'image': 'lib/assets/images/plumping.png',
      'icon': Icons.house,
      'options': [
        {'title': 'Install and repair', 'icon': Icons.handyman},
      ],
    },
    'Washing & Ironing': {
      'image': 'lib/assets/images/washing_ironing.png',
      'icon': Icons.wash_outlined,
      'options': [
        {'title': 'Washing', 'icon': Icons.wash_rounded},
        {'title': 'Ironing', 'icon': Icons.iron},
      ],
    },
    'Furniture Assembly': {
      'image': 'lib/assets/images/furniture_assembly.png',
      'icon': Icons.table_restaurant_rounded,
      'options': [
        {'title': 'Assembly and Repair', 'icon': Icons.table_restaurant},
      ],
    },
    // Add other services similarly...
  };

  void _navigateToService(BuildContext context, String serviceName) {
    final service = services[serviceName];
    if (service == null) return;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ServiceDetailScreen(
          serviceName: serviceName,
          serviceIcon: service['icon'],
          options: (service['options'] as List)
              .map((opt) => ServiceOption(
                    title: opt['title'],
                    icon: opt['icon'],
                  ))
              .toList(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: const CustomAppBar(title: "Kaar Beta"),
        drawer: Drawer(
          backgroundColor: AppColors.background,
          child: Column(
            children: [
              DrawerHeader(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: Image.asset(
                    'lib/assets/images/logo.png',
                    width: 100,
                  ),
                ),
              ),
              ListTile(
                leading: const Icon(
                  Icons.dashboard_rounded,
                  color: AppColors.primary,
                ),
                title: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const ProfileScreen()),
                    ).then((value) => Navigator.pop(context));
                  },
                  child: const Text("Profile",
                      style: TextStyle(color: AppColors.primary)),
                ),
              ),
            ],
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              ImageSwiper(),
              const SizedBox(height: 28),
              GridView.count(
                crossAxisCount: 3,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                padding: const EdgeInsets.all(16),
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: services.entries.map((entry) {
                  final serviceName = entry.key;
                  final serviceData = entry.value;

                  return DashboardTile(
                    imagePath: serviceData['image'],
                    title: serviceName,
                    onTap: () => _navigateToService(context, serviceName),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Add this to your service_detail_screen.dart file
class ServiceOption {
  final String title;
  final IconData icon;

  ServiceOption({
    required this.title,
    required this.icon,
  });
}

class ServiceDetailScreen extends StatelessWidget {
  final String serviceName;
  final IconData serviceIcon;
  final List<ServiceOption> options;

  const ServiceDetailScreen({
    super.key,
    required this.serviceName,
    required this.serviceIcon,
    required this.options,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          serviceName,
          style: const TextStyle(color: AppColors.secondary),
        ),
        backgroundColor: AppColors.background,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Icon(serviceIcon, size: 60, color: AppColors.primary),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: options.length,
                itemBuilder: (context, index) {
                  final option = options[index];
                  return Card(
                    color: AppColors.primary,
                    margin: const EdgeInsets.only(bottom: 12),
                    child: ListTile(
                      leading: Icon(
                        option.icon,
                        color: AppColors.background,
                      ),
                      title: Text(
                        option.title,
                        style: TextStyle(color: AppColors.background),
                      ),

                      //Only shows dialogue
                      // onTap: () {
                      //   // Handle specific service option selection
                      //   // You can navigate to another screen or show a dialog
                      //   showDialog(
                      //     context: context,
                      //     builder: (context) => AlertDialog(
                      //       // title: Text('$serviceName - ${option.title}'),
                      //       content: const Text('Coming Soon'),
                      //       actions: [
                      //         TextButton(
                      //           onPressed: () => Navigator.pop(context),
                      //           child: const Text('OK'),
                      //         ),
                      //       ],
                      //     ),
                      //   );
                      // },
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BookingScreen(
                              serviceName: serviceName,
                              optionName: option.title,
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
