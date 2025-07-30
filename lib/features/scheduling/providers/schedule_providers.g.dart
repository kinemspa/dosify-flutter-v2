// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'schedule_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$scheduleRepositoryHash() =>
    r'33cb70ee7226e579180ad7acd9a8176fb8238b6a';

/// See also [scheduleRepository].
@ProviderFor(scheduleRepository)
final scheduleRepositoryProvider =
    AutoDisposeProvider<ScheduleRepository>.internal(
  scheduleRepository,
  name: r'scheduleRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$scheduleRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ScheduleRepositoryRef = AutoDisposeProviderRef<ScheduleRepository>;
String _$medicationSchedulesHash() =>
    r'a51f4689ce870b1952bb67647b281c8d086f765a';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

/// See also [medicationSchedules].
@ProviderFor(medicationSchedules)
const medicationSchedulesProvider = MedicationSchedulesFamily();

/// See also [medicationSchedules].
class MedicationSchedulesFamily
    extends Family<AsyncValue<List<MedicationSchedule>>> {
  /// See also [medicationSchedules].
  const MedicationSchedulesFamily();

  /// See also [medicationSchedules].
  MedicationSchedulesProvider call(
    String medicationId,
  ) {
    return MedicationSchedulesProvider(
      medicationId,
    );
  }

  @override
  MedicationSchedulesProvider getProviderOverride(
    covariant MedicationSchedulesProvider provider,
  ) {
    return call(
      provider.medicationId,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'medicationSchedulesProvider';
}

/// See also [medicationSchedules].
class MedicationSchedulesProvider
    extends AutoDisposeFutureProvider<List<MedicationSchedule>> {
  /// See also [medicationSchedules].
  MedicationSchedulesProvider(
    String medicationId,
  ) : this._internal(
          (ref) => medicationSchedules(
            ref as MedicationSchedulesRef,
            medicationId,
          ),
          from: medicationSchedulesProvider,
          name: r'medicationSchedulesProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$medicationSchedulesHash,
          dependencies: MedicationSchedulesFamily._dependencies,
          allTransitiveDependencies:
              MedicationSchedulesFamily._allTransitiveDependencies,
          medicationId: medicationId,
        );

  MedicationSchedulesProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.medicationId,
  }) : super.internal();

  final String medicationId;

  @override
  Override overrideWith(
    FutureOr<List<MedicationSchedule>> Function(MedicationSchedulesRef provider)
        create,
  ) {
    return ProviderOverride(
      origin: this,
      override: MedicationSchedulesProvider._internal(
        (ref) => create(ref as MedicationSchedulesRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        medicationId: medicationId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<MedicationSchedule>> createElement() {
    return _MedicationSchedulesProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is MedicationSchedulesProvider &&
        other.medicationId == medicationId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, medicationId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin MedicationSchedulesRef
    on AutoDisposeFutureProviderRef<List<MedicationSchedule>> {
  /// The parameter `medicationId` of this provider.
  String get medicationId;
}

class _MedicationSchedulesProviderElement
    extends AutoDisposeFutureProviderElement<List<MedicationSchedule>>
    with MedicationSchedulesRef {
  _MedicationSchedulesProviderElement(super.provider);

  @override
  String get medicationId =>
      (origin as MedicationSchedulesProvider).medicationId;
}

String _$scheduleByIdHash() => r'904d257db4f69cfc270219d02e4d8d0337b53fd3';

/// See also [scheduleById].
@ProviderFor(scheduleById)
const scheduleByIdProvider = ScheduleByIdFamily();

/// See also [scheduleById].
class ScheduleByIdFamily extends Family<AsyncValue<MedicationSchedule?>> {
  /// See also [scheduleById].
  const ScheduleByIdFamily();

  /// See also [scheduleById].
  ScheduleByIdProvider call(
    String scheduleId,
  ) {
    return ScheduleByIdProvider(
      scheduleId,
    );
  }

  @override
  ScheduleByIdProvider getProviderOverride(
    covariant ScheduleByIdProvider provider,
  ) {
    return call(
      provider.scheduleId,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'scheduleByIdProvider';
}

/// See also [scheduleById].
class ScheduleByIdProvider
    extends AutoDisposeFutureProvider<MedicationSchedule?> {
  /// See also [scheduleById].
  ScheduleByIdProvider(
    String scheduleId,
  ) : this._internal(
          (ref) => scheduleById(
            ref as ScheduleByIdRef,
            scheduleId,
          ),
          from: scheduleByIdProvider,
          name: r'scheduleByIdProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$scheduleByIdHash,
          dependencies: ScheduleByIdFamily._dependencies,
          allTransitiveDependencies:
              ScheduleByIdFamily._allTransitiveDependencies,
          scheduleId: scheduleId,
        );

  ScheduleByIdProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.scheduleId,
  }) : super.internal();

  final String scheduleId;

  @override
  Override overrideWith(
    FutureOr<MedicationSchedule?> Function(ScheduleByIdRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ScheduleByIdProvider._internal(
        (ref) => create(ref as ScheduleByIdRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        scheduleId: scheduleId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<MedicationSchedule?> createElement() {
    return _ScheduleByIdProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ScheduleByIdProvider && other.scheduleId == scheduleId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, scheduleId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin ScheduleByIdRef on AutoDisposeFutureProviderRef<MedicationSchedule?> {
  /// The parameter `scheduleId` of this provider.
  String get scheduleId;
}

class _ScheduleByIdProviderElement
    extends AutoDisposeFutureProviderElement<MedicationSchedule?>
    with ScheduleByIdRef {
  _ScheduleByIdProviderElement(super.provider);

  @override
  String get scheduleId => (origin as ScheduleByIdProvider).scheduleId;
}

String _$doseRecordsHash() => r'90b8c6bf357419d6a6378698ce84775d10ba5b85';

/// See also [doseRecords].
@ProviderFor(doseRecords)
const doseRecordsProvider = DoseRecordsFamily();

/// See also [doseRecords].
class DoseRecordsFamily extends Family<AsyncValue<List<DoseRecord>>> {
  /// See also [doseRecords].
  const DoseRecordsFamily();

  /// See also [doseRecords].
  DoseRecordsProvider call({
    String? scheduleId,
    String? medicationId,
    DateTime? startDate,
    DateTime? endDate,
  }) {
    return DoseRecordsProvider(
      scheduleId: scheduleId,
      medicationId: medicationId,
      startDate: startDate,
      endDate: endDate,
    );
  }

  @override
  DoseRecordsProvider getProviderOverride(
    covariant DoseRecordsProvider provider,
  ) {
    return call(
      scheduleId: provider.scheduleId,
      medicationId: provider.medicationId,
      startDate: provider.startDate,
      endDate: provider.endDate,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'doseRecordsProvider';
}

/// See also [doseRecords].
class DoseRecordsProvider extends AutoDisposeFutureProvider<List<DoseRecord>> {
  /// See also [doseRecords].
  DoseRecordsProvider({
    String? scheduleId,
    String? medicationId,
    DateTime? startDate,
    DateTime? endDate,
  }) : this._internal(
          (ref) => doseRecords(
            ref as DoseRecordsRef,
            scheduleId: scheduleId,
            medicationId: medicationId,
            startDate: startDate,
            endDate: endDate,
          ),
          from: doseRecordsProvider,
          name: r'doseRecordsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$doseRecordsHash,
          dependencies: DoseRecordsFamily._dependencies,
          allTransitiveDependencies:
              DoseRecordsFamily._allTransitiveDependencies,
          scheduleId: scheduleId,
          medicationId: medicationId,
          startDate: startDate,
          endDate: endDate,
        );

  DoseRecordsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.scheduleId,
    required this.medicationId,
    required this.startDate,
    required this.endDate,
  }) : super.internal();

  final String? scheduleId;
  final String? medicationId;
  final DateTime? startDate;
  final DateTime? endDate;

  @override
  Override overrideWith(
    FutureOr<List<DoseRecord>> Function(DoseRecordsRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: DoseRecordsProvider._internal(
        (ref) => create(ref as DoseRecordsRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        scheduleId: scheduleId,
        medicationId: medicationId,
        startDate: startDate,
        endDate: endDate,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<DoseRecord>> createElement() {
    return _DoseRecordsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is DoseRecordsProvider &&
        other.scheduleId == scheduleId &&
        other.medicationId == medicationId &&
        other.startDate == startDate &&
        other.endDate == endDate;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, scheduleId.hashCode);
    hash = _SystemHash.combine(hash, medicationId.hashCode);
    hash = _SystemHash.combine(hash, startDate.hashCode);
    hash = _SystemHash.combine(hash, endDate.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin DoseRecordsRef on AutoDisposeFutureProviderRef<List<DoseRecord>> {
  /// The parameter `scheduleId` of this provider.
  String? get scheduleId;

  /// The parameter `medicationId` of this provider.
  String? get medicationId;

  /// The parameter `startDate` of this provider.
  DateTime? get startDate;

  /// The parameter `endDate` of this provider.
  DateTime? get endDate;
}

class _DoseRecordsProviderElement
    extends AutoDisposeFutureProviderElement<List<DoseRecord>>
    with DoseRecordsRef {
  _DoseRecordsProviderElement(super.provider);

  @override
  String? get scheduleId => (origin as DoseRecordsProvider).scheduleId;
  @override
  String? get medicationId => (origin as DoseRecordsProvider).medicationId;
  @override
  DateTime? get startDate => (origin as DoseRecordsProvider).startDate;
  @override
  DateTime? get endDate => (origin as DoseRecordsProvider).endDate;
}

String _$doseRecordByIdHash() => r'8ebad41d96580b324cbe31aa634c900af1078fde';

/// See also [doseRecordById].
@ProviderFor(doseRecordById)
const doseRecordByIdProvider = DoseRecordByIdFamily();

/// See also [doseRecordById].
class DoseRecordByIdFamily extends Family<AsyncValue<DoseRecord?>> {
  /// See also [doseRecordById].
  const DoseRecordByIdFamily();

  /// See also [doseRecordById].
  DoseRecordByIdProvider call(
    String doseId,
  ) {
    return DoseRecordByIdProvider(
      doseId,
    );
  }

  @override
  DoseRecordByIdProvider getProviderOverride(
    covariant DoseRecordByIdProvider provider,
  ) {
    return call(
      provider.doseId,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'doseRecordByIdProvider';
}

/// See also [doseRecordById].
class DoseRecordByIdProvider extends AutoDisposeFutureProvider<DoseRecord?> {
  /// See also [doseRecordById].
  DoseRecordByIdProvider(
    String doseId,
  ) : this._internal(
          (ref) => doseRecordById(
            ref as DoseRecordByIdRef,
            doseId,
          ),
          from: doseRecordByIdProvider,
          name: r'doseRecordByIdProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$doseRecordByIdHash,
          dependencies: DoseRecordByIdFamily._dependencies,
          allTransitiveDependencies:
              DoseRecordByIdFamily._allTransitiveDependencies,
          doseId: doseId,
        );

  DoseRecordByIdProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.doseId,
  }) : super.internal();

  final String doseId;

  @override
  Override overrideWith(
    FutureOr<DoseRecord?> Function(DoseRecordByIdRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: DoseRecordByIdProvider._internal(
        (ref) => create(ref as DoseRecordByIdRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        doseId: doseId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<DoseRecord?> createElement() {
    return _DoseRecordByIdProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is DoseRecordByIdProvider && other.doseId == doseId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, doseId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin DoseRecordByIdRef on AutoDisposeFutureProviderRef<DoseRecord?> {
  /// The parameter `doseId` of this provider.
  String get doseId;
}

class _DoseRecordByIdProviderElement
    extends AutoDisposeFutureProviderElement<DoseRecord?>
    with DoseRecordByIdRef {
  _DoseRecordByIdProviderElement(super.provider);

  @override
  String get doseId => (origin as DoseRecordByIdProvider).doseId;
}

String _$dosesForDateHash() => r'9653985ac452b508a0c17e58a875d858f0eb37fc';

/// See also [dosesForDate].
@ProviderFor(dosesForDate)
const dosesForDateProvider = DosesForDateFamily();

/// See also [dosesForDate].
class DosesForDateFamily extends Family<AsyncValue<List<DoseRecord>>> {
  /// See also [dosesForDate].
  const DosesForDateFamily();

  /// See also [dosesForDate].
  DosesForDateProvider call(
    DateTime date,
  ) {
    return DosesForDateProvider(
      date,
    );
  }

  @override
  DosesForDateProvider getProviderOverride(
    covariant DosesForDateProvider provider,
  ) {
    return call(
      provider.date,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'dosesForDateProvider';
}

/// See also [dosesForDate].
class DosesForDateProvider extends AutoDisposeFutureProvider<List<DoseRecord>> {
  /// See also [dosesForDate].
  DosesForDateProvider(
    DateTime date,
  ) : this._internal(
          (ref) => dosesForDate(
            ref as DosesForDateRef,
            date,
          ),
          from: dosesForDateProvider,
          name: r'dosesForDateProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$dosesForDateHash,
          dependencies: DosesForDateFamily._dependencies,
          allTransitiveDependencies:
              DosesForDateFamily._allTransitiveDependencies,
          date: date,
        );

  DosesForDateProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.date,
  }) : super.internal();

  final DateTime date;

  @override
  Override overrideWith(
    FutureOr<List<DoseRecord>> Function(DosesForDateRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: DosesForDateProvider._internal(
        (ref) => create(ref as DosesForDateRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        date: date,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<DoseRecord>> createElement() {
    return _DosesForDateProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is DosesForDateProvider && other.date == date;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, date.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin DosesForDateRef on AutoDisposeFutureProviderRef<List<DoseRecord>> {
  /// The parameter `date` of this provider.
  DateTime get date;
}

class _DosesForDateProviderElement
    extends AutoDisposeFutureProviderElement<List<DoseRecord>>
    with DosesForDateRef {
  _DosesForDateProviderElement(super.provider);

  @override
  DateTime get date => (origin as DosesForDateProvider).date;
}

String _$adherenceStatsHash() => r'f52d8a619398ea37c07a62f09e43c98e757293ad';

/// See also [adherenceStats].
@ProviderFor(adherenceStats)
const adherenceStatsProvider = AdherenceStatsFamily();

/// See also [adherenceStats].
class AdherenceStatsFamily extends Family<AsyncValue<AdherenceStats>> {
  /// See also [adherenceStats].
  const AdherenceStatsFamily();

  /// See also [adherenceStats].
  AdherenceStatsProvider call({
    required String medicationId,
    String? scheduleId,
    required DateTime startDate,
    required DateTime endDate,
  }) {
    return AdherenceStatsProvider(
      medicationId: medicationId,
      scheduleId: scheduleId,
      startDate: startDate,
      endDate: endDate,
    );
  }

  @override
  AdherenceStatsProvider getProviderOverride(
    covariant AdherenceStatsProvider provider,
  ) {
    return call(
      medicationId: provider.medicationId,
      scheduleId: provider.scheduleId,
      startDate: provider.startDate,
      endDate: provider.endDate,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'adherenceStatsProvider';
}

/// See also [adherenceStats].
class AdherenceStatsProvider extends AutoDisposeFutureProvider<AdherenceStats> {
  /// See also [adherenceStats].
  AdherenceStatsProvider({
    required String medicationId,
    String? scheduleId,
    required DateTime startDate,
    required DateTime endDate,
  }) : this._internal(
          (ref) => adherenceStats(
            ref as AdherenceStatsRef,
            medicationId: medicationId,
            scheduleId: scheduleId,
            startDate: startDate,
            endDate: endDate,
          ),
          from: adherenceStatsProvider,
          name: r'adherenceStatsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$adherenceStatsHash,
          dependencies: AdherenceStatsFamily._dependencies,
          allTransitiveDependencies:
              AdherenceStatsFamily._allTransitiveDependencies,
          medicationId: medicationId,
          scheduleId: scheduleId,
          startDate: startDate,
          endDate: endDate,
        );

  AdherenceStatsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.medicationId,
    required this.scheduleId,
    required this.startDate,
    required this.endDate,
  }) : super.internal();

  final String medicationId;
  final String? scheduleId;
  final DateTime startDate;
  final DateTime endDate;

  @override
  Override overrideWith(
    FutureOr<AdherenceStats> Function(AdherenceStatsRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: AdherenceStatsProvider._internal(
        (ref) => create(ref as AdherenceStatsRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        medicationId: medicationId,
        scheduleId: scheduleId,
        startDate: startDate,
        endDate: endDate,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<AdherenceStats> createElement() {
    return _AdherenceStatsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is AdherenceStatsProvider &&
        other.medicationId == medicationId &&
        other.scheduleId == scheduleId &&
        other.startDate == startDate &&
        other.endDate == endDate;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, medicationId.hashCode);
    hash = _SystemHash.combine(hash, scheduleId.hashCode);
    hash = _SystemHash.combine(hash, startDate.hashCode);
    hash = _SystemHash.combine(hash, endDate.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin AdherenceStatsRef on AutoDisposeFutureProviderRef<AdherenceStats> {
  /// The parameter `medicationId` of this provider.
  String get medicationId;

  /// The parameter `scheduleId` of this provider.
  String? get scheduleId;

  /// The parameter `startDate` of this provider.
  DateTime get startDate;

  /// The parameter `endDate` of this provider.
  DateTime get endDate;
}

class _AdherenceStatsProviderElement
    extends AutoDisposeFutureProviderElement<AdherenceStats>
    with AdherenceStatsRef {
  _AdherenceStatsProviderElement(super.provider);

  @override
  String get medicationId => (origin as AdherenceStatsProvider).medicationId;
  @override
  String? get scheduleId => (origin as AdherenceStatsProvider).scheduleId;
  @override
  DateTime get startDate => (origin as AdherenceStatsProvider).startDate;
  @override
  DateTime get endDate => (origin as AdherenceStatsProvider).endDate;
}

String _$adherenceRateHash() => r'3cdc82d7592432be84cde5606ab0fc9bb7c2f866';

/// See also [adherenceRate].
@ProviderFor(adherenceRate)
const adherenceRateProvider = AdherenceRateFamily();

/// See also [adherenceRate].
class AdherenceRateFamily extends Family<AsyncValue<double>> {
  /// See also [adherenceRate].
  const AdherenceRateFamily();

  /// See also [adherenceRate].
  AdherenceRateProvider call(
    String medicationId, {
    int days = 30,
  }) {
    return AdherenceRateProvider(
      medicationId,
      days: days,
    );
  }

  @override
  AdherenceRateProvider getProviderOverride(
    covariant AdherenceRateProvider provider,
  ) {
    return call(
      provider.medicationId,
      days: provider.days,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'adherenceRateProvider';
}

/// See also [adherenceRate].
class AdherenceRateProvider extends AutoDisposeFutureProvider<double> {
  /// See also [adherenceRate].
  AdherenceRateProvider(
    String medicationId, {
    int days = 30,
  }) : this._internal(
          (ref) => adherenceRate(
            ref as AdherenceRateRef,
            medicationId,
            days: days,
          ),
          from: adherenceRateProvider,
          name: r'adherenceRateProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$adherenceRateHash,
          dependencies: AdherenceRateFamily._dependencies,
          allTransitiveDependencies:
              AdherenceRateFamily._allTransitiveDependencies,
          medicationId: medicationId,
          days: days,
        );

  AdherenceRateProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.medicationId,
    required this.days,
  }) : super.internal();

  final String medicationId;
  final int days;

  @override
  Override overrideWith(
    FutureOr<double> Function(AdherenceRateRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: AdherenceRateProvider._internal(
        (ref) => create(ref as AdherenceRateRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        medicationId: medicationId,
        days: days,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<double> createElement() {
    return _AdherenceRateProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is AdherenceRateProvider &&
        other.medicationId == medicationId &&
        other.days == days;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, medicationId.hashCode);
    hash = _SystemHash.combine(hash, days.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin AdherenceRateRef on AutoDisposeFutureProviderRef<double> {
  /// The parameter `medicationId` of this provider.
  String get medicationId;

  /// The parameter `days` of this provider.
  int get days;
}

class _AdherenceRateProviderElement
    extends AutoDisposeFutureProviderElement<double> with AdherenceRateRef {
  _AdherenceRateProviderElement(super.provider);

  @override
  String get medicationId => (origin as AdherenceRateProvider).medicationId;
  @override
  int get days => (origin as AdherenceRateProvider).days;
}

String _$missedDosesHash() => r'4feeaa55a4a72435d8a3806caff957824394ac40';

/// See also [missedDoses].
@ProviderFor(missedDoses)
const missedDosesProvider = MissedDosesFamily();

/// See also [missedDoses].
class MissedDosesFamily extends Family<AsyncValue<List<DoseRecord>>> {
  /// See also [missedDoses].
  const MissedDosesFamily();

  /// See also [missedDoses].
  MissedDosesProvider call({
    String? medicationId,
    String? scheduleId,
    int days = 7,
  }) {
    return MissedDosesProvider(
      medicationId: medicationId,
      scheduleId: scheduleId,
      days: days,
    );
  }

  @override
  MissedDosesProvider getProviderOverride(
    covariant MissedDosesProvider provider,
  ) {
    return call(
      medicationId: provider.medicationId,
      scheduleId: provider.scheduleId,
      days: provider.days,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'missedDosesProvider';
}

/// See also [missedDoses].
class MissedDosesProvider extends AutoDisposeFutureProvider<List<DoseRecord>> {
  /// See also [missedDoses].
  MissedDosesProvider({
    String? medicationId,
    String? scheduleId,
    int days = 7,
  }) : this._internal(
          (ref) => missedDoses(
            ref as MissedDosesRef,
            medicationId: medicationId,
            scheduleId: scheduleId,
            days: days,
          ),
          from: missedDosesProvider,
          name: r'missedDosesProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$missedDosesHash,
          dependencies: MissedDosesFamily._dependencies,
          allTransitiveDependencies:
              MissedDosesFamily._allTransitiveDependencies,
          medicationId: medicationId,
          scheduleId: scheduleId,
          days: days,
        );

  MissedDosesProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.medicationId,
    required this.scheduleId,
    required this.days,
  }) : super.internal();

  final String? medicationId;
  final String? scheduleId;
  final int days;

  @override
  Override overrideWith(
    FutureOr<List<DoseRecord>> Function(MissedDosesRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: MissedDosesProvider._internal(
        (ref) => create(ref as MissedDosesRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        medicationId: medicationId,
        scheduleId: scheduleId,
        days: days,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<DoseRecord>> createElement() {
    return _MissedDosesProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is MissedDosesProvider &&
        other.medicationId == medicationId &&
        other.scheduleId == scheduleId &&
        other.days == days;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, medicationId.hashCode);
    hash = _SystemHash.combine(hash, scheduleId.hashCode);
    hash = _SystemHash.combine(hash, days.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin MissedDosesRef on AutoDisposeFutureProviderRef<List<DoseRecord>> {
  /// The parameter `medicationId` of this provider.
  String? get medicationId;

  /// The parameter `scheduleId` of this provider.
  String? get scheduleId;

  /// The parameter `days` of this provider.
  int get days;
}

class _MissedDosesProviderElement
    extends AutoDisposeFutureProviderElement<List<DoseRecord>>
    with MissedDosesRef {
  _MissedDosesProviderElement(super.provider);

  @override
  String? get medicationId => (origin as MissedDosesProvider).medicationId;
  @override
  String? get scheduleId => (origin as MissedDosesProvider).scheduleId;
  @override
  int get days => (origin as MissedDosesProvider).days;
}

String _$dashboardSummaryHash() => r'beee2908b493363add5f1e3837dbb95c3802e9ce';

/// See also [dashboardSummary].
@ProviderFor(dashboardSummary)
final dashboardSummaryProvider =
    AutoDisposeFutureProvider<DashboardSummary>.internal(
  dashboardSummary,
  name: r'dashboardSummaryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$dashboardSummaryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef DashboardSummaryRef = AutoDisposeFutureProviderRef<DashboardSummary>;
String _$scheduleListHash() => r'ee0dfc69cbbbcb38621034043adce37a249ad939';

/// See also [ScheduleList].
@ProviderFor(ScheduleList)
final scheduleListProvider = AutoDisposeAsyncNotifierProvider<ScheduleList,
    List<MedicationSchedule>>.internal(
  ScheduleList.new,
  name: r'scheduleListProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$scheduleListHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$ScheduleList = AutoDisposeAsyncNotifier<List<MedicationSchedule>>;
String _$activeSchedulesHash() => r'ff33483942919fce7072f31e22c60292ed2a8081';

/// See also [ActiveSchedules].
@ProviderFor(ActiveSchedules)
final activeSchedulesProvider = AutoDisposeAsyncNotifierProvider<
    ActiveSchedules, List<MedicationSchedule>>.internal(
  ActiveSchedules.new,
  name: r'activeSchedulesProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$activeSchedulesHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$ActiveSchedules = AutoDisposeAsyncNotifier<List<MedicationSchedule>>;
String _$todaysDosesHash() => r'5e62fef3df983d5b8a05d1a8f5b0ae5a3ccbc97e';

/// See also [TodaysDoses].
@ProviderFor(TodaysDoses)
final todaysDosesProvider =
    AutoDisposeAsyncNotifierProvider<TodaysDoses, List<DoseRecord>>.internal(
  TodaysDoses.new,
  name: r'todaysDosesProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$todaysDosesHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$TodaysDoses = AutoDisposeAsyncNotifier<List<DoseRecord>>;
String _$upcomingDosesHash() => r'64ea79d2b04d6a67b3d63208844e3b7ec7ba9fa5';

abstract class _$UpcomingDoses
    extends BuildlessAutoDisposeAsyncNotifier<List<DoseRecord>> {
  late final int hoursAhead;

  FutureOr<List<DoseRecord>> build({
    int hoursAhead = 24,
  });
}

/// See also [UpcomingDoses].
@ProviderFor(UpcomingDoses)
const upcomingDosesProvider = UpcomingDosesFamily();

/// See also [UpcomingDoses].
class UpcomingDosesFamily extends Family<AsyncValue<List<DoseRecord>>> {
  /// See also [UpcomingDoses].
  const UpcomingDosesFamily();

  /// See also [UpcomingDoses].
  UpcomingDosesProvider call({
    int hoursAhead = 24,
  }) {
    return UpcomingDosesProvider(
      hoursAhead: hoursAhead,
    );
  }

  @override
  UpcomingDosesProvider getProviderOverride(
    covariant UpcomingDosesProvider provider,
  ) {
    return call(
      hoursAhead: provider.hoursAhead,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'upcomingDosesProvider';
}

/// See also [UpcomingDoses].
class UpcomingDosesProvider extends AutoDisposeAsyncNotifierProviderImpl<
    UpcomingDoses, List<DoseRecord>> {
  /// See also [UpcomingDoses].
  UpcomingDosesProvider({
    int hoursAhead = 24,
  }) : this._internal(
          () => UpcomingDoses()..hoursAhead = hoursAhead,
          from: upcomingDosesProvider,
          name: r'upcomingDosesProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$upcomingDosesHash,
          dependencies: UpcomingDosesFamily._dependencies,
          allTransitiveDependencies:
              UpcomingDosesFamily._allTransitiveDependencies,
          hoursAhead: hoursAhead,
        );

  UpcomingDosesProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.hoursAhead,
  }) : super.internal();

  final int hoursAhead;

  @override
  FutureOr<List<DoseRecord>> runNotifierBuild(
    covariant UpcomingDoses notifier,
  ) {
    return notifier.build(
      hoursAhead: hoursAhead,
    );
  }

  @override
  Override overrideWith(UpcomingDoses Function() create) {
    return ProviderOverride(
      origin: this,
      override: UpcomingDosesProvider._internal(
        () => create()..hoursAhead = hoursAhead,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        hoursAhead: hoursAhead,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<UpcomingDoses, List<DoseRecord>>
      createElement() {
    return _UpcomingDosesProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is UpcomingDosesProvider && other.hoursAhead == hoursAhead;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, hoursAhead.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin UpcomingDosesRef
    on AutoDisposeAsyncNotifierProviderRef<List<DoseRecord>> {
  /// The parameter `hoursAhead` of this provider.
  int get hoursAhead;
}

class _UpcomingDosesProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<UpcomingDoses,
        List<DoseRecord>> with UpcomingDosesRef {
  _UpcomingDosesProviderElement(super.provider);

  @override
  int get hoursAhead => (origin as UpcomingDosesProvider).hoursAhead;
}

String _$overdueDosesHash() => r'bb65d242e9b300d3aaa85b0d43130bd8c02ec81a';

/// See also [OverdueDoses].
@ProviderFor(OverdueDoses)
final overdueDosesProvider =
    AutoDisposeAsyncNotifierProvider<OverdueDoses, List<DoseRecord>>.internal(
  OverdueDoses.new,
  name: r'overdueDosesProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$overdueDosesHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$OverdueDoses = AutoDisposeAsyncNotifier<List<DoseRecord>>;
String _$scheduleGenerationHash() =>
    r'b23169793e69d632ff328ae635352a328f3decdb';

/// See also [ScheduleGeneration].
@ProviderFor(ScheduleGeneration)
final scheduleGenerationProvider =
    AutoDisposeAsyncNotifierProvider<ScheduleGeneration, void>.internal(
  ScheduleGeneration.new,
  name: r'scheduleGenerationProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$scheduleGenerationHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$ScheduleGeneration = AutoDisposeAsyncNotifier<void>;
String _$scheduleMaintenanceHash() =>
    r'b7e4dac9072c746585dcbbebff12fdcf5e938ed4';

/// See also [ScheduleMaintenance].
@ProviderFor(ScheduleMaintenance)
final scheduleMaintenanceProvider =
    AutoDisposeAsyncNotifierProvider<ScheduleMaintenance, void>.internal(
  ScheduleMaintenance.new,
  name: r'scheduleMaintenanceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$scheduleMaintenanceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$ScheduleMaintenance = AutoDisposeAsyncNotifier<void>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
