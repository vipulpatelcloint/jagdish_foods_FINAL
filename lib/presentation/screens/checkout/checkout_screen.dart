// lib/presentation/screens/checkout/checkout_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../data/models/models.dart';
import '../../../providers/cart_provider.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});
  @override State<CheckoutScreen> createState() => _CheckoutState();
}

class _CheckoutState extends State<CheckoutScreen> {
  int _addrIdx    = 0;
  int _deliveryIdx = 0;
  int _payIdx     = 0;
  bool _placing   = false;

  final _deliveries = [
    {'label': 'Express Delivery', 'sub': 'In 2–4 hours · ₹49', 'icon': Icons.bolt_rounded},
    {'label': 'Standard Delivery', 'sub': 'Tomorrow by 7 PM · FREE', 'icon': Icons.schedule_rounded},
  ];
  final _payments = [
    {'label': 'UPI Payment', 'sub': 'GPay, PhonePe, Paytm', 'emoji': '📱'},
    {'label': 'Credit / Debit Card', 'sub': 'Visa, Mastercard, RuPay', 'emoji': '💳'},
    {'label': 'Cash on Delivery', 'sub': 'Pay when delivered', 'emoji': '💵'},
  ];

  Future<void> _placeOrder() async {
    setState(() => _placing = true);
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;
    await context.read<CartProvider>().clear();
    context.go('/success/JF2026-${DateTime.now().millisecondsSinceEpoch % 10000}');
  }

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      appBar: AppBar(
        title: const Text('Checkout'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(46),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
            child: Row(children: List.generate(7, (i) {
              if (i.isOdd) return Expanded(child: Container(height: 2, color: i ~/ 2 < 1 ? Colors.white : Colors.white30));
              final s = i ~/ 2;
              final done = s < 1; final active = s == 1;
              return Column(mainAxisSize: MainAxisSize.min, children: [
                Container(width: 26, height: 26,
                  decoration: BoxDecoration(
                    color: done ? AppColors.green : active ? Colors.white : Colors.white30,
                    shape: BoxShape.circle),
                  child: Center(child: done
                      ? const Icon(Icons.check, size: 14, color: Colors.white)
                      : Text('${s + 1}', style: TextStyle(fontFamily: 'Poppins', fontSize: 11, fontWeight: FontWeight.w700,
                          color: active ? AppColors.primary : Colors.white)))),
                const SizedBox(height: 2),
                Text(['Cart', 'Address', 'Payment', 'Done'][s],
                  style: TextStyle(fontFamily: 'Poppins', fontSize: 9, fontWeight: FontWeight.w600,
                    color: active ? Colors.white : Colors.white60)),
              ]);
            })),
          ),
        ),
      ),
      body: Column(children: [
        Expanded(child: ListView(padding: const EdgeInsets.all(16), children: [
          // Address
          _Card(title: '📍 Delivery Address',
            action: TextButton.icon(onPressed: () {}, icon: const Icon(Icons.add, size: 14), label: const Text('Add New')),
            child: Column(children: List.generate(MockData.addresses.length, (i) {
              final a = MockData.addresses[i]; final sel = i == _addrIdx;
              return GestureDetector(
                onTap: () => setState(() => _addrIdx = i),
                child: AnimatedContainer(duration: const Duration(milliseconds: 200),
                  margin: EdgeInsets.only(bottom: i < MockData.addresses.length - 1 ? 8 : 0),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: sel ? AppColors.primaryLight : AppColors.scaffoldBg,
                    border: Border.all(color: sel ? AppColors.primary : AppColors.border, width: sel ? 2 : 1),
                    borderRadius: BorderRadius.circular(12)),
                  child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Container(width: 18, height: 18, margin: const EdgeInsets.only(top: 2),
                      decoration: BoxDecoration(shape: BoxShape.circle,
                        border: Border.all(color: sel ? AppColors.primary : AppColors.textLight, width: 2)),
                      child: sel ? Center(child: Container(width: 8, height: 8,
                        decoration: const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle))) : null),
                    const SizedBox(width: 10),
                    Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(color: sel ? AppColors.primary : AppColors.textLight, borderRadius: BorderRadius.circular(4)),
                        child: Text(a.label.toUpperCase(), style: const TextStyle(fontFamily: 'Poppins', fontSize: 9, fontWeight: FontWeight.w800, color: Colors.white))),
                      const SizedBox(height: 4),
                      Text(a.name, style: const TextStyle(fontFamily: 'Poppins', fontSize: 13, fontWeight: FontWeight.w600)),
                      Text(a.full, style: const TextStyle(fontFamily: 'Poppins', fontSize: 11, color: AppColors.textLight), maxLines: 2),
                    ])),
                  ])),
              );
            }))),
          const SizedBox(height: 12),

          // Delivery options
          _Card(title: '🚚 Delivery Option', child: Column(children: List.generate(_deliveries.length, (i) {
            final d = _deliveries[i]; final sel = i == _deliveryIdx;
            return GestureDetector(
              onTap: () => setState(() => _deliveryIdx = i),
              child: AnimatedContainer(duration: const Duration(milliseconds: 200),
                margin: EdgeInsets.only(bottom: i < _deliveries.length - 1 ? 8 : 0),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: sel ? AppColors.primaryLight : Colors.white,
                  border: Border.all(color: sel ? AppColors.primary : AppColors.border, width: sel ? 2 : 1),
                  borderRadius: BorderRadius.circular(12)),
                child: Row(children: [
                  Container(width: 36, height: 36,
                    decoration: BoxDecoration(color: AppColors.primaryLight, borderRadius: BorderRadius.circular(10)),
                    child: Icon(d['icon'] as IconData, color: AppColors.primary, size: 18)),
                  const SizedBox(width: 12),
                  Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(d['label'] as String, style: const TextStyle(fontFamily: 'Poppins', fontSize: 13, fontWeight: FontWeight.w600)),
                    Text(d['sub'] as String, style: const TextStyle(fontFamily: 'Poppins', fontSize: 11, color: AppColors.textLight)),
                  ])),
                  if (sel) const Icon(Icons.check_circle_rounded, color: AppColors.primary, size: 20),
                ])));
          }))),
          const SizedBox(height: 12),

          // Payment methods
          _Card(title: '💳 Payment Method', child: Column(children: List.generate(_payments.length, (i) {
            final p = _payments[i]; final sel = i == _payIdx;
            return GestureDetector(
              onTap: () => setState(() => _payIdx = i),
              child: AnimatedContainer(duration: const Duration(milliseconds: 200),
                margin: EdgeInsets.only(bottom: i < _payments.length - 1 ? 8 : 0),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: sel ? AppColors.primaryLight : Colors.white,
                  border: Border.all(color: sel ? AppColors.primary : AppColors.border, width: sel ? 2 : 1),
                  borderRadius: BorderRadius.circular(12)),
                child: Row(children: [
                  Container(width: 36, height: 36,
                    decoration: BoxDecoration(color: AppColors.primaryLight, borderRadius: BorderRadius.circular(10)),
                    child: Center(child: Text(p['emoji'] as String, style: const TextStyle(fontSize: 18)))),
                  const SizedBox(width: 12),
                  Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(p['label'] as String, style: const TextStyle(fontFamily: 'Poppins', fontSize: 13, fontWeight: FontWeight.w600)),
                    Text(p['sub'] as String, style: const TextStyle(fontFamily: 'Poppins', fontSize: 11, color: AppColors.textLight)),
                  ])),
                  if (sel) const Icon(Icons.check_circle_rounded, color: AppColors.primary, size: 20),
                ])));
          }))),
          const SizedBox(height: 12),

          // Total
          Container(padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14), boxShadow: AppColors.cardShadow),
            child: Row(children: [
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const Text('Order Total', style: TextStyle(fontFamily: 'Poppins', fontSize: 14, fontWeight: FontWeight.w600)),
                Text('${cart.itemCount} items · Incl. all taxes',
                  style: const TextStyle(fontFamily: 'Poppins', fontSize: 11, color: AppColors.textLight)),
              ]),
              const Spacer(),
              Text('₹${cart.finalTotal.toInt()}', style: const TextStyle(fontFamily: 'Poppins', fontSize: 24, fontWeight: FontWeight.w700, color: AppColors.primary)),
            ])),
        ])),

        // Place order
        Container(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 28),
          decoration: BoxDecoration(color: Colors.white,
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 16, offset: const Offset(0, -4))]),
          child: ElevatedButton.icon(
            onPressed: _placing ? null : _placeOrder,
            icon: _placing
                ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                : const Icon(Icons.lock_rounded),
            label: Text(_placing ? 'Placing Order...' : 'Place Order · ₹${cart.finalTotal.toInt()}'),
            style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 52)),
          ),
        ),
      ]),
    );
  }
}

class _Card extends StatelessWidget {
  final String title; final Widget child; final Widget? action;
  const _Card({required this.title, required this.child, this.action});
  @override Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14), boxShadow: AppColors.cardShadow),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(children: [
        Text(title, style: const TextStyle(fontFamily: 'Poppins', fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.textDark)),
        const Spacer(), if (action != null) action!]),
      const SizedBox(height: 12),
      child,
    ]));
}

// ─── Order Success ─────────────────────────────────────────────────────────
class OrderSuccessScreen extends StatelessWidget {
  final String orderId;
  const OrderSuccessScreen({super.key, required this.orderId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.heroGradient),
        child: SafeArea(child: Stack(children: [
          Positioned(top: -40, right: -40, child: Container(width: 200, height: 200,
            decoration: BoxDecoration(color: Colors.white.withOpacity(0.05), shape: BoxShape.circle))),
          Positioned(bottom: -60, left: -60, child: Container(width: 250, height: 250,
            decoration: BoxDecoration(color: Colors.white.withOpacity(0.04), shape: BoxShape.circle))),
          Padding(padding: const EdgeInsets.all(24), child: Column(
            mainAxisAlignment: MainAxisAlignment.center, children: [
            // Animated success icon
            Container(width: 110, height: 110,
              decoration: BoxDecoration(color: Colors.white.withOpacity(0.15), shape: BoxShape.circle,
                border: Border.all(color: Colors.white.withOpacity(0.3), width: 2)),
              child: const Center(child: Text('🎉', style: TextStyle(fontSize: 50))))
                .animate(onPlay: (c) => c.repeat(reverse: true))
                .scale(begin: const Offset(1,1), end: const Offset(1.05,1.05), duration: 1500.ms),
            const SizedBox(height: 24),

            const Text('Order Placed!', style: TextStyle(fontFamily: 'Poppins', color: Colors.white, fontSize: 30, fontWeight: FontWeight.w700))
                .animate().fadeIn(delay: 200.ms).slideY(begin: 0.3),
            const SizedBox(height: 8),
            Text("Your Jagdish snacks are being packed\nwith love and care 🥐",
              textAlign: TextAlign.center,
              style: TextStyle(fontFamily: 'Poppins', color: Colors.white.withOpacity(0.8), fontSize: 13))
                .animate().fadeIn(delay: 350.ms),
            const SizedBox(height: 32),

            // Order details card
            Container(width: double.infinity, padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
              child: Column(children: [
                _SRow('Order ID', '#$orderId', highlight: true),
                _SRow('Total Paid', '₹647 via UPI', highlight: true),
                _SRow('Items', '3 items · 4 packs'),
                _SRow('Delivery To', 'Alkapuri, Vadodara'),
                _SRow('ETA', 'Today, 2:00 – 4:00 PM'),
              ])).animate().fadeIn(delay: 500.ms).slideY(begin: 0.2),

            const SizedBox(height: 24),

            OutlinedButton.icon(
              onPressed: () => context.go('/tracking/$orderId'),
              icon: const Icon(Icons.location_on_rounded, color: Colors.white),
              label: const Text('Track My Order', style: TextStyle(color: Colors.white)),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Colors.white54, width: 2),
                minimumSize: const Size(double.infinity, 50)),
            ).animate().fadeIn(delay: 700.ms),
            const SizedBox(height: 12),

            ElevatedButton.icon(
              onPressed: () => context.go('/home'),
              icon: const Icon(Icons.storefront_rounded),
              label: const Text('Continue Shopping'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white, foregroundColor: AppColors.primary,
                minimumSize: const Size(double.infinity, 50)),
            ).animate().fadeIn(delay: 800.ms),
          ])),
        ])),
      ),
    );
  }
}

class _SRow extends StatelessWidget {
  final String label, value; final bool highlight;
  const _SRow(this.label, this.value, {this.highlight = false});
  @override Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 7),
    child: Row(children: [
      Text(label, style: const TextStyle(fontFamily: 'Poppins', fontSize: 12, color: AppColors.textLight)),
      const Spacer(),
      Text(value, style: TextStyle(fontFamily: 'Poppins', fontSize: 12, fontWeight: FontWeight.w700,
        color: highlight ? AppColors.primary : AppColors.textDark)),
    ]));
}
