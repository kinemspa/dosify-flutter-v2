class DashboardStatsData {
  final int totalMedications;
  final int activeSchedules;
  final int todaysDoses;
  final int lowStockCount;
  final DateTime? nextDoseTime;

  const DashboardStatsData({
    required this.totalMedications,
    required this.activeSchedules,
    required this.todaysDoses,
    required this.lowStockCount,
    this.nextDoseTime,
  });

  String get nextDoseFormatted {
    if (nextDoseTime == null) return 'No doses';
    
    final now = DateTime.now();
    final time = nextDoseTime!;
    
    // Format time as 12-hour format
    final hour = time.hour == 0 ? 12 : (time.hour > 12 ? time.hour - 12 : time.hour);
    final minute = time.minute.toString().padLeft(2, '0');
    final amPm = time.hour >= 12 ? 'PM' : 'AM';
    
    return '$hour:$minute $amPm';
  }
}
