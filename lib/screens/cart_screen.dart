import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../models/product.dart';
import '../providers/cart_provider.dart';

const _blue = Color(0xFF0083BC);
const _green = Color(0xFF52B52A);

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});
  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final _couponCtrl = TextEditingController();
  bool _applying = false;

  @override
  void dispose() { _couponCtrl.dispose(); super.dispose(); }

  Future<void> _applyCoupon(CartProvider cart) async {
    setState(() => _applying = true);
    await Future.delayed(const Duration(milliseconds: 600));
    final ok = cart.applyCoupon(_couponCtrl.text);
    setState(() => _applying = false);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(ok
          ? '🎉 Coupon applied! Save ₹${cart.couponDiscount.toInt()}'
          : cart.couponError ?? 'Invalid coupon'),
      backgroundColor: ok ? _green : Colors.red.shade600,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CartProvider>(builder: (_, cart, __) {
      if (cart.isEmpty) {
        return Scaffold(
          backgroundColor: const Color(0xFFFFF5E1),
          appBar: AppBar(title: const Text('My Cart')),
          body: Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            const Text('🛒', style: TextStyle(fontSize: 72)),
            const SizedBox(height: 20),
            const Text('Your cart is empty!', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
            const SizedBox(height: 8),
            Text('Explore our authentic Gujarati snacks', style: TextStyle(color: Colors.grey.shade600)),
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

      return Scaffold(
        backgroundColor: const Color(0xFFF5F7FA),
        appBar: AppBar(
          title: Text('My Cart (${cart.count})'),
          actions: [
            TextButton(
              onPressed: () => showDialog(context: context, builder: (_) => AlertDialog(
                title: const Text('Clear Cart?'),
                content: const Text('Remove all items?'),
                actions: [
                  TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
                  TextButton(onPressed: () { cart.clear(); Navigator.pop(context); },
                      child: const Text('Clear', style: TextStyle(color: Colors.red))),
                ],
              )),
              child: const Text('Clear All', style: TextStyle(color: Colors.white70)),
            ),
          ],
        ),
        body: Column(children: [
          // Free delivery bar
          if (cart.toFreeDelivery > 0)
            Container(
              color: Colors.white,
              padding: const EdgeInsets.fromLTRB(16, 10, 16, 12),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                RichText(text: TextSpan(
                  style: const TextStyle(fontSize: 12, color: Colors.black54),
                  children: [
                    const TextSpan(text: 'Add '),
                    TextSpan(text: '₹${cart.toFreeDelivery.toInt()} more ', style: const TextStyle(color: _blue, fontWeight: FontWeight.w700)),
                    const TextSpan(text: 'for FREE delivery 🚚'),
                  ],
                )),
                const SizedBox(height: 6),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: (cart.subtotal / 299).clamp(0, 1),
                    backgroundColor: Colors.grey.shade200,
                    color: _green,
                    minHeight: 5,
                  ),
                ),
              ]),
            ),

          Expanded(child: ListView(padding: const EdgeInsets.all(16), children: [
            // Items
            ...cart.items.map((item) => Dismissible(
              key: ValueKey(item.productId),
              direction: DismissDirection.endToStart,
              onDismissed: (_) => cart.remove(item.productId),
              background: Container(
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.only(right: 20),
                margin: const EdgeInsets.only(bottom: 10),
                decoration: BoxDecoration(color: Colors.red.shade400, borderRadius: BorderRadius.circular(14)),
                child: const Icon(Icons.delete_rounded, color: Colors.white, size: 28),
              ),
              child: Container(
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8, offset: const Offset(0, 2))],
                ),
                child: Row(children: [
                  Container(
                    width: 70, height: 70,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFF3CD),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(child: Text(item.emoji, style: const TextStyle(fontSize: 34))),
                  ),
                  const SizedBox(width: 12),
                  Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(item.name, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600), maxLines: 1, overflow: TextOverflow.ellipsis),
                    Text(item.weight, style: TextStyle(fontSize: 11, color: Colors.grey.shade500)),
                    const SizedBox(height: 8),
                    Row(children: [
                      Text('₹${item.total.toInt()}', style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: _blue)),
                      const Spacer(),
                      Container(
                        decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade300), borderRadius: BorderRadius.circular(10)),
                        child: Row(mainAxisSize: MainAxisSize.min, children: [
                          _QtyBtn(Icons.remove, () => cart.decrement(item.productId)),
                          Padding(padding: const EdgeInsets.symmetric(horizontal: 12),
                            child: Text('${item.quantity}', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700))),
                          _QtyBtn(Icons.add, () => cart.increment(item.productId)),
                        ]),
                      ),
                    ]),
                  ])),
                ]),
              ),
            )),

            // Coupon
            Container(
              decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(14),
                border: Border.all(color: _blue.withOpacity(0.4), width: 1.5),
              ),
              child: Row(children: [
                const SizedBox(width: 14),
                const Text('🏷️', style: TextStyle(fontSize: 18)),
                const SizedBox(width: 8),
                Expanded(child: cart.couponCode != null
                    ? Row(children: [
                        Text(cart.couponCode!, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: _green)),
                        const SizedBox(width: 6),
                        Text('−₹${cart.couponDiscount.toInt()} saved!', style: const TextStyle(fontSize: 11, color: Color(0xFF2E7D32))),
                      ])
                    : TextField(
                        controller: _couponCtrl,
                        textCapitalization: TextCapitalization.characters,
                        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                        decoration: const InputDecoration(
                          hintText: 'Enter coupon code',
                          border: InputBorder.none, enabledBorder: InputBorder.none, focusedBorder: InputBorder.none,
                        ),
                      )),
                cart.couponCode != null
                    ? TextButton(onPressed: cart.removeCoupon, child: const Text('Remove', style: TextStyle(color: Colors.red, fontSize: 12)))
                    : TextButton(
                        onPressed: _applying ? null : () => _applyCoupon(cart),
                        child: _applying
                            ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2))
                            : const Text('Apply', style: TextStyle(fontWeight: FontWeight.w700)),
                      ),
              ]),
            ),

            // Savings
            if (cart.totalSaving > 0) ...[
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: const Color(0xFFE8F5E9), borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: _green.withOpacity(0.3)),
                ),
                child: Row(children: [
                  const Text('🎉', style: TextStyle(fontSize: 16)),
                  const SizedBox(width: 8),
                  Text('You\'re saving ₹${cart.totalSaving.toInt()} on this order!',
                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF2E7D32))),
                ]),
              ),
            ],

            const SizedBox(height: 12),

            // Price breakdown
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(14),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8, offset: const Offset(0, 2))],
              ),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const Text('Price Details', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
                const SizedBox(height: 14),
                _PRow('MRP Total (${cart.count} items)', '₹${cart.mrpTotal.toInt()}'),
                _PRow('Product Discount', '−₹${cart.productSaving.toInt()}', green: true),
                if (cart.couponDiscount > 0) _PRow('Coupon (${cart.couponCode})', '−₹${cart.couponDiscount.toInt()}', green: true),
                _PRow('Delivery', cart.delivery == 0 ? 'FREE 🎉' : '₹${cart.delivery.toInt()}', green: cart.delivery == 0),
                const Divider(height: 20),
                Row(children: [
                  const Text('Total Amount', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
                  const Spacer(),
                  Text('₹${cart.total.toInt()}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: _blue)),
                ]),
              ]),
            ),
            const SizedBox(height: 16),
          ])),

          // Bottom CTA
          Container(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 28),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 16, offset: const Offset(0, -4))],
            ),
            child: Row(children: [
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('Total', style: TextStyle(fontSize: 11, color: Colors.grey.shade500)),
                Text('₹${cart.total.toInt()}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: _blue)),
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
  final IconData icon; final VoidCallback fn;
  const _QtyBtn(this.icon, this.fn);
  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: fn,
    child: SizedBox(width: 32, height: 32, child: Icon(icon, size: 16, color: _blue)),
  );
}

class _PRow extends StatelessWidget {
  final String label, value; final bool green;
  const _PRow(this.label, this.value, {this.green = false});
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Row(children: [
      Text(label, style: TextStyle(fontSize: 13, color: Colors.grey.shade600)),
      const Spacer(),
      Text(value, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: green ? _green : Colors.black87)),
    ]),
  );
}
