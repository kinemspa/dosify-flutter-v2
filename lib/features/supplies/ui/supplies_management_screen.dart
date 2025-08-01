import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/data/models/supply.dart';
import '../providers/supplies_providers.dart';
import 'add_edit_supply_form.dart';

class SuppliesManagementScreen extends ConsumerWidget {
  const SuppliesManagementScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Supplies Management'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: ref.watch(suppliesProvider).when(
                data: (supplies) => supplies.length,
                loading: () => 0,
                error: (err, stack) => 0,
              ),
              itemBuilder: (context, index) {
                final supply = ref.read(suppliesProvider).maybeWhen(
                  data: (supplies) => supplies[index],
                  orElse: () => null,
                );
                if (supply == null) return Container();
                return ListTile(
                  title: Text(supply.name),
                  subtitle: Text('Type: ${supply.type.toString().split('.').last}'),
                  trailing: Text('${supply.currentStock.toString()} ${supply.unit.toString().split('.').last}'),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => AddEditSupplyForm(supply: supply),
                      ),
                    );
                  },
                  onLongPress: () async {
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
                      ref.read(supplyManagementProvider.notifier).deleteSupply(supply.id);
                    }
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const AddEditSupplyForm(),
                  ),
                );
              },
              child: const Text('Add New Supply'),
            ),
          ),
        ],
      ),
    );
  }
}

