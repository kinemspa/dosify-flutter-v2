import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/data/models/supply.dart';
import '../providers/supplies_providers.dart';

class AddEditSupplyForm extends ConsumerWidget {
  final Supply? supply;

  const AddEditSupplyForm({Key? key, this.supply}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formState = ref.watch(supplyFormProvider);
    final formNotifier = ref.read(supplyFormProvider.notifier);

    if (supply != null) {
      formNotifier.loadFromSupply(supply!);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(supply == null ? 'Add Supply' : 'Edit Supply'),
        actions: [
          if (supply != null)
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () async {
                final delete = await showDialog<bool>(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Delete Supply'),
                    content: const Text('Are you sure you want to delete this supply?'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(false),
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(true),
                        child: const Text('Delete'),
                      ),
                    ],
                  ),
                );
                if (delete ?? false) {
                  ref.read(supplyManagementProvider.notifier).deleteSupply(supply!.id);
                  Navigator.of(context).pop();
                }
              },
            ),
        ],
      ),
      body: Form(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                initialValue: formState.name,
                decoration: const InputDecoration(labelText: 'Supply Name'),
                onChanged: formNotifier.updateName,
              ),
              const SizedBox(height: 16.0),
              DropdownButtonFormField<SupplyType>(
                value: formState.type,
                decoration: const InputDecoration(labelText: 'Supply Type'),
                onChanged: (type) => formNotifier.updateType(type!),
                items: SupplyType.values.map((type) {
                  return DropdownMenuItem(
                    value: type,
                    child: Text(type.toString().split('.').last),
                  );
                }).toList(),
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                initialValue: formState.currentStock.toString(),
                decoration: const InputDecoration(labelText: 'Current Stock'),
                keyboardType: TextInputType.number,
                onChanged: (value) => formNotifier.updateCurrentStock(double.parse(value)),
              ),
              const SizedBox(height: 16.0),
              DropdownButtonFormField<SupplyUnit>(
                value: formState.unit,
                decoration: const InputDecoration(labelText: 'Unit'),
                onChanged: (unit) => formNotifier.updateUnit(unit!),
                items: SupplyUnit.values.map((unit) {
                  return DropdownMenuItem(
                    value: unit,
                    child: Text(unit.toString().split('.').last),
                  );
                }).toList(),
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                initialValue: formState.lowStockThreshold.toString(),
                decoration: const InputDecoration(labelText: 'Low Stock Threshold'),
                keyboardType: TextInputType.number,
                onChanged: (value) => formNotifier.updateLowStockThreshold(double.parse(value)),
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                initialValue: formState.lotNumber ?? '',
                decoration: const InputDecoration(labelText: 'Lot Number (Optional)'),
                onChanged: formNotifier.updateLotNumber,
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                initialValue: formState.costPerUnit?.toString() ?? '',
                decoration: const InputDecoration(
                  labelText: 'Cost Per Unit (Optional)',
                  prefixText: '\$',
                ),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                onChanged: (value) {
                  if (value.isNotEmpty) {
                    formNotifier.updateCostPerUnit(double.tryParse(value));
                  } else {
                    formNotifier.updateCostPerUnit(null);
                  }
                },
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                initialValue: formState.supplier ?? '',
                decoration: const InputDecoration(labelText: 'Supplier (Optional)'),
                onChanged: formNotifier.updateSupplier,
              ),
              const SizedBox(height: 16.0),
              // Expiration Date Picker
              ListTile(
                title: const Text('Expiration Date (Optional)'),
                subtitle: Text(
                  formState.expirationDate != null
                      ? '${formState.expirationDate!.day}/${formState.expirationDate!.month}/${formState.expirationDate!.year}'
                      : 'No expiration date set',
                ),
                trailing: const Icon(Icons.calendar_today),
                onTap: () async {
                  final date = await showDatePicker(
                    context: context,
                    initialDate: formState.expirationDate ?? DateTime.now().add(const Duration(days: 365)),
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(const Duration(days: 365 * 10)),
                  );
                  if (date != null) {
                    formNotifier.updateExpirationDate(date);
                  }
                },
              ),
              if (formState.expirationDate != null)
                Padding(
                  padding: const EdgeInsets.only(left: 16.0),
                  child: TextButton(
                    onPressed: () => formNotifier.updateExpirationDate(null),
                    child: const Text('Clear expiration date'),
                  ),
                ),
              const SizedBox(height: 16.0),
              TextFormField(
                initialValue: formState.notes ?? '',
                decoration: const InputDecoration(
                  labelText: 'Notes (Optional)',
                  alignLabelWithHint: true,
                ),
                maxLines: 3,
                onChanged: formNotifier.updateNotes,
              ),
              const SizedBox(height: 24.0),
              ElevatedButton(
                onPressed: formState.isValid ? () {
                  if (supply == null) {
                    ref.read(supplyManagementProvider.notifier).addSupply(
                      name: formState.name,
                      type: formState.type,
                      currentStock: formState.currentStock,
                      unit: formState.unit,
                      lowStockThreshold: formState.lowStockThreshold,
                      expirationDate: formState.expirationDate,
                      notes: formState.notes,
                      lotNumber: formState.lotNumber,
                      costPerUnit: formState.costPerUnit,
                      supplier: formState.supplier,
                    );
                  } else {
                    ref.read(supplyManagementProvider.notifier).updateSupply(
                      supply!.copyWith(
                        name: formState.name,
                        type: formState.type,
                        currentStock: formState.currentStock,
                        unit: formState.unit,
                        lowStockThreshold: formState.lowStockThreshold,
                        expirationDate: formState.expirationDate,
                        notes: formState.notes,
                        lotNumber: formState.lotNumber,
                        costPerUnit: formState.costPerUnit,
                        supplier: formState.supplier,
                      ),
                    );
                  }
                  Navigator.of(context).pop();
                } : null,
                child: Text(supply == null ? 'Add Supply' : 'Update Supply'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

