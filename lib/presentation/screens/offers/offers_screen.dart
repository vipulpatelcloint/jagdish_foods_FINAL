// lib/presentation/screens/offers/offers_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/constants/app_colors.dart';
import '../../../data/models/models.dart';

class OffersScreen extends StatelessWidget {
  const OffersScreen({super.key});

  static const _howToSteps = [
    {'icon': '1️⃣', 'text': 'Add products to your cart'},
    {'icon': '2️⃣', 'text': 'Go to Cart → Enter coupon code'},
    {'icon': '3️⃣', 'text': 'Tap Apply and enjoy savings!'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      appBar: AppBar(title: const Text('🏷️ Offers & Coupons')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Festive hero banner
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: AppColors.festiveGradient,
              borderRadius: BorderRadius.circular(18),
              boxShadow: AppColors.primaryShadow,
            ),
            child: Row(children: [
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const Text('Diwali Special 🪔',
                    style: TextStyle(fontFamily: 'Poppins', color: Colors.white, fontSize: 20, fontWeight: FontWeight.w700)),
                const SizedBox(height: 4),
                Text('Upto 30% off on Gift Hampers',
                    style: TextStyle(fontFamily: 'Poppins', color: Colors.white.withOpacity(0.85), fontSize: 12)),
                const SizedBox(height: 14),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: const Color(0xFFE8891A),
                    minimumSize: const Size(120, 36),
                    textStyle: const TextStyle(fontFamily: 'Poppins', fontSize: 12, fontWeight: FontWeight.w700),
                  ),
                  child: const Text('Shop Now'),
                ),
              ])),
              const Text('🎁', style: TextStyle(fontSize: 56)),
            ]),
          ).animate().fadeIn().slideY(begin: -0.1),

          const SizedBox(height: 22),

          Text('Available Coupons (${MockData.coupons.length})',
              style: const TextStyle(fontFamily: 'Poppins', fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.textDark)),
          const SizedBox(height: 12),

          ...MockData.coupons.asMap().entries.map((e) {
            final c     = e.value;
            final color = [AppColors.primary, AppColors.green, AppColors.gold, AppColors.primary][e.key % 4];
            final emoji = ['🎊', '🚚', '🪔', '💰'][e.key % 4];

            return Container(
              margin: const EdgeInsets.only(bottom: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                boxShadow: AppColors.cardShadow,
                border: Border(left: BorderSide(color: color, width: 5)),
              ),
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(emoji, style: const TextStyle(fontSize: 30)),
                  const SizedBox(width: 12),
                  Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(c.code,
                        style: const TextStyle(fontFamily: 'Poppins', fontSize: 16, fontWeight: FontWeight.w800,
                            color: AppColors.textDark, letterSpacing: 0.5)),
                    const SizedBox(height: 3),
                    Text(c.description,
                        style: const TextStyle(fontFamily: 'Poppins', fontSize: 11, color: AppColors.textMedium, height: 1.4),
                        maxLines: 2),
                    const SizedBox(height: 5),
                    Row(children: [
                      if (c.minOrder > 0) ...[
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppColors.scaffoldBg,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text('Min ₹${c.minOrder.toInt()}',
                              style: const TextStyle(fontFamily: 'Poppins', fontSize: 10, fontWeight: FontWeight.w600, color: AppColors.textMedium)),
                        ),
                        const SizedBox(width: 6),
                      ],
                      Text('Valid till ${c.validTill.day}/${c.validTill.month}/${c.validTill.year}',
                          style: const TextStyle(fontFamily: 'Poppins', fontSize: 10, color: AppColors.textLight)),
                    ]),
                  ])),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: () {
                      Clipboard.setData(ClipboardData(text: c.code));
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text('${c.code} copied to clipboard!'),
                        backgroundColor: AppColors.green,
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        duration: const Duration(seconds: 2),
                      ));
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: color.withOpacity(0.1),
                        border: Border.all(color: color, width: 1.5),
                        borderRadius: BorderRadius.circular(9),
                      ),
                      child: Text('Copy',
                          style: TextStyle(fontFamily: 'Poppins', fontSize: 12, fontWeight: FontWeight.w700, color: color)),
                    ),
                  ),
                ]),
              ),
            ).animate().fadeIn(delay: (e.key * 80).ms).slideX(begin: 0.08);
          }),

          const SizedBox(height: 16),

          // How to use section
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              boxShadow: AppColors.cardShadow,
            ),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Text('How to use coupons?',
                  style: TextStyle(fontFamily: 'Poppins', fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.textDark)),
              const SizedBox(height: 12),
              ..._howToSteps.map((step) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(children: [
                  Text(step['icon']!, style: const TextStyle(fontSize: 16)),
                  const SizedBox(width: 10),
                  Expanded(child: Text(step['text']!, style: const TextStyle(fontFamily: 'Poppins', fontSize: 13, color: AppColors.textMedium))),
                ]),
              )),
            ]),
          ).animate().fadeIn(delay: 400.ms),
        ],
      ),
    );
  }
}
