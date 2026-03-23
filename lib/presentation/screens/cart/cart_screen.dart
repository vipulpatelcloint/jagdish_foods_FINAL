// lib/presentation/screens/cart/cart_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../data/models/models.dart';
import '../../../providers/cart_provider.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});
  @override State<CartScreen> createState() => _CartState();
}

class _CartState extends State<CartScreen> {
  final _couponCtrl = TextEditingController();
  bool _applying = false;

  @override void dispose() { _couponCtrl.dispose(); super.dispose(); }

  Future<void> _applyCoupon() async {
    if (_couponCtrl.text.isEmpty) return;
    setState(() => _applying = true);
    final cart = context.read<CartProvider>();
    final ok   = await cart.applyCoupon(_couponCtrl.text);
    setState(() => _applying = false);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(ok ? '🎉 Coupon applied! You save ₹${cart.couponSaving.toInt()}' : cart.error ?? 'Invalid coupon'),
      backgroundColor: ok ? AppColors.green : AppColors.error,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CartProvider>(builder: (context, cart, _) {
      if (cart.isEmpty) return _EmptyCart();
      return Scaffold(
        backgroundColor: AppColors.scaffoldBg,
        appBar: AppBar(
          title: Text('My Cart (${cart.itemCount})'),
          actions: [TextButton(
            onPressed: () => showDialog(context: context, builder: (_) => AlertDialog(
              title: const Text('Clear Cart?'),
              content: const Text('Remove all items from cart?'),
              actions: [
                TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
                TextButton(onPressed: () { cart.clear(); Navigator.pop(context); },
                  child: const Text('Clear', style: TextStyle(color: AppColors.error))),
              ],
            )),
            child: const Text('Clear All', style: TextStyle(color: Colors.white70, fontFamily: 'Poppins', fontSize: 13)),
          )],
        ),
        body: Column(children: [
          // Free delivery progress
          if (cart.toFreeDelivery > 0)
            Container(color: Colors.white, padding: const EdgeInsets.fromLTRB(16, 10, 16, 12),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                RichText(text: TextSpan(
                  style: const TextStyle(fontFamily: 'Poppins', fontSize: 12, color: AppColors.textMedium),
                  children: [
                    const TextSpan(text: 'Add '),
                    TextSpan(text: '₹${cart.toFreeDelivery.toInt()} more ',
                      style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.w700)),
                    const TextSpan(text: 'for FREE delivery 🚚'),
                  ],
                )),
                const SizedBox(height: 6),
                ClipRRect(borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: (cart.subtotal / 299).clamp(0, 1),
                    backgroundColor: AppColors.border,
                    valueColor: const AlwaysStoppedAnimation(AppColors.green),
                    minHeight: 5)),
              ])),

          Expanded(child: ListView(padding: const EdgeInsets.all(16), children: [
            // Cart items
            ...cart.items.map((item) => Dismissible(
              key: ValueKey('${item.productId}_${item.variantId}'),
              direction: DismissDirection.endToStart,
              onDismissed: (_) => cart.remove(item.productId, item.variantId),
              background: Container(
                alignment: Alignment.centerRight, padding: const EdgeInsets.only(right: 20),
                margin: const EdgeInsets.only(bottom: 10),
                decoration: BoxDecoration(color: AppColors.error, borderRadius: BorderRadius.circular(14)),
                child: const Icon(Icons.delete_rounded, color: Colors.white, size: 28),
              ),
              child: Container(
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14), boxShadow: AppColors.cardShadow),
                child: Row(children: [
                  Container(width: 72, height: 72,
                    decoration: BoxDecoration(
                      color: Color(MockData.productBgColors[item.productId.replaceAll('p', '')] ?? 0xFFFFF3CD),
                      borderRadius: BorderRadius.circular(12)),
                    child: Center(child: Text(item.emoji, style: const TextStyle(fontSize: 34)))),
                  const SizedBox(width: 12),
                  Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(item.name, style: const TextStyle(fontFamily: 'Poppins', fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textDark), maxLines: 1, overflow: TextOverflow.ellipsis),
                    Text(item.weight, style: const TextStyle(fontFamily: 'Poppins', fontSize: 11, color: AppColors.textLight)),
                    const SizedBox(height: 8),
                    Row(children: [
                      Text('₹${item.total.toInt()}', style: const TextStyle(fontFamily: 'Poppins', fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.primary)),
                      const Spacer(),
                      Container(decoration: BoxDecoration(border: Border.all(color: AppColors.border), borderRadius: BorderRadius.circular(10)),
                        child: Row(mainAxisSize: MainAxisSize.min, children: [
                          _QtyBtn(Icons.remove, () => cart.setQty(item.productId, item.variantId, item.quantity - 1)),
                          Padding(padding: const EdgeInsets.symmetric(horizontal: 12),
                            child: Text('${item.quantity}', style: const TextStyle(fontFamily: 'Poppins', fontSize: 14, fontWeight: FontWeight.w700))),
                          _QtyBtn(Icons.add, () => cart.setQty(item.productId, item.variantId, item.quantity + 1)),
                        ])),
                    ]),
                  ])),
                ]),
              ).animate().fadeIn(delay: 80.ms).slideX(begin: -0.05),
            )),

            const SizedBox(height: 4),

            // Coupon box
            Container(
              decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.primary.withOpacity(0.4), width: 1.5),
                boxShadow: AppColors.cardShadow),
              child: Row(children: [
                const SizedBox(width: 14),
                const Text('🏷️', style: TextStyle(fontSize: 18)),
                const SizedBox(width: 8),
                Expanded(child: cart.coupon != null
                    ? Row(children: [
                        Text(cart.coupon!.code,
                          style: const TextStyle(fontFamily: 'Poppins', fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.green)),
                        const SizedBox(width: 6),
                        Text('−₹${cart.couponSaving.toInt()} saved!',
                          style: const TextStyle(fontFamily: 'Poppins', fontSize: 11, color: AppColors.greenDeep)),
                      ])
                    : TextField(
                        controller: _couponCtrl,
                        textCapitalization: TextCapitalization.characters,
                        style: const TextStyle(fontFamily: 'Poppins', fontSize: 14, fontWeight: FontWeight.w600),
                        decoration: const InputDecoration(
                          hintText: 'Enter coupon code', border: InputBorder.none,
                          enabledBorder: InputBorder.none, focusedBorder: InputBorder.none),
                      )),
                cart.coupon != null
                    ? TextButton(onPressed: cart.removeCoupon,
                        child: const Text('Remove', style: TextStyle(color: AppColors.error, fontSize: 12)))
                    : TextButton(
                        onPressed: _applying ? null : _applyCoupon,
                        child: _applying
                            ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2))
                            : const Text('Apply', style: TextStyle(fontWeight: FontWeight.w700))),
              ]),
            ),

            // Savings banner
            if (cart.totalSaving > 0)
              Container(
                margin: const EdgeInsets.only(top: 10),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: AppColors.greenLight, borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.green.withOpacity(0.3))),
                child: Row(children: [
                  const Text('🎉', style: TextStyle(fontSize: 16)),
                  const SizedBox(width: 8),
                  Text('You\'re saving ₹${cart.totalSaving.toInt()} on this order!',
                    style: const TextStyle(fontFamily: 'Poppins', fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.greenDeep)),
                ])),

            const SizedBox(height: 12),

            // Price breakdown
            Container(padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14), boxShadow: AppColors.cardShadow),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const Text('Price Details', style: TextStyle(fontFamily: 'Poppins', fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.textDark)),
                const SizedBox(height: 14),
                _PRow('MRP Total (${cart.itemCount} items)', '₹${cart.mrpTotal.toInt()}'),
                _PRow('Product Discount', '−₹${cart.productSaving.toInt()}', green: true),
                if (cart.couponSaving > 0)
                  _PRow('Coupon (${cart.coupon!.code})', '−₹${cart.couponSaving.toInt()}', green: true),
                _PRow('Delivery', cart.deliveryFee == 0 ? 'FREE 🎉' : '₹${cart.deliveryFee.toInt()}', green: cart.deliveryFee == 0),
                const Divider(height: 20),
                Row(children: [
                  const Text('Total Amount', style: TextStyle(fontFamily: 'Poppins', fontSize: 15, fontWeight: FontWeight.w700)),
                  const Spacer(),
                  Text('₹${cart.finalTotal.toInt()}', style: const TextStyle(fontFamily: 'Poppins', fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.primary)),
                ]),
              ])),
            const SizedBox(height: 16),
          ])),

          // Bottom CTA
          Container(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 28),
            decoration: BoxDecoration(color: Colors.white,
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 16, offset: const Offset(0, -4))]),
            child: Row(children: [
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const Text('Total', style: TextStyle(fontFamily: 'Poppins', fontSize: 11, color: AppColors.textLight)),
                Text('₹${cart.finalTotal.toInt()}', style: const TextStyle(fontFamily: 'Poppins', fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.primary)),
              ]),
              const SizedBox(width: 16),
              Expanded(child: ElevatedButton.icon(
                onPressed: () => context.push('/checkout'),
                icon: const Icon(Icons.arrow_forward_rounded),
                label: const Text('Proceed to Checkout'),
                style: ElevatedButton.styleFrom(minimumSize: const Size(0, 52)),
              )),
            ]),
          ),
        ]),
      );
    });
  }
}

class _QtyBtn extends StatelessWidget {
  final IconData icon; final VoidCallback onTap;
  const _QtyBtn(this.icon, this.onTap);
  @override Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: SizedBox(width: 32, height: 32, child: Icon(icon, size: 16, color: AppColors.primary)));
}

class _PRow extends StatelessWidget {
  final String label, value; final bool green;
  const _PRow(this.label, this.value, {this.green = false});
  @override Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Row(children: [
      Text(label, style: const TextStyle(fontFamily: 'Poppins', fontSize: 13, color: AppColors.textMedium)),
      const Spacer(),
      Text(value, style: TextStyle(fontFamily: 'Poppins', fontSize: 13, fontWeight: FontWeight.w600,
        color: green ? AppColors.green : AppColors.textDark)),
    ]));
}

class _EmptyCart extends StatelessWidget {
  @override Widget build(BuildContext context) => Scaffold(
    backgroundColor: AppColors.creamLight,
    appBar: AppBar(title: const Text('My Cart')),
    body: Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      const Text('🛒', style: TextStyle(fontSize: 72))
          .animate(onPlay: (c) => c.repeat(reverse: true))
          .scale(begin: const Offset(1,1), end: const Offset(1.08,1.08), duration: 1000.ms),
      const SizedBox(height: 20),
      const Text('Your cart is empty!', style: TextStyle(fontFamily: 'Poppins', fontSize: 20, fontWeight: FontWeight.w700, color: AppColors.textDark)),
      const SizedBox(height: 8),
      const Text('Explore our authentic Gujarati snacks',
        style: TextStyle(fontFamily: 'Poppins', fontSize: 13, color: AppColors.textMedium)),
      const SizedBox(height: 28),
      Padding(padding: const EdgeInsets.symmetric(horizontal: 60),
        child: ElevatedButton.icon(
          onPressed: () => context.go('/home'),
          icon: const Icon(Icons.home_rounded),
          label: const Text('Start Shopping'),
        )),
    ])),
  );
}
