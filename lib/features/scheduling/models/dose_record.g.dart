// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dose_record.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DoseRecord _$DoseRecordFromJson(Map<String, dynamic> json) => DoseRecord(
      id: json['id'] as String,
      scheduleId: json['schedule_id'] as String,
      medicationId: json['medication_id'] as String,
      scheduledTime: DateTime.parse(json['scheduled_time'] as String),
      takenTime: json['taken_time'] == null
          ? null
          : DateTime.parse(json['taken_time'] as String),
      status: $enumDecode(_$DoseStatusEnumMap, json['status']),
      actualAmount: (json['actual_amount'] as num?)?.toDouble(),
      actualUnit: json['actual_unit'] as String?,
      volumeDrawn: (json['volume_drawn'] as num?)?.toDouble(),
      notes: json['notes'] as String?,
      metadata: json['metadata'] as Map<String, dynamic>,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$DoseRecordToJson(DoseRecord instance) =>
    <String, dynamic>{
      'id': instance.id,
      'schedule_id': instance.scheduleId,
      'medication_id': instance.medicationId,
      'scheduled_time': instance.scheduledTime.toIso8601String(),
      'taken_time': instance.takenTime?.toIso8601String(),
      'status': _$DoseStatusEnumMap[instance.status]!,
      'actual_amount': instance.actualAmount,
      'actual_unit': instance.actualUnit,
      'volume_drawn': instance.volumeDrawn,
      'notes': instance.notes,
      'metadata': instance.metadata,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
    };

const _$DoseStatusEnumMap = {
  DoseStatus.scheduled: 'scheduled',
  DoseStatus.taken: 'taken',
  DoseStatus.missed: 'missed',
  DoseStatus.skipped: 'skipped',
  DoseStatus.partial: 'partial',
  DoseStatus.delayed: 'delayed',
};

AdherenceStats _$AdherenceStatsFromJson(Map<String, dynamic> json) =>
    AdherenceStats(
      medicationId: json['medication_id'] as String,
      scheduleId: json['schedule_id'] as String?,
      periodStart: DateTime.parse(json['period_start'] as String),
      periodEnd: DateTime.parse(json['period_end'] as String),
      totalDoses: (json['total_doses'] as num).toInt(),
      takenDoses: (json['taken_doses'] as num).toInt(),
      missedDoses: (json['missed_doses'] as num).toInt(),
      onTimeDoses: (json['on_time_doses'] as num).toInt(),
      lateDoses: (json['late_doses'] as num).toInt(),
      adherenceRate: (json['adherence_rate'] as num).toDouble(),
      onTimeRate: (json['on_time_rate'] as num).toDouble(),
      averageDelay:
          Duration(microseconds: (json['average_delay'] as num).toInt()),
      missedReasons: Map<String, int>.from(json['missed_reasons'] as Map),
      calculatedAt: DateTime.parse(json['calculated_at'] as String),
    );

Map<String, dynamic> _$AdherenceStatsToJson(AdherenceStats instance) =>
    <String, dynamic>{
      'medication_id': instance.medicationId,
      'schedule_id': instance.scheduleId,
      'period_start': instance.periodStart.toIso8601String(),
      'period_end': instance.periodEnd.toIso8601String(),
      'total_doses': instance.totalDoses,
      'taken_doses': instance.takenDoses,
      'missed_doses': instance.missedDoses,
      'on_time_doses': instance.onTimeDoses,
      'late_doses': instance.lateDoses,
      'adherence_rate': instance.adherenceRate,
      'on_time_rate': instance.onTimeRate,
      'average_delay': instance.averageDelay.inMicroseconds,
      'missed_reasons': instance.missedReasons,
      'calculated_at': instance.calculatedAt.toIso8601String(),
    };
