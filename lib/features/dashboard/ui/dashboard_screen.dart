import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/dashboard_providers.dart';
import '../../../test_data_script.dart';

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
class DashboardContent extends ConsumerWidget {
  const DashboardContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    print('Building DashboardContent...');
    final dashboardStats = ref.watch(dashboardStatsProvider);
    
    return dashboardStats.when(
      data: (stats) => SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildMedicationOverviewCard(context, stats),
            const SizedBox(height: 20),
            _buildQuickStatsRow(stats),
            const SizedBox(height: 20),
            _buildTodayOverviewCard(context, stats),
            const SizedBox(height: 20),
            _buildAdherenceChart(context),
          ],
        ),
      ),
      loading: () => const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Loading dashboard...'),
          ],
        ),
      ),
      error: (error, stack) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text('Error: $error'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => ref.refresh(dashboardStatsProvider),
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWelcomeHeader() {
    final hour = DateTime.now().hour;
    String greeting;
    if (hour < 12) {
      greeting = 'Good Morning';
    } else if (hour < 17) {
      greeting = 'Good Afternoon';
    } else {
      greeting = 'Good Evening';
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          greeting,
          style: const TextStyle(fontSize: 16, color: Colors.grey),
        ),
        const Text(
          'Welcome to Dosify',
          style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text(
          'Manage your health with confidence',
          style: TextStyle(fontSize: 16, color: Colors.grey[600]),
        ),
      ],
    );
  }

  Widget _buildMedicationOverviewCard(BuildContext context, stats) {
    return GestureDetector(
      onTap: () => context.go('/medications'),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.blue.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.medication, color: Colors.blue),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Medication Overview',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          'Track your medication management',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                  const Icon(Icons.arrow_forward_ios, color: Colors.grey),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _buildMiniStat('Total Medications', '${stats.totalMedications}', Colors.blue),
                  ),
                  Expanded(
                    child: _buildMiniStat('Active Schedules', '${stats.activeSchedules}', Colors.green),
                  ),
                  Expanded(
                    child: _buildMiniStat('Next Dose', stats.nextDoseFormatted, Colors.purple),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMiniStat(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: Colors.grey),
        ),
      ],
    );
  }

  Widget _buildQuickStatsRow(stats) {
    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            'Active Medications',
            '${stats.totalMedications}',
            Icons.medication,
            Colors.blue,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            'Due Today',
            '${stats.todaysDoses}',
            Icons.schedule,
            Colors.orange,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            'Low Stock',
            '${stats.lowStockCount}',
            Icons.warning,
            Colors.red,
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            Text(
              title,
              style: const TextStyle(fontSize: 12, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTodayOverviewCard(BuildContext context, stats) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.today, color: Colors.blue),
                SizedBox(width: 8),
                Text(
                  'Today\'s Overview',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 16),
            stats.todaysDoses > 0
                ? Column(
                    children: [
                      _buildTodayItem('Morning Insulin', '8:00 AM', true),
                      _buildTodayItem('Vitamin D', '12:00 PM', false),
                      _buildTodayItem('Evening Medication', '6:00 PM', false),
                    ],
                  )
                : const Center(
                    child: Text(
                      'No medications scheduled for today',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () => context.go('/schedules'),
                child: const Text('View All Schedules'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTodayItem(String medication, String time, bool taken) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(
            taken ? Icons.check_circle : Icons.schedule,
            color: taken ? Colors.green : Colors.grey,
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              medication,
              style: TextStyle(
                decoration: taken ? TextDecoration.lineThrough : null,
                color: taken ? Colors.grey : null,
              ),
            ),
          ),
          Text(
            time,
            style: TextStyle(
              color: taken ? Colors.grey : Colors.blue,
              fontWeight: taken ? FontWeight.normal : FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAdherenceChart(BuildContext context) {
    // Placeholder for adherence chart
    return const Card(
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Center(
          child: Text('Adherence Chart - Coming Soon!'),
        ),
      ),
    );
  }

  Widget _buildActionCard(
    BuildContext context,
    String title,
    String subtitle,
    IconData icon,
    Color color,
    String route,
  ) {
    return Card(
      child: InkWell(
        onTap: () => context.go(route),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(
                flex: 2,
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Icon(icon, color: color, size: 20),
                ),
              ),
              const SizedBox(height: 4),
              Flexible(
                flex: 1,
                child: Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Flexible(
                flex: 1,
                child: Text(
                  subtitle,
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 10,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTestDataButton(BuildContext context, WidgetRef ref) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text(
              'Test Data',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Add sample data to test the app functionality',
              style: TextStyle(color: Colors.grey),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () async {
                try {
                  await addTestData();
                  // Refresh dashboard stats after adding test data
                  ref.refresh(dashboardStatsProvider);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Test data added successfully!'),
                      backgroundColor: Colors.green,
                    ),
                  );
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Error adding test data: $e'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              child: const Text('Add Test Data'),
            ),
          ],
        ),
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
