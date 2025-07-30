import 'package:json_annotation/json_annotation.dart';

part 'inventory_transaction.g.dart';

@JsonSerializable()
class InventoryTransaction {
  final String id;
  final String entryId;
  final TransactionType transactionType;
  final int quantity;
  final String? reason;
  final String? performedBy;
  final DateTime transactionDate;
  final String? notes;
  final DateTime createdAt;

  const InventoryTransaction({
    required this.id,
    required this.entryId,
    required this.transactionType,
    required this.quantity,
    this.reason,
    this.performedBy,
    required this.transactionDate,
    this.notes,
    required this.createdAt,
  });

  factory InventoryTransaction.fromJson(Map<String, dynamic> json) =>
      _$InventoryTransactionFromJson(json);

  Map<String, dynamic> toJson() => _$InventoryTransactionToJson(this);

  InventoryTransaction copyWith({
    String? id,
    String? entryId,
    TransactionType? transactionType,
    int? quantity,
    String? reason,
    String? performedBy,
    DateTime? transactionDate,
    String? notes,
    DateTime? createdAt,
  }) {
    return InventoryTransaction(
      id: id ?? this.id,
      entryId: entryId ?? this.entryId,
      transactionType: transactionType ?? this.transactionType,
      quantity: quantity ?? this.quantity,
      reason: reason ?? this.reason,
      performedBy: performedBy ?? this.performedBy,
      transactionDate: transactionDate ?? this.transactionDate,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  // Helper getters
  bool get isIncoming => transactionType == TransactionType.received ||
      transactionType == TransactionType.returned ||
      transactionType == TransactionType.adjustment && quantity > 0;

  bool get isOutgoing => transactionType == TransactionType.dispensed ||
      transactionType == TransactionType.wasted ||
      transactionType == TransactionType.expired ||
      transactionType == TransactionType.adjustment && quantity < 0;
}

enum TransactionType {
  @JsonValue('received')
  received,
  
  @JsonValue('dispensed')
  dispensed,
  
  @JsonValue('wasted')
  wasted,
  
  @JsonValue('expired')
  expired,
  
  @JsonValue('returned')
  returned,
  
  @JsonValue('adjustment')
  adjustment,
  
  @JsonValue('transferred')
  transferred;

  String get displayName {
    switch (this) {
      case TransactionType.received:
        return 'Received';
      case TransactionType.dispensed:
        return 'Dispensed';
      case TransactionType.wasted:
        return 'Wasted';
      case TransactionType.expired:
        return 'Expired';
      case TransactionType.returned:
        return 'Returned';
      case TransactionType.adjustment:
        return 'Adjustment';
      case TransactionType.transferred:
        return 'Transferred';
    }
  }

  String get description {
    switch (this) {
      case TransactionType.received:
        return 'Stock received from supplier';
      case TransactionType.dispensed:
        return 'Medication taken/used';
      case TransactionType.wasted:
        return 'Stock discarded/wasted';
      case TransactionType.expired:
        return 'Expired stock removed';
      case TransactionType.returned:
        return 'Stock returned to inventory';
      case TransactionType.adjustment:
        return 'Inventory count adjustment';
      case TransactionType.transferred:
        return 'Stock transferred to another location';
    }
  }
}
