import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  static const Color primary      = Color(0xFF0083BC);
  static const Color primaryDark  = Color(0xFF005F8A);
  static const Color primaryLight = Color(0xFFE6F4FB);

  static const Color green      = Color(0xFF52B52A);
  static const Color greenDeep  = Color(0xFF2E7D32);
  static const Color greenLight = Color(0xFFE8F5E9);

  static const Color yellow      = Color(0xFFF4A300);
  static const Color gold        = Color(0xFFD4AF37);
  static const Color yellowLight = Color(0xFFFFF8E1);

  static const Color cream       = Color(0xFFFFF5E1);
  static const Color creamLight  = Color(0xFFFFF9F0);
  static const Color scaffoldBg  = Color(0xFFF5F7FA);
  static const Color white       = Color(0xFFFFFFFF);

  static const Color textDark   = Color(0xFF1A1A2E);
  static const Color textMedium = Color(0xFF4A4A6A);
  static const Color textLight  = Color(0xFF9090A8);
  static const Color textHint   = Color(0xFFBBBBCC);

  static const Color border      = Color(0xFFE8E8F0);
  static const Color borderLight = Color(0xFFF0F0F8);

  static const Color error   = Color(0xFFE53935);
  static const Color success = Color(0xFF4CAF50);

  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primary, primaryDark],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  static const LinearGradient heroGradient = LinearGradient(
    colors: [Color(0xFF0083BC), Color(0xFF004270)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
  static const LinearGradient festiveGradient = LinearGradient(
    colors: [Color(0xFFF4A300), Color(0xFFE8891A)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  static const LinearGradient greenGradient = LinearGradient(
    colors: [Color(0xFF52B52A), Color(0xFF2E7D32)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static List<BoxShadow> get cardShadow => [
    BoxShadow(color: Colors.black.withOpacity(0.07), blurRadius: 12, offset: const Offset(0, 4)),
  ];
  static List<BoxShadow> get primaryShadow => [
    BoxShadow(color: primary.withOpacity(0.32), blurRadius: 16, offset: const Offset(0, 6)),
  ];
}
