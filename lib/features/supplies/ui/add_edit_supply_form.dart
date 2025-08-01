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
      ),
      body: Form(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
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
                initialValue: formState.notes ?? '',
                decoration: const InputDecoration(labelText: 'Notes (Optional)'),
                onChanged: formNotifier.updateNotes,
              ),
              const SizedBox(height: 16.0),
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

