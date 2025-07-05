import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:takhfifman/models/discount_code.dart';

class FilteredCodeScreen extends StatelessWidget {
  final String brand;

  const FilteredCodeScreen({super.key, required this.brand});

  @override
  Widget build(BuildContext context) {
    final box = Hive.box<DiscountCode>('codes');
    final codes = box.values.where((c) => c.brand == brand).toList();

    return Scaffold(
      appBar: AppBar(title: Text('کدهای $brand')),
      body: ListView.builder(
        itemCount: codes.length,
        itemBuilder: (context, index) {
          final code = codes[index];
          final isExpired = code.isExpired;

          return ListTile(
            title: Text(code.code),
            subtitle: Text(code.discountDetail ?? ''),
            trailing: IconButton(
              icon: const Icon(Icons.copy),
              onPressed: () {
                Clipboard.setData(ClipboardData(text: code.code));
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('کد کپی شد!')));
              },
            ),
            tileColor: isExpired ? Colors.grey[300] : null,
          );
        },
      ),
    );
  }
}
