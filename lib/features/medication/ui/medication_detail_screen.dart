import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../core/data/models/medication.dart' as CoreMedication;
import '../../../core/data/repositories/medication_repository.dart';
import '../../../core/di/service_locator.dart';
import '../../../core/utils/number_formatter.dart';

class MedicationDetailScreen extends StatefulWidget {
  final String medicationId;

  const MedicationDetailScreen({
    Key? key,
    required this.medicationId,
  }) : super(key: key);

  @override
  State<MedicationDetailScreen> createState() => _MedicationDetailScreenState();
}

class _MedicationDetailScreenState extends State<MedicationDetailScreen> {
  CoreMedication.Medication? medication;
  bool isLoading = true;
  String? error;

  @override
  void initState() {
    super.initState();
    _loadMedication();
  }

  Future<void> _loadMedication() async {
    try {
      final repository = getIt<MedicationRepository>();
      final medications = await repository.getAllMedications();
      final foundMedication = medications.firstWhere(
        (med) => med.id == widget.medicationId,
        orElse: () => throw Exception('Medication not found'),
      );
      
      setState(() {
        medication = foundMedication;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        error = e.toString();
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Loading...'),
          centerTitle: true,
        ),
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (error != null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Error'),
          centerTitle: true,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error, size: 64, color: Colors.red),
              const SizedBox(height: 16),
              Text('Error: $error'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _loadMedication,
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    if (medication == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Not Found'),
          centerTitle: true,
        ),
        body: const Center(
          child: Text('Medication not found'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(medication!.name),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              // TODO: Navigate to edit medication screen
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Edit functionality coming soon')),
              );
            },
          ),
          PopupMenuButton<String>(
            onSelected: (value) {
              switch (value) {
                case 'duplicate':
                  // TODO: Implement duplicate medication
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Duplicate functionality coming soon')),
                  );
                  break;
                case 'delete':
                  _showDeleteConfirmation(context);
                  break;
                case 'calculator':
                  if (medication!.type == CoreMedication.MedicationType.injection) {
                    context.go('/calculator');
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Calculator is only available for injectable medications')),
                    );
                  }
                  break;
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'duplicate',
                child: Row(
                  children: [
                    Icon(Icons.copy),
                    SizedBox(width: 8),
                    Text('Duplicate'),
                  ],
                ),
              ),
              if (medication!.type == CoreMedication.MedicationType.injection)
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
                value: 'delete',
                child: Row(
                  children: [
                    Icon(Icons.delete, color: Colors.red),
                    SizedBox(width: 8),
                    Text('Delete', style: TextStyle(color: Colors.red)),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeaderCard(context),
            const SizedBox(height: 16),
            _buildDetailsCard(context),
            const SizedBox(height: 16),
            _buildInventoryCard(context),
            const SizedBox(height: 16),
            _buildNotesCard(context),
            if (medication!.type == CoreMedication.MedicationType.injection) ...[
              const SizedBox(height: 16),
              _buildInjectableActionsCard(context),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderCard(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: _getTypeColor(medication!.type),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    _getTypeIcon(medication!.type),
                    color: Colors.white,
                    size: 32,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        medication!.name,
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        medication!.type.displayName,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: _getTypeColor(medication!.type),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey[200]!),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Strength',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.grey[600],
                    ),
                  ),
                  Text(
                    '${NumberFormatter.formatNumber(medication!.strength)} ${medication!.unit}',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailsCard(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Details',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildDetailRow(context, 'Type', medication!.type.displayName),
            _buildDetailRow(context, 'Unit', medication!.unit),
            if (medication!.expirationDate != null)
              _buildDetailRow(
                context,
                'Expiration',
                DateFormat('MMM dd, yyyy').format(medication!.expirationDate!),
                valueColor: medication!.isExpired
                    ? Colors.red
                    : medication!.isExpiringSoon
                        ? Colors.orange
                        : null,
              ),
            _buildDetailRow(
              context,
              'Created',
              DateFormat('MMM dd, yyyy').format(medication!.createdAt),
            ),
            if (medication!.updatedAt != medication!.createdAt)
              _buildDetailRow(
                context,
                'Updated',
                DateFormat('MMM dd, yyyy').format(medication!.updatedAt),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildInventoryCard(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Inventory',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: medication!.isLowStock ? Colors.orange[50] : Colors.green[50],
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: medication!.isLowStock ? Colors.orange[200]! : Colors.green[200]!,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Current Stock',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${medication!.currentStock} ${medication!.type.stockUnit}',
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: medication!.isLowStock ? Colors.orange[700] : Colors.green[700],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.blue[50],
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.blue[200]!),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Low Stock Threshold',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${medication!.lowStockThreshold} ${medication!.type.stockUnit}',
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.blue[700],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            if (medication!.isLowStock || medication!.isExpiringSoon || medication!.isExpired) ...[
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: _getAlertColor(medication!).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: _getAlertColor(medication!).withOpacity(0.3)),
                ),
                child: Row(
                  children: [
                    Icon(
                      _getAlertIcon(medication!),
                      color: _getAlertColor(medication!),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        _getAlertMessage(medication!),
                        style: TextStyle(
                          color: _getAlertColor(medication!),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildNotesCard(BuildContext context) {
    if (medication!.notes == null || medication!.notes!.isEmpty) return const SizedBox.shrink();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Notes',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey[200]!),
              ),
              child: Text(
                medication!.notes!,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  height: 1.5,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInjectableActionsCard(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Injectable Actions',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => context.go('/calculator'),
                    icon: const Icon(Icons.calculate),
                    label: const Text('Reconstitution Calculator'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
              ],
            ),
            if (medication!.requiresReconstitution) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.blue[200]!),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.info, color: Colors.blue),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'This medication requires reconstitution before use.',
                        style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(BuildContext context, String label, String value, {Color? valueColor}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.grey[600],
            ),
          ),
          Text(
            value,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w500,
              color: valueColor,
            ),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Medication'),
        content: Text('Are you sure you want to delete ${medication!.name}? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              // TODO: Implement delete functionality
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Delete functionality coming soon')),
              );
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
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

  IconData _getAlertIcon(CoreMedication.Medication medication) {
    if (medication.isExpired) {
      return Icons.warning;
    } else if (medication.isExpiringSoon) {
      return Icons.schedule;
    } else if (medication.isLowStock) {
      return Icons.inventory_2;
    }
    return Icons.info;
  }

  String _getAlertMessage(CoreMedication.Medication medication) {
    if (medication.isExpired) {
      return 'This medication has expired and should not be used.';
    } else if (medication.isExpiringSoon) {
      final days = medication.expirationDate!.difference(DateTime.now()).inDays;
      return 'This medication expires in $days days.';
    } else if (medication.isLowStock) {
      return 'Stock is running low. Consider reordering soon.';
    }
    return '';
  }
}
