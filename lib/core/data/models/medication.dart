import 'package:json_annotation/json_annotation.dart';

part 'medication.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class Medication {
  final String id;
  final String name;
  final MedicationType type;
  final double strength;
  final String unit;
  final int currentStock;
  final int lowStockThreshold;
  final DateTime? expirationDate;
  final bool requiresReconstitution;
  final String? notes;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Medication({
    required this.id,
    required this.name,
    required this.type,
    required this.strength,
    required this.unit,
    required this.currentStock,
    required this.lowStockThreshold,
    this.expirationDate,
    required this.requiresReconstitution,
    this.notes,
    required this.createdAt,
    required this.updatedAt,
  });

  // Custom fromJson to handle boolean conversion from SQLite
  factory Medication.fromJson(Map<String, dynamic> json) {
    // Create a mutable copy of the map to avoid read-only issues
    final mutableJson = Map<String, dynamic>.from(json);
    
    // Convert int to boolean from SQLite
    if (mutableJson.containsKey('requires_reconstitution') && mutableJson['requires_reconstitution'] is int) {
      mutableJson['requires_reconstitution'] = mutableJson['requires_reconstitution'] == 1;
    }
    return _$MedicationFromJson(mutableJson);
  }

  // Custom toJson to handle boolean conversion for SQLite
  Map<String, dynamic> toJson() {
    final json = _$MedicationToJson(this);
    // Convert boolean to int for SQLite
    json['requires_reconstitution'] = requiresReconstitution ? 1 : 0;
    return json;
  }

  Medication copyWith({
    String? id,
    String? name,
    MedicationType? type,
    double? strength,
    String? unit,
    int? currentStock,
    int? lowStockThreshold,
    DateTime? expirationDate,
    bool? requiresReconstitution,
    String? notes,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Medication(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      strength: strength ?? this.strength,
      unit: unit ?? this.unit,
      currentStock: currentStock ?? this.currentStock,
      lowStockThreshold: lowStockThreshold ?? this.lowStockThreshold,
      expirationDate: expirationDate ?? this.expirationDate,
      requiresReconstitution: requiresReconstitution ?? this.requiresReconstitution,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  bool get isLowStock => currentStock <= lowStockThreshold;
  
  bool get isExpiringSoon {
    if (expirationDate == null) return false;
    final daysUntilExpiration = expirationDate!.difference(DateTime.now()).inDays;
    return daysUntilExpiration <= 30 && daysUntilExpiration >= 0;
  }
  
  bool get isExpired {
    if (expirationDate == null) return false;
    return expirationDate!.isBefore(DateTime.now());
  }
  
  String get displayStrength {
    return '$strength $unit';
  }
}

@JsonEnum()
enum MedicationType {
  tablet,
  capsule,
  liquid,
  injection,
  peptide,
  cream,
  patch,
  inhaler,
  drops,
  spray
}

extension MedicationTypeExtension on MedicationType {
  String get displayName {
    switch (this) {
      case MedicationType.tablet:
        return 'Tablet';
      case MedicationType.capsule:
        return 'Capsule';
      case MedicationType.liquid:
        return 'Liquid';
      case MedicationType.injection:
        return 'Injection';
      case MedicationType.peptide:
        return 'Peptide';
      case MedicationType.cream:
        return 'Cream';
      case MedicationType.patch:
        return 'Patch';
      case MedicationType.inhaler:
        return 'Inhaler';
      case MedicationType.drops:
        return 'Drops';
      case MedicationType.spray:
        return 'Spray';
    }
  }

  List<String> get availableUnits {
    switch (this) {
      case MedicationType.tablet:
      case MedicationType.capsule:
        return ['mg', 'mcg', 'g', 'IU'];
      case MedicationType.liquid:
        return ['mg/ml', 'mcg/ml', 'g/ml', '%', 'IU/ml'];
      case MedicationType.injection:
      case MedicationType.peptide:
        return ['mg', 'mcg', 'g', 'IU', 'mg/ml', 'mcg/ml'];
      case MedicationType.cream:
        return ['%', 'mg/g', 'mcg/g'];
      case MedicationType.patch:
        return ['mg', 'mcg', 'mg/hr', 'mcg/hr'];
      case MedicationType.inhaler:
        return ['mcg/dose', 'mg/dose'];
      case MedicationType.drops:
        return ['mg/ml', 'mcg/ml', '%'];
      case MedicationType.spray:
        return ['mg/spray', 'mcg/spray'];
    }
  }

  String get stockUnit {
    switch (this) {
      case MedicationType.tablet:
        return 'tablets';
      case MedicationType.capsule:
        return 'capsules';
      case MedicationType.liquid:
        return 'ml';
      case MedicationType.injection:
      case MedicationType.peptide:
        return 'vials';
      case MedicationType.cream:
        return 'tubes';
      case MedicationType.patch:
        return 'patches';
      case MedicationType.inhaler:
        return 'inhalers';
      case MedicationType.drops:
        return 'bottles';
      case MedicationType.spray:
        return 'bottles';
    }
  }
}
