import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/data/models/medication.dart' as core_medication;
import '../../../core/utils/number_formatter.dart';
import '../providers/medication_providers.dart';
import '../../calculator/ui/reconstitution_calculator_screen.dart';

class MedicationScreen extends ConsumerWidget {
  const MedicationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
class MedicationContent extends ConsumerStatefulWidget {
  const MedicationContent({Key? key}) : super(key: key);

  @override
  ConsumerState<MedicationContent> createState() => _MedicationContentState();
}

class _MedicationContentState extends ConsumerState<MedicationContent> with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Medications', icon: Icon(Icons.medication, size: 18)),
            Tab(text: 'Supplies', icon: Icon(Icons.inventory, size: 18)),
            Tab(text: 'Calculator', icon: Icon(Icons.calculate, size: 18)),
          ],
        ),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              _buildMedicationsTab(),
              _buildSuppliesTab(),
              _buildCalculatorTab(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMedicationsListOld(BuildContext context) {
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
                  // Refresh functionality would go here
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
      body: const Center(
        child: Text('This method is no longer used'),
      ),
    );
  }

  Widget _buildMedicationsList(BuildContext context, List<core_medication.Medication> medications) {
    if (medications.isEmpty) {
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
            itemCount: medications.length,
      itemBuilder: (context, index) {
return GestureDetector(
          onTap: () {
            context.go('/medications/detail/${medications[index].id}');
          },
          child: _buildMedicationCard(context, medications[index]),
        );
      },
    );
  }

  Widget _buildMedicationCard(BuildContext context, core_medication.Medication medication) {
    final strength = NumberFormatter.formatNumber(medication.strength);
    
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: _getTypeColor(context, medication.type),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            _getTypeIcon(context, medication.type),
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
        trailing: _buildAlertBadge(context, medication),
        isThreeLine: true,
      ),
    );
  }

  Widget? _buildAlertBadge(BuildContext context, core_medication.Medication medication) {
    if (medication.isLowStock || medication.isExpiringSoon || medication.isExpired) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: _getAlertColor(context, medication),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          _getAlertText(context, medication),
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

  Color _getTypeColor(BuildContext context, core_medication.MedicationType type) {
    switch (type) {
      case core_medication.MedicationType.tablet:
        return Colors.blue;
      case core_medication.MedicationType.capsule:
        return Colors.green;
      case core_medication.MedicationType.liquid:
        return Colors.cyan;
      case core_medication.MedicationType.injection:
        return Colors.red;
      case core_medication.MedicationType.peptide:
        return Colors.purple;
      case core_medication.MedicationType.cream:
        return Colors.orange;
      case core_medication.MedicationType.patch:
        return Colors.teal;
      case core_medication.MedicationType.inhaler:
        return Colors.indigo;
      case core_medication.MedicationType.drops:
        return Colors.lightBlue;
      case core_medication.MedicationType.spray:
        return Colors.amber;
    }
  }

  IconData _getTypeIcon(BuildContext context, core_medication.MedicationType type) {
    switch (type) {
      case core_medication.MedicationType.tablet:
      case core_medication.MedicationType.capsule:
        return Icons.medication;
      case core_medication.MedicationType.liquid:
        return Icons.water_drop;
      case core_medication.MedicationType.injection:
      case core_medication.MedicationType.peptide:
        return Icons.medication_liquid;
      case core_medication.MedicationType.cream:
        return Icons.healing;
      case core_medication.MedicationType.patch:
        return Icons.local_pharmacy;
      case core_medication.MedicationType.inhaler:
        return Icons.air;
      case core_medication.MedicationType.drops:
        return Icons.opacity;
      case core_medication.MedicationType.spray:
        return Icons.water;
    }
  }

  Color _getAlertColor(BuildContext context, core_medication.Medication medication) {
    if (medication.isExpired) {
      return Colors.red;
    } else if (medication.isExpiringSoon) {
      return Colors.orange;
    } else if (medication.isLowStock) {
      return Colors.amber;
    }
    return Colors.grey;
  }

  String _getAlertText(BuildContext context, core_medication.Medication medication) {
    if (medication.isExpired) {
      return 'EXPIRED';
    } else if (medication.isExpiringSoon) {
      return 'EXPIRES SOON';
    } else if (medication.isLowStock) {
      return 'LOW STOCK';
    }
    return '';
  }

  Widget _buildQuickActionDashboard(BuildContext context, List<core_medication.Medication> medications) {
  final lowStockMeds = medications.where((med) => med.isLowStock).length;
    final expiringMeds = medications.where((med) => med.isExpiringSoon || med.isExpired).length;
    final activeMeds = medications.length;
    final injectableMeds = medications.where((med) => 
      med.type == core_medication.MedicationType.injection || 
      med.type == core_medication.MedicationType.peptide).length;

    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Stats Row - Enhanced Cards
          Row(
            children: [
              Expanded(
                child: _buildEnhancedStatCard(
                  context,
                  'Your Medications',
                  activeMeds.toString(),
                  'Active prescriptions',
                  Icons.medication_outlined,
                  Colors.blue,
                  () => {}, // Make tappable later
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildEnhancedStatCard(
                  context,
                  'Injectable Meds',
                  injectableMeds.toString(),
                  'Require injection',
                  Icons.vaccines_outlined,
                  Colors.purple,
                  () => _showFilteredMedications(
                    context,
                    'Injectable Medications',
                    medications.where((med) => 
                      med.type == core_medication.MedicationType.injection || 
                      med.type == core_medication.MedicationType.peptide).toList(),
                  ),
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
                  context,
                  'Low Stock',
                  lowStockMeds.toString(),
                  Icons.inventory_2_outlined,
                  Colors.orange,
                  () => _showFilteredMedications(
                    context,
                    'Low Stock Medications',
                    medications.where((med) => med.isLowStock).toList(),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildActionButton(
                  context,
                  'Expiring',
                  expiringMeds.toString(),
                  Icons.schedule_outlined,
                  Colors.red,
                  () => _showFilteredMedications(
                    context,
                    'Expiring Medications',
                    medications.where((med) => med.isExpiringSoon || med.isExpired).toList(),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildCalculatorButton(
                  context,
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

  Widget _buildEnhancedStatCard(BuildContext context, String title, String value, String subtitle, IconData icon, Color color, VoidCallback onTap) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                color.withOpacity(0.15),
                color.withOpacity(0.05),
              ],
            ),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: color.withOpacity(0.2)),
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(icon, color: color, size: 20),
                  ),
                  const Spacer(),
                  Icon(Icons.arrow_forward_ios, color: color.withOpacity(0.6), size: 16),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                value,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                title,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[800],
                ),
              ),
              Text(
                subtitle,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCalculatorButton(BuildContext context, VoidCallback onTap) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.green.withOpacity(0.2),
                Colors.green.withOpacity(0.1),
              ],
            ),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.green.withOpacity(0.3)),
          ),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.green.withOpacity(0.3),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: const Icon(Icons.calculate, color: Colors.white, size: 20),
              ),
              const SizedBox(height: 6),
              Text(
                'Calculator',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: Colors.green[700],
                ),
                textAlign: TextAlign.center,
              ),
              Text(
                'Reconstitution',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontSize: 10,
                  color: Colors.green[600],
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard(BuildContext context, String title, String value, IconData icon, Color color) {
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

  Widget _buildActionButton(BuildContext context, String title, String badge, IconData icon, Color color, VoidCallback onTap) {
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

  void _showFilteredMedications(BuildContext context, String title, List<core_medication.Medication> medications) {
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
                  return _buildMedicationCard(context, medications[index]);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMedicationsTab() {
    final medicationsAsyncValue = ref.watch(medicationListProvider);

    return medicationsAsyncValue.when(
      data: (medications) => Column(children: [
        // Quick Action Dashboard without Injectable Meds
        _buildUpdatedQuickActionDashboard(context, medications),
        // Medications List
        Expanded(child: _buildMedicationsList(context, medications)),
      ]),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 48, color: Colors.red),
            const SizedBox(height: 16),
            Text('Error loading medications', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            Text(e.toString(), style: Theme.of(context).textTheme.bodySmall, textAlign: TextAlign.center),
            const SizedBox(height: 16),
            ElevatedButton(onPressed: () => ref.read(medicationListProvider.notifier).refresh(), child: const Text('Try Again')),
          ],
        ),
      ),
    );
  }

  Widget _buildSuppliesTab() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.inventory,
            size: 64,
            color: Colors.grey,
          ),
          const SizedBox(height: 16),
          Text(
            'Supplies Management',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          Text(
            'Track medical supplies and inventory',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: () => context.go('/inventory'),
            icon: const Icon(Icons.add),
            label: const Text('View Inventory'),
          ),
        ],
      ),
    );
  }

  Widget _buildCalculatorTab() {
    // Import the calculator screen content directly
    return const ReconstitutionCalculatorContent();
  }

  Widget _buildUpdatedQuickActionDashboard(BuildContext context, List<core_medication.Medication> medications) {
    final lowStockMeds = medications.where((med) => med.isLowStock).length;
    final expiringMeds = medications.where((med) => med.isExpiringSoon || med.isExpired).length;
    final activeMeds = medications.length;

    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Stats Row - Updated without Injectable Meds
          Row(
            children: [
              Expanded(
                child: _buildEnhancedStatCard(
                  context,
                  'Your Medications',
                  activeMeds.toString(),
                  'Active prescriptions',
                  Icons.medication_outlined,
                  Colors.blue,
                  () => {}, // Make tappable later
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildEnhancedStatCard(
                  context,
                  'Stock Alerts',
                  (lowStockMeds + expiringMeds).toString(),
                  'Need attention',
                  Icons.warning_amber_outlined,
                  Colors.orange,
                  () => _showFilteredMedications(
                    context,
                    'Medications Needing Attention',
                    medications.where((med) => med.isLowStock || med.isExpiringSoon || med.isExpired).toList(),
                  ),
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
                  context,
                  'Low Stock',
                  lowStockMeds.toString(),
                  Icons.inventory_2_outlined,
                  Colors.orange,
                  () => _showFilteredMedications(
                    context,
                    'Low Stock Medications',
                    medications.where((med) => med.isLowStock).toList(),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildActionButton(
                  context,
                  'Expiring',
                  expiringMeds.toString(),
                  Icons.schedule_outlined,
                  Colors.red,
                  () => _showFilteredMedications(
                    context,
                    'Expiring Medications',
                    medications.where((med) => med.isExpiringSoon || med.isExpired).toList(),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildActionButton(
                  context,
                  'Add Med',
                  '',
                  Icons.add_circle_outlined,
                  Colors.green,
                  () => context.go('/medications/add'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
