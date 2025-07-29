import 'dart:convert';
import 'package:json_annotation/json_annotation.dart';

part 'dose_record.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class DoseRecord {
  final String id;
  final String scheduleId;
  final String medicationId;
  final DateTime scheduledTime;
  final DateTime? takenTime;
  final DoseStatus status;
  final double? actualAmount; // Actual dose taken (may differ from scheduled)
  final String? actualUnit; // Unit of actual dose
  final double? volumeDrawn; // For injections - volume drawn from vial
  final String? notes;
  final Map<String, dynamic> metadata; // Additional tracking data
  final DateTime createdAt;
  final DateTime updatedAt;

  const DoseRecord({
    required this.id,
    required this.scheduleId,
    required this.medicationId,
    required this.scheduledTime,
    this.takenTime,
    required this.status,
    this.actualAmount,
    this.actualUnit,
    this.volumeDrawn,
    this.notes,
    required this.metadata,
    required this.createdAt,
    required this.updatedAt,
  });

  factory DoseRecord.fromJson(Map<String, dynamic> json) {
    final mutableJson = Map<String, dynamic>.from(json);
    
    // Handle DateTime conversion from milliseconds since epoch
    if (mutableJson['scheduled_time'] is int) {
      mutableJson['scheduled_time'] = DateTime.fromMillisecondsSinceEpoch(mutableJson['scheduled_time']).toIso8601String();
    }
    if (mutableJson['taken_time'] is int) {
      mutableJson['taken_time'] = DateTime.fromMillisecondsSinceEpoch(mutableJson['taken_time']).toIso8601String();
    }
    if (mutableJson['created_at'] is int) {
      mutableJson['created_at'] = DateTime.fromMillisecondsSinceEpoch(mutableJson['created_at']).toIso8601String();
    }
    if (mutableJson['updated_at'] is int) {
      mutableJson['updated_at'] = DateTime.fromMillisecondsSinceEpoch(mutableJson['updated_at']).toIso8601String();
    }
    
    // Parse metadata from JSON string
    if (mutableJson['metadata'] is String) {
      mutableJson['metadata'] = Map<String, dynamic>.from(
        jsonDecode(mutableJson['metadata'])
      );
    }
    
    return _$DoseRecordFromJson(mutableJson);
  }

  Map<String, dynamic> toJson() => _$DoseRecordToJson(this);

  DoseRecord copyWith({
    String? id,
    String? scheduleId,
    String? medicationId,
    DateTime? scheduledTime,
    DateTime? takenTime,
    DoseStatus? status,
    double? actualAmount,
    String? actualUnit,
    double? volumeDrawn,
    String? notes,
    Map<String, dynamic>? metadata,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return DoseRecord(
      id: id ?? this.id,
      scheduleId: scheduleId ?? this.scheduleId,
      medicationId: medicationId ?? this.medicationId,
      scheduledTime: scheduledTime ?? this.scheduledTime,
      takenTime: takenTime ?? this.takenTime,
      status: status ?? this.status,
      actualAmount: actualAmount ?? this.actualAmount,
      actualUnit: actualUnit ?? this.actualUnit,
      volumeDrawn: volumeDrawn ?? this.volumeDrawn,
      notes: notes ?? this.notes,
      metadata: metadata ?? this.metadata,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  // Helper methods for adherence tracking
  bool get wasTaken => status == DoseStatus.taken;
  bool get wasMissed => status == DoseStatus.missed;
  bool get isOverdue => status == DoseStatus.scheduled && 
      DateTime.now().isAfter(scheduledTime.add(const Duration(hours: 2)));
  
  Duration? get timeDifference {
    if (takenTime == null) return null;
    return takenTime!.difference(scheduledTime);
  }

  bool get isTakenOnTime {
    if (takenTime == null) return false;
    final diff = timeDifference!.abs();
    return diff.inMinutes <= 30; // Within 30 minutes is considered on time
  }
}

@JsonSerializable(fieldRename: FieldRename.snake)
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
  final double adherenceRate; // Percentage of doses taken
  final double onTimeRate; // Percentage of doses taken on time
  final Duration averageDelay;
  final Map<String, int> missedReasons; // Categorized reasons for missed doses
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

  factory AdherenceStats.fromJson(Map<String, dynamic> json) {
    final mutableJson = Map<String, dynamic>.from(json);
    
    // Handle DateTime conversion from milliseconds since epoch
    if (mutableJson['period_start'] is int) {
      mutableJson['period_start'] = DateTime.fromMillisecondsSinceEpoch(mutableJson['period_start']).toIso8601String();
    }
    if (mutableJson['period_end'] is int) {
      mutableJson['period_end'] = DateTime.fromMillisecondsSinceEpoch(mutableJson['period_end']).toIso8601String();
    }
    if (mutableJson['calculated_at'] is int) {
      mutableJson['calculated_at'] = DateTime.fromMillisecondsSinceEpoch(mutableJson['calculated_at']).toIso8601String();
    }
    
    if (mutableJson['missed_reasons'] is String) {
      mutableJson['missed_reasons'] = Map<String, int>.from(
        jsonDecode(mutableJson['missed_reasons'])
      );
    }
    
    return _$AdherenceStatsFromJson(mutableJson);
  }

  Map<String, dynamic> toJson() => _$AdherenceStatsToJson(this);
}

enum DoseStatus {
  scheduled,
  taken,
  missed,
  skipped,
  partial,
  delayed
}
