import '../../../core/data/models/enhanced_medication.dart';

class EnhancedReconstitutionCalculator {
  
  /// Calculate reconstitution options for lyophilized powder
  /// Returns up to 3 options: Concentrated, Standard, and Diluted
  /// Each option fits within the target syringe size with utilization between:
  /// - Concentrated: 5-30% of syringe
  /// - Standard: 30-70% of syringe  
  /// - Diluted: 70-100% of syringe
  static List<ReconstitutionCalculationOption> calculateOptions({
    required double powderAmount,           // Amount of active ingredient in vial
    required StrengthUnit powderUnit,       // Unit of active ingredient (mg, mcg, IU)
    required double targetDose,             // Desired dose amount
    required StrengthUnit targetDoseUnit,   // Unit of desired dose
    required SyringeSize targetSyringe,     // Syringe size to use
    required double? maxVialCapacity,       // Maximum volume vial can hold (mL)
    String solventName = 'Bacteriostatic Water',
  }) {
    final syringeVolumeInMl = targetSyringe.volumeInMl;
    final maxCapacity = maxVialCapacity ?? syringeVolumeInMl * 2; // Default to 2x syringe if not specified
    
    // Convert powder and target dose to same unit (mg for calculation)
    final powderInMg = _convertToMg(powderAmount, powderUnit);
    final targetDoseInMg = _convertToMg(targetDose, targetDoseUnit);
    
    if (powderInMg == null || targetDoseInMg == null) {
      return [];
    }
    
    final options = <ReconstitutionCalculationOption>[];
    
    // Calculate the three concentration levels
    // We want dose volumes that fit in: 5-30%, 30-70%, 70-100% of syringe
    
    // Concentrated option (5-30% of syringe)
    final concentratedDoseVolume = _findOptimalVolume(
      syringeVolumeInMl * 0.05, // 5% minimum
      syringeVolumeInMl * 0.30, // 30% maximum
    );
    
    if (concentratedDoseVolume != null) {
      final concentratedOption = _createOption(
        name: 'Concentrated',
        doseVolume: concentratedDoseVolume,
        targetDoseInMg: targetDoseInMg,
        powderInMg: powderInMg,
        maxCapacity: maxCapacity,
        solventName: solventName,
        syringeVolumeInMl: syringeVolumeInMl,
      );
      if (concentratedOption != null) options.add(concentratedOption);
    }
    
    // Standard option (30-70% of syringe)
    final standardDoseVolume = _findOptimalVolume(
      syringeVolumeInMl * 0.30, // 30% minimum
      syringeVolumeInMl * 0.70, // 70% maximum
    );
    
    if (standardDoseVolume != null) {
      final standardOption = _createOption(
        name: 'Standard',
        doseVolume: standardDoseVolume,
        targetDoseInMg: targetDoseInMg,
        powderInMg: powderInMg,
        maxCapacity: maxCapacity,
        solventName: solventName,
        syringeVolumeInMl: syringeVolumeInMl,
      );
      if (standardOption != null) options.add(standardOption);
    }
    
    // Diluted option (70-100% of syringe)
    final dilutedDoseVolume = _findOptimalVolume(
      syringeVolumeInMl * 0.70, // 70% minimum
      syringeVolumeInMl * 1.00, // 100% maximum
    );
    
    if (dilutedDoseVolume != null) {
      final dilutedOption = _createOption(
        name: 'Diluted',
        doseVolume: dilutedDoseVolume,
        targetDoseInMg: targetDoseInMg,
        powderInMg: powderInMg,
        maxCapacity: maxCapacity,
        solventName: solventName,
        syringeVolumeInMl: syringeVolumeInMl,
      );
      if (dilutedOption != null) options.add(dilutedOption);
    }
    
    return options;
  }
  
  /// Find optimal volume within range, preferring round numbers
  static double? _findOptimalVolume(double minVolume, double maxVolume) {
    // Prefer round numbers: 0.1, 0.2, 0.25, 0.3, 0.4, 0.5, 0.6, 0.75, 0.8, 0.9, 1.0, etc.
    final preferredVolumes = [
      0.1, 0.15, 0.2, 0.25, 0.3, 0.35, 0.4, 0.45, 0.5, 
      0.55, 0.6, 0.65, 0.7, 0.75, 0.8, 0.85, 0.9, 0.95, 1.0,
      1.1, 1.2, 1.25, 1.3, 1.4, 1.5, 1.6, 1.75, 1.8, 1.9, 2.0,
      2.2, 2.4, 2.5, 2.6, 2.8, 3.0, 3.2, 3.5, 3.8, 4.0, 4.5, 5.0,
      5.5, 6.0, 6.5, 7.0, 7.5, 8.0, 8.5, 9.0, 9.5, 10.0
    ];
    
    // Find the best preferred volume within range
    for (final volume in preferredVolumes) {
      if (volume >= minVolume && volume <= maxVolume) {
        return volume;
      }
    }
    
    // If no preferred volume fits, use the midpoint rounded to nearest 0.05
    final midpoint = (minVolume + maxVolume) / 2;
    return _roundToNearest(midpoint, 0.05);
  }
  
  /// Create a reconstitution option
  static ReconstitutionCalculationOption? _createOption({
    required String name,
    required double doseVolume,
    required double targetDoseInMg,
    required double powderInMg,
    required double maxCapacity,
    required String solventName,
    required double syringeVolumeInMl,
  }) {
    // Calculate required concentration: dose (mg) / dose volume (mL) = mg/mL
    final requiredConcentration = targetDoseInMg / doseVolume;
    
    // Calculate solvent volume needed: total volume = powder volume + solvent volume
    // Assume powder adds minimal volume, so total volume ≈ solvent volume
    // total concentration = powder (mg) / total volume (mL)
    // We need: powder (mg) / total volume (mL) = required concentration (mg/mL)
    // Therefore: total volume = powder (mg) / required concentration (mg/mL)
    final totalVolume = powderInMg / requiredConcentration;
    
    // Check if total volume fits in vial capacity
    if (totalVolume > maxCapacity) {
      return null; // Cannot fit in vial
    }
    
    // Solvent volume = total volume (assuming powder adds no volume)
    final solventVolume = _roundToNearest(totalVolume, 0.1);
    
    // Recalculate actual concentration with rounded solvent volume
    final actualConcentration = powderInMg / solventVolume;
    
    // Recalculate actual dose volume needed
    final actualDoseVolume = targetDoseInMg / actualConcentration;
    
    // Calculate syringe utilization percentage
    final syringeUtilization = (actualDoseVolume / syringeVolumeInMl) * 100;
    
    return ReconstitutionCalculationOption(
      name: name,
      solventVolume: solventVolume,
      solventVolumeUnit: VolumeUnit.ml,
      finalConcentration: actualConcentration,
      finalConcentrationUnit: StrengthUnit.mgPerMl,
      doseVolume: _roundToNearest(actualDoseVolume, 0.01),
      doseVolumeUnit: VolumeUnit.ml,
      syringeUtilization: syringeUtilization,
    );
  }
  
  /// Adjust an existing option by nudging the solvent volume
  static ReconstitutionCalculationOption? adjustOption({
    required ReconstitutionCalculationOption baseOption,
    required double newSolventVolume,
    required double powderAmount,
    required StrengthUnit powderUnit,
    required double targetDose,
    required StrengthUnit targetDoseUnit,
    required SyringeSize targetSyringe,
  }) {
    final powderInMg = _convertToMg(powderAmount, powderUnit);
    final targetDoseInMg = _convertToMg(targetDose, targetDoseUnit);
    final syringeVolumeInMl = targetSyringe.volumeInMl;
    
    if (powderInMg == null || targetDoseInMg == null) return null;
    
    // Calculate new concentration and dose volume
    final newConcentration = powderInMg / newSolventVolume;
    final newDoseVolume = targetDoseInMg / newConcentration;
    final newSyringeUtilization = (newDoseVolume / syringeVolumeInMl) * 100;
    
    return ReconstitutionCalculationOption(
      name: baseOption.name,
      solventVolume: _roundToNearest(newSolventVolume, 0.1),
      solventVolumeUnit: baseOption.solventVolumeUnit,
      finalConcentration: _roundToNearest(newConcentration, 0.01),
      finalConcentrationUnit: baseOption.finalConcentrationUnit,
      doseVolume: _roundToNearest(newDoseVolume, 0.01),
      doseVolumeUnit: baseOption.doseVolumeUnit,
      syringeUtilization: newSyringeUtilization,
    );
  }
  
  /// Convert various strength units to mg for calculation
  static double? _convertToMg(double amount, StrengthUnit unit) {
    switch (unit) {
      case StrengthUnit.mcg:
        return amount / 1000; // 1000 mcg = 1 mg
      case StrengthUnit.mg:
        return amount;
      case StrengthUnit.g:
        return amount * 1000; // 1 g = 1000 mg
      case StrengthUnit.iu:
        // IU conversion is medication-specific, for now assume 1:1 with mg
        // In real implementation, this would need medication-specific conversion factors
        return amount;
      default:
        return null; // Cannot convert concentration units without volume
    }
  }
  
  /// Round number to nearest increment
  static double _roundToNearest(double value, double increment) {
    return (value / increment).round() * increment;
  }
  
  /// Validate that a reconstitution option is feasible
  static bool validateOption({
    required ReconstitutionCalculationOption option,
    required double maxVialCapacity,
    required SyringeSize targetSyringe,
  }) {
    // Check vial capacity
    if (option.solventVolume > maxVialCapacity) return false;
    
    // Check syringe capacity
    if (option.doseVolume > targetSyringe.volumeInMl) return false;
    
    // Check reasonable utilization (5-100%)
    if (option.syringeUtilization < 5 || option.syringeUtilization > 100) return false;
    
    return true;
  }
  
  /// Create reconstitution info from selected option
  static ReconstitutionInfo createReconstitutionInfo({
    required ReconstitutionCalculationOption selectedOption,
    String solventName = 'Bacteriostatic Water',
    int stabilityDays = 28, // Default 28 days for most peptides
  }) {
    return ReconstitutionInfo(
      solventName: solventName,
      solventVolume: selectedOption.solventVolume,
      solventVolumeUnit: selectedOption.solventVolumeUnit,
      finalConcentration: selectedOption.finalConcentration,
      finalConcentrationUnit: selectedOption.finalConcentrationUnit,
      totalVolume: selectedOption.solventVolume, // Assuming powder adds no volume
      totalVolumeUnit: selectedOption.solventVolumeUnit,
      reconstitutionDate: DateTime.now(),
      stabilityDays: stabilityDays,
    );
  }
  
  /// Get common solvents for reconstitution
  static List<String> getCommonSolvents() {
    return [
      'Bacteriostatic Water',
      'Sterile Water',
      'Normal Saline (0.9% NaCl)',
      'Sterile Saline',
      'Lidocaine (if specified)',
    ];
  }
  
  /// Get stability days for common medication types
  static int getStabilityDays(MedicationType type) {
    switch (type) {
      case MedicationType.peptide:
        return 28; // Most peptides stable for 28 days when refrigerated
      case MedicationType.injection:
        return 14; // Conservative estimate for general injections
      default:
        return 7; // Very conservative for unknown types
    }
  }
}

/// Helper class for syringe recommendations
class SyringeRecommendations {
  /// Get recommended syringe sizes based on expected dose volume
  static List<SyringeSize> getRecommendedSyringes({
    required double expectedDoseVolume,
    required MedicationType medicationType,
    bool preferInsulinSyringes = false,
  }) {
    final recommendations = <SyringeSize>[];
    
    // For very small volumes (<= 1mL), recommend insulin syringes
    if (expectedDoseVolume <= 1.0 || preferInsulinSyringes) {
      if (expectedDoseVolume <= 0.3) {
        recommendations.add(SyringeSize.insulin_0_3ml);
      }
      if (expectedDoseVolume <= 0.5) {
        recommendations.add(SyringeSize.insulin_0_5ml);
      }
      if (expectedDoseVolume <= 1.0) {
        recommendations.add(SyringeSize.insulin_1ml);
      }
    }
    
    // Add standard syringes based on volume
    if (expectedDoseVolume <= 1.0) {
      recommendations.add(SyringeSize.standard_1ml);
    }
    if (expectedDoseVolume <= 3.0) {
      recommendations.add(SyringeSize.standard_3ml);
    }
    if (expectedDoseVolume <= 5.0) {
      recommendations.add(SyringeSize.standard_5ml);
    }
    if (expectedDoseVolume <= 10.0) {
      recommendations.add(SyringeSize.standard_10ml);
    }
    if (expectedDoseVolume <= 20.0) {
      recommendations.add(SyringeSize.standard_20ml);
    }
    
    // Remove duplicates and sort by volume
    final uniqueRecommendations = recommendations.toSet().toList();
    uniqueRecommendations.sort((a, b) => a.volumeInMl.compareTo(b.volumeInMl));
    
    return uniqueRecommendations;
  }
  
  /// Get all available syringe sizes
  static List<SyringeSize> getAllSyringes() {
    return SyringeSize.values;
  }
  
  /// Check if syringe is suitable for medication type
  static bool isSyringeSuitable({
    required SyringeSize syringe,
    required MedicationType medicationType,
    required double expectedDoseVolume,
  }) {
    // Volume check
    if (expectedDoseVolume > syringe.volumeInMl) return false;
    
    // Type-specific recommendations
    switch (medicationType) {
      case MedicationType.peptide:
        // Peptides often require precise small volumes
        return expectedDoseVolume >= syringe.volumeInMl * 0.05; // At least 5% utilization
        
      case MedicationType.injection:
        // General injections are more flexible
        return expectedDoseVolume >= syringe.volumeInMl * 0.05; // At least 5% utilization
        
      default:
        return true;
    }
  }
}
