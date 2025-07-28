import 'package:flutter/material.dart';

class SimpleDashboardScreen extends StatelessWidget {
  const SimpleDashboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print('Building SimpleDashboardScreen...');
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dosify'),
        centerTitle: true,
      ),
      body: const SingleChildScrollView(
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
            _SimpleDashboardCard(
              icon: Icons.medication,
              title: 'Medications',
              subtitle: 'Manage your medications',
            ),
            SizedBox(height: 16),
            _SimpleDashboardCard(
              icon: Icons.calculate,
              title: 'Calculator',
              subtitle: 'Reconstitution calculations',
            ),
            SizedBox(height: 16),
            _SimpleDashboardCard(
              icon: Icons.inventory,
              title: 'Inventory',
              subtitle: 'Track medication stock',
            ),
            SizedBox(height: 16),
            _SimpleDashboardCard(
              icon: Icons.schedule,
              title: 'Schedules',
              subtitle: 'Medication schedules',
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: 0,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.medication),
            label: 'Medications',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.schedule),
            label: 'Schedules',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}

class _SimpleDashboardCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const _SimpleDashboardCard({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: () {
          print('Tapped on $title');
          // Show snackbar instead of navigation
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('$title feature - Coming Soon!')),
          );
        },
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
