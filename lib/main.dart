import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'screens/detail_screen.dart';
import 'screens/home_screen.dart';
import 'widgets/brand_logo.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Aura Jewelry Store',
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFFF9F6EE),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF0A1931),
          elevation: 0,
        ),
      ),
      home: const SplashGate(),
      onGenerateRoute: (settings) {
        if (settings.name == ProductDetailScreen.routeName) {
          return MaterialPageRoute<void>(
            builder: (_) => const ProductDetailScreen(),
            settings: settings,
          );
        }
        return null;
      },
    );
  }
}

class SplashGate extends StatefulWidget {
  const SplashGate({super.key});

  @override
  State<SplashGate> createState() => _SplashGateState();
}

class _SplashGateState extends State<SplashGate> {
  bool showHome = false;

  @override
  void initState() {
    super.initState();
    Future<void>.delayed(const Duration(milliseconds: 3500), () {
      if (!mounted) return;
      setState(() => showHome = true);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (showHome) return const ProductGridScreen();
    return const SplashScreen();
  }
}

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A1931),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const BrandLogo(isSplash: true),
            const SizedBox(height: 20),
            SvgPicture.asset(
              'assets/icons/diamond.svg',
              width: 52,
              height: 52,
              colorFilter: const ColorFilter.mode(
                Colors.white,
                BlendMode.srcIn,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
