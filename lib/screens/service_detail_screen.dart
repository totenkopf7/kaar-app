// services_module.dart
import 'package:flutter/material.dart';

// 1. Model Definitions
class Service {
  final String id;
  final String name;
  final IconData icon;
  final List<ServiceOption> options;

  Service({
    required this.id,
    required this.name,
    required this.icon,
    required this.options,
  });
}

class ServiceOption {
  final String id;
  final String title;
  final IconData icon;

  ServiceOption({
    required this.id,
    required this.title,
    required this.icon,
  });
}

// 2. Data - All Services
final List<Service> allServices = [
  Service(
    id: 'glass',
    name: 'Glass',
    icon: Icons.window,
    options: [
      ServiceOption(
        id: 'installation',
        title: 'Installation',
        icon: Icons.install_desktop,
      ),
      ServiceOption(
        id: 'repair',
        title: 'Repair',
        icon: Icons.handyman,
      ),
    ],
  ),
  Service(
    id: 'medical',
    name: 'Medical',
    icon: Icons.medical_services,
    options: [
      ServiceOption(
        id: 'blood_pressure',
        title: 'Blood Pressure',
        icon: Icons.monitor_heart,
      ),
    ],
  ),
  // Add other services here
];

// 3. Widgets
class ServiceContainer extends StatelessWidget {
  final Service service;
  final VoidCallback onTap;

  const ServiceContainer({
    super.key,
    required this.service,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(service.icon, size: 40, color: Theme.of(context).primaryColor),
            const SizedBox(height: 8),
            Text(
              service.name,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// 4. Screens
class ServicesScreen extends StatelessWidget {
  const ServicesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Our Services')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 0.9,
          ),
          itemCount: allServices.length,
          itemBuilder: (context, index) {
            final service = allServices[index];
            return ServiceContainer(
              service: service,
              onTap: () => _navigateToServiceDetail(context, service),
            );
          },
        ),
      ),
    );
  }

  void _navigateToServiceDetail(BuildContext context, Service service) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ServiceDetailScreen(service: service),
      ),
    );
  }
}

class ServiceDetailScreen extends StatelessWidget {
  final Service service;

  const ServiceDetailScreen({
    super.key,
    required this.service,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(service.name)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Icon(
              service.icon,
              size: 60,
              color: Theme.of(context).primaryColor,
            ),
            const SizedBox(height: 20),
            Text('Available Options:',
                style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: service.options.length,
                itemBuilder: (context, index) {
                  final option = service.options[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    child: ListTile(
                      leading: Icon(option.icon),
                      title: Text(option.title),
                      onTap: () => _handleOptionSelection(context, option),
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

  void _handleOptionSelection(BuildContext context, ServiceOption option) {
    // Handle option selection
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Selected: ${option.title}'),
        content: Text('Service: ${service.name}\nOption: ${option.title}'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
