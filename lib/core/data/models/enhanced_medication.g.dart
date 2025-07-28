// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'enhanced_medication.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MedicationStrength _$MedicationStrengthFromJson(Map<String, dynamic> json) =>
    MedicationStrength(
      amount: (json['amount'] as num).toDouble(),
      unit: $enumDecode(_$StrengthUnitEnumMap, json['unit']),
      volume: (json['volume'] as num?)?.toDouble(),
      volumeUnit: $enumDecodeNullable(_$VolumeUnitEnumMap, json['volumeUnit']),
    );

Map<String, dynamic> _$MedicationStrengthToJson(MedicationStrength instance) =>
    <String, dynamic>{
      'amount': instance.amount,
      'unit': _$StrengthUnitEnumMap[instance.unit]!,
      'volume': instance.volume,
      'volumeUnit': _$VolumeUnitEnumMap[instance.volumeUnit],
    };

const _$StrengthUnitEnumMap = {
  StrengthUnit.mcg: 'mcg',
  StrengthUnit.mg: 'mg',
  StrengthUnit.g: 'g',
  StrengthUnit.mcgPerMl: 'mcgPerMl',
  StrengthUnit.mgPerMl: 'mgPerMl',
  StrengthUnit.gPerMl: 'gPerMl',
  StrengthUnit.iu: 'iu',
  StrengthUnit.iuPerMl: 'iuPerMl',
  StrengthUnit.percent: 'percent',
  StrengthUnit.units: 'units',
  StrengthUnit.unitsPerMl: 'unitsPerMl',
};

const _$VolumeUnitEnumMap = {
  VolumeUnit.ml: 'ml',
  VolumeUnit.cc: 'cc',
  VolumeUnit.l: 'l',
};

MedicationInventory _$MedicationInventoryFromJson(Map<String, dynamic> json) =>
    MedicationInventory(
      currentStock: (json['currentStock'] as num).toInt(),
      stockUnit: $enumDecode(_$StockUnitEnumMap, json['stockUnit']),
      lowStockThreshold: (json['lowStockThreshold'] as num).toInt(),
      currentVialVolume: (json['currentVialVolume'] as num?)?.toDouble(),
      currentVialVolumeUnit: $enumDecodeNullable(
          _$VolumeUnitEnumMap, json['currentVialVolumeUnit']),
      totalVialVolume: (json['totalVialVolume'] as num?)?.toDouble(),
      syringeSize: (json['syringeSize'] as num?)?.toDouble(),
      syringeSizeUnit:
          $enumDecodeNullable(_$VolumeUnitEnumMap, json['syringeSizeUnit']),
    );

Map<String, dynamic> _$MedicationInventoryToJson(
        MedicationInventory instance) =>
    <String, dynamic>{
      'currentStock': instance.currentStock,
      'stockUnit': _$StockUnitEnumMap[instance.stockUnit]!,
      'lowStockThreshold': instance.lowStockThreshold,
      'currentVialVolume': instance.currentVialVolume,
      'currentVialVolumeUnit':
          _$VolumeUnitEnumMap[instance.currentVialVolumeUnit],
      'totalVialVolume': instance.totalVialVolume,
      'syringeSize': instance.syringeSize,
      'syringeSizeUnit': _$VolumeUnitEnumMap[instance.syringeSizeUnit],
    };

const _$StockUnitEnumMap = {
  StockUnit.tablets: 'tablets',
  StockUnit.syringes: 'syringes',
  StockUnit.vials: 'vials',
  StockUnit.pens: 'pens',
  StockUnit.cartridges: 'cartridges',
  StockUnit.tubes: 'tubes',
  StockUnit.patches: 'patches',
  StockUnit.bottles: 'bottles',
  StockUnit.milliliters: 'milliliters',
};

ReconstitutionInfo _$ReconstitutionInfoFromJson(Map<String, dynamic> json) =>
    ReconstitutionInfo(
      solventName: json['solventName'] as String?,
      solventVolume: (json['solventVolume'] as num?)?.toDouble(),
      solventVolumeUnit:
          $enumDecodeNullable(_$VolumeUnitEnumMap, json['solventVolumeUnit']),
      finalConcentration: (json['finalConcentration'] as num?)?.toDouble(),
      finalConcentrationUnit: $enumDecodeNullable(
          _$StrengthUnitEnumMap, json['finalConcentrationUnit']),
      totalVolume: (json['totalVolume'] as num?)?.toDouble(),
      totalVolumeUnit:
          $enumDecodeNullable(_$VolumeUnitEnumMap, json['totalVolumeUnit']),
      reconstitutionDate: json['reconstitutionDate'] == null
          ? null
          : DateTime.parse(json['reconstitutionDate'] as String),
      stabilityDays: (json['stabilityDays'] as num?)?.toInt(),
      maxVialCapacity: (json['maxVialCapacity'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$ReconstitutionInfoToJson(ReconstitutionInfo instance) =>
    <String, dynamic>{
      'solventName': instance.solventName,
      'solventVolume': instance.solventVolume,
      'solventVolumeUnit': _$VolumeUnitEnumMap[instance.solventVolumeUnit],
      'finalConcentration': instance.finalConcentration,
      'finalConcentrationUnit':
          _$StrengthUnitEnumMap[instance.finalConcentrationUnit],
      'totalVolume': instance.totalVolume,
      'totalVolumeUnit': _$VolumeUnitEnumMap[instance.totalVolumeUnit],
      'reconstitutionDate': instance.reconstitutionDate?.toIso8601String(),
      'stabilityDays': instance.stabilityDays,
      'maxVialCapacity': instance.maxVialCapacity,
    };

ReconstitutionCalculationOption _$ReconstitutionCalculationOptionFromJson(
        Map<String, dynamic> json) =>
    ReconstitutionCalculationOption(
      name: json['name'] as String,
      solventVolume: (json['solventVolume'] as num).toDouble(),
      solventVolumeUnit:
          $enumDecode(_$VolumeUnitEnumMap, json['solventVolumeUnit']),
      finalConcentration: (json['finalConcentration'] as num).toDouble(),
      finalConcentrationUnit:
          $enumDecode(_$StrengthUnitEnumMap, json['finalConcentrationUnit']),
      doseVolume: (json['doseVolume'] as num).toDouble(),
      doseVolumeUnit: $enumDecode(_$VolumeUnitEnumMap, json['doseVolumeUnit']),
      syringeUtilization: (json['syringeUtilization'] as num).toDouble(),
    );

Map<String, dynamic> _$ReconstitutionCalculationOptionToJson(
        ReconstitutionCalculationOption instance) =>
    <String, dynamic>{
      'name': instance.name,
      'solventVolume': instance.solventVolume,
      'solventVolumeUnit': _$VolumeUnitEnumMap[instance.solventVolumeUnit]!,
      'finalConcentration': instance.finalConcentration,
      'finalConcentrationUnit':
          _$StrengthUnitEnumMap[instance.finalConcentrationUnit]!,
      'doseVolume': instance.doseVolume,
      'doseVolumeUnit': _$VolumeUnitEnumMap[instance.doseVolumeUnit]!,
      'syringeUtilization': instance.syringeUtilization,
    };

EnhancedMedication _$EnhancedMedicationFromJson(Map<String, dynamic> json) =>
    EnhancedMedication(
      id: json['id'] as String,
      name: json['name'] as String,
      type: $enumDecode(_$MedicationTypeEnumMap, json['type']),
      injectionSubType: $enumDecodeNullable(
          _$InjectionSubTypeEnumMap, json['injectionSubType']),
      strength:
          MedicationStrength.fromJson(json['strength'] as Map<String, dynamic>),
      inventory: MedicationInventory.fromJson(
          json['inventory'] as Map<String, dynamic>),
      expirationDate: json['expirationDate'] == null
          ? null
          : DateTime.parse(json['expirationDate'] as String),
      reconstitutionInfo: json['reconstitutionInfo'] == null
          ? null
          : ReconstitutionInfo.fromJson(
              json['reconstitutionInfo'] as Map<String, dynamic>),
      notes: json['notes'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$EnhancedMedicationToJson(EnhancedMedication instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'type': _$MedicationTypeEnumMap[instance.type]!,
      'injectionSubType': _$InjectionSubTypeEnumMap[instance.injectionSubType],
      'strength': instance.strength,
      'inventory': instance.inventory,
      'expirationDate': instance.expirationDate?.toIso8601String(),
      'reconstitutionInfo': instance.reconstitutionInfo,
      'notes': instance.notes,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
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

const _$InjectionSubTypeEnumMap = {
  InjectionSubType.preFilledSyringe: 'preFilledSyringe',
  InjectionSubType.readyToUseVial: 'readyToUseVial',
  InjectionSubType.lyophilizedPowder: 'lyophilizedPowder',
  InjectionSubType.injectionPen: 'injectionPen',
};
