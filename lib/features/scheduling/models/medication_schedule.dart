import 'dart:convert';
import 'package:json_annotation/json_annotation.dart';

part 'medication_schedule.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class MedicationSchedule {
  final String id;
  final String medicationId;
  final String name; // Schedule name for user reference
  final ScheduleType type;
  final ScheduleFrequency frequency;
  final DoseConfiguration doseConfig;
  final CyclingConfiguration? cyclingConfig; // For peptides and cycling medications
  final DateTime startDate;
  final DateTime? endDate;
  final bool isActive;
  final List<String> timeSlots; // Time strings like "08:00", "20:00"
  final Map<String, dynamic> customSettings; // Flexible settings storage
  final DateTime createdAt;
  final DateTime updatedAt;

  const MedicationSchedule({
    required this.id,
    required this.medicationId,
    required this.name,
    required this.type,
    required this.frequency,
    required this.doseConfig,
    this.cyclingConfig,
    required this.startDate,
    this.endDate,
    required this.isActive,
    required this.timeSlots,
    required this.customSettings,
    required this.createdAt,
    required this.updatedAt,
  });

  factory MedicationSchedule.fromJson(Map<String, dynamic> json) {
    // Create mutable copy to avoid read-only map issues
    final mutableJson = Map<String, dynamic>.from(json);
    
    // Handle boolean conversion from SQLite integer
    if (mutableJson['is_active'] is int) {
      mutableJson['is_active'] = mutableJson['is_active'] == 1;
    }
    
    // Handle DateTime conversion from milliseconds since epoch
    if (mutableJson['start_date'] is int) {
      mutableJson['start_date'] = DateTime.fromMillisecondsSinceEpoch(mutableJson['start_date']).toIso8601String();
    }
    if (mutableJson['end_date'] is int) {
      mutableJson['end_date'] = DateTime.fromMillisecondsSinceEpoch(mutableJson['end_date']).toIso8601String();
    }
    if (mutableJson['created_at'] is int) {
      mutableJson['created_at'] = DateTime.fromMillisecondsSinceEpoch(mutableJson['created_at']).toIso8601String();
    }
    if (mutableJson['updated_at'] is int) {
      mutableJson['updated_at'] = DateTime.fromMillisecondsSinceEpoch(mutableJson['updated_at']).toIso8601String();
    }
    
    // Parse nested JSON objects
    if (mutableJson['dose_config'] is String) {
      mutableJson['dose_config'] = Map<String, dynamic>.from(
        jsonDecode(mutableJson['dose_config'])
      );
    } else if (mutableJson['dose_config'] is Map) {
      // Already parsed, just ensure it's the right type
      mutableJson['dose_config'] = Map<String, dynamic>.from(mutableJson['dose_config']);
    }
    
    if (mutableJson['cycling_config'] is String && mutableJson['cycling_config'] != null) {
      mutableJson['cycling_config'] = Map<String, dynamic>.from(
        jsonDecode(mutableJson['cycling_config'])
      );
    } else if (mutableJson['cycling_config'] is Map) {
      mutableJson['cycling_config'] = Map<String, dynamic>.from(mutableJson['cycling_config']);
    }
    
    // Parse time slots from JSON string
    if (mutableJson['time_slots'] is String) {
      mutableJson['time_slots'] = List<String>.from(
        jsonDecode(mutableJson['time_slots'])
      );
    }
    
    // Parse custom settings from JSON string
    if (mutableJson['custom_settings'] is String) {
      mutableJson['custom_settings'] = Map<String, dynamic>.from(
        jsonDecode(mutableJson['custom_settings'])
      );
    }
    
    return _$MedicationScheduleFromJson(mutableJson);
  }

  Map<String, dynamic> toJson() => _$MedicationScheduleToJson(this);

  MedicationSchedule copyWith({
    String? id,
    String? medicationId,
    String? name,
    ScheduleType? type,
    ScheduleFrequency? frequency,
    DoseConfiguration? doseConfig,
    CyclingConfiguration? cyclingConfig,
    DateTime? startDate,
    DateTime? endDate,
    bool? isActive,
    List<String>? timeSlots,
    Map<String, dynamic>? customSettings,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return MedicationSchedule(
      id: id ?? this.id,
      medicationId: medicationId ?? this.medicationId,
      name: name ?? this.name,
      type: type ?? this.type,
      frequency: frequency ?? this.frequency,
      doseConfig: doseConfig ?? this.doseConfig,
      cyclingConfig: cyclingConfig ?? this.cyclingConfig,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      isActive: isActive ?? this.isActive,
      timeSlots: timeSlots ?? this.timeSlots,
      customSettings: customSettings ?? this.customSettings,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

@JsonSerializable(fieldRename: FieldRename.snake)
class DoseConfiguration {
  final double amount;
  final String unit; // "mg", "ml", "IU", "mcg", etc.
  final CalculationMethod calculationMethod;
  final double? reconstitutionVolume; // For injections
  final double? concentration; // Calculated or manual concentration
  final Map<String, dynamic> calculationParams; // Flexible calculation storage

  const DoseConfiguration({
    required this.amount,
    required this.unit,
    required this.calculationMethod,
    this.reconstitutionVolume,
    this.concentration,
    required this.calculationParams,
  });

  factory DoseConfiguration.fromJson(Map<String, dynamic> json) {
    final mutableJson = Map<String, dynamic>.from(json);
    
    if (mutableJson['calculation_params'] is String) {
      mutableJson['calculation_params'] = Map<String, dynamic>.from(
        jsonDecode(mutableJson['calculation_params'])
      );
    }
    
    return _$DoseConfigurationFromJson(mutableJson);
  }

  Map<String, dynamic> toJson() => _$DoseConfigurationToJson(this);

  DoseConfiguration copyWith({
    double? amount,
    String? unit,
    CalculationMethod? calculationMethod,
    double? reconstitutionVolume,
    double? concentration,
    Map<String, dynamic>? calculationParams,
  }) {
    return DoseConfiguration(
      amount: amount ?? this.amount,
      unit: unit ?? this.unit,
      calculationMethod: calculationMethod ?? this.calculationMethod,
      reconstitutionVolume: reconstitutionVolume ?? this.reconstitutionVolume,
      concentration: concentration ?? this.concentration,
      calculationParams: calculationParams ?? this.calculationParams,
    );
  }
}

@JsonSerializable(fieldRename: FieldRename.snake)
class CyclingConfiguration {
  final int onDays;
  final int offDays;
  final int currentCycle;
  final int totalCycles;
  final CyclePhase currentPhase;
  final DateTime cycleStartDate;
  final DateTime? nextPhaseDate;
  final Map<String, dynamic> cycleNotes; // Phase-specific notes and settings

  const CyclingConfiguration({
    required this.onDays,
    required this.offDays,
    required this.currentCycle,
    required this.totalCycles,
    required this.currentPhase,
    required this.cycleStartDate,
    this.nextPhaseDate,
    required this.cycleNotes,
  });

  factory CyclingConfiguration.fromJson(Map<String, dynamic> json) {
    final mutableJson = Map<String, dynamic>.from(json);
    
    // Handle DateTime conversion from milliseconds since epoch
    if (mutableJson['cycle_start_date'] is int) {
      mutableJson['cycle_start_date'] = DateTime.fromMillisecondsSinceEpoch(mutableJson['cycle_start_date']).toIso8601String();
    }
    if (mutableJson['next_phase_date'] is int) {
      mutableJson['next_phase_date'] = DateTime.fromMillisecondsSinceEpoch(mutableJson['next_phase_date']).toIso8601String();
    }
    
    if (mutableJson['cycle_notes'] is String) {
      mutableJson['cycle_notes'] = Map<String, dynamic>.from(
        jsonDecode(mutableJson['cycle_notes'])
      );
    }
    
    return _$CyclingConfigurationFromJson(mutableJson);
  }

  Map<String, dynamic> toJson() => _$CyclingConfigurationToJson(this);

  CyclingConfiguration copyWith({
    int? onDays,
    int? offDays,
    int? currentCycle,
    int? totalCycles,
    CyclePhase? currentPhase,
    DateTime? cycleStartDate,
    DateTime? nextPhaseDate,
    Map<String, dynamic>? cycleNotes,
  }) {
    return CyclingConfiguration(
      onDays: onDays ?? this.onDays,
      offDays: offDays ?? this.offDays,
      currentCycle: currentCycle ?? this.currentCycle,
      totalCycles: totalCycles ?? this.totalCycles,
      currentPhase: currentPhase ?? this.currentPhase,
      cycleStartDate: cycleStartDate ?? this.cycleStartDate,
      nextPhaseDate: nextPhaseDate ?? this.nextPhaseDate,
      cycleNotes: cycleNotes ?? this.cycleNotes,
    );
  }
}

// Enums for scheduling system
enum ScheduleType {
  daily,
  weekly,
  monthly,
  asNeeded,
  cycling,
  custom
}

enum ScheduleFrequency {
  onceDaily,
  twiceDaily,
  threeTimes,
  fourTimes,
  everyOtherDay,
  weekly,
  biweekly,
  monthly,
  asNeeded,
  custom
}

enum CalculationMethod {
  direct, // Direct amount per dose
  concentration, // Calculate based on concentration
  bodyWeight, // Calculate based on body weight
  bodyArea, // Calculate based on body surface area
  reconstitution, // Calculate based on reconstitution
  custom // Custom calculation method
}

enum CyclePhase {
  on,
  off,
  transition,
  cycleBreak
}
