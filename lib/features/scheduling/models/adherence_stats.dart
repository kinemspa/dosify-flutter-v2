class AdherenceStats {
  final String medicationId;
  final String? scheduleId;
  final DateTime periodStart;
  final DateTime periodEnd;
  final int totalDoses;
  final int takenDoses;
  final int missedDoses;
  final int onTimeDoses;
  final int lateDoses;
  final double adherenceRate;
  final double onTimeRate;
  final Duration averageDelay;
  final Map<String, int> missedReasons;
  final DateTime calculatedAt;

  const AdherenceStats({
    required this.medicationId,
    this.scheduleId,
    required this.periodStart,
    required this.periodEnd,
    required this.totalDoses,
    required this.takenDoses,
    required this.missedDoses,
    required this.onTimeDoses,
    required this.lateDoses,
    required this.adherenceRate,
    required this.onTimeRate,
    required this.averageDelay,
    required this.missedReasons,
    required this.calculatedAt,
  });

  @override
  String toString() {
    return 'AdherenceStats('
        'medicationId: $medicationId, '
        'scheduleId: $scheduleId, '
        'periodStart: $periodStart, '
        'periodEnd: $periodEnd, '
        'totalDoses: $totalDoses, '
        'takenDoses: $takenDoses, '
        'missedDoses: $missedDoses, '
        'adherenceRate: ${adherenceRate.toStringAsFixed(1)}%, '
        'onTimeRate: ${onTimeRate.toStringAsFixed(1)}%'
        ')';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AdherenceStats &&
        other.medicationId == medicationId &&
        other.scheduleId == scheduleId &&
        other.periodStart == periodStart &&
        other.periodEnd == periodEnd &&
        other.totalDoses == totalDoses &&
        other.takenDoses == takenDoses &&
        other.missedDoses == missedDoses &&
        other.onTimeDoses == onTimeDoses &&
        other.lateDoses == lateDoses &&
        other.adherenceRate == adherenceRate &&
        other.onTimeRate == onTimeRate &&
        other.averageDelay == averageDelay &&
        other.calculatedAt == calculatedAt;
  }

  @override
  int get hashCode {
    return Object.hash(
      medicationId,
      scheduleId,
      periodStart,
      periodEnd,
      totalDoses,
      takenDoses,
      missedDoses,
      onTimeDoses,
      lateDoses,
      adherenceRate,
      onTimeRate,
      averageDelay,
      calculatedAt,
    );
  }
}
