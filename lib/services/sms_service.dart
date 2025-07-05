import 'package:telephony/telephony.dart';
import '../models/discount_code.dart';

class SmsService {
  final Telephony telephony = Telephony.instance;

  Future<bool> requestPermissions() async {
    return await telephony.requestPhoneAndSmsPermissions ?? false;
  }

  Future<List<DiscountCode>> fetchDiscountCodes() async {
    final smsList = await telephony.getInboxSms(columns: [SmsColumn.BODY]);

    final List<DiscountCode> codes = [];

    for (var sms in smsList) {
      final body = sms.body ?? '';

      // فقط پیامک‌هایی که احتمالاً کد دارن رو بررسی کن
      if (_looksLikeCoupon(body)) {
        final code = _extractCode(body);
        final brand = _detectBrand(body);
        final minPurchase = _extractMinPurchase(body);
        final usageLimit = _extractUsageLimit(body);
        final (value, isPercent) = _extractDiscountValue(body);

        if (code != null && brand != null) {
          codes.add(
            DiscountCode(
              code: code,
              brand: brand,
              receivedAt: DateTime.now(),
              minPurchase: minPurchase,
              usageLimit: usageLimit,
              discountValue: value,
              isPercentage: isPercent,
              discountDetail: body,
            ),
          );
        }
      }
    }

    return codes;
  }

  bool _looksLikeCoupon(String body) {
    return body.contains('%') || body.contains('تخفیف') || body.contains('OFF');
  }

  String? _extractCode(String text) {
    final match = RegExp(r'(?:(?:کد|کد تخفیف)[:：]?\s*)([A-Z0-9]{4,})').firstMatch(text);
    return match?.group(1);
  }

  String? _detectBrand(String text) {
    if (text.contains('دیجی')) return 'دیجی‌کالا';
    if (text.contains('اسنپ')) return 'اسنپ';
    if (text.contains('علی‌بابا')) return 'علی‌بابا';
    // بقیه برندها رو هم اضافه کن
    return 'نامشخص';
  }

  double? _extractMinPurchase(String text) {
    final match = RegExp(r'بالای\s*(\d{4,7})\s*(?:تومان|هزار)').firstMatch(text);
    if (match != null) {
      final value = double.tryParse(match.group(1)!);
      return value;
    }
    return null;
  }

  int? _extractUsageLimit(String text) {
    final match = RegExp(r'(?:تا)?\s*(\d)\s*بار').firstMatch(text);
    if (match != null) {
      return int.tryParse(match.group(1)!);
    }
    return null;
  }

  (double?, bool) _extractDiscountValue(String text) {
    final percent = RegExp(r'(\d{1,2})\s*٪').firstMatch(text);
    if (percent != null) {
      return (double.tryParse(percent.group(1)!), true);
    }

    final fixed = RegExp(r'(\d{2,7})\s*(?:تومان|هزار)').firstMatch(text);
    if (fixed != null) {
      return (double.tryParse(fixed.group(1)!), false);
    }

    return (null, false);
  }
}
