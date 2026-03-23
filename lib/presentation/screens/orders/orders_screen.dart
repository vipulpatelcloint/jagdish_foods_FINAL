// lib/presentation/screens/orders/orders_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';

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
      backgroundColor: AppColors.scaffoldBg,
      appBar: AppBar(title: const Text('My Orders')),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: _orders.length,
        separatorBuilder: (_, __) => const SizedBox(height: 10),
        itemBuilder: (context, i) {
          final o = _orders[i];
          return Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14), boxShadow: AppColors.cardShadow),
            child: Column(children: [
              Row(children: [
                Text('#${o['id']}', style: const TextStyle(fontFamily: 'Poppins', fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.primary)),
                const Spacer(),
                Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(color: Color(o['color'] as int).withOpacity(0.12), borderRadius: BorderRadius.circular(20)),
                  child: Text(o['status'] as String, style: TextStyle(fontFamily: 'Poppins', fontSize: 11, fontWeight: FontWeight.w700, color: Color(o['color'] as int)))),
              ]),
              const SizedBox(height: 10),
              const Divider(height: 1),
              const SizedBox(height: 10),
              Row(children: [
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('${o['items']} items', style: const TextStyle(fontFamily: 'Poppins', fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textDark)),
                  Text(o['date'] as String, style: const TextStyle(fontFamily: 'Poppins', fontSize: 11, color: AppColors.textLight)),
                ]),
                const Spacer(),
                Text('₹${o['total']}', style: const TextStyle(fontFamily: 'Poppins', fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.primary)),
              ]),
              const SizedBox(height: 12),
              Row(children: [
                Expanded(child: OutlinedButton(
                  onPressed: () => context.push('/tracking/${o['id']}'),
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
          ).animate().fadeIn(delay: (i * 80).ms).slideY(begin: 0.1);
        },
      ),
    );
  }
}

// ─── Order Tracking ────────────────────────────────────────────────────────
class OrderTrackingScreen extends StatelessWidget {
  final String orderId;
  const OrderTrackingScreen({super.key, required this.orderId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text('Track Order'),
          Text('Order #$orderId', style: const TextStyle(fontSize: 11, color: Colors.white70, fontFamily: 'Poppins')),
        ]),
      ),
      body: Column(children: [
        // Map area
        Container(height: 170, color: const Color(0xFFE8F4FD),
          child: Stack(children: [
            // Route line
            Center(child: Container(height: 3, margin: const EdgeInsets.symmetric(horizontal: 56),
              decoration: BoxDecoration(
                gradient: AppColors.greenGradient,
                borderRadius: BorderRadius.circular(2)))),
            // Dots
            Positioned(left: 56, top: 82, child: _Dot(color: AppColors.green)),
            Positioned(right: 56, top: 82, child: _Dot(color: AppColors.primary)),
            // Rider
            Positioned(
              left: MediaQuery.of(context).size.width / 2 - 20, top: 67,
              child: Container(width: 36, height: 36,
                decoration: BoxDecoration(color: AppColors.yellow, shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2), boxShadow: AppColors.cardShadow),
                child: const Center(child: Text('🛵', style: TextStyle(fontSize: 18))))
              .animate(onPlay: (c) => c.repeat(reverse: true))
              .moveX(begin: -18, end: 18, duration: 2000.ms, curve: Curves.easeInOut),
            ),
            // Labels
            const Positioned(left: 36, bottom: 22, child: Text('📦 Warehouse',
              style: TextStyle(fontFamily: 'Poppins', fontSize: 10, fontWeight: FontWeight.w600, color: AppColors.textMedium))),
            const Positioned(right: 16, bottom: 22, child: Text('🏠 Your Home',
              style: TextStyle(fontFamily: 'Poppins', fontSize: 10, fontWeight: FontWeight.w600, color: AppColors.textMedium))),
          ])),

        Expanded(child: SingleChildScrollView(padding: const EdgeInsets.all(16), child: Column(children: [
          // ETA card
          Container(padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: AppColors.primaryLight, borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.primary.withOpacity(0.2))),
            child: Row(children: [
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const Text('Estimated Arrival', style: TextStyle(fontFamily: 'Poppins', fontSize: 11, color: AppColors.primary)),
                const Text('1:45 PM', style: TextStyle(fontFamily: 'Poppins', fontSize: 26, fontWeight: FontWeight.w700, color: AppColors.primary)),
                const Text('Today · Approx 45 min', style: TextStyle(fontFamily: 'Poppins', fontSize: 11, color: AppColors.textMedium)),
              ]),
              const Spacer(),
              Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                const Text('Delivery Partner', style: TextStyle(fontFamily: 'Poppins', fontSize: 11, color: AppColors.textLight)),
                const Text('Ramesh D.', style: TextStyle(fontFamily: 'Poppins', fontSize: 14, fontWeight: FontWeight.w700)),
                const SizedBox(height: 6),
                Row(children: [
                  _ActionBtn('📞 Call', AppColors.primary, () {}),
                  const SizedBox(width: 6),
                  _ActionBtn('💬 Chat', AppColors.green, () {}),
                ]),
              ]),
            ])).animate().fadeIn().slideY(begin: 0.2),

          const SizedBox(height: 24),
          const Align(alignment: Alignment.centerLeft,
            child: Text('Order Timeline', style: TextStyle(fontFamily: 'Poppins', fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.textDark))),
          const SizedBox(height: 16),

          _TLItem('✅', 'Order Placed',        'Payment confirmed',                      '12:10 PM', _TLS.done),
          _TLItem('✅', 'Order Confirmed',     'Jagdish Foods accepted your order',      '12:12 PM', _TLS.done),
          _TLItem('✅', 'Being Packed',        'Your snacks are being packed fresh',     '12:28 PM', _TLS.done),
          _TLItem('🛵', 'Out for Delivery',    'Ramesh is on the way to your location',  '12:55 PM · Now', _TLS.active),
          _TLItem('🏠', 'Delivered',           'Estimated at 1:45 PM',                  '',           _TLS.pending, isLast: true),
        ]))),
      ]),
    );
  }
}

enum _TLS { done, active, pending }

class _Dot extends StatelessWidget {
  final Color color;
  const _Dot({required this.color});
  @override Widget build(BuildContext context) => Container(width: 13, height: 13,
    decoration: BoxDecoration(color: color, shape: BoxShape.circle,
      boxShadow: [BoxShadow(color: color.withOpacity(0.4), blurRadius: 6)]));
}

class _ActionBtn extends StatelessWidget {
  final String label; final Color color; final VoidCallback onTap;
  const _ActionBtn(this.label, this.color, this.onTap);
  @override Widget build(BuildContext context) => GestureDetector(onTap: onTap,
    child: Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(8)),
      child: Text(label, style: const TextStyle(fontFamily: 'Poppins', fontSize: 11, fontWeight: FontWeight.w700, color: Colors.white))));
}

class _TLItem extends StatelessWidget {
  final String emoji, label, sub, time;
  final _TLS state;
  final bool isLast;
  const _TLItem(this.emoji, this.label, this.sub, this.time, this.state, {this.isLast = false});
  @override
  Widget build(BuildContext context) {
    final Color circleColor = state == _TLS.done ? AppColors.green : state == _TLS.active ? AppColors.primary : Colors.white;
    return IntrinsicHeight(child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
      SizedBox(width: 34, child: Column(children: [
        Container(width: 34, height: 34,
          decoration: BoxDecoration(color: circleColor, shape: BoxShape.circle,
            border: Border.all(color: state == _TLS.pending ? AppColors.border : Colors.transparent, width: 2)),
          child: Center(child: Text(emoji, style: const TextStyle(fontSize: 14)))),
        if (!isLast) Expanded(child: Container(width: 2,
          color: state == _TLS.done ? AppColors.green : AppColors.border)),
      ])),
      const SizedBox(width: 14),
      Expanded(child: Padding(padding: EdgeInsets.only(bottom: isLast ? 0 : 20, top: 4),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(label, style: TextStyle(fontFamily: 'Poppins', fontSize: 13, fontWeight: FontWeight.w700,
            color: state == _TLS.active ? AppColors.primary : state == _TLS.pending ? AppColors.textLight : AppColors.textDark)),
          const SizedBox(height: 2),
          Text(sub, style: const TextStyle(fontFamily: 'Poppins', fontSize: 11, color: AppColors.textLight)),
          if (time.isNotEmpty) ...[
            const SizedBox(height: 2),
            Text(time, style: TextStyle(fontFamily: 'Poppins', fontSize: 10, fontWeight: FontWeight.w700,
              color: state == _TLS.active ? AppColors.primary : AppColors.textLight)),
          ],
        ]))),
    ])).animate().fadeIn(delay: 100.ms).slideX(begin: 0.1);
  }
}
