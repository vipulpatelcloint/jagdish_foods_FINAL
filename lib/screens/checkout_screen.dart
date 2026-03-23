import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../models/product.dart';
import '../providers/cart_provider.dart';

const _blue = Color(0xFF0083BC);
const _green = Color(0xFF52B52A);

// ─── Checkout ─────────────────────────────────────────────────────────────

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});
  @override
  State<CheckoutScreen> createState() => _CheckoutState();
}

class _CheckoutState extends State<CheckoutScreen> {
  int _addr = 0;
  int _pay  = 0;
  bool _placing = false;

  final _addresses = const [
    {'label': 'Home', 'name': 'Rajesh Patel', 'line': '12, Shyamal Society, Alkapuri, Vadodara - 390007'},
    {'label': 'Work', 'name': 'Rajesh Patel', 'line': 'Plot 45, GIDC, Makarpura, Vadodara - 390010'},
  ];

  final _payments = const [
    {'label': 'UPI Payment',        'sub': 'GPay, PhonePe, Paytm', 'emoji': '📱'},
    {'label': 'Credit/Debit Card',  'sub': 'Visa, Mastercard, RuPay', 'emoji': '💳'},
    {'label': 'Cash on Delivery',   'sub': 'Pay when delivered', 'emoji': '💵'},
  ];

  Future<void> _place(CartProvider cart) async {
    setState(() => _placing = true);
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;
    cart.clear();
    context.go('/orders');
  }

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(title: const Text('Checkout')),
      body: Column(children: [
        Expanded(child: ListView(padding: const EdgeInsets.all(16), children: [
          _Section('📍 Delivery Address', [
            ..._addresses.asMap().entries.map((e) => _SelTile(
              selected: e.key == _addr,
              onTap: () => setState(() => _addr = e.key),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(color: e.key == _addr ? _blue : Colors.grey, borderRadius: BorderRadius.circular(4)),
                  child: Text((e.value['label'] as String).toUpperCase(), style: const TextStyle(fontSize: 9, fontWeight: FontWeight.w800, color: Colors.white))),
                const SizedBox(height: 4),
                Text(e.value['name'] as String, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                Text(e.value['line'] as String, style: TextStyle(fontSize: 11, color: Colors.grey.shade600)),
              ]),
            )),
          ]),
          const SizedBox(height: 12),
          _Section('💳 Payment Method', [
            ..._payments.asMap().entries.map((e) => _SelTile(
              selected: e.key == _pay,
              onTap: () => setState(() => _pay = e.key),
              child: Row(children: [
                Container(width: 36, height: 36,
                  decoration: BoxDecoration(color: const Color(0xFFE6F4FB), borderRadius: BorderRadius.circular(10)),
                  child: Center(child: Text(e.value['emoji'] as String, style: const TextStyle(fontSize: 18)))),
                const SizedBox(width: 12),
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(e.value['label'] as String, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                  Text(e.value['sub'] as String, style: TextStyle(fontSize: 11, color: Colors.grey.shade500)),
                ]),
              ]),
            )),
          ]),
          const SizedBox(height: 12),
          Container(padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14)),
            child: Row(children: [
              const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('Order Total', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                Text('Incl. all taxes', style: TextStyle(fontSize: 11, color: Colors.grey)),
              ]),
              const Spacer(),
              Text('₹${cart.total.toInt()}', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w700, color: _blue)),
            ])),
        ])),
        Container(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 28),
          decoration: BoxDecoration(color: Colors.white,
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 16, offset: const Offset(0, -4))]),
          child: ElevatedButton.icon(
            onPressed: _placing ? null : () => _place(cart),
            icon: _placing
                ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                : const Icon(Icons.lock_rounded),
            label: Text(_placing ? 'Placing Order...' : 'Place Order · ₹${cart.total.toInt()}'),
            style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 52)),
          ),
        ),
      ]),
    );
  }
}

class _Section extends StatelessWidget {
  final String title;
  final List<Widget> children;
  const _Section(this.title, this.children);
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.white, borderRadius: BorderRadius.circular(14),
      boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8, offset: const Offset(0, 2))],
    ),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
      const SizedBox(height: 12),
      ...children,
    ]),
  );
}

class _SelTile extends StatelessWidget {
  final bool selected;
  final VoidCallback onTap;
  final Widget child;
  const _SelTile({required this.selected, required this.onTap, required this.child});
  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: selected ? const Color(0xFFE6F4FB) : const Color(0xFFF5F7FA),
        border: Border.all(color: selected ? _blue : Colors.grey.shade300, width: selected ? 2 : 1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: child,
    ),
  );
}

// ─── Orders ───────────────────────────────────────────────────────────────

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  static const _orders = [
    {'id': 'JF2026-8834', 'date': '20 Mar 2026', 'items': 3, 'total': 647, 'status': 'Delivered',  'color': 0xFF52B52A},
    {'id': 'JF2026-8791', 'date': '12 Mar 2026', 'items': 2, 'total': 380, 'status': 'Delivered',  'color': 0xFF52B52A},
    {'id': 'JF2026-8722', 'date': '1 Mar 2026',  'items': 5, 'total': 1120,'status': 'Delivered',  'color': 0xFF52B52A},
    {'id': 'JF2026-8650', 'date': '18 Feb 2026', 'items': 1, 'total': 220, 'status': 'Cancelled',  'color': 0xFFE53935},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(title: const Text('My Orders')),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: _orders.length,
        separatorBuilder: (_, __) => const SizedBox(height: 10),
        itemBuilder: (_, i) {
          final o = _orders[i];
          final color = Color(o['color'] as int);
          return Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(14),
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8, offset: const Offset(0, 2))],
            ),
            child: Column(children: [
              Row(children: [
                Text('#${o['id']}', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: _blue)),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(20)),
                  child: Text(o['status'] as String, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: color)),
                ),
              ]),
              const Divider(height: 20),
              Row(children: [
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('${o['items']} items', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                  Text(o['date'] as String, style: TextStyle(fontSize: 11, color: Colors.grey.shade500)),
                ]),
                const Spacer(),
                Text('₹${o['total']}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: _blue)),
              ]),
              const SizedBox(height: 12),
              Row(children: [
                Expanded(child: OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(minimumSize: const Size(0, 38), padding: EdgeInsets.zero),
                  child: const Text('Track Order', style: TextStyle(fontSize: 12)),
                )),
                const SizedBox(width: 8),
                Expanded(child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(minimumSize: const Size(0, 38), padding: EdgeInsets.zero),
                  child: const Text('Reorder', style: TextStyle(fontSize: 12)),
                )),
              ]),
            ]),
          );
        },
      ),
    );
  }
}

// ─── Profile ──────────────────────────────────────────────────────────────

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: CustomScrollView(slivers: [
        SliverAppBar(
          expandedHeight: 200,
          pinned: true,
          automaticallyImplyLeading: false,
          backgroundColor: _blue,
          flexibleSpace: FlexibleSpaceBar(
            background: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(colors: [Color(0xFF0083BC), Color(0xFF004270)],
                  begin: Alignment.topCenter, end: Alignment.bottomCenter),
              ),
              child: SafeArea(child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                child: Column(children: [
                  Row(children: [
                    Container(width: 64, height: 64,
                      decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.white.withOpacity(0.4), width: 2)),
                      child: const Center(child: Text('👤', style: TextStyle(fontSize: 28)))),
                    const SizedBox(width: 14),
                    const Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text('Rajesh Patel', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w700)),
                      Text('+91 98765 43210', style: TextStyle(color: Colors.white70, fontSize: 12)),
                    ])),
                  ]),
                  const SizedBox(height: 16),
                  Container(
                    decoration: BoxDecoration(color: Colors.white.withOpacity(0.12), borderRadius: BorderRadius.circular(14)),
                    child: Row(children: [
                      _Stat('23', 'Orders'),
                      Container(width: 1, height: 36, color: Colors.white.withOpacity(0.2)),
                      _Stat('4.8', 'Rating'),
                      Container(width: 1, height: 36, color: Colors.white.withOpacity(0.2)),
                      _Stat('₹480', 'Saved'),
                    ]),
                  ),
                ]),
              )),
            ),
          ),
        ),

        SliverToBoxAdapter(child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(children: [
            _MenuGroup('MY ACCOUNT', [
              _MI(Icons.edit_rounded, 'Edit Profile', () {}),
              _MI(Icons.location_on_rounded, 'Saved Addresses', () {}),
              _MI(Icons.favorite_rounded, 'My Wishlist', () {}),
            ]),
            const SizedBox(height: 12),
            _MenuGroup('ORDERS & OFFERS', [
              _MI(Icons.receipt_long_rounded, 'My Orders', () => context.go('/orders')),
              _MI(Icons.local_offer_rounded, 'Offers & Coupons', () {}),
              _MI(Icons.card_giftcard_rounded, 'Festive Gift Packs', () {}),
            ]),
            const SizedBox(height: 12),
            _MenuGroup('SUPPORT', [
              _MI(Icons.chat_bubble_outline_rounded, 'Help & Support', () {}),
              _MI(Icons.star_outline_rounded, 'Rate the App', () {}),
            ]),
            const SizedBox(height: 12),
            GestureDetector(
              onTap: () => context.go('/splash'),
              child: Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: const Color(0xFFFCE4EC), borderRadius: BorderRadius.circular(12),
                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8, offset: const Offset(0, 2))],
                ),
                child: const Row(children: [
                  Icon(Icons.logout_rounded, color: Color(0xFFC62828)),
                  SizedBox(width: 12),
                  Text('Logout', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFFC62828))),
                ]),
              ),
            ),
            const SizedBox(height: 24),
            const Text('Jagdish Foods v1.0.0', style: TextStyle(fontSize: 12, color: Colors.grey)),
            const Text("Vadodara's Taste Since 1945", style: TextStyle(fontSize: 11, color: Colors.grey)),
            const SizedBox(height: 24),
          ]),
        )),
      ]),
    );
  }
}

class _Stat extends StatelessWidget {
  final String val, label;
  const _Stat(this.val, this.label);
  @override
  Widget build(BuildContext context) => Expanded(child: Padding(
    padding: const EdgeInsets.symmetric(vertical: 12),
    child: Column(children: [
      Text(val, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700)),
      Text(label, style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 10)),
    ]),
  ));
}

class _MenuGroup extends StatelessWidget {
  final String title; final List<_MI> items;
  const _MenuGroup(this.title, this.items);
  @override
  Widget build(BuildContext context) => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
    Padding(padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Text(title, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: Colors.grey, letterSpacing: 1))),
    Container(
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8, offset: const Offset(0, 2))]),
      child: Column(children: items.asMap().entries.map((e) => Column(children: [
        e.value,
        if (e.key < items.length - 1) const Divider(height: 1, indent: 56),
      ])).toList()),
    ),
  ]);
}

class _MI extends StatelessWidget {
  final IconData icon; final String label; final VoidCallback onTap;
  const _MI(this.icon, this.label, this.onTap);
  @override
  Widget build(BuildContext context) => InkWell(
    onTap: onTap, borderRadius: BorderRadius.circular(14),
    child: Padding(padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      child: Row(children: [
        Container(width: 36, height: 36,
          decoration: BoxDecoration(color: const Color(0xFFE6F4FB), borderRadius: BorderRadius.circular(10)),
          child: Icon(icon, color: _blue, size: 18)),
        const SizedBox(width: 12),
        Text(label, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
        const Spacer(),
        const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: Colors.grey),
      ])),
  );
}
