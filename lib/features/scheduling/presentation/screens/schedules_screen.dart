import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../../../core/data/models/medication.dart';
import '../../../medication/providers/medication_providers.dart';
import '../../models/dose_record.dart';
import '../../models/medication_schedule.dart';
import '../../providers/schedule_providers.dart';

class SchedulesContent extends ConsumerStatefulWidget {
  const SchedulesContent({super.key});

  @override
  ConsumerState<SchedulesContent> createState() => _SchedulesContentState();
}

class _SchedulesContentState extends ConsumerState<SchedulesContent>
    with TickerProviderStateMixin {
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
    return Scaffold(
      body: Column(
        children: [
          // Header with title and summary cards
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Theme.of(context).primaryColor,
                  Theme.of(context).primaryColor.withValues(alpha: 0.8),
                ],
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 24),
                Text(
                  'Medication Schedules',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Manage your medication schedules and track adherence',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.white.withValues(alpha: 0.9),
                  ),
                ),
                const SizedBox(height: 16),
                _buildSummaryCards(),
              ],
            ),
          ),
          
          // Tab Bar
          Container(
            color: Theme.of(context).scaffoldBackgroundColor,
            child: TabBar(
              controller: _tabController,
              labelColor: Theme.of(context).primaryColor,
              unselectedLabelColor: Colors.grey[600],
              indicatorColor: Theme.of(context).primaryColor,
              tabs: const [
                Tab(text: 'Today\'s Doses'),
                Tab(text: 'Calendar'),
                Tab(text: 'All Schedules'),
                Tab(text: 'Adherence'),
              ],
            ),
          ),
          
          // Tab Views
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildTodaysDosesTab(),
                _buildCalendarTab(),
                _buildAllSchedulesTab(),
                _buildAdherenceTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCards() {
    final todaysDosesAsync = ref.watch(todaysDosesProvider);
    final schedulesAsync = ref.watch(scheduleListProvider);
    
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          todaysDosesAsync.when(
            data: (doses) {
              final takenCount = doses.where((d) => d.status == DoseStatus.taken).length;
              final totalCount = doses.length;
              return _buildSummaryCard(
                'Today\'s Doses',
                '$takenCount/$totalCount',
                Icons.medication,
                Colors.blue,
              );
            },
            loading: () => _buildSummaryCard('Today\'s Doses', '...', Icons.medication, Colors.blue),
            error: (_, __) => _buildSummaryCard('Today\'s Doses', 'Error', Icons.medication, Colors.blue),
          ),
          const SizedBox(width: 12),
          todaysDosesAsync.when(
            data: (doses) {
              if (doses.isEmpty) {
                return _buildSummaryCard('Adherence Rate', '0%', Icons.trending_up, Colors.green);
              }
              final takenCount = doses.where((d) => d.status == DoseStatus.taken).length;
              final adherenceRate = ((takenCount / doses.length) * 100).round();
              return _buildSummaryCard(
                'Adherence Rate',
                '${adherenceRate}%',
                Icons.trending_up,
                Colors.green,
              );
            },
            loading: () => _buildSummaryCard('Adherence Rate', '...', Icons.trending_up, Colors.green),
            error: (_, __) => _buildSummaryCard('Adherence Rate', 'Error', Icons.trending_up, Colors.green),
          ),
          const SizedBox(width: 12),
          todaysDosesAsync.when(
            data: (doses) {
              final overdueCount = doses.where((d) => d.status == DoseStatus.scheduled && d.isOverdue).length;
              return _buildSummaryCard(
                'Overdue',
                overdueCount.toString(),
                Icons.warning,
                Colors.orange,
              );
            },
            loading: () => _buildSummaryCard('Overdue', '...', Icons.warning, Colors.orange),
            error: (_, __) => _buildSummaryCard('Overdue', 'Error', Icons.warning, Colors.orange),
          ),
          const SizedBox(width: 12),
          schedulesAsync.when(
            data: (schedules) {
              final activeCount = schedules.where((s) => s.isActive).length;
              return _buildSummaryCard(
                'Active Schedules',
                activeCount.toString(),
                Icons.schedule,
                Colors.purple,
              );
            },
            loading: () => _buildSummaryCard('Active Schedules', '...', Icons.schedule, Colors.purple),
            error: (_, __) => _buildSummaryCard('Active Schedules', 'Error', Icons.schedule, Colors.purple),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard(String title, String value, IconData icon, Color color) {
    return Container(
      width: 120,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withValues(alpha: 0.3)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.white, size: 24),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            title,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.9),
              fontSize: 12,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildTodaysDosesTab() {
    final todaysDosesAsync = ref.watch(todaysDosesProvider);
    
    return todaysDosesAsync.when(
      data: (doses) {
        if (doses.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.check_circle_outline,
                  size: 64,
                  color: Colors.grey[400],
                ),
                const SizedBox(height: 16),
                Text(
                  'No doses scheduled for today',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Create a medication schedule to see your daily doses',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey[500],
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        }
        
        // Group doses by status
        final scheduledDoses = doses.where((d) => d.status == DoseStatus.scheduled).toList();
        final takenDoses = doses.where((d) => d.status == DoseStatus.taken).toList();
        final overdueDoses = doses.where((d) => d.status == DoseStatus.scheduled && d.isOverdue).toList();
        final missedDoses = doses.where((d) => d.status == DoseStatus.missed).toList();
        
        return RefreshIndicator(
          onRefresh: () async {
            await ref.read(todaysDosesProvider.notifier).refresh();
          },
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              if (overdueDoses.isNotEmpty) ...[
                _buildDoseSectionHeader('Overdue', Colors.red, overdueDoses.length),
                ...overdueDoses.map((dose) => _buildDoseCard(dose)),
                const SizedBox(height: 16),
              ],
              if (scheduledDoses.isNotEmpty) ...[
                _buildDoseSectionHeader('Upcoming', Colors.blue, scheduledDoses.length),
                ...scheduledDoses.map((dose) => _buildDoseCard(dose)),
                const SizedBox(height: 16),
              ],
              if (takenDoses.isNotEmpty) ...[
                _buildDoseSectionHeader('Completed', Colors.green, takenDoses.length),
                ...takenDoses.map((dose) => _buildDoseCard(dose)),
                const SizedBox(height: 16),
              ],
              if (missedDoses.isNotEmpty) ...[
                _buildDoseSectionHeader('Missed', Colors.orange, missedDoses.length),
                ...missedDoses.map((dose) => _buildDoseCard(dose)),
              ],
            ],
          ),
        );
      },
      loading: () => const Center(
        child: CircularProgressIndicator(),
      ),
      error: (error, stack) => Center(
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
              'Error loading today\'s doses',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              error.toString(),
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => ref.read(todaysDosesProvider.notifier).refresh(),
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDoseSectionHeader(String title, Color color, int count) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 20,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              count.toString(),
              style: TextStyle(
                color: color,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDoseCard(DoseRecord dose) {
    final medicationAsync = ref.watch(medicationByIdProvider(dose.medicationId));
    
    return medicationAsync.when(
      data: (medication) {
        if (medication == null) return const SizedBox.shrink();
        
        return Container(
          margin: const EdgeInsets.only(bottom: 8),
          child: Card(
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  // Status indicator
                  Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: _getDoseStatusColor(dose),
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 12),
                  
                  // Dose info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          medication.name,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Scheduled: ${DateFormat('HH:mm').format(dose.scheduledTime)}',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 14,
                          ),
                        ),
                        if (dose.takenTime != null)
                          Text(
                            'Taken: ${DateFormat('HH:mm').format(dose.takenTime!)}',
                            style: TextStyle(
                              color: Colors.green[600],
                              fontSize: 14,
                            ),
                          ),
                      ],
                    ),
                  ),
                  
                  // Action buttons
                  if (dose.status == DoseStatus.scheduled)
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          onPressed: () => _markDoseAsTaken(dose),
                          icon: const Icon(Icons.check, color: Colors.green),
                          tooltip: 'Mark as taken',
                        ),
                        IconButton(
                          onPressed: () => _markDoseAsMissed(dose),
                          icon: const Icon(Icons.close, color: Colors.red),
                          tooltip: 'Mark as missed',
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ),
        );
      },
      loading: () => const Card(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: CircularProgressIndicator(),
        ),
      ),
      error: (error, stack) => const SizedBox.shrink(),
    );
  }

  Widget _buildAllSchedulesTab() {
    final schedulesAsync = ref.watch(scheduleListProvider);
    
    return schedulesAsync.when(
      data: (schedules) {
        if (schedules.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.schedule,
                  size: 64,
                  color: Colors.grey[400],
                ),
                const SizedBox(height: 16),
                Text(
                  'No schedules created yet',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Create your first medication schedule to get started',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey[500],
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        }
        
        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: schedules.length,
          itemBuilder: (context, index) {
            return _buildScheduleCard(schedules[index]);
          },
        );
      },
      loading: () => const Center(
        child: CircularProgressIndicator(),
      ),
      error: (error, stack) => Center(
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
              'Error loading schedules',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              error.toString(),
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildScheduleCard(MedicationSchedule schedule) {
    final medicationAsync = ref.watch(medicationByIdProvider(schedule.medicationId));
    
    return medicationAsync.when(
      data: (medication) {
        if (medication == null) return const SizedBox.shrink();
        
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          child: Card(
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              schedule.name,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              medication.name,
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Switch(
                        value: schedule.isActive,
                        onChanged: (value) {
                          ref.read(scheduleListProvider.notifier)
                              .toggleScheduleActive(schedule.id, value);
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  
                  // Schedule details
                  _buildScheduleDetailRow(
                    'Dose',
                    '${schedule.doseConfig.amount} ${schedule.doseConfig.unit}',
                    Icons.medication,
                  ),
                  _buildScheduleDetailRow(
                    'Frequency',
                    _getFrequencyText(schedule.frequency),
                    Icons.schedule,
                  ),
                  _buildScheduleDetailRow(
                    'Times',
                    schedule.timeSlots.join(', '),
                    Icons.access_time,
                  ),
                  
                  const SizedBox(height: 12),
                  
                  // Action buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton.icon(
                        onPressed: () => _viewScheduleDetails(schedule),
                        icon: const Icon(Icons.visibility),
                        label: const Text('View'),
                      ),
                      TextButton.icon(
                        onPressed: () => _editSchedule(schedule),
                        icon: const Icon(Icons.edit),
                        label: const Text('Edit'),
                      ),
                      TextButton.icon(
                        onPressed: () => _deleteSchedule(schedule),
                        icon: const Icon(Icons.delete, color: Colors.red),
                        label: const Text('Delete', style: TextStyle(color: Colors.red)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
      loading: () => const Card(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: CircularProgressIndicator(),
        ),
      ),
      error: (error, stack) => const SizedBox.shrink(),
    );
  }

  Widget _buildScheduleDetailRow(String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Icon(icon, size: 16, color: Colors.grey[600]),
          const SizedBox(width: 8),
          Text(
            '$label: ',
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 14,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCalendarTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Card(
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: TableCalendar<DoseRecord>(
                firstDay: DateTime.utc(2020, 1, 1),
                lastDay: DateTime.utc(2030, 12, 31),
                focusedDay: DateTime.now(),
                calendarFormat: CalendarFormat.month,
                eventLoader: _getEventsForDay,
                startingDayOfWeek: StartingDayOfWeek.monday,
                calendarStyle: CalendarStyle(
                  outsideDaysVisible: false,
                  weekendTextStyle: const TextStyle(color: Colors.red),
                  holidayTextStyle: const TextStyle(color: Colors.red),
                  markerDecoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    shape: BoxShape.circle,
                  ),
                  markersMaxCount: 3,
                ),
                headerStyle: const HeaderStyle(
                  formatButtonVisible: false,
                  titleCentered: true,
                ),
                onDaySelected: (selectedDay, focusedDay) {
                  _showDaySchedule(selectedDay);
                },
              ),
            ),
          ),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Calendar Legend',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildLegendItem(Colors.green, 'All doses taken'),
                  _buildLegendItem(Colors.orange, 'Some doses missed'),
                  _buildLegendItem(Colors.red, 'No doses taken'),
                  _buildLegendItem(Colors.blue, 'Scheduled doses'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem(Color color, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Container(
            width: 16,
            height: 16,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 8),
          Text(text),
        ],
      ),
    );
  }

  List<DoseRecord> _getEventsForDay(DateTime day) {
    final dosesAsync = ref.read(todaysDosesProvider);
    return dosesAsync.when(
      data: (doses) {
        return doses.where((dose) {
          final doseDate = DateTime(dose.scheduledTime.year, dose.scheduledTime.month, dose.scheduledTime.day);
          final selectedDate = DateTime(day.year, day.month, day.day);
          return doseDate.isAtSameMomentAs(selectedDate);
        }).toList();
      },
      loading: () => [],
      error: (_, __) => [],
    );
  }

  void _showDaySchedule(DateTime selectedDay) {
    final events = _getEventsForDay(selectedDay);
    final dateFormat = DateFormat('MMMM d, yyyy');
    
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.6,
        maxChildSize: 0.9,
        minChildSize: 0.3,
        builder: (context, scrollController) => Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Text(
                'Schedule for ${dateFormat.format(selectedDay)}',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              if (events.isEmpty)
                const Expanded(
                  child: Center(
                    child: Text('No doses scheduled for this day'),
                  ),
                )
              else
                Expanded(
                  child: ListView.builder(
                    controller: scrollController,
                    itemCount: events.length,
                    itemBuilder: (context, index) => _buildDoseCard(events[index]),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAdherenceTab() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.analytics, size: 64, color: Colors.grey),
          SizedBox(height: 16),
          Text(
            'Adherence Analytics',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text(
            'Detailed adherence tracking coming soon',
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Color _getDoseStatusColor(DoseRecord dose) {
    switch (dose.status) {
      case DoseStatus.taken:
        return Colors.green;
      case DoseStatus.missed:
        return Colors.red;
      case DoseStatus.scheduled:
        return dose.isOverdue ? Colors.orange : Colors.blue;
      case DoseStatus.skipped:
        return Colors.grey;
      default:
        return Colors.grey;
    }
  }

  String _getFrequencyText(ScheduleFrequency frequency) {
    switch (frequency) {
      case ScheduleFrequency.onceDaily:
        return 'Once daily';
      case ScheduleFrequency.twiceDaily:
        return 'Twice daily';
      case ScheduleFrequency.threeTimes:
        return '3 times daily';
      case ScheduleFrequency.fourTimes:
        return '4 times daily';
      case ScheduleFrequency.everyOtherDay:
        return 'Every other day';
      case ScheduleFrequency.weekly:
        return 'Weekly';
      case ScheduleFrequency.biweekly:
        return 'Bi-weekly';
      case ScheduleFrequency.monthly:
        return 'Monthly';
      case ScheduleFrequency.asNeeded:
        return 'As needed';
      case ScheduleFrequency.custom:
        return 'Custom';
    }
  }

  void _showAddScheduleDialog() {
    // TODO: Navigate to add schedule screen
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Add schedule functionality coming soon')),
    );
  }

  void _markDoseAsTaken(DoseRecord dose) {
    ref.read(todaysDosesProvider.notifier).markDoseAsTaken(dose.id);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Dose marked as taken')),
    );
  }

  void _markDoseAsMissed(DoseRecord dose) {
    ref.read(todaysDosesProvider.notifier).markDoseAsMissed(dose.id);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Dose marked as missed')),
    );
  }

  void _viewScheduleDetails(MedicationSchedule schedule) {
    // TODO: Navigate to schedule details screen
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Schedule details coming soon')),
    );
  }

  void _editSchedule(MedicationSchedule schedule) {
    // TODO: Navigate to edit schedule screen
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Edit schedule coming soon')),
    );
  }

  void _deleteSchedule(MedicationSchedule schedule) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Schedule'),
        content: Text('Are you sure you want to delete "${schedule.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              ref.read(scheduleListProvider.notifier).deleteSchedule(schedule.id);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Schedule deleted')),
              );
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
