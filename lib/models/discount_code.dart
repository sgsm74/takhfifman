import 'package:equatable/equatable.dart';
import 'package:hive_flutter/hive_flutter.dart';

part 'discount_code.g.dart';

@HiveType(typeId: 0)
class DiscountCode extends Equatable {
  const DiscountCode({
    required this.code,
    required this.brand,
    required this.receivedAt,
    this.expiresAt,
    this.minPurchase,
    this.usageLimit,
    this.discountDetail,
    this.discountValue,
    this.isPercentage = false,
  });

  @HiveField(0)
  final String code;

  @HiveField(1)
  final String brand;

  @HiveField(2)
  final DateTime receivedAt;

  @HiveField(3)
  final DateTime? expiresAt;

  @HiveField(4)
  final double? minPurchase;

  @HiveField(5)
  final int? usageLimit;

  @HiveField(6)
  final String? discountDetail;

  @HiveField(7)
  final double? discountValue;

  @HiveField(8)
  final bool isPercentage;

  bool get isExpired => expiresAt != null && expiresAt!.isBefore(DateTime.now());

  @override
  List<Object?> get props => [code];
}
