// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'medication_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$medicationRepositoryHash() =>
    r'8b09b6e9a964a9a0fbf52032a44948a4f728eeaf';

/// See also [medicationRepository].
@ProviderFor(medicationRepository)
final medicationRepositoryProvider =
    AutoDisposeProvider<MedicationRepository>.internal(
  medicationRepository,
  name: r'medicationRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$medicationRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef MedicationRepositoryRef = AutoDisposeProviderRef<MedicationRepository>;
String _$medicationByIdHash() => r'176a1ffb7ab4170a0d861ebe4f99964afd1f137d';

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

/// See also [medicationById].
@ProviderFor(medicationById)
const medicationByIdProvider = MedicationByIdFamily();

/// See also [medicationById].
class MedicationByIdFamily extends Family<AsyncValue<Medication?>> {
  /// See also [medicationById].
  const MedicationByIdFamily();

  /// See also [medicationById].
  MedicationByIdProvider call(
    String medicationId,
  ) {
    return MedicationByIdProvider(
      medicationId,
    );
  }

  @override
  MedicationByIdProvider getProviderOverride(
    covariant MedicationByIdProvider provider,
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
  String? get name => r'medicationByIdProvider';
}

/// See also [medicationById].
class MedicationByIdProvider extends AutoDisposeFutureProvider<Medication?> {
  /// See also [medicationById].
  MedicationByIdProvider(
    String medicationId,
  ) : this._internal(
          (ref) => medicationById(
            ref as MedicationByIdRef,
            medicationId,
          ),
          from: medicationByIdProvider,
          name: r'medicationByIdProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$medicationByIdHash,
          dependencies: MedicationByIdFamily._dependencies,
          allTransitiveDependencies:
              MedicationByIdFamily._allTransitiveDependencies,
          medicationId: medicationId,
        );

  MedicationByIdProvider._internal(
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
    FutureOr<Medication?> Function(MedicationByIdRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: MedicationByIdProvider._internal(
        (ref) => create(ref as MedicationByIdRef),
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
  AutoDisposeFutureProviderElement<Medication?> createElement() {
    return _MedicationByIdProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is MedicationByIdProvider &&
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
mixin MedicationByIdRef on AutoDisposeFutureProviderRef<Medication?> {
  /// The parameter `medicationId` of this provider.
  String get medicationId;
}

class _MedicationByIdProviderElement
    extends AutoDisposeFutureProviderElement<Medication?>
    with MedicationByIdRef {
  _MedicationByIdProviderElement(super.provider);

  @override
  String get medicationId => (origin as MedicationByIdProvider).medicationId;
}

String _$medicationListHash() => r'cd2b5b7c5c5b3d71e41f04badc5d4f6c95dd23fd';

/// See also [MedicationList].
@ProviderFor(MedicationList)
final medicationListProvider =
    AutoDisposeAsyncNotifierProvider<MedicationList, List<Medication>>.internal(
  MedicationList.new,
  name: r'medicationListProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$medicationListHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$MedicationList = AutoDisposeAsyncNotifier<List<Medication>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
