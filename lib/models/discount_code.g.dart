// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'discount_code.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DiscountCodeAdapter extends TypeAdapter<DiscountCode> {
  @override
  final int typeId = 0;

  @override
  DiscountCode read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DiscountCode(
      code: fields[0] as String,
      brand: fields[1] as String,
      receivedAt: fields[2] as DateTime,
      expiresAt: fields[3] as DateTime?,
      minPurchase: fields[4] as double?,
      usageLimit: fields[5] as int?,
      discountDetail: fields[6] as String?,
      discountValue: fields[7] as double?,
      isPercentage: fields[8] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, DiscountCode obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.code)
      ..writeByte(1)
      ..write(obj.brand)
      ..writeByte(2)
      ..write(obj.receivedAt)
      ..writeByte(3)
      ..write(obj.expiresAt)
      ..writeByte(4)
      ..write(obj.minPurchase)
      ..writeByte(5)
      ..write(obj.usageLimit)
      ..writeByte(6)
      ..write(obj.discountDetail)
      ..writeByte(7)
      ..write(obj.discountValue)
      ..writeByte(8)
      ..write(obj.isPercentage);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DiscountCodeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
