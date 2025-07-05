import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:takhfifman/models/discount_code.dart';
import 'package:takhfifman/screens/filtered_code_screen.dart';

class BrandScreen extends StatefulWidget {
  const BrandScreen({super.key});

  @override
  State<BrandScreen> createState() => _BrandScreenState();
}

class _BrandScreenState extends State<BrandScreen> {
  List<String> brands = [];
  List<DiscountCode> codes = [];

  @override
  void initState() {
    super.initState();
    final box = Hive.box<DiscountCode>('codes');
    codes = box.values.toList();

    brands = codes.map((e) => e.brand).toSet().toList();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(title: const Text('برندها')),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: ListView.builder(
            itemCount: brands.length,
            itemBuilder: (context, index) {
              final brand = brands[index];
              final count = codes.where((c) => c.brand == brand).length;
              return GestureDetector(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) => FilteredCodeScreen(brand: brand)));
                },
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                    side: BorderSide(color: Color(0xFF1A73E8).withValues(alpha: 0.1), width: 1),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Row(
                      children: [
                        Image.asset('assets/images/brands/digikala.png', width: 64, height: 64),
                        Text(brand),
                        Spacer(),
                        Text('$count کد تخفیف'),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
