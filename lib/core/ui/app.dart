import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../theme/theme.dart';
import 'package:go_router/go_router.dart';
import 'bottom_nav_wrapper.dart';
import '../../features/dashboard/ui/dashboard_screen.dart';
import '../../features/medication/ui/medication_screen.dart';
import '../../features/medication/ui/add_medication_screen.dart';
import '../../features/medication/ui/medication_detail_screen.dart';
import '../../features/calculator/ui/reconstitution_calculator_screen.dart';
import '../../features/scheduling/presentation/screens/schedules_screen.dart';
import '../../features/scheduling/presentation/screens/add_schedule_screen.dart';
import '../../features/settings/ui/settings_screen.dart';
import '../../features/user_account/ui/user_account_screen.dart';
import '../../features/inventory/ui/inventory_screen.dart';

class DosifyApp extends StatelessWidget {
  const DosifyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      child: MaterialApp.router(
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.system,
        routerConfig: _router,
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}

final _router = GoRouter(
  initialLocation: '/dashboard',
  routes: [
    GoRoute(
      path: '/dashboard',
      builder: (context, state) => const BottomNavWrapper(
        title: 'Dosify',
        child: DashboardContent(),
      ),
    ),
    GoRoute(
      path: '/medications',
      builder: (context, state) => BottomNavWrapper(
        title: 'Medications',
        floatingActionButton: _buildMultiChoiceFAB(context),
        child: const MedicationContent(),
      ),
      routes: [
        GoRoute(
          path: 'add',
          builder: (context, state) => const AddMedicationScreen(),
        ),
        GoRoute(
          path: 'detail/:id',
          builder: (context, state) {
            final medicationId = state.pathParameters['id']!;
            return MedicationDetailScreen(medicationId: medicationId);
          },
        ),
      ],
    ),
    GoRoute(
      path: '/schedules',
      builder: (context, state) => BottomNavWrapper(
        title: 'Schedules',
        floatingActionButton: FloatingActionButton(
          heroTag: "schedulesFAB",
          onPressed: () => context.go('/schedules/add'),
          child: const Icon(Icons.add),
        ),
        child: const SchedulesContent(),
      ),
      routes: [
        GoRoute(
          path: 'add',
          builder: (context, state) => const AddScheduleScreen(),
        ),
      ],
    ),
    GoRoute(
      path: '/settings',
      builder: (context, state) => const BottomNavWrapper(
        title: 'Settings',
        child: SettingsContent(),
      ),
    ),
    GoRoute(
      path: '/calculator',
      builder: (context, state) => const ReconstitutionCalculatorScreen(),
    ),
    GoRoute(
      path: '/user-account',
      builder: (context, state) => const UserAccountScreen(),
    ),
    GoRoute(
      path: '/inventory',
      builder: (context, state) => const BottomNavWrapper(
        title: 'Inventory',
        child: InventoryContent(),
      ),
    ),
  ],
);

Widget _buildMultiChoiceFAB(BuildContext context) {
  return FloatingActionButton(
    heroTag: "medicationsFAB",
    onPressed: () => _showAddOptions(context),
    child: const Icon(Icons.add),
  );
}

void _showAddOptions(BuildContext context) {
  showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) => Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'Add New Item',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: _buildAddOptionCard(
                  context,
                  'Medication',
                  'Add a new medication',
                  Icons.medication,
                  Colors.blue,
                  () {
                    Navigator.of(context).pop();
                    context.go('/medications/add');
                  },
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildAddOptionCard(
                  context,
                  'Supply',
                  'Add medical supply',
                  Icons.inventory,
                  Colors.green,
                  () {
                    Navigator.of(context).pop();
                    context.go('/inventory');
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
        ],
      ),
    ),
  );
}

Widget _buildAddOptionCard(
  BuildContext context,
  String title,
  String subtitle,
  IconData icon,
  Color color,
  VoidCallback onTap,
) {
  return Material(
    color: Colors.transparent,
    child: InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(color: color.withOpacity(0.3)),
          borderRadius: BorderRadius.circular(16),
          color: color.withOpacity(0.1),
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: Colors.white,
                size: 24,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    ),
  );
}
