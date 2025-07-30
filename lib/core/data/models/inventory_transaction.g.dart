// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'inventory_transaction.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

InventoryTransaction _$InventoryTransactionFromJson(
        Map<String, dynamic> json) =>
    InventoryTransaction(
      id: json['id'] as String,
      entryId: json['entryId'] as String,
      transactionType:
          $enumDecode(_$TransactionTypeEnumMap, json['transactionType']),
      quantity: (json['quantity'] as num).toInt(),
      reason: json['reason'] as String?,
      performedBy: json['performedBy'] as String?,
      transactionDate: DateTime.parse(json['transactionDate'] as String),
      notes: json['notes'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$InventoryTransactionToJson(
        InventoryTransaction instance) =>
    <String, dynamic>{
      'id': instance.id,
      'entryId': instance.entryId,
      'transactionType': _$TransactionTypeEnumMap[instance.transactionType]!,
      'quantity': instance.quantity,
      'reason': instance.reason,
      'performedBy': instance.performedBy,
      'transactionDate': instance.transactionDate.toIso8601String(),
      'notes': instance.notes,
      'createdAt': instance.createdAt.toIso8601String(),
    };

const _$TransactionTypeEnumMap = {
  TransactionType.received: 'received',
  TransactionType.dispensed: 'dispensed',
  TransactionType.wasted: 'wasted',
  TransactionType.expired: 'expired',
  TransactionType.returned: 'returned',
  TransactionType.adjustment: 'adjustment',
  TransactionType.transferred: 'transferred',
};
