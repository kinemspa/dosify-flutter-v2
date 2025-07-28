import 'package:flutter/material.dart';
import '../theme/theme.dart';
import 'package:go_router/go_router.dart';
import 'bottom_nav_wrapper.dart';
import '../../features/dashboard/ui/dashboard_screen.dart';
import '../../features/medication/ui/medication_screen.dart';
import '../../features/medication/ui/add_medication_screen.dart';
import '../../features/medication/ui/medication_detail_screen.dart';
import '../../features/calculator/ui/reconstitution_calculator_screen.dart';
import '../../features/scheduling/ui/scheduling_screen.dart';
import '../../features/settings/ui/settings_screen.dart';

class DosifyApp extends StatelessWidget {
  const DosifyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      routerConfig: _router,
      debugShowCheckedModeBanner: false,
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
        floatingActionButton: FloatingActionButton(
          onPressed: () => context.go('/medications/add'),
          child: const Icon(Icons.add),
        ),
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
      builder: (context, state) => const BottomNavWrapper(
        title: 'Schedules',
        child: SchedulingContent(),
      ),
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
  ],
);
