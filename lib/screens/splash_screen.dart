import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:takhfifman/screens/home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key, required this.toggleTheme});
  final VoidCallback toggleTheme;

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Map<String, dynamic> packageinfo = {};
  @override
  void initState() {
    super.initState();
    checkVersion();
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => HomeScreen(toggleTheme: widget.toggleTheme)));
    });
  }

  void checkVersion() async {
    packageinfo = await initPackageInfo();
  }

  Future<Map<String, dynamic>> initPackageInfo() async {
    final info = await PackageInfo.fromPlatform();
    return <String, dynamic>{'app_version': info.version, 'app_build_number': info.buildNumber};
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        maintainBottomViewPadding: true,
        top: true,
        bottom: true,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/images/logo.png', width: MediaQuery.sizeOf(context).width, height: MediaQuery.sizeOf(context).height / 2),
              Spacer(),
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text('V1.0.0'),
            ],
          ),
        ),
      ),
    );
  }
}
