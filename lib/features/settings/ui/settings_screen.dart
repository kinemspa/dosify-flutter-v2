import 'package:flutter/material.dart';
import '../../../core/di/service_locator.dart';
import '../../../core/data/services/database_service.dart';
import '../../../core/data/repositories/medication_repository.dart';
import '../../inventory/repositories/inventory_repository.dart';
import '../../scheduling/data/repositories/schedule_repository.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        centerTitle: true,
      ),
      body: const SettingsContent(),
    );
  }
}

// Content-only version for use with BottomNavWrapper
class SettingsContent extends StatefulWidget {
  const SettingsContent({Key? key}) : super(key: key);

  @override
  State<SettingsContent> createState() => _SettingsContentState();
}

class _SettingsContentState extends State<SettingsContent> {
  bool _notificationsEnabled = true;
  bool _soundAlertsEnabled = true;
  String _reminderFrequency = 'Every day';
  bool _darkModeEnabled = false;
  String _timeFormat = '12 hour';
  bool _backupEnabled = true;
  String _backupFrequency = 'Daily';
  bool _lowStockAlertsEnabled = true;
  bool _adherenceRemindersEnabled = true;
  String _defaultMedicationView = 'List view';
  bool _showMedicationImages = true;
  bool _enableBiometricAuth = false;
  
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSection(
            'Notifications',
            [
              _buildSwitchTile(
                'Enable Notifications',
                'Receive medication reminders',
                _notificationsEnabled,
                (value) => setState(() => _notificationsEnabled = value),
                Icons.notifications,
              ),
              _buildSwitchTile(
                'Sound Alerts',
                'Play sound for medication reminders',
                _soundAlertsEnabled,
                (value) => setState(() => _soundAlertsEnabled = value),
                Icons.volume_up,
              ),
              _buildDropdownTile(
                'Reminder Frequency',
                'How often to remind for missed doses',
                _reminderFrequency,
                ['Every hour', 'Every 4 hours', 'Every day', 'Never'],
                (value) => setState(() => _reminderFrequency = value!),
                Icons.schedule,
              ),
            ],
          ),
          const SizedBox(height: 24),
          _buildSection(
            'Appearance',
            [
              _buildSwitchTile(
                'Dark Mode',
                'Use dark theme throughout the app',
                _darkModeEnabled,
                (value) => setState(() => _darkModeEnabled = value),
                Icons.dark_mode,
              ),
              _buildDropdownTile(
                'Time Format',
                'Display time in 12 or 24 hour format',
                _timeFormat,
                ['12 hour', '24 hour'],
                (value) => setState(() => _timeFormat = value!),
                Icons.access_time,
              ),
            ],
          ),
          const SizedBox(height: 24),
          _buildSection(
            'Data & Storage',
            [
              _buildActionTile(
                'Export Data',
                'Export your medication data',
                Icons.download,
                () => _showExportDialog(),
              ),
              _buildActionTile(
                'Import Data',
                'Import medication data from backup',
                Icons.upload,
                () => _showImportDialog(),
              ),
              _buildActionTile(
                'Clear All Data',
                'Remove all medications and schedules',
                Icons.delete_forever,
                () => _showClearDataDialog(),
                isDestructive: true,
              ),
            ],
          ),
          const SizedBox(height: 24),
          _buildSection(
            'About',
            [
              _buildInfoTile('App Version', '1.0.0', Icons.info),
              _buildActionTile(
                'Privacy Policy',
                'View our privacy policy',
                Icons.privacy_tip,
                () => _showPrivacyPolicy(),
              ),
              _buildActionTile(
                'Terms of Service',
                'View terms and conditions',
                Icons.article,
                () => _showTermsOfService(),
              ),
              _buildActionTile(
                'Contact Support',
                'Get help with the app',
                Icons.support,
                () => _showContactSupport(),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).primaryColor,
          ),
        ),
        const SizedBox(height: 16),
        Card(
          child: Column(
            children: children,
          ),
        ),
      ],
    );
  }

  Widget _buildSwitchTile(
    String title,
    String subtitle,
    bool value,
    ValueChanged<bool> onChanged,
    IconData icon,
  ) {
    return ListTile(
      leading: Icon(icon, color: Theme.of(context).primaryColor),
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
      ),
    );
  }

  Widget _buildDropdownTile(
    String title,
    String subtitle,
    String value,
    List<String> options,
    ValueChanged<String?> onChanged,
    IconData icon,
  ) {
    return ListTile(
      leading: Icon(icon, color: Theme.of(context).primaryColor),
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: DropdownButton<String>(
        value: value,
        items: options.map((option) {
          return DropdownMenuItem(
            value: option,
            child: Text(option),
          );
        }).toList(),
        onChanged: onChanged,
      ),
    );
  }

  Widget _buildActionTile(
    String title,
    String subtitle,
    IconData icon,
    VoidCallback onTap, {
    bool isDestructive = false,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: isDestructive ? Colors.red : Theme.of(context).primaryColor,
      ),
      title: Text(
        title,
        style: TextStyle(
          color: isDestructive ? Colors.red : null,
        ),
      ),
      subtitle: Text(subtitle),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }

  Widget _buildInfoTile(String title, String value, IconData icon) {
    return ListTile(
      leading: Icon(icon, color: Theme.of(context).primaryColor),
      title: Text(title),
      trailing: Text(
        value,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
          color: Colors.grey[600],
        ),
      ),
    );
  }

  void _showExportDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Export Data'),
        content: const Text('Export your medication data to a backup file?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Export feature coming soon')),
              );
            },
            child: const Text('Export'),
          ),
        ],
      ),
    );
  }

  void _showImportDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Import Data'),
        content: const Text('Import medication data from a backup file?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Import feature coming soon')),
              );
            },
            child: const Text('Import'),
          ),
        ],
      ),
    );
  }

  void _showClearDataDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear All Data?'),
        content: const Text(
          'This will permanently delete all your medications, schedules, and history. This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _clearAllData();
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Clear All', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showPrivacyPolicy() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Privacy Policy'),
        content: const SingleChildScrollView(
          child: Text(
            'Dosify Privacy Policy\n\n'
            'Your privacy is important to us. This medication management app stores all data locally on your device. We do not collect, transmit, or store any personal health information on external servers.\n\n'
            'Data stored includes:\n'
            '• Medication names and dosages\n'
            '• Medication schedules\n'
            '• Reminder preferences\n\n'
            'This data remains on your device and is not shared with third parties.',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showTermsOfService() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Terms of Service'),
        content: const SingleChildScrollView(
          child: Text(
            'Dosify Terms of Service\n\n'
            'By using this app, you agree to:\n\n'
            '1. Use the app responsibly for medication management\n'
            '2. Consult healthcare professionals for medical advice\n'
            '3. Verify medication information with your doctor\n'
            '4. Not rely solely on this app for critical medication management\n\n'
            'This app is a tool to assist with medication tracking and should not replace professional medical advice.',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showContactSupport() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Contact Support'),
        content: const Text(
          'Need help with the app?\n\n'
          'Email: support@dosify.app\n'
          'Website: www.dosify.app/support\n\n'
          'We typically respond within 24 hours.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Future<void> _clearAllData() async {
    try {
      final dbService = getIt<DatabaseService>();
      await dbService.clearAllData();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('All data cleared successfully.'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error clearing data: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}
