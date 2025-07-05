import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:takhfifman/models/discount_code.dart';

class AddCodeScreen extends StatefulWidget {
  const AddCodeScreen({super.key});

  @override
  State<AddCodeScreen> createState() => _AddCodeScreenState();
}

class _AddCodeScreenState extends State<AddCodeScreen> {
  final _formKey = GlobalKey<FormState>();
  final _codeController = TextEditingController();
  final _brandController = TextEditingController();
  final _detailController = TextEditingController();
  final _minPurchaseController = TextEditingController();
  final _usageLimitController = TextEditingController();
  final _discountValueController = TextEditingController();

  bool _isPercent = false;
  DateTime? _expiresAt;

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final newCode = DiscountCode(
      code: _codeController.text.trim(),
      brand: _brandController.text.trim(),
      receivedAt: DateTime.now(),
      expiresAt: _expiresAt,
      discountDetail: _detailController.text.trim(),
      minPurchase: double.tryParse(_minPurchaseController.text),
      usageLimit: int.tryParse(_usageLimitController.text),
      discountValue: double.tryParse(_discountValueController.text),
      isPercentage: _isPercent,
    );

    final box = Hive.box<DiscountCode>('codes');
    await box.add(newCode);

    Navigator.pop(context); // برمی‌گردیم به صفحه قبلی
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('افزودن کد تخفیف')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _codeController,
                decoration: const InputDecoration(labelText: 'کد'),
                validator: (v) => v!.isEmpty ? 'کد اجباریه' : null,
              ),
              TextFormField(
                controller: _brandController,
                decoration: const InputDecoration(labelText: 'برند'),
                validator: (v) => v!.isEmpty ? 'برند اجباریه' : null,
              ),
              TextFormField(controller: _detailController, decoration: const InputDecoration(labelText: 'توضیحات')),
              TextFormField(
                controller: _minPurchaseController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'کف خرید (تومان)'),
              ),
              TextFormField(
                controller: _usageLimitController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'تعداد استفاده مجاز'),
              ),
              TextFormField(
                controller: _discountValueController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'مقدار تخفیف'),
              ),
              Row(children: [Checkbox(value: _isPercent, onChanged: (v) => setState(() => _isPercent = v!)), const Text('درصدی است')]),
              ListTile(
                title: Text(_expiresAt == null ? 'تاریخ انقضا انتخاب نشده' : 'انقضا: ${_expiresAt!.toLocal().toString().substring(0, 10)}'),
                trailing: const Icon(Icons.calendar_today),
                onTap: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now().add(const Duration(days: 30)),
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(const Duration(days: 365)),
                  );
                  if (picked != null) setState(() => _expiresAt = picked);
                },
              ),
              const SizedBox(height: 16),
              ElevatedButton(onPressed: _submit, child: const Text('ذخیره')),
            ],
          ),
        ),
      ),
    );
  }
}
