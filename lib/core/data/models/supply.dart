import 'package:hive/hive.dart';

part 'supply.g.dart';

@HiveType(typeId: 4)
enum SupplyType {
  @HiveField(0)
  item, // Countable items like alcohol swabs, syringes, etc.
  
  @HiveField(1)
  fluid, // Measurable fluids like bacteriostatic water, saline, etc.
}

@HiveType(typeId: 5)
enum SupplyUnit {
  // Item units
  @HiveField(0)
  pieces,
  @HiveField(1)
  syringes,
  @HiveField(2)
  swabs,
  @HiveField(3)
  vials,
  @HiveField(4)
  needles,
  @HiveField(5)
  bottles,
  
  // Fluid units
  @HiveField(6)
  ml,
  @HiveField(7)
  liters,
}

@HiveType(typeId: 6)
class Supply extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String name;

  @HiveField(2)
  SupplyType type;

  @HiveField(3)
  double currentStock;

  @HiveField(4)
  SupplyUnit unit;

  @HiveField(5)
  double lowStockThreshold;

  @HiveField(6)
  DateTime? expirationDate;

  @HiveField(7)
  String? notes;

  @HiveField(8)
  String? lotNumber;

  @HiveField(9)
  DateTime createdAt;

  @HiveField(10)
  DateTime updatedAt;

  @HiveField(11)
  double? costPerUnit;

  @HiveField(12)
  String? supplier;

  Supply({
    required this.id,
    required this.name,
    required this.type,
    required this.currentStock,
    required this.unit,
    required this.lowStockThreshold,
    this.expirationDate,
    this.notes,
    this.lotNumber,
    required this.createdAt,
    required this.updatedAt,
    this.costPerUnit,
    this.supplier,
  });

  // Computed properties
  bool get isLowStock => currentStock <= lowStockThreshold;
  
  bool get isExpired => 
      expirationDate != null && expirationDate!.isBefore(DateTime.now());
  
  bool get isExpiringSoon => 
      expirationDate != null && 
      expirationDate!.isAfter(DateTime.now()) &&
      expirationDate!.isBefore(DateTime.now().add(const Duration(days: 30)));

  String get stockStatusText {
    if (isExpired) return 'EXPIRED';
    if (isExpiringSoon) return 'EXPIRES SOON';
    if (isLowStock) return 'LOW STOCK';
    return 'IN STOCK';
  }

  String get displayUnit {
    switch (unit) {
      case SupplyUnit.pieces:
        return 'pcs';
      case SupplyUnit.syringes:
        return 'syringes';
      case SupplyUnit.swabs:
        return 'swabs';
      case SupplyUnit.vials:
        return 'vials';
      case SupplyUnit.needles:
        return 'needles';
      case SupplyUnit.bottles:
        return 'bottles';
      case SupplyUnit.ml:
        return 'mL';
      case SupplyUnit.liters:
        return 'L';
    }
  }

  String get displayName {
    return '$name (${currentStock.toStringAsFixed(type == SupplyType.fluid ? 1 : 0)} $displayUnit)';
  }

  // Usage tracking methods
  void consume(double amount) {
    if (amount <= currentStock) {
      currentStock = (currentStock - amount).clamp(0.0, double.infinity);
      updatedAt = DateTime.now();
    }
  }

  void restock(double amount) {
    currentStock += amount;
    updatedAt = DateTime.now();
  }

  Supply copyWith({
    String? id,
    String? name,
    SupplyType? type,
    double? currentStock,
    SupplyUnit? unit,
    double? lowStockThreshold,
    DateTime? expirationDate,
    String? notes,
    String? lotNumber,
    DateTime? createdAt,
    DateTime? updatedAt,
    double? costPerUnit,
    String? supplier,
  }) {
    return Supply(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      currentStock: currentStock ?? this.currentStock,
      unit: unit ?? this.unit,
      lowStockThreshold: lowStockThreshold ?? this.lowStockThreshold,
      expirationDate: expirationDate ?? this.expirationDate,
      notes: notes ?? this.notes,
      lotNumber: lotNumber ?? this.lotNumber,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      costPerUnit: costPerUnit ?? this.costPerUnit,
      supplier: supplier ?? this.supplier,
    );
  }

  @override
  String toString() {
    return 'Supply(id: $id, name: $name, type: $type, currentStock: $currentStock, unit: $unit)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    
    return other is Supply &&
        other.id == id &&
        other.name == name &&
        other.type == type &&
        other.currentStock == currentStock &&
        other.unit == unit;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        type.hashCode ^
        currentStock.hashCode ^
        unit.hashCode;
  }
}

// Usage tracking for linking supplies to medication doses
@HiveType(typeId: 7)
class SupplyUsage extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String supplyId;

  @HiveField(2)
  String? medicationId; // Optional - can be used without specific medication

  @HiveField(3)
  double amountUsed;

  @HiveField(4)
  DateTime usedAt;

  @HiveField(5)
  String? notes;

  @HiveField(6)
  String? doseRecordId; // Link to specific dose record if applicable

  SupplyUsage({
    required this.id,
    required this.supplyId,
    this.medicationId,
    required this.amountUsed,
    required this.usedAt,
    this.notes,
    this.doseRecordId,
  });

  SupplyUsage copyWith({
    String? id,
    String? supplyId,
    String? medicationId,
    double? amountUsed,
    DateTime? usedAt,
    String? notes,
    String? doseRecordId,
  }) {
    return SupplyUsage(
      id: id ?? this.id,
      supplyId: supplyId ?? this.supplyId,
      medicationId: medicationId ?? this.medicationId,
      amountUsed: amountUsed ?? this.amountUsed,
      usedAt: usedAt ?? this.usedAt,
      notes: notes ?? this.notes,
      doseRecordId: doseRecordId ?? this.doseRecordId,
    );
  }
}
