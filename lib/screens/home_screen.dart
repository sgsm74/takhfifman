import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:takhfifman/data/local_storage.dart';
import 'package:takhfifman/models/discount_code.dart';
import 'package:takhfifman/screens/add_code_screen.dart';
import 'package:takhfifman/screens/brand_screen.dart';
import 'package:takhfifman/services/sms_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.toggleTheme});
  final VoidCallback toggleTheme;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final SmsService _smsService = SmsService();
  bool _loading = false;
  String _search = '';
  String _sortMode = 'date'; // or 'exp'

  Future<void> _scanSms() async {
    setState(() => _loading = true);

    final granted = await _smsService.requestPermissions();
    if (!granted) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('اجازه دسترسی به پیامک داده نشد.')));
      setState(() => _loading = false);
      return;
    }

    final codes = await _smsService.fetchDiscountCodes();
    await LocalStorage.saveCodes(codes);

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${codes.length} کد جدید اضافه شد!')));

    setState(() => _loading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('تخفیف من'),
        actions: [
          IconButton(
            icon: const Icon(Icons.list_alt),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => const BrandScreen()));
            },
          ),
          IconButton(
            onPressed: _loading ? null : _scanSms,
            icon: _loading ? const CircularProgressIndicator(strokeWidth: 2) : const Icon(Icons.refresh),
          ),
          IconButton(icon: const Icon(Icons.brightness_6), onPressed: widget.toggleTheme),
          PopupMenuButton<String>(
            icon: const Icon(Icons.sort),
            onSelected: (value) => setState(() => _sortMode = value),
            itemBuilder:
                (context) => [
                  const PopupMenuItem(value: 'date', child: Text('مرتب بر اساس تاریخ دریافت')),
                  const PopupMenuItem(value: 'exp', child: Text('مرتب بر اساس تاریخ انقضا')),
                ],
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48),
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: TextField(
              decoration: const InputDecoration(
                hintText: 'جستجو کد یا برند...',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(horizontal: 12),
              ),
              onChanged: (value) => setState(() => _search = value),
            ),
          ),
        ),
      ),
      body: ValueListenableBuilder(
        valueListenable: Hive.box<DiscountCode>('codes').listenable(),
        builder: (context, Box<DiscountCode> box, _) {
          var codes = box.values.toList();

          // فیلتر
          if (_search.isNotEmpty) {
            codes =
                codes
                    .where(
                      (c) => c.code.toLowerCase().contains(_search.toLowerCase()) || c.brand.toLowerCase().contains(_search.toLowerCase()),
                    )
                    .toList();
          }

          // مرتب‌سازی
          if (_sortMode == 'date') {
            codes.sort((a, b) => b.receivedAt.compareTo(a.receivedAt));
          } else if (_sortMode == 'exp') {
            codes.sort((a, b) {
              final aExp = a.expiresAt ?? DateTime(2100);
              final bExp = b.expiresAt ?? DateTime(2100);
              return aExp.compareTo(bExp);
            });
          }

          if (codes.isEmpty) {
            return const Center(child: Text('چیزی پیدا نشد.'));
          }

          return ListView.builder(
            itemCount: codes.length,
            itemBuilder: (context, index) {
              final code = codes[index];
              final isExpired = code.isExpired;

              return ListTile(
                title: Text('${code.brand} - ${code.code}'),
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
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (_) => const AddCodeScreen()));
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
