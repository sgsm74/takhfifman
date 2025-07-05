import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:takhfifman/screens/splash_screen.dart';
import 'models/discount_code.dart';
import 'theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(DiscountCodeAdapter());
  await Hive.openBox<DiscountCode>('codes');

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeMode _themeMode = ThemeMode.system;

  void _toggleTheme() {
    setState(() {
      _themeMode = _themeMode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'تخفیف من',
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: _themeMode,
      home: SplashScreen(toggleTheme: _toggleTheme),
    );
  }
}
