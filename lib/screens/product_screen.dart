import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../models/product.dart';
import '../providers/cart_provider.dart';

const _blue = Color(0xFF0083BC);

class ProductScreen extends StatefulWidget {
  final String id;
  const ProductScreen({super.key, required this.id});
  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  bool _adding = false;

  Product get _product =>
    kProducts.firstWhere((p) => p.id == widget.id, orElse: () => kProducts.first);

  Future<void> _addToCart({bool buy = false}) async {
    setState(() => _adding = true);
    context.read<CartProvider>().add(_product);
    await Future.delayed(const Duration(milliseconds: 500));
    if (!mounted) return;
    setState(() => _adding = false);
    if (buy) {
      context.push('/checkout');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('${_product.name} added to cart!'),
        backgroundColor: const Color(0xFF52B52A),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        duration: const Duration(seconds: 2),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    final p = _product;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(children: [
        CustomScrollView(slivers: [
          SliverAppBar(
            expandedHeight: 280,
            pinned: true,
            backgroundColor: Colors.white,
            leading: CircleAvatar(
              backgroundColor: Colors.white,
              child: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.black87),
                onPressed: () => context.pop(),
              ),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                color: Color(p.bgColor),
                child: Center(child: Text(p.emoji, style: const TextStyle(fontSize: 110))),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 120),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

                Text(p.name, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w700)),
                const SizedBox(height: 8),

                // Veg badge
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE8F5E9),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: const Color(0xFF52B52A)),
                  ),
                  child: const Row(mainAxisSize: MainAxisSize.min, children: [
                    CircleAvatar(radius: 4, backgroundColor: Color(0xFF52B52A)),
                    SizedBox(width: 5),
                    Text('Pure Veg · No Preservatives', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Color(0xFF2E7D32))),
                  ]),
                ),
                const SizedBox(height: 14),

                // Price
                Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
                  Text('₹${p.price.toInt()}', style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w700, color: _blue)),
                  const SizedBox(width: 8),
                  if (p.hasDiscount) ...[
                    Text('₹${p.mrp.toInt()}', style: TextStyle(fontSize: 14, color: Colors.grey.shade400, decoration: TextDecoration.lineThrough)),
                    const SizedBox(width: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(color: const Color(0xFFE8F5E9), borderRadius: BorderRadius.circular(6)),
                      child: Text('${p.discount.toInt()}% OFF', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Color(0xFF2E7D32))),
                    ),
                  ],
                ]),
                const SizedBox(height: 12),

                // Rating
                Row(children: [
                  const Icon(Icons.star_rounded, color: Color(0xFFF4A300), size: 18),
                  const SizedBox(width: 4),
                  Text('${p.rating}', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700)),
                  const SizedBox(width: 4),
                  Text('(${p.reviews} reviews)', style: TextStyle(fontSize: 12, color: Colors.grey.shade500)),
                ]),
                const SizedBox(height: 20),

                // Trust badges
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE6F4FB),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: const Color(0xFF0083BC).withOpacity(0.15)),
                  ),
                  child: Row(children: [
                    _TrustBadge('🚚', 'Free Delivery', 'Above ₹299'),
                    _TrustBadge('🔄', 'Easy Returns', '7 days'),
                    _TrustBadge('🌿', 'Pure Veg', 'Certified'),
                    _TrustBadge('✅', 'FSSAI', 'Approved'),
                  ]),
                ),
                const SizedBox(height: 20),

                // Description
                const Text('Description', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
                const SizedBox(height: 8),
                Text(p.description, style: TextStyle(fontSize: 13, color: Colors.grey.shade600, height: 1.6)),
                const SizedBox(height: 10),
                Text('🕐 Shelf Life: 45 days  🌡️ Store in cool, dry place', style: TextStyle(fontSize: 12, color: Colors.grey.shade500)),
              ]),
            ),
          ),
        ]),

        // CTA
        Positioned(
          bottom: 0, left: 0, right: 0,
          child: Container(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 28),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 16, offset: const Offset(0, -4))],
            ),
            child: Row(children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _adding ? null : () => _addToCart(),
                  icon: _adding
                      ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2))
                      : const Icon(Icons.add_shopping_cart_rounded),
                  label: Text(_adding ? 'Adding...' : 'Add to Cart'),
                  style: OutlinedButton.styleFrom(minimumSize: const Size(0, 52)),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => _addToCart(buy: true),
                  icon: const Icon(Icons.bolt_rounded),
                  label: const Text('Buy Now'),
                  style: ElevatedButton.styleFrom(minimumSize: const Size(0, 52)),
                ),
              ),
            ]),
          ),
        ),
      ]),
    );
  }
}

class _TrustBadge extends StatelessWidget {
  final String emoji, title, sub;
  const _TrustBadge(this.emoji, this.title, this.sub);
  @override
  Widget build(BuildContext context) => Expanded(child: Column(children: [
    Text(emoji, style: const TextStyle(fontSize: 20)),
    const SizedBox(height: 4),
    Text(title, textAlign: TextAlign.center, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w700)),
    Text(sub, textAlign: TextAlign.center, style: TextStyle(fontSize: 9, color: Colors.grey.shade500)),
  ]));
}
