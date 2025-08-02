import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../core/data/models/inventory_entry.dart';
import '../../supplies/ui/supplies_management_screen.dart';
import '../providers/inventory_providers.dart';

class InventoryScreen extends ConsumerWidget {
  const InventoryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {    
    return Scaffold(
      body: Column(
        children: [
          // Modern Clinical Header
          Container(
            padding: const EdgeInsets.fromLTRB(20, 60, 20, 24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Theme.of(context).primaryColor,
                  Theme.of(context).primaryColor.withOpacity(0.8),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: const Icon(
                    Icons.inventory_2_outlined,
                    color: Colors.white,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Inventory',
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Advanced stock & supply management',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: IconButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const SuppliesManagementScreen(),
                        ),
                      );
                    },
                    icon: const Icon(
                      Icons.add,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Expanded(
            child: InventoryContent(),
          ),
        ],
      ),
    );
  }
}

class InventoryContent extends ConsumerStatefulWidget {
  const InventoryContent({Key? key}) : super(key: key);

  @override
  ConsumerState<InventoryContent> createState() => _InventoryContentState();
}

class _InventoryContentState extends ConsumerState<InventoryContent> with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
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
            Tab(text: 'Overview', icon: Icon(Icons.dashboard, size: 18)),
            Tab(text: 'Stock', icon: Icon(Icons.inventory_2, size: 18)),
            Tab(text: 'Alerts', icon: Icon(Icons.warning, size: 18)),
            Tab(text: 'Reports', icon: Icon(Icons.analytics, size: 18)),
          ],
        ),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              _buildOverviewTab(),
              _buildStockTab(),
              _buildAlertsTab(),
              _buildReportsTab(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildOverviewTab() {
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

  Widget _buildStockTab() {
    final inventoryDashboardData = ref.watch(inventoryDashboardDataProvider);
    
    return inventoryDashboardData.when(
      data: (data) => RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(inventoryDashboardDataProvider);
        },
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Current Stock Levels',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'All inventory entries with current quantities and status.',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Show all inventory entries
            ...data.allEntries.map((entry) => Card(
              margin: const EdgeInsets.only(bottom: 8),
              child: _buildInventoryEntryTile(context, entry),
            )),
          ],
        ),
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stackTrace) => Center(
        child: Text('Error: $error'),
      ),
    );
  }

  Widget _buildAlertsTab() {
    final inventoryDashboardData = ref.watch(inventoryDashboardDataProvider);
    
    return inventoryDashboardData.when(
      data: (data) => RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(inventoryDashboardDataProvider);
        },
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
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
                'Expiring Soon',
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
            if (data.lowStockEntries.isEmpty && data.expiringEntries.isEmpty && data.expiredEntries.isEmpty)
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.check_circle_outline,
                      size: 64,
                      color: Colors.green,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'No Active Alerts',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'All inventory items are in good condition',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stackTrace) => Center(
        child: Text('Error: $error'),
      ),
    );
  }

  Widget _buildReportsTab() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.analytics,
            size: 64,
            color: Colors.grey,
          ),
          const SizedBox(height: 16),
          Text(
            'Inventory Reports',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          Text(
            'Detailed analytics and reporting coming soon',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Reports feature coming soon!'),
                ),
              );
            },
            icon: const Icon(Icons.bar_chart),
            label: const Text('Generate Report'),
          ),
        ],
      ),
    );
  }
}
