import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../core/data/models/inventory_entry.dart';
import '../providers/inventory_providers.dart';

class InventoryScreen extends ConsumerWidget {
  const InventoryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inventory Management'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              // TODO: Navigate to add inventory entry screen
            },
          ),
        ],
      ),
      body: const InventoryContent(),
    );
  }
}

class InventoryContent extends ConsumerWidget {
  const InventoryContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final inventoryDashboardData = ref.watch(inventoryDashboardDataProvider);
    
    return inventoryDashboardData.when(
      data: (data) => RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(inventoryDashboardDataProvider);
        },
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _buildDashboardSummaryCard(context, data),
            const SizedBox(height: 16),
            ..._buildInventoryDetailCards(context, data),
          ],
        ),
      ),
      loading: () => const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Loading inventory data...'),
          ],
        ),
      ),
      error: (error, stackTrace) => Center(
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
              'Error loading inventory',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              error.toString(),
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                ref.invalidate(inventoryDashboardDataProvider);
              },
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDashboardSummaryCard(BuildContext context, InventoryDashboardData data) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Inventory Overview',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    context,
                    'Total Entries',
                    data.totalEntries.toString(),
                    Icons.inventory_2,
                    Colors.blue,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildStatCard(
                    context,
                    'Available',
                    data.availableEntries.toString(),
                    Icons.check_circle,
                    Colors.green,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    context,
                    'Low Stock',
                    data.lowStockCount.toString(),
                    Icons.warning,
                    Colors.orange,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildStatCard(
                    context,
                    'Expired',
                    data.expiredCount.toString(),
                    Icons.error,
                    Colors.red,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  const Icon(Icons.attach_money, color: Colors.green),
                  const SizedBox(width: 8),
                  Text(
                    'Total Value: \$${data.totalValue.toStringAsFixed(2)}',
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

  Widget _buildStatCard(BuildContext context, String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(
            value,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            title,
            style: Theme.of(context).textTheme.bodySmall,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  List<Widget> _buildInventoryDetailCards(BuildContext context, InventoryDashboardData data) {
    return [
      if (data.lowStockEntries.isNotEmpty) ...[
        _buildInventorySection(
          context,
          'Low Stock Alerts',
          data.lowStockEntries,
          Colors.orange,
          Icons.warning,
        ),
        const SizedBox(height: 16),
      ],
      if (data.expiringEntries.isNotEmpty) ...[
        _buildInventorySection(
          context,
          'Expiring Soon (30 days)',
          data.expiringEntries,
          Colors.amber,
          Icons.schedule,
        ),
        const SizedBox(height: 16),
      ],
      if (data.expiredEntries.isNotEmpty) ...[
        _buildInventorySection(
          context,
          'Expired Items',
          data.expiredEntries,
          Colors.red,
          Icons.error,
        ),
      ],
    ];
  }

  Widget _buildInventorySection(
    BuildContext context,
    String title,
    List<InventoryEntry> entries,
    Color color,
    IconData icon,
  ) {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Icon(icon, color: color),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${entries.length}',
                    style: TextStyle(
                      color: color,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          ...entries.take(5).map((entry) => _buildInventoryEntryTile(context, entry)),
          if (entries.length > 5)
            Padding(
              padding: const EdgeInsets.all(16),
              child: Center(
                child: TextButton(
                  onPressed: () {
                    // TODO: Navigate to full list
                  },
                  child: Text('View all ${entries.length} items'),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildInventoryEntryTile(BuildContext context, InventoryEntry entry) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: _getStatusColor(entry.status).withOpacity(0.1),
        child: Icon(
          _getStatusIcon(entry.status),
          color: _getStatusColor(entry.status),
        ),
      ),
      title: Text('Entry ${entry.id.substring(0, 8)}'),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Quantity: ${entry.quantity}'),
          if (entry.expirationDate != null)
            Text(
              'Expires: ${_formatDate(entry.expirationDate!)}',
              style: TextStyle(
                color: entry.isExpired ? Colors.red : 
                       entry.isExpiringSoon ? Colors.orange : null,
              ),
            ),
          if (entry.batchNumber != null)
            Text('Batch: ${entry.batchNumber}'),
        ],
      ),
      trailing: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: _getStatusColor(entry.status).withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          entry.status.displayName,
          style: TextStyle(
            color: _getStatusColor(entry.status),
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      onTap: () {
        // TODO: Navigate to entry details
      },
    );
  }

  Color _getStatusColor(InventoryStatus status) {
    switch (status) {
      case InventoryStatus.available:
        return Colors.green;
      case InventoryStatus.expired:
        return Colors.red;
      case InventoryStatus.depleted:
        return Colors.grey;
      case InventoryStatus.reserved:
        return Colors.blue;
      case InventoryStatus.damaged:
        return Colors.orange;
      case InventoryStatus.recalled:
        return Colors.purple;
    }
  }

  IconData _getStatusIcon(InventoryStatus status) {
    switch (status) {
      case InventoryStatus.available:
        return Icons.check_circle;
      case InventoryStatus.expired:
        return Icons.error;
      case InventoryStatus.depleted:
        return Icons.remove_circle;
      case InventoryStatus.reserved:
        return Icons.lock;
      case InventoryStatus.damaged:
        return Icons.warning;
      case InventoryStatus.recalled:
        return Icons.block;
    }
  }

  String _formatDate(DateTime date) {
    return DateFormat('dd/MM/yyyy').format(date);
  }
}
