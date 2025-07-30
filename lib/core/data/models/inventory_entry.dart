import 'package:json_annotation/json_annotation.dart';

part 'inventory_entry.g.dart';

@JsonSerializable()
class InventoryEntry {
  final String id;
  final String medicationId;
  final int quantity;
  final DateTime? expirationDate;
  final String? batchNumber;
  final double? costPerUnit;
  final DateTime addedDate;
  final InventoryStatus status;
  final String? supplierName;
  final String? notes;
  final DateTime createdAt;
  final DateTime updatedAt;

  const InventoryEntry({
    required this.id,
    required this.medicationId,
    required this.quantity,
    this.expirationDate,
    this.batchNumber,
    this.costPerUnit,
    required this.addedDate,
    required this.status,
    this.supplierName,
    this.notes,
    required this.createdAt,
    required this.updatedAt,
  });

  factory InventoryEntry.fromJson(Map<String, dynamic> json) =>
      _$InventoryEntryFromJson(json);

  Map<String, dynamic> toJson() => _$InventoryEntryToJson(this);

  InventoryEntry copyWith({
    String? id,
    String? medicationId,
    int? quantity,
    DateTime? expirationDate,
    String? batchNumber,
    double? costPerUnit,
    DateTime? addedDate,
    InventoryStatus? status,
    String? supplierName,
    String? notes,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return InventoryEntry(
      id: id ?? this.id,
      medicationId: medicationId ?? this.medicationId,
      quantity: quantity ?? this.quantity,
      expirationDate: expirationDate ?? this.expirationDate,
      batchNumber: batchNumber ?? this.batchNumber,
      costPerUnit: costPerUnit ?? this.costPerUnit,
      addedDate: addedDate ?? this.addedDate,
      status: status ?? this.status,
      supplierName: supplierName ?? this.supplierName,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  // Helper getters
  bool get isExpired => expirationDate != null && 
      expirationDate!.isBefore(DateTime.now());
  
  bool get isExpiringSoon => expirationDate != null && 
      expirationDate!.isBefore(DateTime.now().add(const Duration(days: 30)));
  
  double get totalValue => (costPerUnit ?? 0.0) * quantity;
  
  int get daysUntilExpiration => expirationDate != null 
      ? expirationDate!.difference(DateTime.now()).inDays
      : -1;
}

enum InventoryStatus {
  @JsonValue('available')
  available,
  
  @JsonValue('expired')
  expired,
  
  @JsonValue('depleted')
  depleted,
  
  @JsonValue('reserved')
  reserved,
  
  @JsonValue('damaged')
  damaged,
  
  @JsonValue('recalled')
  recalled;

  String get displayName {
    switch (this) {
      case InventoryStatus.available:
        return 'Available';
      case InventoryStatus.expired:
        return 'Expired';
      case InventoryStatus.depleted:
        return 'Depleted';
      case InventoryStatus.reserved:
        return 'Reserved';
      case InventoryStatus.damaged:
        return 'Damaged';
      case InventoryStatus.recalled:
        return 'Recalled';
    }
  }
}
