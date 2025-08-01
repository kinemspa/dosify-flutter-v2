// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'supply.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SupplyAdapter extends TypeAdapter<Supply> {
  @override
  final int typeId = 6;

  @override
  Supply read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Supply(
      id: fields[0] as String,
      name: fields[1] as String,
      type: fields[2] as SupplyType,
      currentStock: fields[3] as double,
      unit: fields[4] as SupplyUnit,
      lowStockThreshold: fields[5] as double,
      expirationDate: fields[6] as DateTime?,
      notes: fields[7] as String?,
      lotNumber: fields[8] as String?,
      createdAt: fields[9] as DateTime,
      updatedAt: fields[10] as DateTime,
      costPerUnit: fields[11] as double?,
      supplier: fields[12] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, Supply obj) {
    writer
      ..writeByte(13)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.type)
      ..writeByte(3)
      ..write(obj.currentStock)
      ..writeByte(4)
      ..write(obj.unit)
      ..writeByte(5)
      ..write(obj.lowStockThreshold)
      ..writeByte(6)
      ..write(obj.expirationDate)
      ..writeByte(7)
      ..write(obj.notes)
      ..writeByte(8)
      ..write(obj.lotNumber)
      ..writeByte(9)
      ..write(obj.createdAt)
      ..writeByte(10)
      ..write(obj.updatedAt)
      ..writeByte(11)
      ..write(obj.costPerUnit)
      ..writeByte(12)
      ..write(obj.supplier);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SupplyAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class SupplyUsageAdapter extends TypeAdapter<SupplyUsage> {
  @override
  final int typeId = 7;

  @override
  SupplyUsage read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SupplyUsage(
      id: fields[0] as String,
      supplyId: fields[1] as String,
      medicationId: fields[2] as String?,
      amountUsed: fields[3] as double,
      usedAt: fields[4] as DateTime,
      notes: fields[5] as String?,
      doseRecordId: fields[6] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, SupplyUsage obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.supplyId)
      ..writeByte(2)
      ..write(obj.medicationId)
      ..writeByte(3)
      ..write(obj.amountUsed)
      ..writeByte(4)
      ..write(obj.usedAt)
      ..writeByte(5)
      ..write(obj.notes)
      ..writeByte(6)
      ..write(obj.doseRecordId);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SupplyUsageAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class SupplyTypeAdapter extends TypeAdapter<SupplyType> {
  @override
  final int typeId = 4;

  @override
  SupplyType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return SupplyType.item;
      case 1:
        return SupplyType.fluid;
      default:
        return SupplyType.item;
    }
  }

  @override
  void write(BinaryWriter writer, SupplyType obj) {
    switch (obj) {
      case SupplyType.item:
        writer.writeByte(0);
        break;
      case SupplyType.fluid:
        writer.writeByte(1);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SupplyTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class SupplyUnitAdapter extends TypeAdapter<SupplyUnit> {
  @override
  final int typeId = 5;

  @override
  SupplyUnit read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return SupplyUnit.pieces;
      case 1:
        return SupplyUnit.syringes;
      case 2:
        return SupplyUnit.swabs;
      case 3:
        return SupplyUnit.vials;
      case 4:
        return SupplyUnit.needles;
      case 5:
        return SupplyUnit.bottles;
      case 6:
        return SupplyUnit.ml;
      case 7:
        return SupplyUnit.liters;
      default:
        return SupplyUnit.pieces;
    }
  }

  @override
  void write(BinaryWriter writer, SupplyUnit obj) {
    switch (obj) {
      case SupplyUnit.pieces:
        writer.writeByte(0);
        break;
      case SupplyUnit.syringes:
        writer.writeByte(1);
        break;
      case SupplyUnit.swabs:
        writer.writeByte(2);
        break;
      case SupplyUnit.vials:
        writer.writeByte(3);
        break;
      case SupplyUnit.needles:
        writer.writeByte(4);
        break;
      case SupplyUnit.bottles:
        writer.writeByte(5);
        break;
      case SupplyUnit.ml:
        writer.writeByte(6);
        break;
      case SupplyUnit.liters:
        writer.writeByte(7);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SupplyUnitAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
