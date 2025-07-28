// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'medication.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Medication _$MedicationFromJson(Map<String, dynamic> json) => Medication(
      id: json['id'] as String,
      name: json['name'] as String,
      type: $enumDecode(_$MedicationTypeEnumMap, json['type']),
      strength: (json['strength'] as num).toDouble(),
      unit: json['unit'] as String,
      currentStock: (json['current_stock'] as num).toInt(),
      lowStockThreshold: (json['low_stock_threshold'] as num).toInt(),
      expirationDate: json['expiration_date'] == null
          ? null
          : DateTime.parse(json['expiration_date'] as String),
      requiresReconstitution: json['requires_reconstitution'] as bool,
      notes: json['notes'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$MedicationToJson(Medication instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'type': _$MedicationTypeEnumMap[instance.type]!,
      'strength': instance.strength,
      'unit': instance.unit,
      'current_stock': instance.currentStock,
      'low_stock_threshold': instance.lowStockThreshold,
      'expiration_date': instance.expirationDate?.toIso8601String(),
      'requires_reconstitution': instance.requiresReconstitution,
      'notes': instance.notes,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
    };

const _$MedicationTypeEnumMap = {
  MedicationType.tablet: 'tablet',
  MedicationType.capsule: 'capsule',
  MedicationType.liquid: 'liquid',
  MedicationType.injection: 'injection',
  MedicationType.peptide: 'peptide',
  MedicationType.cream: 'cream',
  MedicationType.patch: 'patch',
  MedicationType.inhaler: 'inhaler',
  MedicationType.drops: 'drops',
  MedicationType.spray: 'spray',
};
