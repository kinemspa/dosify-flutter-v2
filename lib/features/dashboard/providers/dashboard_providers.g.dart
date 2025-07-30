// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dashboard_providers.dart';

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
String _$inventoryRepositoryHash() =>
    r'50963abf4c11f05ede30b1a31c51d980cde9ab99';

/// See also [inventoryRepository].
@ProviderFor(inventoryRepository)
final inventoryRepositoryProvider =
    AutoDisposeProvider<InventoryRepository>.internal(
  inventoryRepository,
  name: r'inventoryRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$inventoryRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef InventoryRepositoryRef = AutoDisposeProviderRef<InventoryRepository>;
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
String _$dashboardStatsHash() => r'e44252de1a27b3dc93b572fa425af375367ca94a';

/// See also [DashboardStats].
@ProviderFor(DashboardStats)
final dashboardStatsProvider = AutoDisposeAsyncNotifierProvider<DashboardStats,
    DashboardStatsData>.internal(
  DashboardStats.new,
  name: r'dashboardStatsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$dashboardStatsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$DashboardStats = AutoDisposeAsyncNotifier<DashboardStatsData>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
