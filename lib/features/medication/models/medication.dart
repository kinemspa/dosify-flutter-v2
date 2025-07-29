import '../../../core/utils/number_formatter.dart';

enum MedicationType {
  tablet,
  capsule,
  injection,
  topical,
  liquid;

  String get displayName {
    switch (this) {
      case MedicationType.tablet:
        return 'Tablet';
      case MedicationType.capsule:
        return 'Capsule';
      case MedicationType.injection:
        return 'Injection';
      case MedicationType.topical:
        return 'Topical';
      case MedicationType.liquid:
        return 'Liquid';
    }
  }
}

enum InjectionSubtype {
  prefilledSyringe,
  preconstitutedVial,
  injectionPenPrefilled,
  injectionPenManual,
  lyophilizedVial;

  String get displayName {
    switch (this) {
      case InjectionSubtype.prefilledSyringe:
        return 'Pre-filled Syringe';
      case InjectionSubtype.preconstitutedVial:
        return 'Pre-constituted Vial';
      case InjectionSubtype.injectionPenPrefilled:
        return 'Injection Pen (Pre-filled)';
      case InjectionSubtype.injectionPenManual:
        return 'Injection Pen (Manually filled)';
      case InjectionSubtype.lyophilizedVial:
        return 'Lyophilized Vial';
    }
  }
}

enum StrengthUnit {
  mg,
  mcg,
  g,
  ml,
  iu,
  units,
  cc;

  String get displayName {
    switch (this) {
      case StrengthUnit.mg:
        return 'mg';
      case StrengthUnit.mcg:
        return 'mcg';
      case StrengthUnit.g:
        return 'g';
      case StrengthUnit.ml:
        return 'ml';
      case StrengthUnit.iu:
        return 'IU';
      case StrengthUnit.units:
        return 'Units';
      case StrengthUnit.cc:
        return 'CC';
    }
  }
}

class Medication {
  final String id;
  final String name;
  final MedicationType type;
  final InjectionSubtype? injectionSubtype; // For injections only
  final double strength; // Strength per unit (tablet/capsule) or per ml/syringe
  final StrengthUnit strengthUnit;
  final String? manufacturer;
  final String? description;
  final String? notes;
  final DateTime? expirationDate;
  final String? lotNumber;
  final int currentStock;
  final int? minimumStock;
  final String? storageInstructions;
  final bool requiresRefrigeration;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Medication({
    required this.id,
    required this.name,
    required this.type,
    this.injectionSubtype,
    required this.strength,
    required this.strengthUnit,
    this.manufacturer,
    this.description,
    this.notes,
    this.expirationDate,
    this.lotNumber,
    required this.currentStock,
    this.minimumStock,
    this.storageInstructions,
    this.requiresRefrigeration = false,
    required this.createdAt,
    required this.updatedAt,
  });

  // Display strength with unit
  String get displayStrength {
    return NumberFormatter.formatStrength(strength, strengthUnit.displayName);
  }

  // Get stock display based on type
  String get stockDisplay {
    switch (type) {
      case MedicationType.tablet:
        return '$currentStock Tablets';
      case MedicationType.capsule:
        return '$currentStock Capsules';
      case MedicationType.injection:
        if (injectionSubtype == InjectionSubtype.prefilledSyringe) {
          return '$currentStock Syringes';
        } else {
          return '$currentStock ${strengthUnit.displayName}';
        }
      case MedicationType.topical:
        return '$currentStock Units';
      case MedicationType.liquid:
        return '$currentStock ml';
    }
  }

  // Calculate total medication amount
  double get totalMedicationAmount {
    switch (type) {
      case MedicationType.tablet:
      case MedicationType.capsule:
        return currentStock * strength;
      case MedicationType.injection:
        if (injectionSubtype == InjectionSubtype.prefilledSyringe) {
          return currentStock * strength; // Each syringe contains 'strength' amount
        } else {
          return currentStock.toDouble(); // For vials, stock is in ml/units
        }
      case MedicationType.topical:
      case MedicationType.liquid:
        return currentStock * strength;
    }
  }

  // Display total medication with proper unit
  String get totalMedicationDisplay {
    final total = totalMedicationAmount;
    return '${total.toStringAsFixed(total.truncateToDouble() == total ? 0 : 1)} ${strengthUnit.displayName}';
  }

  // Summary for helper text
  String get summaryText {
    final typeText = injectionSubtype != null 
        ? '${injectionSubtype!.displayName}' 
        : '${type.displayName}s';
    
    return '$name $typeText. $displayStrength each ${_getUnitText()}. Total of $stockDisplay in stock. $totalMedicationDisplay of $name in total.';
  }

  String _getUnitText() {
    switch (type) {
      case MedicationType.tablet:
        return 'tablet';
      case MedicationType.capsule:
        return 'capsule';
      case MedicationType.injection:
        return injectionSubtype == InjectionSubtype.prefilledSyringe ? 'syringe' : 'ml';
      case MedicationType.topical:
      case MedicationType.liquid:
        return 'unit';
    }
  }

  bool get isLowStock {
    if (minimumStock == null) return false;
    return currentStock <= minimumStock!;
  }

  bool get isExpired {
    if (expirationDate == null) return false;
    return DateTime.now().isAfter(expirationDate!);
  }

  bool get isExpiringSoon {
    if (expirationDate == null) return false;
    final daysUntilExpiration = expirationDate!.difference(DateTime.now()).inDays;
    return daysUntilExpiration <= 30 && daysUntilExpiration >= 0;
  }

  @override
  String toString() {
    return 'Medication{name: $name, type: ${type.displayName}, strength: $displayStrength}';
  }

  Medication copyWith({
    String? id,
    String? name,
    MedicationType? type,
    InjectionSubtype? injectionSubtype,
    double? strength,
    StrengthUnit? strengthUnit,
    String? manufacturer,
    String? description,
    String? notes,
    DateTime? expirationDate,
    String? lotNumber,
    int? currentStock,
    int? minimumStock,
    String? storageInstructions,
    bool? requiresRefrigeration,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Medication(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      injectionSubtype: injectionSubtype ?? this.injectionSubtype,
      strength: strength ?? this.strength,
      strengthUnit: strengthUnit ?? this.strengthUnit,
      manufacturer: manufacturer ?? this.manufacturer,
      description: description ?? this.description,
      notes: notes ?? this.notes,
      expirationDate: expirationDate ?? this.expirationDate,
      lotNumber: lotNumber ?? this.lotNumber,
      currentStock: currentStock ?? this.currentStock,
      minimumStock: minimumStock ?? this.minimumStock,
      storageInstructions: storageInstructions ?? this.storageInstructions,
      requiresRefrigeration: requiresRefrigeration ?? this.requiresRefrigeration,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

// Helper class for form data
class MedicationFormData {
  String name = '';
  MedicationType type = MedicationType.tablet;
  InjectionSubtype? injectionSubtype;
  double? strength;
  StrengthUnit strengthUnit = StrengthUnit.mg;
  String manufacturer = '';
  String description = '';
  String notes = '';
  DateTime? expirationDate;
  String lotNumber = '';
  int currentStock = 0;
  int? minimumStock;
  String storageInstructions = '';
  bool requiresRefrigeration = false;

  bool get isValid {
    return name.isNotEmpty && 
           strength != null && 
           strength! > 0 && 
           currentStock >= 0 &&
           (type != MedicationType.injection || injectionSubtype != null);
  }

  // Get available strength units based on medication type
  List<StrengthUnit> get availableStrengthUnits {
    switch (type) {
      case MedicationType.tablet:
      case MedicationType.capsule:
        // Tablets and capsules should not have injection-specific units
        return [StrengthUnit.mg, StrengthUnit.mcg, StrengthUnit.g, StrengthUnit.iu, StrengthUnit.units];
      case MedicationType.injection:
        // Injection units depend on the subtype
        switch (injectionSubtype) {
          case InjectionSubtype.prefilledSyringe:
            // Pre-filled syringes usually contain total amount per syringe
            return [StrengthUnit.mg, StrengthUnit.mcg, StrengthUnit.g, StrengthUnit.iu, StrengthUnit.units];
          case InjectionSubtype.preconstitutedVial:
          case InjectionSubtype.lyophilizedVial:
            // Vials are usually concentration per mL
            return [StrengthUnit.mg, StrengthUnit.mcg, StrengthUnit.g, StrengthUnit.iu, StrengthUnit.units];
          case InjectionSubtype.injectionPenPrefilled:
          case InjectionSubtype.injectionPenManual:
            // Pens usually specify units per dose
            return [StrengthUnit.iu, StrengthUnit.units, StrengthUnit.mg, StrengthUnit.mcg];
          case null:
            return [StrengthUnit.mg, StrengthUnit.mcg, StrengthUnit.g, StrengthUnit.iu, StrengthUnit.units];
        }
      case MedicationType.topical:
        // Topical medications are usually concentrations
        return [StrengthUnit.mg, StrengthUnit.mcg, StrengthUnit.g];
      case MedicationType.liquid:
        // Liquid medications are usually concentration per mL
        return [StrengthUnit.mg, StrengthUnit.mcg, StrengthUnit.g, StrengthUnit.iu, StrengthUnit.units];
    }
  }

  // Get stock label based on type
  String get stockLabel {
    switch (type) {
      case MedicationType.tablet:
        return 'Tablets in Stock';
      case MedicationType.capsule:
        return 'Capsules in Stock';
      case MedicationType.injection:
        if (injectionSubtype == InjectionSubtype.prefilledSyringe) {
          return 'Syringes in Stock';
        } else {
          return '${strengthUnit.displayName} in Stock';
        }
      case MedicationType.topical:
      case MedicationType.liquid:
        return 'Units in Stock';
    }
  }

  // Generate preview text for the helper
  String get previewText {
    if (name.isEmpty) {
      return 'Enter medication name to begin...';
    }
    
    if (strength == null || strength! <= 0) {
      return 'Enter strength information to see detailed preview...';
    }

    final medicationName = name.trim();
    final strengthDisplay = NumberFormatter.formatStrength(strength!, strengthUnit.displayName);
    
    // Build pharmaceutical description
    String pharmaceuticalForm = '';
    String inventoryUnit = '';
    String inventoryPlural = '';
    
    switch (type) {
      case MedicationType.tablet:
        pharmaceuticalForm = 'oral tablet';
        inventoryUnit = 'tablet';
        inventoryPlural = 'tablets';
        break;
      case MedicationType.capsule:
        pharmaceuticalForm = 'oral capsule';
        inventoryUnit = 'capsule';
        inventoryPlural = 'capsules';
        break;
      case MedicationType.injection:
        switch (injectionSubtype) {
          case InjectionSubtype.prefilledSyringe:
            pharmaceuticalForm = 'prefilled syringe for injection';
            inventoryUnit = 'syringe';
            inventoryPlural = 'syringes';
            break;
          case InjectionSubtype.preconstitutedVial:
            pharmaceuticalForm = 'injectable solution (vial)';
            inventoryUnit = 'vial';
            inventoryPlural = 'vials';
            break;
          case InjectionSubtype.injectionPenPrefilled:
            pharmaceuticalForm = 'injection pen (prefilled)';
            inventoryUnit = 'pen';
            inventoryPlural = 'pens';
            break;
          case InjectionSubtype.injectionPenManual:
            pharmaceuticalForm = 'injection pen (manual)';
            inventoryUnit = 'pen';
            inventoryPlural = 'pens';
            break;
          case InjectionSubtype.lyophilizedVial:
            pharmaceuticalForm = 'lyophilized powder for injection';
            inventoryUnit = 'vial';
            inventoryPlural = 'vials';
            break;
          case null:
            pharmaceuticalForm = 'injectable solution';
            inventoryUnit = 'unit';
            inventoryPlural = 'units';
            break;
        }
        break;
      case MedicationType.topical:
        pharmaceuticalForm = 'topical preparation';
        inventoryUnit = 'unit';
        inventoryPlural = 'units';
        break;
      case MedicationType.liquid:
        pharmaceuticalForm = 'oral liquid';
        inventoryUnit = 'bottle';
        inventoryPlural = 'bottles';
        break;
    }
    
    // Calculate total active ingredient
    double totalActiveIngredient = 0;
    String activeIngredientUnit = strengthUnit.displayName;
    
    if (type == MedicationType.tablet || type == MedicationType.capsule || 
        (type == MedicationType.injection && injectionSubtype == InjectionSubtype.prefilledSyringe)) {
      totalActiveIngredient = currentStock * strength!;
    } else {
      totalActiveIngredient = currentStock.toDouble();
      activeIngredientUnit = inventoryPlural;
    }
    
    // Format inventory count
    final inventoryDescription = NumberFormatter.formatStock(currentStock, inventoryUnit, inventoryPlural);
    final totalIngredientText = NumberFormatter.formatStrength(totalActiveIngredient, activeIngredientUnit);
    
    // Build manufacturer info if available
    final manufacturerText = manufacturer.isNotEmpty ? ' (${manufacturer.trim()})' : '';
    
    // Build comprehensive preview
    String preview = '';
    preview += '$medicationName$manufacturerText\n';
    preview += 'Strength: $strengthDisplay per $inventoryUnit\n';
    preview += 'Pharmaceutical form: $pharmaceuticalForm\n';
    
    if (currentStock > 0) {
      preview += 'Current inventory: $inventoryDescription';
      if (totalActiveIngredient > 0 && activeIngredientUnit != inventoryPlural) {
        preview += ' (total: $totalIngredientText)';
      }
    } else {
      preview += 'No current stock recorded';
    }
    
    // Add storage requirements
    if (requiresRefrigeration) {
      preview += '\n⚠️ Requires refrigeration (2-8°C)';
    }
    
    // Add expiration alert if date is set
    if (expirationDate != null) {
      final daysUntilExpiry = expirationDate!.difference(DateTime.now()).inDays;
      if (daysUntilExpiry <= 30 && daysUntilExpiry > 0) {
        preview += '\n⚠️ Expires in $daysUntilExpiry days';
      } else if (daysUntilExpiry <= 0) {
        preview += '\n🚨 EXPIRED';
      }
    }
    
    return preview;
  }

  Medication toMedication() {
    final now = DateTime.now();
    return Medication(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name.trim(),
      type: type,
      injectionSubtype: injectionSubtype,
      strength: strength!,
      strengthUnit: strengthUnit,
      manufacturer: manufacturer.trim().isEmpty ? null : manufacturer.trim(),
      description: description.trim().isEmpty ? null : description.trim(),
      notes: notes.trim().isEmpty ? null : notes.trim(),
      expirationDate: expirationDate,
      lotNumber: lotNumber.trim().isEmpty ? null : lotNumber.trim(),
      currentStock: currentStock,
      minimumStock: minimumStock,
      storageInstructions: storageInstructions.trim().isEmpty ? null : storageInstructions.trim(),
      requiresRefrigeration: requiresRefrigeration,
      createdAt: now,
      updatedAt: now,
    );
  }
}
