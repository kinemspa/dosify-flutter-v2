import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/data/models/supply.dart';

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
              itemCount: 0, // Update with actual list length
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text('Supply Name'), // Update with actual supply name
                  subtitle: Text('Type: Item'), // Update with actual supply type
                  trailing: Text('100 pcs'), // Update with actual supply stock
                  onTap: () {
                    // Navigate to edit supply
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () {
                // Navigate to add new supply
              },
              child: const Text('Add New Supply'),
            ),
          ),
        ],
      ),
    );
  }
}

