import 'package:json_annotation/json_annotation.dart';

part 'enhanced_medication.g.dart';

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

enum InjectionSubType {
  preFilledSyringe,     // Pre-filled syringe with fixed dose
  readyToUseVial,       // Multi-dose vial ready to use
  lyophilizedPowder,    // Powder requiring reconstitution
  injectionPen,         // Pen device (pre-filled or cartridge)
}

enum StrengthUnit {
  // Mass units (per tablet/capsule/dose)
  mcg,  // micrograms
  mg,   // milligrams
  g,    // grams
  
  // Concentration units (per mL)
  mcgPerMl, // mcg/mL
  mgPerMl,  // mg/mL
  gPerMl,   // g/mL
  
  // International units
  iu,       // IU
  iuPerMl,  // IU/mL
  
  // Percentage
  percent,  // %
  
  // Units (for insulin)
  units,    // U
  unitsPerMl, // U/mL
}

enum VolumeUnit {
  ml,   // milliliters
  cc,   // cubic centimeters (same as mL)
  l,    // liters
}

enum StockUnit {
  tablets,      // Individual tablets/capsules
  syringes,     // Individual pre-filled syringes
  vials,        // Individual vials
  pens,         // Individual injection pens
  cartridges,   // Pen cartridges
  tubes,        // Cream/gel tubes
  patches,      // Individual patches
  bottles,      // Liquid bottles
  milliliters,  // mL of liquid
}

// Standard syringe sizes for injections
enum SyringeSize {
  insulin_0_3ml,    // 0.3mL (30 units for insulin)
  insulin_0_5ml,    // 0.5mL (50 units for insulin)
  insulin_1ml,      // 1.0mL (100 units for insulin)
  standard_1ml,     // 1mL standard
  standard_3ml,     // 3mL standard
  standard_5ml,     // 5mL standard
  standard_10ml,    // 10mL standard
  standard_20ml,    // 20mL standard
}

extension SyringeSizeExtension on SyringeSize {
  double get volumeInMl {
    switch (this) {
      case SyringeSize.insulin_0_3ml: return 0.3;
      case SyringeSize.insulin_0_5ml: return 0.5;
      case SyringeSize.insulin_1ml: return 1.0;
      case SyringeSize.standard_1ml: return 1.0;
      case SyringeSize.standard_3ml: return 3.0;
      case SyringeSize.standard_5ml: return 5.0;
      case SyringeSize.standard_10ml: return 10.0;
      case SyringeSize.standard_20ml: return 20.0;
    }
  }
  
  String get displayName {
    switch (this) {
      case SyringeSize.insulin_0_3ml: return '0.3mL (30U insulin syringe)';
      case SyringeSize.insulin_0_5ml: return '0.5mL (50U insulin syringe)';
      case SyringeSize.insulin_1ml: return '1.0mL (100U insulin syringe)';
      case SyringeSize.standard_1ml: return '1mL standard syringe';
      case SyringeSize.standard_3ml: return '3mL standard syringe';
      case SyringeSize.standard_5ml: return '5mL standard syringe';
      case SyringeSize.standard_10ml: return '10mL standard syringe';
      case SyringeSize.standard_20ml: return '20mL standard syringe';
    }
  }
  
  bool get isInsulinSyringe {
    return [
      SyringeSize.insulin_0_3ml,
      SyringeSize.insulin_0_5ml,
      SyringeSize.insulin_1ml,
    ].contains(this);
  }
}

@JsonSerializable()
class MedicationStrength {
  final double amount;
  final StrengthUnit unit;
  final double? volume; // For concentration, the volume this strength is in
  final VolumeUnit? volumeUnit;
  
  const MedicationStrength({
    required this.amount,
    required this.unit,
    this.volume,
    this.volumeUnit,
  });
  
  factory MedicationStrength.fromJson(Map<String, dynamic> json) =>
      _$MedicationStrengthFromJson(json);
  Map<String, dynamic> toJson() => _$MedicationStrengthToJson(this);
  
  // Check if this is a concentration (per mL) unit
  bool get isConcentration => [
    StrengthUnit.mcgPerMl,
    StrengthUnit.mgPerMl,
    StrengthUnit.gPerMl,
    StrengthUnit.iuPerMl,
    StrengthUnit.unitsPerMl,
  ].contains(unit);
  
  // Get display string for strength
  String get displayString {
    final unitStr = _getUnitString(unit);
    if (volume != null && volumeUnit != null) {
      final volUnitStr = _getVolumeUnitString(volumeUnit!);
      return '$amount$unitStr per $volume$volUnitStr';
    }
    return '$amount$unitStr';
  }
  
  String _getUnitString(StrengthUnit unit) {
    switch (unit) {
      case StrengthUnit.mcg: return 'mcg';
      case StrengthUnit.mg: return 'mg';
      case StrengthUnit.g: return 'g';
      case StrengthUnit.mcgPerMl: return 'mcg/mL';
      case StrengthUnit.mgPerMl: return 'mg/mL';
      case StrengthUnit.gPerMl: return 'g/mL';
      case StrengthUnit.iu: return 'IU';
      case StrengthUnit.iuPerMl: return 'IU/mL';
      case StrengthUnit.percent: return '%';
      case StrengthUnit.units: return 'U';
      case StrengthUnit.unitsPerMl: return 'U/mL';
    }
  }
  
  String _getVolumeUnitString(VolumeUnit unit) {
    switch (unit) {
      case VolumeUnit.ml: return 'mL';
      case VolumeUnit.cc: return 'cc';
      case VolumeUnit.l: return 'L';
    }
  }
}

@JsonSerializable()
class MedicationInventory {
  final int currentStock;
  final StockUnit stockUnit;
  final int lowStockThreshold;
  
  // For vials with current usage tracking
  final double? currentVialVolume; // Remaining volume in current vial
  final VolumeUnit? currentVialVolumeUnit;
  final double? totalVialVolume; // Total volume when vial is full
  
  // For syringes
  final double? syringeSize; // Size of each syringe
  final VolumeUnit? syringeSizeUnit;
  
  const MedicationInventory({
    required this.currentStock,
    required this.stockUnit,
    required this.lowStockThreshold,
    this.currentVialVolume,
    this.currentVialVolumeUnit,
    this.totalVialVolume,
    this.syringeSize,
    this.syringeSizeUnit,
  });
  
  factory MedicationInventory.fromJson(Map<String, dynamic> json) =>
      _$MedicationInventoryFromJson(json);
  Map<String, dynamic> toJson() => _$MedicationInventoryToJson(this);
  
  bool get isLowStock => currentStock <= lowStockThreshold;
  
  String get displayString {
    final stockUnitStr = _getStockUnitString(stockUnit);
    
    if (stockUnit == StockUnit.vials && currentVialVolume != null && currentVialVolumeUnit != null) {
      final volUnitStr = _getVolumeUnitString(currentVialVolumeUnit!);
      return '$currentStock $stockUnitStr (${currentVialVolume?.toStringAsFixed(1)}$volUnitStr remaining in current vial)';
    }
    
    if (stockUnit == StockUnit.syringes && syringeSize != null && syringeSizeUnit != null) {
      final volUnitStr = _getVolumeUnitString(syringeSizeUnit!);
      return '$currentStock × ${syringeSize}$volUnitStr $stockUnitStr';
    }
    
    return '$currentStock $stockUnitStr';
  }
  
  // Calculate total medication amount available
  double? get totalMedicationVolume {
    if (stockUnit == StockUnit.vials && totalVialVolume != null) {
      final currentVialRemainder = currentVialVolume ?? 0.0;
      final additionalVialsVolume = (currentStock - 1) * totalVialVolume!;
      return currentVialRemainder + additionalVialsVolume;
    }
    
    if (stockUnit == StockUnit.syringes && syringeSize != null) {
      return currentStock * syringeSize!;
    }
    
    if (stockUnit == StockUnit.milliliters) {
      return currentStock.toDouble();
    }
    
    return null;
  }
  
  String _getStockUnitString(StockUnit unit) {
    switch (unit) {
      case StockUnit.tablets: return 'tablets';
      case StockUnit.syringes: return 'syringes';
      case StockUnit.vials: return 'vials';
      case StockUnit.pens: return 'pens';
      case StockUnit.cartridges: return 'cartridges';
      case StockUnit.tubes: return 'tubes';
      case StockUnit.patches: return 'patches';
      case StockUnit.bottles: return 'bottles';
      case StockUnit.milliliters: return 'mL';
    }
  }
  
  String _getVolumeUnitString(VolumeUnit unit) {
    switch (unit) {
      case VolumeUnit.ml: return 'mL';
      case VolumeUnit.cc: return 'cc';
      case VolumeUnit.l: return 'L';
    }
  }
}

@JsonSerializable()
class ReconstitutionInfo {
  final String? solventName; // e.g., "Bacteriostatic Water", "Sterile Saline"
  final double? solventVolume;
  final VolumeUnit? solventVolumeUnit;
  final double? finalConcentration; // Calculated concentration after mixing
  final StrengthUnit? finalConcentrationUnit;
  final double? totalVolume; // Total volume after reconstitution
  final VolumeUnit? totalVolumeUnit;
  final DateTime? reconstitutionDate;
  final int? stabilityDays; // How many days stable after reconstitution
  final double? maxVialCapacity; // Maximum volume the vial can hold
  
  const ReconstitutionInfo({
    this.solventName,
    this.solventVolume,
    this.solventVolumeUnit,
    this.finalConcentration,
    this.finalConcentrationUnit,
    this.totalVolume,
    this.totalVolumeUnit,
    this.reconstitutionDate,
    this.stabilityDays,
    this.maxVialCapacity,
  });
  
  factory ReconstitutionInfo.fromJson(Map<String, dynamic> json) =>
      _$ReconstitutionInfoFromJson(json);
  Map<String, dynamic> toJson() => _$ReconstitutionInfoToJson(this);
  
  bool get isReconstituted => reconstitutionDate != null;
  
  bool get isExpired {
    if (!isReconstituted || stabilityDays == null) return false;
    final expiryDate = reconstitutionDate!.add(Duration(days: stabilityDays!));
    return DateTime.now().isAfter(expiryDate);
  }
  
  DateTime? get expiryDate {
    if (!isReconstituted || stabilityDays == null) return null;
    return reconstitutionDate!.add(Duration(days: stabilityDays!));
  }
  
  String get displayString {
    if (!isReconstituted) return 'Not reconstituted';
    
    final solventStr = solventName ?? 'Unknown solvent';
    final volStr = solventVolume != null && solventVolumeUnit != null 
        ? '${solventVolume}${_getVolumeUnitString(solventVolumeUnit!)}'
        : 'Unknown volume';
    
    return 'Reconstituted with $volStr of $solventStr';
  }
  
  String _getVolumeUnitString(VolumeUnit unit) {
    switch (unit) {
      case VolumeUnit.ml: return 'mL';
      case VolumeUnit.cc: return 'cc';
      case VolumeUnit.l: return 'L';
    }
  }
}

@JsonSerializable()
class ReconstitutionCalculationOption {
  final String name; // "Concentrated", "Standard", "Diluted"
  final double solventVolume;
  final VolumeUnit solventVolumeUnit;
  final double finalConcentration;
  final StrengthUnit finalConcentrationUnit;
  final double doseVolume; // Volume needed for target dose
  final VolumeUnit doseVolumeUnit;
  final double syringeUtilization; // Percentage of syringe used (5-30%, 30-70%, 70-100%)
  
  const ReconstitutionCalculationOption({
    required this.name,
    required this.solventVolume,
    required this.solventVolumeUnit,
    required this.finalConcentration,
    required this.finalConcentrationUnit,
    required this.doseVolume,
    required this.doseVolumeUnit,
    required this.syringeUtilization,
  });
  
  factory ReconstitutionCalculationOption.fromJson(Map<String, dynamic> json) =>
      _$ReconstitutionCalculationOptionFromJson(json);
  Map<String, dynamic> toJson() => _$ReconstitutionCalculationOptionToJson(this);
  
  String get displayString {
    final solventStr = '${solventVolume.toStringAsFixed(1)}${_getVolumeUnitString(solventVolumeUnit)}';
    final concStr = '${finalConcentration.toStringAsFixed(2)}${_getStrengthUnitString(finalConcentrationUnit)}';
    final doseStr = '${doseVolume.toStringAsFixed(2)}${_getVolumeUnitString(doseVolumeUnit)}';
    final utilStr = '${syringeUtilization.toStringAsFixed(0)}%';
    
    return '$name: Add $solventStr → $concStr (Dose: $doseStr, Syringe: $utilStr)';
  }
  
  String _getVolumeUnitString(VolumeUnit unit) {
    switch (unit) {
      case VolumeUnit.ml: return 'mL';
      case VolumeUnit.cc: return 'cc';
      case VolumeUnit.l: return 'L';
    }
  }
  
  String _getStrengthUnitString(StrengthUnit unit) {
    switch (unit) {
      case StrengthUnit.mcg: return 'mcg';
      case StrengthUnit.mg: return 'mg';
      case StrengthUnit.g: return 'g';
      case StrengthUnit.mcgPerMl: return 'mcg/mL';
      case StrengthUnit.mgPerMl: return 'mg/mL';
      case StrengthUnit.gPerMl: return 'g/mL';
      case StrengthUnit.iu: return 'IU';
      case StrengthUnit.iuPerMl: return 'IU/mL';
      case StrengthUnit.percent: return '%';
      case StrengthUnit.units: return 'U';
      case StrengthUnit.unitsPerMl: return 'U/mL';
    }
  }
}

@JsonSerializable()
class EnhancedMedication {
  final String id;
  final String name;
  final MedicationType type;
  final InjectionSubType? injectionSubType;
  final MedicationStrength strength;
  final MedicationInventory inventory;
  final DateTime? expirationDate;
  final ReconstitutionInfo? reconstitutionInfo;
  final String? notes;
  final DateTime createdAt;
  final DateTime updatedAt;

  const EnhancedMedication({
    required this.id,
    required this.name,
    required this.type,
    this.injectionSubType,
    required this.strength,
    required this.inventory,
    this.expirationDate,
    this.reconstitutionInfo,
    this.notes,
    required this.createdAt,
    required this.updatedAt,
  });

  factory EnhancedMedication.fromJson(Map<String, dynamic> json) =>
      _$EnhancedMedicationFromJson(json);

  Map<String, dynamic> toJson() => _$EnhancedMedicationToJson(this);

  EnhancedMedication copyWith({
    String? id,
    String? name,
    MedicationType? type,
    InjectionSubType? injectionSubType,
    MedicationStrength? strength,
    MedicationInventory? inventory,
    DateTime? expirationDate,
    ReconstitutionInfo? reconstitutionInfo,
    String? notes,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return EnhancedMedication(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      injectionSubType: injectionSubType ?? this.injectionSubType,
      strength: strength ?? this.strength,
      inventory: inventory ?? this.inventory,
      expirationDate: expirationDate ?? this.expirationDate,
      reconstitutionInfo: reconstitutionInfo ?? this.reconstitutionInfo,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
  
  // Helper methods
  bool get requiresReconstitution => 
      type == MedicationType.injection && 
      injectionSubType == InjectionSubType.lyophilizedPowder &&
      (reconstitutionInfo?.isReconstituted != true);
      
  bool get isInjectable => type == MedicationType.injection || type == MedicationType.peptide;
  
  bool get isExpired {
    final now = DateTime.now();
    if (expirationDate != null && now.isAfter(expirationDate!)) return true;
    if (reconstitutionInfo?.isExpired == true) return true;
    return false;
  }
  
  bool get isLowStock => inventory.isLowStock;
  
  bool get isExpiringSoon {
    if (expirationDate == null) return false;
    final daysUntilExpiration = expirationDate!.difference(DateTime.now()).inDays;
    return daysUntilExpiration <= 30 && daysUntilExpiration >= 0;
  }
  
  String get typeDisplayName {
    switch (type) {
      case MedicationType.tablet: return 'Tablet';
      case MedicationType.capsule: return 'Capsule';
      case MedicationType.liquid: return 'Liquid';
      case MedicationType.injection: return _getInjectionDisplayName();
      case MedicationType.peptide: return 'Peptide';
      case MedicationType.cream: return 'Cream';
      case MedicationType.patch: return 'Patch';
      case MedicationType.inhaler: return 'Inhaler';
      case MedicationType.drops: return 'Drops';
      case MedicationType.spray: return 'Spray';
    }
  }
  
  String _getInjectionDisplayName() {
    if (injectionSubType == null) return 'Injection';
    switch (injectionSubType!) {
      case InjectionSubType.preFilledSyringe: return 'Pre-filled Syringe';
      case InjectionSubType.readyToUseVial: return 'Ready-to-use Vial';
      case InjectionSubType.lyophilizedPowder: return 'Lyophilized Powder';
      case InjectionSubType.injectionPen: return 'Injection Pen';
    }
  }
  
  // Get available strength units for this medication type
  List<StrengthUnit> get availableStrengthUnits {
    switch (type) {
      case MedicationType.tablet:
      case MedicationType.capsule:
        return [StrengthUnit.mcg, StrengthUnit.mg, StrengthUnit.g, StrengthUnit.iu];
        
      case MedicationType.liquid:
        return [StrengthUnit.mcgPerMl, StrengthUnit.mgPerMl, StrengthUnit.gPerMl, 
                StrengthUnit.percent, StrengthUnit.iuPerMl, StrengthUnit.unitsPerMl];
                
      case MedicationType.injection:
        if (injectionSubType == InjectionSubType.preFilledSyringe) {
          return [StrengthUnit.mcgPerMl, StrengthUnit.mgPerMl, StrengthUnit.gPerMl, 
                  StrengthUnit.iuPerMl, StrengthUnit.unitsPerMl];
        } else {
          return [StrengthUnit.mcg, StrengthUnit.mg, StrengthUnit.g, StrengthUnit.iu,
                  StrengthUnit.mcgPerMl, StrengthUnit.mgPerMl, StrengthUnit.gPerMl, 
                  StrengthUnit.iuPerMl, StrengthUnit.unitsPerMl];
        }
        
      case MedicationType.peptide:
        return [StrengthUnit.mcg, StrengthUnit.mg, StrengthUnit.iu,
                StrengthUnit.mcgPerMl, StrengthUnit.mgPerMl, StrengthUnit.iuPerMl];
                
      case MedicationType.cream:
        return [StrengthUnit.percent, StrengthUnit.mgPerMl, StrengthUnit.mcgPerMl];
        
      case MedicationType.patch:
        return [StrengthUnit.mg, StrengthUnit.mcg];
        
      case MedicationType.inhaler:
      case MedicationType.drops:
      case MedicationType.spray:
        return [StrengthUnit.mcgPerMl, StrengthUnit.mgPerMl, StrengthUnit.percent];
    }
  }
  
  // Get available stock units for this medication type
  List<StockUnit> get availableStockUnits {
    switch (type) {
      case MedicationType.tablet:
        return [StockUnit.tablets];
      case MedicationType.capsule:
        return [StockUnit.tablets]; // Using tablets enum for capsules
      case MedicationType.liquid:
        return [StockUnit.bottles, StockUnit.milliliters];
      case MedicationType.injection:
        switch (injectionSubType) {
          case InjectionSubType.preFilledSyringe:
            return [StockUnit.syringes];
          case InjectionSubType.readyToUseVial:
          case InjectionSubType.lyophilizedPowder:
            return [StockUnit.vials];
          case InjectionSubType.injectionPen:
            return [StockUnit.pens, StockUnit.cartridges];
          default:
            return [StockUnit.vials, StockUnit.syringes];
        }
      case MedicationType.peptide:
        return [StockUnit.vials];
      case MedicationType.cream:
        return [StockUnit.tubes];
      case MedicationType.patch:
        return [StockUnit.patches];
      case MedicationType.inhaler:
      case MedicationType.drops:
      case MedicationType.spray:
        return [StockUnit.bottles];
    }
  }
}

// Helper class for dose calculations
class DoseCalculator {
  // Calculate how many tablets/capsules needed for a dose
  static double calculateTabletDose({
    required double targetDose,
    required StrengthUnit targetDoseUnit,
    required MedicationStrength medicationStrength,
  }) {
    // Convert both to same unit and calculate ratio
    final targetInMg = _convertToMg(targetDose, targetDoseUnit);
    final strengthInMg = _convertToMg(medicationStrength.amount, medicationStrength.unit);
    
    if (targetInMg == null || strengthInMg == null) return 0.0;
    
    return targetInMg / strengthInMg;
  }
  
  // Calculate volume needed for liquid/injection dose
  static double calculateVolumeDose({
    required double targetDose,
    required StrengthUnit targetDoseUnit,
    required MedicationStrength medicationStrength,
  }) {
    if (!medicationStrength.isConcentration) return 0.0;
    
    final targetInMg = _convertToMg(targetDose, targetDoseUnit);
    final concentrationInMgPerMl = _convertToMgPerMl(
      medicationStrength.amount, 
      medicationStrength.unit
    );
    
    if (targetInMg == null || concentrationInMgPerMl == null) return 0.0;
    
    return targetInMg / concentrationInMgPerMl;
  }
  
  static double? _convertToMg(double amount, StrengthUnit unit) {
    switch (unit) {
      case StrengthUnit.mcg: return amount / 1000;
      case StrengthUnit.mg: return amount;
      case StrengthUnit.g: return amount * 1000;
      default: return null; // Cannot convert concentration units without volume
    }
  }
  
  static double? _convertToMgPerMl(double amount, StrengthUnit unit) {
    switch (unit) {
      case StrengthUnit.mcgPerMl: return amount / 1000;
      case StrengthUnit.mgPerMl: return amount;
      case StrengthUnit.gPerMl: return amount * 1000;
      default: return null;
    }
  }
}
