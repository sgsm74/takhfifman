import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:takhfifman/models/discount_code.dart';
import 'package:takhfifman/screens/filtered_code_screen.dart';

class BrandScreen extends StatelessWidget {
  const BrandScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final box = Hive.box<DiscountCode>('codes');
    final codes = box.values.toList();

    final brands = codes.map((e) => e.brand).toSet().toList();

    return Scaffold(
      appBar: AppBar(title: const Text('برندها')),
      body: ListView.builder(
        itemCount: brands.length,
        itemBuilder: (context, index) {
          final brand = brands[index];
          final count = codes.where((c) => c.brand == brand).length;

          return ListTile(
            title: Text(brand),
            subtitle: Text('$count کد تخفیف'),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => FilteredCodeScreen(brand: brand)));
            },
          );
        },
      ),
    );
  }
}
