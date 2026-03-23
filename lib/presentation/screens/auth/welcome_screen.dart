// lib/presentation/screens/auth/welcome_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(children: [
        // Hero
        Container(
          height: MediaQuery.of(context).size.height * 0.50,
          decoration: const BoxDecoration(
            gradient: AppColors.heroGradient,
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(36)),
          ),
          child: SafeArea(child: Center(child: Column(
            mainAxisAlignment: MainAxisAlignment.center, children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: Colors.white.withOpacity(0.25)),
                ),
                child: const Icon(Icons.restaurant_rounded, color: Colors.white, size: 56),
              ).animate().scale(duration: 600.ms, curve: Curves.elasticOut),
              const SizedBox(height: 16),
              const Text('Jagdish Foods',
                style: TextStyle(fontFamily: 'Poppins', color: Colors.white,
                  fontSize: 26, fontWeight: FontWeight.w700)).animate(delay: 200.ms).fadeIn().slideY(begin: 0.3),
              const SizedBox(height: 6),
              Text("Vadodara's Taste Since 1945",
                style: TextStyle(fontFamily: 'Poppins', color: Colors.white.withOpacity(0.8), fontSize: 13))
                .animate(delay: 350.ms).fadeIn(),
              const SizedBox(height: 16),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                _Pill('🌿 Pure Veg'), const SizedBox(width: 8),
                _Pill('🏆 Since 1945'), const SizedBox(width: 8),
                _Pill('🚚 Fast Delivery'),
              ]).animate(delay: 500.ms).fadeIn(),
            ],
          ))),
        ),
        // Body
        Expanded(child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const SizedBox(height: 8),
            const Text('Welcome! 👋', style: TextStyle(
              fontFamily: 'Poppins', fontSize: 24, fontWeight: FontWeight.w700, color: AppColors.textDark)),
            const SizedBox(height: 6),
            const Text('Sign in to enjoy Bhakharwadi, Chevdo,\nand your favourite Gujarati snacks.',
              style: TextStyle(fontFamily: 'Poppins', fontSize: 13, color: AppColors.textMedium)),
            const SizedBox(height: 28),
            ElevatedButton.icon(
              onPressed: () => context.push('/phone'),
              icon: const Icon(Icons.phone_android_rounded),
              label: const Text('Continue with Phone'),
            ).animate(delay: 400.ms).fadeIn().slideY(begin: 0.2),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              onPressed: () => context.go('/home'),
              icon: const Icon(Icons.person_outline_rounded),
              label: const Text('Continue as Guest'),
            ).animate(delay: 500.ms).fadeIn().slideY(begin: 0.2),
          ]),
        )),
      ]),
    );
  }
}

class _Pill extends StatelessWidget {
  final String text;
  const _Pill(this.text);
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
    decoration: BoxDecoration(
      color: Colors.white.withOpacity(0.15),
      borderRadius: BorderRadius.circular(20),
      border: Border.all(color: Colors.white.withOpacity(0.2)),
    ),
    child: Text(text, style: const TextStyle(
      fontFamily: 'Poppins', color: Colors.white, fontSize: 11, fontWeight: FontWeight.w500)),
  );
}
