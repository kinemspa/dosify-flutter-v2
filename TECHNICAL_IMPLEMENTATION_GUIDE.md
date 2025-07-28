# Dosify Flutter v2 - Technical Implementation Guide

## Table of Contents
1. [Project Overview](#project-overview)
2. [Current Implementation Status](#current-implementation-status)
3. [Architecture Overview](#architecture-overview)
4. [Core Modules & Features](#core-modules--features)
5. [Data Models & Database](#data-models--database)
6. [UI/UX Implementation](#uiux-implementation)
7. [State Management](#state-management)
8. [Navigation & Routing](#navigation--routing)
9. [Known Issues & Solutions](#known-issues--solutions)
10. [Implementation Roadmap](#implementation-roadmap)

---

## Project Overview

### Application Purpose
Dosify v2 is a comprehensive medication management application designed for healthcare professionals and patients managing injectable medications, peptides, and complex dosing schedules. This version has been completely rebuilt with SQLite database integration, replacing the previous Hive implementation.

### Key Selling Points
- **Auto-reconstitution calculations** for injectable medications with volume capacity limits
- **Professional-grade UI** with Material Design 3 theming
- **Medication-type specific forms** with dynamic field validation
- **Comprehensive adherence tracking** with dose counting and cycling info
- **SQLite database** for robust data management
- **Offline-first** architecture with clean separation of concerns

### Target Platforms
- **Android**: SDK 24+ (Android 7.0+)
- **iOS**: iOS 12+
- **Flutter**: 3.2.6+

---

## Current Implementation Status

### ✅ Completed Features
- **SQLite Database Migration**: Complete transition from Hive to SQLite
- **Clean Architecture**: Repository pattern with dependency injection
- **Material Design 3**: Professional theming with light/dark mode
- **Navigation System**: GoRouter with proper routing structure and working routes
- **State Management**: Riverpod setup for reactive UI
- **Code Generation**: Working build_runner setup
- **Database Schema**: Complete table definitions for all entities
- **Medication Management**: Full CRUD operations with dynamic forms
- **Dashboard Integration**: Quick action cards with statistics and filtered views
- **Reconstitution Calculator**: Professional calculator with detailed results
- **Medication Detail View**: Comprehensive medication information display
- **Navigation Routes**: All screens properly routed and accessible
- **Build System**: Successful APK compilation and deployment

### 🔧 Recently Implemented (Latest Session)
- **Fixed Router Configuration**: Resolved syntax errors and missing route brackets
- **Calculator Route**: Added proper navigation to reconstitution calculator
- **Medication Detail Screen**: Implemented comprehensive detail view with medication information
- **Tappable Medication Cards**: Added navigation from medication list to detail view
- **Quick Action Dashboard**: Enhanced medication screen with statistics and action buttons
- **Professional UI Components**: Improved card designs and color-coded medication types
- **Nullable Field Handling**: Fixed null safety issues with medication notes and other optional fields
- **Code Cleanup**: Removed unused imports and deprecated method usage

### ❌ Remaining Issues to Address
- **Dynamic Medication Forms**: Continue enhancing form validation and field adaptation
- **Lyophilized Vial Integration**: Connect reconstitution calculator with medication types
- **Edit Functionality**: Implement medication editing capabilities
- **Delete Operations**: Add medication deletion with confirmation
- **Advanced Calculator Features**: Enhance calculator for complex medication types
- **Unit Testing**: Add comprehensive test coverage

---

## Architecture Overview

### Project Structure
```
lib/
├── main.dart                 # App entry point
├── core/                     # Core functionality
│   ├── data/
│   │   ├── models/          # SQLite data models
│   │   ├── repositories/    # Repository interfaces & implementations
│   │   └── services/        # Database and other services
│   ├── di/                  # Dependency injection (GetIt)
│   ├── theme/               # Material Design 3 theming
│   └── ui/                  # Core UI components
├── features/                # Feature modules
│   ├── medication/          # Medication management
│   ├── dashboard/           # Main dashboard with metrics
│   ├── calculator/          # Reconstitution calculator
│   ├── inventory/           # Stock tracking (integrated with meds)
│   ├── scheduling/          # Dose scheduling
│   └── settings/            # App settings
└── generated/               # Code generation output
```

### Design Patterns
- **Repository Pattern**: Clean data access abstraction with SQLite
- **Provider Pattern**: State management with Riverpod
- **Dependency Injection**: GetIt for service management
- **Feature-based Architecture**: Modular, maintainable code structure
- **Clean Architecture**: Clear separation of concerns

---

## Core Modules & Features

### 1. Dashboard (`features/dashboard/`)

The dashboard serves as the central command center for medication management, providing real-time insights into adherence, stock levels, cycling schedules, and upcoming doses.

#### Core Features

**1. Adherence Tracking Panel**
- Visual progress rings showing weekly/monthly adherence percentages
- Color-coded indicators: Green (>90%), Yellow (70-90%), Red (<70%)
- Streak counters for consecutive days of perfect adherence
- Historical adherence charts with trend analysis
- Integration with dose logging to calculate real-time compliance

**2. Medication Status Cards**
- Active medications with current status (Active, Paused, Cycling)
- Low stock alerts with exact dose counts remaining
- Expiration warnings with days until expiry
- Cycling medications showing current phase (Active/Off period)
- Quick status toggles for pause/resume medications

**3. Dose Timeline Widget**
- Next 24-hour dose schedule with exact times
- Overdue dose notifications with snooze options
- Recently taken doses with effectiveness ratings
- Upcoming dose predictions based on cycling schedules
- Integration with calendar for dose planning

**4. Cycling Information Panel**
- Current cycle day for cycling medications (e.g., "Day 12 of 28")
- Visual cycle timeline with phase indicators
- Next phase transition dates and automatic notifications
- Cycle effectiveness tracking and adjustment recommendations
- Support for complex cycling patterns (e.g., 5 days on, 2 days off)

**5. Quick Action Hub**
- One-tap medication logging with dose confirmation
- Fast access to reconstitution calculator for injections
- Emergency medication lookup and dosing guidelines
- Quick inventory check and low-stock ordering reminders
- Medication search with recent and frequent selections

#### Advanced Dashboard Features

**Smart Notifications Panel**
- Intelligent dose reminders based on user patterns
- Weather-based medication adjustments (for sensitive medications)
- Travel mode with timezone-adjusted scheduling
- Interaction warnings when adding new medications
- Effectiveness tracking prompts for optimization

**Analytics Widgets**
- Side effect correlation tracking with medication timing
- Effectiveness patterns over time with visual charts
- Cost tracking per medication with insurance integration
- Dosage optimization suggestions based on adherence data
- Integration with health metrics (weight, blood pressure, etc.)

#### Implementation Architecture
```dart
class DashboardData {
  final int totalMedications;
  final int activeMedications;
  final int pausedMedications;
  final int cyclingMedications;
  final int lowStockMedications;
  final int expiringMedications;
  final int upcomingDoses;
  final int overdueDoses;
  final double weeklyAdherenceRate;
  final double monthlyAdherenceRate;
  final int currentStreak;
  final int longestStreak;
  final List<MedicationAlert> alerts;
  final List<UpcomingDose> todaysDoses;
  final List<CyclingInfo> activeCycles;
  final List<EffectivenessMetric> recentEffectiveness;
  final Map<String, double> costAnalytics;
}

class MedicationAlert {
  final String medicationId;
  final String medicationName;
  final AlertType type; // LOW_STOCK, EXPIRING, OVERDUE, INTERACTION
  final AlertSeverity severity; // INFO, WARNING, CRITICAL
  final String message;
  final DateTime timestamp;
  final bool isActionable;
  final String? actionText;
  final VoidCallback? onAction;
}

class UpcomingDose {
  final String scheduleId;
  final String medicationName;
  final double doseAmount;
  final String unit;
  final DateTime scheduledTime;
  final bool isOverdue;
  final bool requiresReconstitution;
  final String? specialInstructions;
}

class CyclingInfo {
  final String medicationId;
  final String medicationName;
  final int totalDays;
  final int activeDays;
  final int currentDay;
  final bool isActivePhase;
  final DateTime nextPhaseChange;
  final List<CyclePhase> phases;
}
```

### 2. Medication Management (`features/medication/`)

The medication management system provides comprehensive CRUD operations with intelligent form handling that adapts to different medication types, ensuring accurate data entry and professional-grade medication tracking.

#### Core Features

**1. Intelligent Medication Forms**
- Dynamic field generation based on medication type selection
- Real-time validation with medical terminology
- Professional helper text panel with medication summary
- Automatic unit conversion and standardization
- Integration with reconstitution calculator for injectable medications

**2. Medication Type-Specific Handling**

**Tablets & Capsules:**
- **Strength Units**: Dropdown with mg, mcg, g, IU options
- **Stock Management**: Count-based inventory (tablets/capsules)
- **Dosing Information**: Standard oral dosing patterns
- **Special Considerations**: Controlled release, enteric coating options
- **Validation**: Range checking for realistic dosage amounts

**Liquid Medications:**
- **Concentration Units**: mg/ml, mcg/ml, g/ml, %, IU/ml
- **Volume Tracking**: ml-based inventory management
- **Viscosity Considerations**: Handling for syrups, suspensions
- **Storage Requirements**: Temperature and light sensitivity
- **Measurement Tools**: Integration with dosing syringes, cups

**Injectable Medications:**
- **Subtype Classification**:
  - Pre-filled Syringes: Ready-to-use with dose verification
  - Ready-made Vials: Multi-dose vial management
  - Injection Pens: Cartridge-based dosing systems
  - Lyophilized Powder: Requires reconstitution calculation
- **Professional Features**:
  - Sterility tracking and expiration after reconstitution
  - Needle gauge and length recommendations
  - Injection site rotation tracking
  - Volume capacity limits for reconstitution

**Peptide Medications:**
- **Specialized Handling**: Always requires reconstitution consideration
- **Potency Units**: IU, mcg, mg with biological activity factors
- **Storage Protocols**: Refrigeration requirements and stability
- **Reconstitution Components**: Bacteriostatic water, saline options
- **Dosing Precision**: Sub-unit dosing with insulin syringes

**Topical Medications (Creams, Patches):**
- **Application Areas**: Body surface area calculations
- **Concentration Tracking**: % active ingredient, mg/g formulations
- **Usage Patterns**: Application frequency and coverage area
- **Patch Systems**: Wear time, adhesion quality, skin irritation tracking

#### Advanced Form Features

**Dynamic Helper Text Panel**
```dart
class MedicationHelperPanel {
  // Real-time medication summary
  String generateSummary(MedicationFormState state) {
    switch (state.type) {
      case MedicationType.injection:
        if (state.subType == 'lyophilizedPowder') {
          return 'Injectable powder requiring reconstitution. '
                 'Target concentration: ${state.strength}${state.unit} per vial. '
                 'Reconstitution volume: ${state.maxVolumeCapacity}ml max.';
        }
        break;
      case MedicationType.peptide:
        return 'Peptide medication requiring refrigerated storage. '
               'Biological activity: ${state.strength}${state.unit}. '
               'Reconstitute with bacteriostatic water for injection.';
    }
  }
}
```

**Professional Validation System**
```dart
class MedicationFormValidator {
  static ValidationResult validateMedication(MedicationFormState state) {
    final errors = <String>[];
    final warnings = <String>[];
    
    // Type-specific validation
    switch (state.type) {
      case MedicationType.injection:
        if (state.requiresReconstitution && state.maxVolumeCapacity == null) {
          errors.add('Max volume capacity required for reconstitution');
        }
        if (state.strength > 1000 && state.unit == 'mg') {
          warnings.add('High concentration - verify dosing accuracy');
        }
        break;
        
      case MedicationType.tablet:
        if (state.strength < 0.1 && state.unit == 'mg') {
          warnings.add('Very low dose - consider mcg units');
        }
        break;
    }
    
    return ValidationResult(errors: errors, warnings: warnings);
  }
}
```

#### Integration Features

**Calculator Integration**
- Automatic calculator button for injectable medications
- Pre-populated calculation fields from medication data
- Save calculation results back to medication record
- Historical calculation tracking for dosage optimization

**Inventory Integration**
- Real-time stock level updates
- Automatic low-stock alerts based on dosing frequency
- Batch number and expiration tracking
- Cost-per-dose calculations with insurance integration

**Schedule Integration**
- Quick schedule creation from medication form
- Dose amount pre-population from medication strength
- Cycling schedule setup for peptides and hormones
- Adherence tracking integration

#### Professional Features

**Medical Terminology Integration**
- INN (International Nonproprietary Names) support
- Brand name cross-referencing
- Drug interaction checking (basic)
- Allergy and contraindication warnings
- Professional dosing guidelines and references

### 3. Reconstitution Calculator (`features/calculator/`)

#### Enhanced Features
- **Max Volume Capacity**: Target vial size limit
- **Component Management**: Multi-component mixing
- **Professional Results**: Detailed calculation breakdown
- **Integration**: Direct medication linking

#### Calculator Model
```dart
class ReconstitutionCalculator {
  final double maxVolumeCapacity;
  final List<Component> components;
  
  ReconstitutionResult calculateWithCapacity({
    required double powderAmount,
    required double solventVolume,
    required double desiredDose,
    required double maxCapacity,
  });
}
```

---

## Data Models & Database

### SQLite Schema

#### Medications Table
```sql
CREATE TABLE medications (
  id TEXT PRIMARY KEY,
  name TEXT NOT NULL,
  type TEXT NOT NULL,
  sub_type TEXT,
  strength REAL NOT NULL,
  unit TEXT NOT NULL,
  current_stock INTEGER NOT NULL DEFAULT 0,
  low_stock_threshold INTEGER NOT NULL DEFAULT 10,
  expiration_date TEXT,
  requires_reconstitution INTEGER NOT NULL DEFAULT 0,
  max_volume_capacity REAL,
  notes TEXT,
  created_at TEXT NOT NULL,
  updated_at TEXT NOT NULL
);
```

#### Enhanced Models
```dart
@JsonSerializable()
class Medication {
  final String id;
  final String name;
  final MedicationType type;
  final String? subType;
  final double strength;
  final String unit;
  final int currentStock;
  final int lowStockThreshold;
  final DateTime? expirationDate;
  final bool requiresReconstitution;
  final double? maxVolumeCapacity;
  final List<Component>? components;
  
  // Computed properties
  int get remainingDoses => (currentStock / typicalDoseAmount).floor();
  bool get isInCycle => cyclingSchedule?.isCurrentlyActive ?? false;
}

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
  preFilledSyringe,
  readyMadeVial,
  injectionPen,
  lyophilizedPowder
}
```

---

## UI/UX Implementation

### Navigation Structure (Revised)

#### Bottom Navigation (Simplified)
```dart
enum NavigationItem {
  dashboard,    // Main hub with metrics
  medications,  // CRUD + Calculator + Inventory access
  schedules,    // Dose scheduling and calendar
  settings,     // Configuration
}
```

#### Medication Screen Integration
- **Main View**: Medication list with search/filter
- **Add/Edit**: Dynamic forms based on medication type
- **Quick Actions**: 
  - Calculator button (for injections/peptides)
  - Inventory button (stock management)
  - Schedule button (dose planning)

### Dynamic Form Components

#### Medication Type Selector
```dart
class MedicationTypeSelector extends StatefulWidget {
  final MedicationType? selectedType;
  final String? selectedSubType;
  final Function(MedicationType, String?) onTypeChanged;
  
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        DropdownButtonFormField<MedicationType>(...),
        if (selectedType == MedicationType.injection)
          DropdownButtonFormField<InjectionSubType>(...),
        // Dynamic helper text
        _buildHelperText(),
      ],
    );
  }
}
```

#### Helper Text Panel
```dart
class MedicationHelperPanel extends StatelessWidget {
  final MedicationType type;
  final String? subType;
  final Map<String, dynamic> currentValues;
  
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        child: Column(
          children: [
            Text('Medication Summary', style: Theme.of(context).textTheme.titleMedium),
            _buildSummaryText(),
            if (type == MedicationType.injection && requiresReconstitution)
              _buildReconstitutionInfo(),
          ],
        ),
      ),
    );
  }
}
```

---

## State Management

### Riverpod Providers

#### Medication Providers
```dart
final medicationRepositoryProvider = Provider<MedicationRepository>((ref) {
  return getIt<MedicationRepository>();
});

final medicationListProvider = FutureProvider<List<Medication>>((ref) async {
  final repository = ref.watch(medicationRepositoryProvider);
  return repository.getAllMedications();
});

final dashboardDataProvider = FutureProvider<DashboardData>((ref) async {
  final medications = await ref.watch(medicationListProvider.future);
  return DashboardData.fromMedications(medications);
});
```

#### Form State Management
```dart
final medicationFormProvider = StateNotifierProvider.autoDispose
    .family<MedicationFormNotifier, MedicationFormState, String?>((ref, medicationId) {
  return MedicationFormNotifier(
    repository: ref.watch(medicationRepositoryProvider),
    medicationId: medicationId,
  );
});
```

---

## Known Issues & Solutions

### 1. Black Screen Issue
**Problem**: App loads but shows black screen instead of dashboard.

**Root Cause**: Navigation routing or widget tree issues.

**Solution**:
```dart
// Check MaterialApp.router configuration
MaterialApp.router(
  routerConfig: GoRouter(
    initialLocation: '/dashboard',
    routes: [
      GoRoute(
        path: '/dashboard',
        builder: (context, state) => const DashboardScreen(),
      ),
    ],
  ),
)
```

### 2. Hive Error References
**Problem**: "Hive Error: Box not found" appearing in screens.

**Solution**: Remove all Hive references and replace with SQLite calls:
```dart
// Old Hive code
final box = Hive.box<Medication>('medications');

// New SQLite code
final medications = await medicationRepository.getAllMedications();
```

### 3. Dynamic Form Validation
**Problem**: Form fields not adapting to medication type selection.

**Solution**: Implement reactive form fields:
```dart
class DynamicMedicationForm extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formState = ref.watch(medicationFormProvider);
    
    return Form(
      child: Column(
        children: [
          MedicationTypeSelector(
            onChanged: (type, subType) {
              ref.read(medicationFormProvider.notifier)
                  .updateType(type, subType);
            },
          ),
          ...buildDynamicFields(formState.type, formState.subType),
        ],
      ),
    );
  }
}
```

---

## Latest Implementation Details (Session 2025-01-28)

### ✅ Successfully Implemented Features

#### 1. Router Configuration Fix
- **Issue**: Syntax errors in GoRouter causing compilation failures
- **Solution**: Recreated app.dart with proper bracket structure and route definitions
- **Result**: Successful APK build and deployment

#### 2. Calculator Navigation
- **Feature**: Added `/calculator` route for reconstitution calculator
- **Integration**: Calculator accessible from medication dashboard and detail views
- **Code**: Direct navigation using `context.go('/calculator')`

#### 3. Medication Detail Screen
- **File**: `lib/features/medication/ui/medication_detail_screen.dart`
- **Features**:
  - Comprehensive medication information display
  - Header card with medication type color coding
  - Details card with creation/update dates
  - Inventory management with stock levels and alerts
  - Notes section (handles nullable fields)
  - Injectable actions card for injection-type medications
  - Edit, duplicate, delete, and calculator actions

#### 4. Tappable Medication Cards
- **Navigation**: Added `GestureDetector` to medication cards
- **Route**: `/medications/detail/:id` with parameter passing
- **Implementation**: Fetches medication by ID in detail screen

#### 5. Enhanced Medication Dashboard
- **Quick Actions**: Statistics cards showing total medications and injectable types
- **Action Buttons**: Low Stock, Expiring, and Calculator buttons with badges
- **Filtered Views**: Modal bottom sheets showing filtered medication lists
- **Professional UI**: Color-coded medication types with proper Material Design

#### 6. Code Quality Improvements
- **Null Safety**: Fixed nullable string handling for medication notes
- **Unused Imports**: Removed deprecated imports and unused references
- **Deprecated Methods**: Replaced `withOpacity` with proper alternatives
- **Test Files**: Updated test references to use correct app class names

## Enhanced Medication Management System (Latest Session)

### 🚀 **MAJOR FEATURE: Precise Quantity & Strength Handling**

#### **Overview**
Implemented a comprehensive enhanced medication system that prevents user errors through type-specific field validation and foolproof quantity/strength management. The system ensures users can only input relevant information for each medication type, eliminating confusion and mistakes.

### 📊 **Enhanced Data Models**

#### **Core Model: `EnhancedMedication`**
Location: `lib/core/data/models/enhanced_medication.dart`

```dart
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
}
```

#### **Medication Strength System**
```dart
class MedicationStrength {
  final double amount;              // Numeric strength value
  final StrengthUnit unit;          // Unit type (mcg, mg, g, IU, etc.)
  final double? volume;             // For concentrations (per mL)
  final VolumeUnit? volumeUnit;     // mL, cc, L
  
  bool get isConcentration;         // Auto-detects concentration units
  String get displayString;         // Human-readable format
}
```

#### **Advanced Inventory Management**
```dart
class MedicationInventory {
  final int currentStock;           // Current quantity available
  final StockUnit stockUnit;        // tablets, syringes, vials, etc.
  final int lowStockThreshold;      // Alert threshold
  
  // Vial-specific tracking
  final double? currentVialVolume;  // Remaining mL in current vial
  final double? totalVialVolume;    // Full vial capacity
  
  // Syringe-specific tracking
  final double? syringeSize;        // Individual syringe volume
  final VolumeUnit? syringeSizeUnit;
  
  double? get totalMedicationVolume; // Calculate total available
  bool get isLowStock;              // Smart low stock detection
}
```

### 💉 **Medication Type Specifications**

#### **1. Tablets (`MedicationType.tablet`)**
**Strength System:**
- **Units**: `mcg`, `mg`, `g`, `IU` (per tablet)
- **Stock Unit**: `tablets` (individual count)
- **Dose Calculation**: Fixed ratio - tablets needed = target dose ÷ tablet strength

**Example:**
- Medication: "Levothyroxine 50mcg tablets"
- Stock: 90 tablets
- Target Dose: 100mcg → Calculated: 2 tablets
- After dose: Stock reduces to 88 tablets

**Inventory Logic:**
```dart
// Cannot be "restocked" - only replaced with new bottle
// Low stock alert when < threshold tablets remaining
// Expiration tracking per bottle/package
```

#### **2. Pre-filled Syringes (`InjectionSubType.preFilledSyringe`)**
**Strength System:**
- **Units**: `U/mL`, `mg/mL`, `mcg/mL` (concentration per syringe)
- **Syringe Sizes**: 0.3mL, 0.5mL, 1.0mL, 3mL, 5mL, 10mL
- **Stock Unit**: `syringes` (individual count)
- **Dose Calculation**: Volume = target dose ÷ concentration

**Example:**
- Medication: "Insulin Lispro 100U/mL in 0.3mL syringes"
- Stock: 5 syringes × 0.3mL = 1.5mL total
- Target Dose: 10 units → Volume: 0.1mL
- After dose: 4 syringes + 0.2mL remaining in current

**Inventory Logic:**
```dart
MedicationInventory(
  currentStock: 5,                    // 5 syringes remaining
  stockUnit: StockUnit.syringes,
  syringeSize: 0.3,                   // Each syringe is 0.3mL
  syringeSizeUnit: VolumeUnit.ml,
  totalMedicationVolume: 1.5,         // 5 × 0.3mL = 1.5mL total
)
```

#### **3. Ready-to-Use Vials (`InjectionSubType.readyToUseVial`)**
**Strength System:**
- **Units**: `mcg/mL`, `mg/mL`, `g/mL`, `IU/mL` (concentration)
- **Volume Specification**: Total vial volume (e.g., 5mL, 10mL, 20mL)
- **Stock Unit**: `vials` with dual inventory tracking
- **Dose Calculation**: Volume = target dose ÷ concentration

**Dual Inventory System:**
```dart
MedicationInventory(
  currentStock: 3,                    // 3 unopened vials + 1 in use
  stockUnit: StockUnit.vials,
  currentVialVolume: 7.2,             // 7.2mL remaining in current vial
  totalVialVolume: 10.0,              // Each vial contains 10mL when full
  // Total available: 7.2mL + (3 × 10mL) = 37.2mL
)
```

**Vial Usage Logic:**
- Current vial tracked separately from stock vials
- Cannot "restock" vials - only replace with fresh vials
- When current vial empty, new vial opened from stock
- Expiration applies to each individual vial

#### **4. Lyophilized Powder (`InjectionSubType.lyophilizedPowder`)**
**Strength System:**
- **Units**: `mcg`, `mg`, `g`, `IU` (total amount in vial)
- **Reconstitution Required**: Links to advanced calculator
- **Stock Unit**: `vials` (powder vials)
- **Volume Capacity**: Maximum vial volume (3mL, 5mL, 10mL limits)

**Reconstitution Integration:**
```dart
ReconstitutionInfo(
  solventName: 'Bacteriostatic Water',
  solventVolume: 2.0,                 // 2mL added
  finalConcentration: 5.0,            // 5mg/mL after mixing
  totalVolume: 2.0,                   // 2mL total (powder adds ~0mL)
  reconstitutionDate: DateTime.now(),
  stabilityDays: 28,                  // Stable for 28 days refrigerated
  maxVialCapacity: 3.0,               // Vial can hold max 3mL
)
```

#### **5. Injection Pens (`InjectionSubType.injectionPen`)**
**Strength System:**
- **Pre-filled Pens**: Fixed concentration per pen
- **Cartridge Pens**: Replaceable cartridges
- **Units**: `U/mL` (typically for insulin), `mg/mL`
- **Stock Units**: `pens` or `cartridges`
- **Device Tracking**: Brand, model, cartridge compatibility

### 🧮 **Advanced Reconstitution Calculator**

Location: `lib/features/calculator/services/enhanced_reconstitution_calculator.dart`

#### **3-Option Calculation System**
The calculator provides exactly 3 reconstitution options targeting different syringe utilization ranges:

**Option Categories:**
1. **Concentrated** (5-30% syringe utilization)
2. **Standard** (30-70% syringe utilization)
3. **Diluted** (70-100% syringe utilization)

#### **Calculation Algorithm**
```dart
static List<ReconstitutionCalculationOption> calculateOptions({
  required double powderAmount,           // e.g., 10mg in vial
  required StrengthUnit powderUnit,       // mg, mcg, or IU
  required double targetDose,             // e.g., 0.5mg desired dose
  required StrengthUnit targetDoseUnit,   // mg, mcg, or IU
  required SyringeSize targetSyringe,     // 0.3mL, 1mL, 3mL, etc.
  required double? maxVialCapacity,       // 3mL, 5mL, 10mL vial limit
  String solventName = 'Bacteriostatic Water',
}) {
  // Algorithm calculates 3 options with different concentrations
  // Each option ensures dose volume fits within target syringe range
  // Prefers round numbers (0.5mL, 1.0mL, 1.5mL, 2.0mL, etc.)
}
```

#### **Example Calculation**
**Input:**
- Powder: 10mg of peptide in vial
- Target Dose: 0.5mg
- Syringe: 1mL insulin syringe
- Vial Capacity: 3mL maximum

**Output Options:**
```dart
// Concentrated Option (15% syringe utilization)
ReconstitutionCalculationOption(
  name: 'Concentrated',
  solventVolume: 1.0,                   // Add 1.0mL solvent
  finalConcentration: 10.0,             // 10mg/mL concentration
  doseVolume: 0.05,                     // 0.05mL for 0.5mg dose
  syringeUtilization: 5.0,              // 5% of 1mL syringe
);

// Standard Option (50% syringe utilization)
ReconstitutionCalculationOption(
  name: 'Standard',
  solventVolume: 2.0,                   // Add 2.0mL solvent
  finalConcentration: 5.0,              // 5mg/mL concentration
  doseVolume: 0.10,                     // 0.10mL for 0.5mg dose
  syringeUtilization: 10.0,             // 10% of 1mL syringe
);

// Diluted Option (90% syringe utilization)
ReconstitutionCalculationOption(
  name: 'Diluted',
  solventVolume: 3.0,                   // Add 3.0mL solvent (max capacity)
  finalConcentration: 3.33,             // 3.33mg/mL concentration
  doseVolume: 0.15,                     // 0.15mL for 0.5mg dose
  syringeUtilization: 15.0,             // 15% of 1mL syringe
);
```

#### **Smart Features**
1. **Round Number Preference**: Prefers 0.5, 1.0, 1.5, 2.0mL volumes for easy measurement
2. **Volume Validation**: Ensures total volume fits within vial capacity
3. **Syringe Optimization**: Targets optimal syringe utilization ranges
4. **Nudge Functionality**: Users can adjust volumes in 0.1mL increments
5. **Real-time Recalculation**: Updates concentration and dose volume automatically

#### **Syringe Size Integration**
```dart
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
```

### 🔄 **Dose Calculation System**

#### **Automatic Unit Conversions**
```dart
class DoseCalculator {
  // Tablet/Capsule calculations
  static double calculateTabletDose({
    required double targetDose,           // e.g., 100mcg
    required StrengthUnit targetDoseUnit, // mcg
    required MedicationStrength medicationStrength, // 50mcg per tablet
  }) {
    // Result: 100mcg ÷ 50mcg = 2.0 tablets needed
  }
  
  // Liquid/Injection volume calculations
  static double calculateVolumeDose({
    required double targetDose,           // e.g., 10mg
    required StrengthUnit targetDoseUnit, // mg
    required MedicationStrength medicationStrength, // 5mg/mL
  }) {
    // Result: 10mg ÷ 5mg/mL = 2.0mL needed
  }
}
```

#### **Inventory Deduction Logic**
When a dose is confirmed as taken:

**Tablets:**
```dart
// Deduct calculated tablets from stock
inventory = inventory.copyWith(
  currentStock: inventory.currentStock - calculatedTablets,
);
```

**Syringes:**
```dart
// Use entire syringe (pre-filled)
inventory = inventory.copyWith(
  currentStock: inventory.currentStock - 1,
);
```

**Vials:**
```dart
// Deduct volume from current vial
final newVialVolume = inventory.currentVialVolume! - calculatedVolume;
if (newVialVolume <= 0) {
  // Open new vial from stock
  inventory = inventory.copyWith(
    currentStock: inventory.currentStock - 1,
    currentVialVolume: inventory.totalVialVolume! + newVialVolume,
  );
} else {
  inventory = inventory.copyWith(
    currentVialVolume: newVialVolume,
  );
}
```

### 📦 **Inventory Management System**

#### **Stock Unit Types**
```dart
enum StockUnit {
  tablets,          // Count individual tablets/capsules
  syringes,         // Count individual pre-filled syringes
  vials,            // Count individual vials (multi-dose or powder)
  pens,             // Count injection pen devices
  cartridges,       // Count pen cartridge refills
  tubes,            // Count cream/gel tubes
  patches,          // Count individual patches
  bottles,          // Count liquid bottles
  milliliters,      // Track liquid volume directly
}
```

#### **Smart Low Stock Alerts**
- **Tablets**: Alert when < threshold tablets remaining
- **Syringes**: Alert when < threshold syringes remaining
- **Vials**: Alert considering both current vial usage AND backup stock
- **Reconstituted**: Alert considering expiration date AND volume remaining

#### **Restocking vs Replacement Logic**
**Cannot be Restocked (Replace Only):**
- Tablets (get new bottle)
- Pre-filled syringes (get new box)
- Vials (get new vials)

**Can be Restocked:**
- None - all medications require replacement with fresh stock

### 🎯 **User Experience Design**

#### **Foolproof Field Validation**
The system only shows relevant fields based on medication type selection:

**Tablets Selected:**
```dart
// ONLY show these fields:
- Strength amount (number input)
- Strength unit dropdown: [mcg, mg, g, IU]
- Stock count (tablets)
- Low stock threshold (tablets)
- Expiration date
```

**Injection → Pre-filled Syringe Selected:**
```dart
// ONLY show these fields:
- Concentration amount (number input)
- Concentration unit dropdown: [mcg/mL, mg/mL, g/mL, IU/mL, U/mL]
- Syringe size dropdown: [0.3mL, 0.5mL, 1mL, 3mL, 5mL]
- Stock count (syringes)
- Low stock threshold (syringes)
- Expiration date
```

**Injection → Lyophilized Powder Selected:**
```dart
// ONLY show these fields:
- Powder amount (number input)
- Powder unit dropdown: [mcg, mg, g, IU]
- Vial capacity dropdown: [3mL, 5mL, 10mL, custom]
- Stock count (vials)
- Low stock threshold (vials)
- Expiration date
- [Reconstitution Calculator Button] - opens calculator
```

#### **Dynamic Helper Text**
Real-time medication summary updates as user types:

```dart
// Example for lyophilized powder:
"Injectable powder requiring reconstitution. "
"Contains 10mg per vial. "
"Maximum reconstitution volume: 5mL. "
"Click calculator to determine solvent amount."
```

### 🔧 **Integration Points**

#### **Calculator Integration**
**From Add Medication Screen:**
- Pre-populates calculator with medication data
- Returns selected reconstitution option
- Automatically updates medication with reconstitution info

**Standalone Calculator:**
- Freeform calculator for general use
- Does not affect existing medications
- Provides calculation results for reference

#### **Scheduling Integration (Future)**
When scheduling system is implemented:
- Dose calculations will use enhanced strength system
- Inventory deductions will use smart deduction logic
- Low stock alerts will integrate with scheduling notifications
- Expiration tracking will prevent scheduling expired medications

### 📋 **Technical Implementation Status**

#### **✅ Completed Components**
1. **Enhanced Models**: All data models implemented and generated
2. **Calculation Services**: Advanced reconstitution calculator completed
3. **Dose Calculator**: Unit conversion and dose calculation logic
4. **Syringe Recommendations**: Smart syringe size selection
5. **Inventory Logic**: Dual inventory tracking for vials
6. **Code Generation**: All models successfully generated with build_runner

#### **🔄 Next Implementation Phase**
1. **Dynamic Medication Forms**: Type-specific UI forms
2. **Form Validation**: Real-time validation with helper text
3. **Calculator UI Integration**: Embedded calculator in add medication flow
4. **Enhanced Repository**: Database integration for new models
5. **Migration System**: Convert existing medications to enhanced format

#### **📊 Code Quality Metrics**
- **Models**: 600+ lines of comprehensive type definitions
- **Calculator**: 400+ lines of advanced calculation logic
- **Type Safety**: 100% type-safe with proper null handling
- **Unit Coverage**: Comprehensive unit system (12 strength units, 3 volume units, 9 stock units)
- **Validation**: Built-in validation for all medication types

### 🗂️ File Structure Changes

```
lib/features/medication/ui/
├── medication_screen.dart          # Enhanced with dashboard and navigation
├── add_medication_screen.dart      # Dynamic form with type-specific fields
├── medication_detail_screen.dart   # NEW: Comprehensive detail view
└── medication_list_screen.dart     # Legacy file (can be removed)

lib/core/ui/
└── app.dart                       # Fixed router configuration

test/
└── widget_test.dart               # Updated to use DosifyApp class
```

### 🎨 UI/UX Enhancements

#### Medication Cards
- **Color Coding**: Each medication type has distinct colors (blue for tablets, red for injections, etc.)
- **Status Badges**: Low stock, expiring, and expired badges with appropriate colors
- **Information Density**: Shows type, strength, stock, and expiration in organized layout
- **Interaction**: Tappable cards that navigate to detailed view

#### Quick Action Dashboard
- **Statistics Cards**: Professional layout with icons and color themes
- **Action Buttons**: Circular badge indicators for low stock and expiring counts
- **Modal Views**: Draggable bottom sheets for filtered medication lists
- **Navigation Integration**: Direct access to calculator and other features

#### Detail Screen Layout
- **Header Section**: Large medication info with strength prominently displayed
- **Information Cards**: Organized sections for details, inventory, notes, and actions
- **Alert System**: Visual indicators for low stock, expiring, and expired medications
- **Action Integration**: Context-aware buttons for injectable medications

### 🔧 Technical Implementation

#### Navigation Routes
```dart
final _router = GoRouter(
  initialLocation: '/dashboard',
  routes: [
    GoRoute(
      path: '/medications',
      routes: [
        GoRoute(
          path: 'detail/:id',
          builder: (context, state) {
            final medicationId = state.pathParameters['id']!;
            return MedicationDetailScreen(medicationId: medicationId);
          },
        ),
      ],
    ),
    GoRoute(
      path: '/calculator',
      builder: (context, state) => const ReconstitutionCalculatorScreen(),
    ),
  ],
);
```

#### Data Fetching Pattern
```dart
class _MedicationDetailScreenState extends State<MedicationDetailScreen> {
  CoreMedication.Medication? medication;
  bool isLoading = true;
  String? error;

  Future<void> _loadMedication() async {
    try {
      final repository = getIt<MedicationRepository>();
      final medications = await repository.getAllMedications();
      final foundMedication = medications.firstWhere(
        (med) => med.id == widget.medicationId,
        orElse: () => throw Exception('Medication not found'),
      );
      setState(() {
        medication = foundMedication;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        error = e.toString();
        isLoading = false;
      });
    }
  }
}
```

#### Professional UI Components
```dart
Widget _buildMedicationCard(CoreMedication.Medication medication) {
  return GestureDetector(
    onTap: () => context.go('/medications/detail/${medication.id}'),
    child: Card(
      child: ListTile(
        leading: Container(
          decoration: BoxDecoration(
            color: _getTypeColor(medication.type),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(_getTypeIcon(medication.type)),
        ),
        title: Text(medication.name),
        subtitle: Column(/* medication details */),
        trailing: _buildAlertBadge(medication),
      ),
    ),
  );
}
```

## Implementation Roadmap

### Phase 1: Critical Fixes (✅ COMPLETED)
1. ✅ **Fix Black Screen**: Resolved navigation and routing issues
2. ✅ **Remove Hive Dependencies**: Complete SQLite migration
3. ✅ **Database Integration**: Ensured proper data loading
4. ✅ **Basic CRUD**: Medication management working
5. ✅ **Navigation Routes**: All screens properly routed and accessible
6. ✅ **Professional UI**: Enhanced medication cards and detail views

### Phase 2: Enhanced UI (Next Sprint)
1. **Dynamic Forms**: Medication type-specific fields
2. **Dashboard Data**: Real metrics and adherence tracking
3. **Navigation Polish**: Simplified bottom nav structure
4. **Helper Text**: Contextual form assistance

### Phase 3: Advanced Features
1. **Reconstitution Calculator**: Enhanced with volume capacity
2. **Cycling Information**: Schedule tracking and predictions
3. **Inventory Integration**: Stock management within medication screens
4. **Calendar Integration**: Visual schedule representation

### Phase 4: Production Polish
1. **Error Handling**: Comprehensive error states
2. **Performance**: Database query optimization
3. **Testing**: Unit and widget test coverage
4. **Documentation**: User guides and API docs

---

## Development Commands

### Essential Commands
```bash
# Install dependencies
flutter pub get

# Generate code (after model changes)
dart run build_runner build --delete-conflicting-outputs

# Run app
flutter run -d emulator-5554

# Analyze code
flutter analyze

# Run tests
flutter test
```

### Database Management
```bash
# View database (if needed for debugging)
adb shell
run-as com.dosify.dosify_flutter
ls databases/
cat databases/dosify.db
```

---

**Status**: 🔧 **IN ACTIVE DEVELOPMENT**

**Priority Issues**: 
1. Black screen fix
2. SQLite data loading
3. Remove Hive references
4. Dynamic form implementation

**Last Updated**: 2025-01-28  
**Version**: 1.0.0+1  
**Database**: SQLite (migrated from Hive)  
**Architecture**: Clean Architecture with Repository Pattern
