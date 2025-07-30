// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'inventory_entry.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

InventoryEntry _$InventoryEntryFromJson(Map<String, dynamic> json) =>
    InventoryEntry(
      id: json['id'] as String,
      medicationId: json['medicationId'] as String,
      quantity: (json['quantity'] as num).toInt(),
      expirationDate: json['expirationDate'] == null
          ? null
          : DateTime.parse(json['expirationDate'] as String),
      batchNumber: json['batchNumber'] as String?,
      costPerUnit: (json['costPerUnit'] as num?)?.toDouble(),
      addedDate: DateTime.parse(json['addedDate'] as String),
      status: $enumDecode(_$InventoryStatusEnumMap, json['status']),
      supplierName: json['supplierName'] as String?,
      notes: json['notes'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$InventoryEntryToJson(InventoryEntry instance) =>
    <String, dynamic>{
      'id': instance.id,
      'medicationId': instance.medicationId,
      'quantity': instance.quantity,
      'expirationDate': instance.expirationDate?.toIso8601String(),
      'batchNumber': instance.batchNumber,
      'costPerUnit': instance.costPerUnit,
      'addedDate': instance.addedDate.toIso8601String(),
      'status': _$InventoryStatusEnumMap[instance.status]!,
      'supplierName': instance.supplierName,
      'notes': instance.notes,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };

const _$InventoryStatusEnumMap = {
  InventoryStatus.available: 'available',
  InventoryStatus.expired: 'expired',
  InventoryStatus.depleted: 'depleted',
  InventoryStatus.reserved: 'reserved',
  InventoryStatus.damaged: 'damaged',
  InventoryStatus.recalled: 'recalled',
};
