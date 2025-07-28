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
