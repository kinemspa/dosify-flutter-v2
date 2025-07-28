import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../core/data/repositories/medication_repository.dart';
import '../../../core/di/service_locator.dart';
import '../../../core/data/models/medication.dart';
import '../../../core/utils/number_formatter.dart';

class MedicationListScreen extends StatefulWidget {
  const MedicationListScreen({Key? key}) : super(key: key);

  @override
  State<MedicationListScreen> createState() => _MedicationListScreenState();
}

class _MedicationListScreenState extends State<MedicationListScreen> {
  List<Medication> _medications = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadMedications();
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
        title: const Text('Saved Medications'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadMedications,
          ),
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
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
              size: 64,
              color: Colors.red,
            ),
            const SizedBox(height: 16),
            Text(
              'Error loading medications',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              _error!,
              style: Theme.of(context).textTheme.bodyMedium,
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
          ],
        ),
      );
    }
    
    return RefreshIndicator(
      onRefresh: _loadMedications,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _medications.length,
        itemBuilder: (context, index) {
          final medication = _medications[index];
          return _buildMedicationCard(medication);
        },
      ),
    );
  }

  Widget _buildMedicationCard(Medication medication) {
    final strength = NumberFormatter.formatNumber(medication.strength);
    
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: _getTypeColor(medication.type),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    _getTypeIcon(medication.type),
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        medication.name,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        medication.type.displayName,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                if (medication.isLowStock || medication.isExpiringSoon || medication.isExpired)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: _getAlertColor(medication),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      _getAlertText(medication),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                _buildInfoChip(
                  icon: Icons.science,
                  label: 'Strength',
                  value: '$strength ${medication.unit}',
                ),
                const SizedBox(width: 12),
                _buildInfoChip(
                  icon: Icons.inventory,
                  label: 'Stock',
                  value: '${medication.currentStock} ${medication.type.stockUnit}',
                ),
              ],
            ),
            if (medication.expirationDate != null) ...[
              const SizedBox(height: 8),
              _buildInfoChip(
                icon: Icons.calendar_today,
                label: 'Expires',
                value: DateFormat('MMM dd, yyyy').format(medication.expirationDate!),
              ),
            ],
            if (medication.notes != null && medication.notes!.isNotEmpty) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.note,
                      size: 16,
                      color: Colors.grey[600],
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        medication.notes!,
                        style: Theme.of(context).textTheme.bodySmall,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
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

  Widget _buildInfoChip({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.grey[50],
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey[300]!),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 16,
              color: Colors.grey[600],
            ),
            const SizedBox(width: 6),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: Colors.grey[600],
                    ),
                  ),
                  Text(
                    value,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.w500,
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

  Color _getTypeColor(MedicationType type) {
    switch (type) {
      case MedicationType.tablet:
        return Colors.blue;
      case MedicationType.capsule:
        return Colors.green;
      case MedicationType.liquid:
        return Colors.cyan;
      case MedicationType.injection:
        return Colors.red;
      case MedicationType.peptide:
        return Colors.purple;
      case MedicationType.cream:
        return Colors.orange;
      case MedicationType.patch:
        return Colors.teal;
      case MedicationType.inhaler:
        return Colors.indigo;
      case MedicationType.drops:
        return Colors.lightBlue;
      case MedicationType.spray:
        return Colors.amber;
    }
  }

  IconData _getTypeIcon(MedicationType type) {
    switch (type) {
      case MedicationType.tablet:
      case MedicationType.capsule:
        return Icons.medication;
      case MedicationType.liquid:
        return Icons.water_drop;
      case MedicationType.injection:
      case MedicationType.peptide:
        return Icons.medication_liquid;
      case MedicationType.cream:
        return Icons.healing;
      case MedicationType.patch:
        return Icons.local_pharmacy;
      case MedicationType.inhaler:
        return Icons.air;
      case MedicationType.drops:
        return Icons.opacity;
      case MedicationType.spray:
        return Icons.water;
    }
  }

  Color _getAlertColor(Medication medication) {
    if (medication.isExpired) {
      return Colors.red;
    } else if (medication.isExpiringSoon) {
      return Colors.orange;
    } else if (medication.isLowStock) {
      return Colors.amber;
    }
    return Colors.grey;
  }

  String _getAlertText(Medication medication) {
    if (medication.isExpired) {
      return 'EXPIRED';
    } else if (medication.isExpiringSoon) {
      return 'EXPIRES SOON';
    } else if (medication.isLowStock) {
      return 'LOW STOCK';
    }
    return '';
  }
}
