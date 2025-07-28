import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  void initState() {
    super.initState();
    print('Dashboard screen initialized');
  }

  @override
  Widget build(BuildContext context) {
    print('Building dashboard screen...');
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dosify'),
        centerTitle: true,
      ),
      body: const DashboardContent(),
    );
  }
}

// Content-only version for use with BottomNavWrapper
class DashboardContent extends StatelessWidget {
  const DashboardContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print('Building DashboardContent...');
    return const SingleChildScrollView(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Welcome to Dosify',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16),
          Text(
            'Your comprehensive medication management app with professional-grade reconstitution calculations.',
            style: TextStyle(fontSize: 16),
          ),
          SizedBox(height: 32),
          _DashboardCard(
            icon: Icons.medication,
            title: 'Medications',
            subtitle: 'Manage your medications',
            route: '/medications',
          ),
          SizedBox(height: 16),
          _DashboardCard(
            icon: Icons.calculate,
            title: 'Calculator',
            subtitle: 'Reconstitution calculations',
            route: '/dashboard',
          ),
          SizedBox(height: 16),
          _DashboardCard(
            icon: Icons.inventory,
            title: 'Inventory',
            subtitle: 'Track medication stock',
            route: '/dashboard',
          ),
          SizedBox(height: 16),
          _DashboardCard(
            icon: Icons.schedule,
            title: 'Schedules',
            subtitle: 'Medication schedules',
            route: '/schedules',
          ),
        ],
      ),
    );
  }
}

class _DashboardCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final String route;

  const _DashboardCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.route,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: () => context.go(route),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Icon(
                icon,
                size: 48,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios),
            ],
          ),
        ),
      ),
    );
  }
}
