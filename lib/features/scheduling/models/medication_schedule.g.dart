// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'medication_schedule.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MedicationSchedule _$MedicationScheduleFromJson(Map<String, dynamic> json) =>
    MedicationSchedule(
      id: json['id'] as String,
      medicationId: json['medication_id'] as String,
      name: json['name'] as String,
      type: $enumDecode(_$ScheduleTypeEnumMap, json['type']),
      frequency: $enumDecode(_$ScheduleFrequencyEnumMap, json['frequency']),
      doseConfig: DoseConfiguration.fromJson(
          json['dose_config'] as Map<String, dynamic>),
      cyclingConfig: json['cycling_config'] == null
          ? null
          : CyclingConfiguration.fromJson(
              json['cycling_config'] as Map<String, dynamic>),
      startDate: DateTime.parse(json['start_date'] as String),
      endDate: json['end_date'] == null
          ? null
          : DateTime.parse(json['end_date'] as String),
      isActive: json['is_active'] as bool,
      timeSlots: (json['time_slots'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      customSettings: json['custom_settings'] as Map<String, dynamic>,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$MedicationScheduleToJson(MedicationSchedule instance) =>
    <String, dynamic>{
      'id': instance.id,
      'medication_id': instance.medicationId,
      'name': instance.name,
      'type': _$ScheduleTypeEnumMap[instance.type]!,
      'frequency': _$ScheduleFrequencyEnumMap[instance.frequency]!,
      'dose_config': instance.doseConfig,
      'cycling_config': instance.cyclingConfig,
      'start_date': instance.startDate.toIso8601String(),
      'end_date': instance.endDate?.toIso8601String(),
      'is_active': instance.isActive,
      'time_slots': instance.timeSlots,
      'custom_settings': instance.customSettings,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
    };

const _$ScheduleTypeEnumMap = {
  ScheduleType.daily: 'daily',
  ScheduleType.weekly: 'weekly',
  ScheduleType.monthly: 'monthly',
  ScheduleType.asNeeded: 'asNeeded',
  ScheduleType.cycling: 'cycling',
  ScheduleType.custom: 'custom',
};

const _$ScheduleFrequencyEnumMap = {
  ScheduleFrequency.onceDaily: 'onceDaily',
  ScheduleFrequency.twiceDaily: 'twiceDaily',
  ScheduleFrequency.threeTimes: 'threeTimes',
  ScheduleFrequency.fourTimes: 'fourTimes',
  ScheduleFrequency.everyOtherDay: 'everyOtherDay',
  ScheduleFrequency.weekly: 'weekly',
  ScheduleFrequency.biweekly: 'biweekly',
  ScheduleFrequency.monthly: 'monthly',
  ScheduleFrequency.asNeeded: 'asNeeded',
  ScheduleFrequency.custom: 'custom',
};

DoseConfiguration _$DoseConfigurationFromJson(Map<String, dynamic> json) =>
    DoseConfiguration(
      amount: (json['amount'] as num).toDouble(),
      unit: json['unit'] as String,
      calculationMethod:
          $enumDecode(_$CalculationMethodEnumMap, json['calculation_method']),
      reconstitutionVolume: (json['reconstitution_volume'] as num?)?.toDouble(),
      concentration: (json['concentration'] as num?)?.toDouble(),
      calculationParams: json['calculation_params'] as Map<String, dynamic>,
    );

Map<String, dynamic> _$DoseConfigurationToJson(DoseConfiguration instance) =>
    <String, dynamic>{
      'amount': instance.amount,
      'unit': instance.unit,
      'calculation_method':
          _$CalculationMethodEnumMap[instance.calculationMethod]!,
      'reconstitution_volume': instance.reconstitutionVolume,
      'concentration': instance.concentration,
      'calculation_params': instance.calculationParams,
    };

const _$CalculationMethodEnumMap = {
  CalculationMethod.direct: 'direct',
  CalculationMethod.concentration: 'concentration',
  CalculationMethod.bodyWeight: 'bodyWeight',
  CalculationMethod.bodyArea: 'bodyArea',
  CalculationMethod.reconstitution: 'reconstitution',
  CalculationMethod.custom: 'custom',
};

CyclingConfiguration _$CyclingConfigurationFromJson(
        Map<String, dynamic> json) =>
    CyclingConfiguration(
      onDays: (json['on_days'] as num).toInt(),
      offDays: (json['off_days'] as num).toInt(),
      currentCycle: (json['current_cycle'] as num).toInt(),
      totalCycles: (json['total_cycles'] as num).toInt(),
      currentPhase: $enumDecode(_$CyclePhaseEnumMap, json['current_phase']),
      cycleStartDate: DateTime.parse(json['cycle_start_date'] as String),
      nextPhaseDate: json['next_phase_date'] == null
          ? null
          : DateTime.parse(json['next_phase_date'] as String),
      cycleNotes: json['cycle_notes'] as Map<String, dynamic>,
    );

Map<String, dynamic> _$CyclingConfigurationToJson(
        CyclingConfiguration instance) =>
    <String, dynamic>{
      'on_days': instance.onDays,
      'off_days': instance.offDays,
      'current_cycle': instance.currentCycle,
      'total_cycles': instance.totalCycles,
      'current_phase': _$CyclePhaseEnumMap[instance.currentPhase]!,
      'cycle_start_date': instance.cycleStartDate.toIso8601String(),
      'next_phase_date': instance.nextPhaseDate?.toIso8601String(),
      'cycle_notes': instance.cycleNotes,
    };

const _$CyclePhaseEnumMap = {
  CyclePhase.on: 'on',
  CyclePhase.off: 'off',
  CyclePhase.transition: 'transition',
  CyclePhase.cycleBreak: 'cycleBreak',
};
