import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../core/data/repositories/medication_repository.dart';
import '../../../core/data/models/medication.dart' as CoreMedication;
import '../../../core/di/service_locator.dart';
import '../../../core/utils/number_formatter.dart';

class MedicationScreen extends StatelessWidget {
  const MedicationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Medications'),
        centerTitle: true,
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.medication,
              size: 64,
              color: Colors.grey,
            ),
            SizedBox(height: 16),
            Text(
              'Medication Management',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'This screen will display your medications',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.go('/medications/add'),
        child: const Icon(Icons.add),
      ),
    );
  }
}

// Content-only version for use with BottomNavWrapper
class MedicationContent extends StatefulWidget {
  const MedicationContent({Key? key}) : super(key: key);

  @override
  State<MedicationContent> createState() => _MedicationContentState();
}

class _MedicationContentState extends State<MedicationContent> with WidgetsBindingObserver {
  List<CoreMedication.Medication> _medications = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _loadMedications();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // Refresh the list when the app becomes active again
      _loadMedications();
    }
  }

  Future<void> _loadMedications() async {
    try {
      setState(() {
        _isLoading = true;
        _error = null;
      });
      
      final repository = getIt<MedicationRepository>();
      final medications = await repository.getAllMedications();
      
      setState(() {
        _medications = medications;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Medications'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => context.go('/medications/add'),
          ),
          PopupMenuButton<String>(
            onSelected: (value) {
              switch (value) {
                case 'refresh':
                  _loadMedications();
                  break;
                case 'calculator':
                  // Navigate to calculator
                  break;
                case 'settings':
                  // Navigate to settings
                  break;
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'refresh',
                child: Row(
                  children: [
                    Icon(Icons.refresh),
                    SizedBox(width: 8),
                    Text('Refresh'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'calculator',
                child: Row(
                  children: [
                    Icon(Icons.calculate),
                    SizedBox(width: 8),
                    Text('Calculator'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'settings',
                child: Row(
                  children: [
                    Icon(Icons.settings),
                    SizedBox(width: 8),
                    Text('Settings'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          // Quick Action Dashboard
          _buildQuickActionDashboard(),
          // Medications List
          Expanded(
            child: _buildMedicationsList(),
          ),
        ],
      ),
    );
  }

  Widget _buildMedicationsList() {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    
    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 48,
              color: Colors.red,
            ),
            const SizedBox(height: 16),
            Text(
              'Error loading medications',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              _error!,
              style: Theme.of(context).textTheme.bodySmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadMedications,
              child: const Text('Try Again'),
            ),
          ],
        ),
      );
    }
    
    if (_medications.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.medication_liquid_outlined,
              size: 64,
              color: Colors.grey,
            ),
            const SizedBox(height: 16),
            Text(
              'No medications found',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              'Add your first medication to get started',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () => context.go('/medications/add'),
              icon: const Icon(Icons.add),
              label: const Text('Add Medication'),
            ),
          ],
        ),
      );
    }
    
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _medications.length,
      itemBuilder: (context, index) {
return GestureDetector(
          onTap: () {
            context.go('/medications/detail/${_medications[index].id}');
          },
          child: _buildMedicationCard(_medications[index]),
        );
      },
    );
  }

  Widget _buildMedicationCard(CoreMedication.Medication medication) {
    final strength = NumberFormatter.formatNumber(medication.strength);
    
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: _getTypeColor(medication.type),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            _getTypeIcon(medication.type),
            color: Colors.white,
            size: 24,
          ),
        ),
        title: Text(
          medication.name,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${medication.type.displayName} • $strength ${medication.unit}'),
            Text('Stock: ${medication.currentStock} ${medication.type.stockUnit}'),
            if (medication.expirationDate != null)
              Text('Expires: ${DateFormat('MMM dd, yyyy').format(medication.expirationDate!)}'),
          ],
        ),
        trailing: _buildAlertBadge(medication),
        isThreeLine: true,
      ),
    );
  }

  Widget? _buildAlertBadge(CoreMedication.Medication medication) {
    if (medication.isLowStock || medication.isExpiringSoon || medication.isExpired) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: _getAlertColor(medication),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          _getAlertText(medication),
          style: const TextStyle(
            color: Colors.white,
            fontSize: 10,
            fontWeight: FontWeight.bold,
          ),
        ),
      );
    }
    return null;
  }

  Color _getTypeColor(CoreMedication.MedicationType type) {
    switch (type) {
      case CoreMedication.MedicationType.tablet:
        return Colors.blue;
      case CoreMedication.MedicationType.capsule:
        return Colors.green;
      case CoreMedication.MedicationType.liquid:
        return Colors.cyan;
      case CoreMedication.MedicationType.injection:
        return Colors.red;
      case CoreMedication.MedicationType.peptide:
        return Colors.purple;
      case CoreMedication.MedicationType.cream:
        return Colors.orange;
      case CoreMedication.MedicationType.patch:
        return Colors.teal;
      case CoreMedication.MedicationType.inhaler:
        return Colors.indigo;
      case CoreMedication.MedicationType.drops:
        return Colors.lightBlue;
      case CoreMedication.MedicationType.spray:
        return Colors.amber;
    }
  }

  IconData _getTypeIcon(CoreMedication.MedicationType type) {
    switch (type) {
      case CoreMedication.MedicationType.tablet:
      case CoreMedication.MedicationType.capsule:
        return Icons.medication;
      case CoreMedication.MedicationType.liquid:
        return Icons.water_drop;
      case CoreMedication.MedicationType.injection:
      case CoreMedication.MedicationType.peptide:
        return Icons.medication_liquid;
      case CoreMedication.MedicationType.cream:
        return Icons.healing;
      case CoreMedication.MedicationType.patch:
        return Icons.local_pharmacy;
      case CoreMedication.MedicationType.inhaler:
        return Icons.air;
      case CoreMedication.MedicationType.drops:
        return Icons.opacity;
      case CoreMedication.MedicationType.spray:
        return Icons.water;
    }
  }

  Color _getAlertColor(CoreMedication.Medication medication) {
    if (medication.isExpired) {
      return Colors.red;
    } else if (medication.isExpiringSoon) {
      return Colors.orange;
    } else if (medication.isLowStock) {
      return Colors.amber;
    }
    return Colors.grey;
  }

  String _getAlertText(CoreMedication.Medication medication) {
    if (medication.isExpired) {
      return 'EXPIRED';
    } else if (medication.isExpiringSoon) {
      return 'EXPIRES SOON';
    } else if (medication.isLowStock) {
      return 'LOW STOCK';
    }
    return '';
  }

  Widget _buildQuickActionDashboard() {
    final lowStockMeds = _medications.where((med) => med.isLowStock).length;
    final expiringMeds = _medications.where((med) => med.isExpiringSoon || med.isExpired).length;
    final activeMeds = _medications.length;
    final injectableMeds = _medications.where((med) => 
      med.type == CoreMedication.MedicationType.injection || 
      med.type == CoreMedication.MedicationType.peptide).length;

    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Stats Row
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  'Total Medications',
                  activeMeds.toString(),
                  Icons.medication,
                  Colors.blue,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatCard(
                  'Injectable Types',
                  injectableMeds.toString(),
                  Icons.medication_liquid,
                  Colors.purple,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Action Buttons Row
          Row(
            children: [
              Expanded(
                child: _buildActionButton(
                  'Low Stock',
                  lowStockMeds.toString(),
                  Icons.inventory_2_outlined,
                  Colors.orange,
                  () => _showFilteredMedications(
                    'Low Stock Medications',
                    _medications.where((med) => med.isLowStock).toList(),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildActionButton(
                  'Expiring',
                  expiringMeds.toString(),
                  Icons.schedule_outlined,
                  Colors.red,
                  () => _showFilteredMedications(
                    'Expiring Medications',
                    _medications.where((med) => med.isExpiringSoon || med.isExpired).toList(),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildActionButton(
                  'Calculator',
                  '',
                  Icons.calculate_outlined,
                  Colors.green,
                  () {
                    // Navigate to calculator
                    context.go('/calculator');
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
                Text(
                  title,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(String title, String badge, IconData icon, Color color, VoidCallback onTap) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: color.withOpacity(0.3)),
          ),
          child: Column(
            children: [
              Stack(
                children: [
                  Icon(icon, color: color, size: 28),
                  if (badge.isNotEmpty)
                    Positioned(
                      right: -6,
                      top: -6,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: color,
                          shape: BoxShape.circle,
                        ),
                        child: Text(
                          badge,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                title,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.w500,
                  color: color,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showFilteredMedications(String title, List<CoreMedication.Medication> medications) {
    if (medications.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('No medications found for $title'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        maxChildSize: 0.9,
        minChildSize: 0.5,
        expand: false,
        builder: (context, scrollController) => Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${medications.length} medication${medications.length == 1 ? '' : 's'} found',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                controller: scrollController,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: medications.length,
                itemBuilder: (context, index) {
                  return _buildMedicationCard(medications[index]);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
