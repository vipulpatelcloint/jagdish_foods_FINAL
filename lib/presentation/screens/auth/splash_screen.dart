// lib/presentation/screens/auth/splash_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_constants.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override State<SplashScreen> createState() => _SplashState();
}
class _SplashState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) context.go('/welcome');
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.heroGradient),
        child: Center(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Container(
              padding: const EdgeInsets.all(28),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.12),
                borderRadius: BorderRadius.circular(28),
                border: Border.all(color: Colors.white.withOpacity(0.2)),
              ),
              child: Column(children: [
                const Icon(Icons.restaurant_rounded, color: Colors.white, size: 64),
                const SizedBox(height: 12),
                const Text('Jagdish', style: TextStyle(
                  fontFamily: 'Poppins', color: Colors.white,
                  fontSize: 28, fontWeight: FontWeight.w700)),
                Text('FOODS', style: TextStyle(
                  fontFamily: 'Poppins', color: Colors.white.withOpacity(0.7),
                  fontSize: 12, letterSpacing: 4, fontWeight: FontWeight.w500)),
              ]),
            ).animate().scale(duration: 600.ms, curve: Curves.elasticOut),
            const SizedBox(height: 20),
            Text(AppConstants.appTagline,
              style: TextStyle(fontFamily: 'Poppins', color: Colors.white.withOpacity(0.75),
                fontSize: 13, letterSpacing: 1.5)),
            const SizedBox(height: 50),
            SizedBox(width: 80, child: LinearProgressIndicator(
              backgroundColor: Colors.white.withOpacity(0.2),
              color: AppColors.yellow, minHeight: 3,
            )),
          ]),
        ),
      ),
    );
  }
}
