import 'package:flutter/material.dart';
import 'core/di/service_locator.dart';
import 'core/ui/app.dart';
import 'core/theme/theme.dart';
import 'features/dashboard/ui/simple_dashboard_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  try {
    // Initialize the service locator
    print('Initializing service locator...');
    await setupServiceLocator();
    print('Service locator initialized successfully!');
    
    // Run the proper app with GoRouter
    print('About to run DosifyApp...');
    
    // Create the app first to test if there are any build issues
    try {
      print('Creating DosifyApp instance...');
      const app = DosifyApp();
      print('DosifyApp instance created successfully!');
      
      print('Running app...');
      runApp(app);
      print('App started successfully!');
    } catch (e) {
      print('CAUGHT ERROR while creating the app: $e');
      rethrow;
    }
    
  } catch (e, stackTrace) {
    print('CAUGHT ERROR during app initialization: $e');
    print('Stack trace: $stackTrace');
    
    // Run a minimal app with error display
    runApp(
      MaterialApp(
        home: Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error, size: 64, color: Colors.red),
                const SizedBox(height: 16),
                const Text('App Initialization Error'),
                const SizedBox(height: 8),
                Text('$e'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Minimal app for testing
class MinimalDosifyApp extends StatelessWidget {
  const MinimalDosifyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dosify Debug',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
      ),
      home: const MinimalDashboard(),
    );
  }
}

class MinimalDashboard extends StatelessWidget {
  const MinimalDashboard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dosify - Debug Mode'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.check_circle,
              size: 64,
              color: Colors.green,
            ),
            SizedBox(height: 16),
            Text(
              'App is Working!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'The basic app structure is functional.',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}

// Simplified app using MaterialApp instead of GoRouter
class SimplifiedDosifyApp extends StatelessWidget {
  const SimplifiedDosifyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print('Building SimplifiedDosifyApp...');
    return MaterialApp(
      title: 'Dosify',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      home: const SimpleDashboardScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
