// lib/presentation/screens/product/product_detail_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../data/models/models.dart';
import '../../../providers/cart_provider.dart';
import '../../../providers/wishlist_provider.dart';

class ProductDetailScreen extends StatefulWidget {
  final String id;
  const ProductDetailScreen({super.key, required this.id});
  @override State<ProductDetailScreen> createState() => _ProductDetailState();
}

class _ProductDetailState extends State<ProductDetailScreen>
    with SingleTickerProviderStateMixin {
  late Product _product;
  late ProductVariant _variant;
  late TabController _tabs;
  int _imgPage = 0;
  bool _adding = false;

  @override
  void initState() {
    super.initState();
    _product = MockData.products.firstWhere(
        (p) => p.id == widget.id, orElse: () => MockData.products.first);
    _variant = _product.defaultVariant;
    _tabs = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() { _tabs.dispose(); super.dispose(); }

  Future<void> _addToCart({bool buyNow = false}) async {
    setState(() => _adding = true);
    await context.read<CartProvider>().add(CartItem(
      productId: _product.id, variantId: _variant.id,
      name: _product.name,
      emoji: MockData.productEmojis[_product.categoryId] ?? '🥐',
      price: _variant.price, mrp: _variant.mrp, weight: _variant.weight,
    ));
    await Future.delayed(const Duration(milliseconds: 500));
    if (!mounted) return;
    setState(() => _adding = false);
    if (buyNow) {
      context.push('/checkout');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('${_product.name} added to cart! 🛒'),
        backgroundColor: AppColors.green, duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    final emoji     = MockData.productEmojis[_product.categoryId] ?? '🥐';
    final bg        = Color(MockData.productBgColors[_product.categoryId] ?? 0xFFFFF3CD);
    final wishlist  = context.watch<WishlistProvider>();
    final wished    = wishlist.isIn(_product.id);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(children: [
        CustomScrollView(slivers: [
          // Image SliverAppBar
          SliverAppBar(
            expandedHeight: 290,
            pinned: true,
            backgroundColor: Colors.white,
            leading: Padding(
              padding: const EdgeInsets.all(8),
              child: CircleAvatar(
                backgroundColor: Colors.white,
                child: IconButton(
                  icon: const Icon(Icons.arrow_back, color: AppColors.textDark),
                  onPressed: () => context.pop(),
                ),
              ),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.all(8),
                child: CircleAvatar(
                  backgroundColor: Colors.white,
                  child: IconButton(
                    icon: Icon(
                      wished ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                      color: wished ? Colors.red : AppColors.textLight,
                    ),
                    onPressed: () => wishlist.toggle(_product),
                  ),
                ),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(children: [
                Container(
                  decoration: BoxDecoration(color: bg),
                  child: Center(child: Text(emoji,
                      style: const TextStyle(fontSize: 120))),
                ),
                if (_product.isBestSeller)
                  Positioned(bottom: 16, left: 16, child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                    decoration: BoxDecoration(color: AppColors.yellow, borderRadius: BorderRadius.circular(20)),
                    child: const Text('⭐ BEST SELLER', style: TextStyle(fontFamily: 'Poppins', fontSize: 11, fontWeight: FontWeight.w800)),
                  )),
              ]),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 110),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

                // Name + veg badge
                Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Expanded(child: Text(_product.name, style: const TextStyle(
                    fontFamily: 'Poppins', fontSize: 22, fontWeight: FontWeight.w700, color: AppColors.textDark))),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.all(3),
                    decoration: BoxDecoration(border: Border.all(color: AppColors.green, width: 1.5), borderRadius: BorderRadius.circular(4)),
                    child: Container(width: 10, height: 10,
                      decoration: const BoxDecoration(color: AppColors.green, shape: BoxShape.circle)),
                  ),
                ]),
                const SizedBox(height: 8),

                // Tags
                Wrap(spacing: 8, runSpacing: 6, children: [
                  _Tag('🌿 Pure Veg', AppColors.greenLight, AppColors.greenDeep),
                  _Tag('✅ No Preservatives', AppColors.primaryLight, AppColors.primary),
                  _Tag('🏆 FSSAI Certified', AppColors.yellowLight, const Color(0xFF7A5800)),
                ]),
                const SizedBox(height: 14),

                // Price
                Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
                  Text('₹${_variant.price.toInt()}', style: const TextStyle(
                    fontFamily: 'Poppins', fontSize: 28, fontWeight: FontWeight.w700, color: AppColors.primary)),
                  const SizedBox(width: 8),
                  if (_variant.hasDiscount) ...[
                    Text('₹${_variant.mrp.toInt()}', style: const TextStyle(
                      fontFamily: 'Poppins', fontSize: 14, color: AppColors.textLight,
                      decoration: TextDecoration.lineThrough)),
                    const SizedBox(width: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(color: AppColors.greenLight, borderRadius: BorderRadius.circular(6)),
                      child: Text('${_variant.discountInt}% OFF',
                        style: const TextStyle(fontFamily: 'Poppins', fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.greenDeep))),
                  ],
                ]),
                const SizedBox(height: 12),

                // Rating
                Row(children: [
                  RatingBarIndicator(
                    rating: _product.rating,
                    itemBuilder: (_, __) => const Icon(Icons.star_rounded, color: AppColors.yellow),
                    itemSize: 18,
                  ),
                  const SizedBox(width: 6),
                  Text('${_product.rating}', style: const TextStyle(fontFamily: 'Poppins', fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.textDark)),
                  const SizedBox(width: 4),
                  Text('(${_product.reviewCount} reviews)', style: const TextStyle(fontFamily: 'Poppins', fontSize: 12, color: AppColors.textLight)),
                ]),
                const SizedBox(height: 20),

                // Weight selector
                const Text('Select Weight', style: TextStyle(fontFamily: 'Poppins', fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textMedium)),
                const SizedBox(height: 8),
                Wrap(spacing: 8, runSpacing: 8, children: _product.variants.map((v) {
                  final sel = v.id == _variant.id;
                  return GestureDetector(
                    onTap: () => setState(() => _variant = v),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
                      decoration: BoxDecoration(
                        color: sel ? AppColors.primaryLight : Colors.white,
                        border: Border.all(color: sel ? AppColors.primary : AppColors.border, width: sel ? 2 : 1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(children: [
                        Text(v.weight, style: TextStyle(fontFamily: 'Poppins', fontSize: 12,
                          fontWeight: FontWeight.w700, color: sel ? AppColors.primary : AppColors.textDark)),
                        Text('₹${v.price.toInt()}', style: TextStyle(fontFamily: 'Poppins', fontSize: 11,
                          fontWeight: FontWeight.w500, color: sel ? AppColors.primary : AppColors.textMedium)),
                      ]),
                    ),
                  );
                }).toList()),
                const SizedBox(height: 20),

                // Trust badges
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: AppColors.primaryLight, borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: AppColors.primary.withOpacity(0.15))),
                  child: Row(children: [
                    _TrustBadge('🚚', 'Free Delivery', 'Above ₹299'),
                    _TrustBadge('🔄', 'Easy Returns', '7 day policy'),
                    _TrustBadge('🌿', 'Pure Veg', 'No meat/egg'),
                    _TrustBadge('✅', 'FSSAI', 'Certified'),
                  ]),
                ),
                const SizedBox(height: 20),

                // Tabs
                TabBar(
                  controller: _tabs,
                  tabs: const [Tab(text: 'Description'), Tab(text: 'Ingredients'), Tab(text: 'Reviews')],
                  labelStyle: const TextStyle(fontFamily: 'Poppins', fontSize: 13, fontWeight: FontWeight.w700),
                  unselectedLabelStyle: const TextStyle(fontFamily: 'Poppins', fontSize: 13),
                  labelColor: AppColors.primary,
                  unselectedLabelColor: AppColors.textLight,
                  indicatorColor: AppColors.primary,
                ),
                const SizedBox(height: 12),
                SizedBox(height: 120, child: TabBarView(controller: _tabs, children: [
                  Text('${_product.description}\n\n🕐 Shelf Life: ${_product.shelfLife}\n🌡️ Store in cool, dry place away from direct sunlight.',
                    style: const TextStyle(fontFamily: 'Poppins', fontSize: 13, color: AppColors.textMedium, height: 1.6)),
                  Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    const Text('Ingredients:', style: TextStyle(fontFamily: 'Poppins', fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.textDark)),
                    const SizedBox(height: 6),
                    Text(_product.ingredients.join(', '),
                      style: const TextStyle(fontFamily: 'Poppins', fontSize: 13, color: AppColors.textMedium, height: 1.6)),
                  ]),
                  Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                    RatingBarIndicator(rating: _product.rating,
                      itemBuilder: (_, __) => const Icon(Icons.star_rounded, color: AppColors.yellow), itemSize: 26),
                    const SizedBox(height: 6),
                    Text('${_product.rating} / 5.0', style: const TextStyle(fontFamily: 'Poppins', fontSize: 16, fontWeight: FontWeight.w700)),
                    Text('${_product.reviewCount} verified reviews', style: const TextStyle(fontFamily: 'Poppins', fontSize: 12, color: AppColors.textLight)),
                  ])),
                ])),
              ]),
            ),
          ),
        ]),

        // Bottom CTA
        Positioned(
          bottom: 0, left: 0, right: 0,
          child: Container(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 28),
            decoration: BoxDecoration(color: Colors.white,
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 16, offset: const Offset(0, -4))]),
            child: Row(children: [
              Expanded(child: OutlinedButton.icon(
                onPressed: _adding ? null : () => _addToCart(),
                icon: _adding
                    ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2))
                    : const Icon(Icons.add_shopping_cart_rounded),
                label: Text(_adding ? 'Adding...' : 'Add to Cart'),
                style: OutlinedButton.styleFrom(minimumSize: const Size(0, 52)),
              )),
              const SizedBox(width: 10),
              Expanded(child: ElevatedButton.icon(
                onPressed: () => _addToCart(buyNow: true),
                icon: const Icon(Icons.bolt_rounded),
                label: const Text('Buy Now'),
                style: ElevatedButton.styleFrom(minimumSize: const Size(0, 52)),
              )),
            ]),
          ).animate().slideY(begin: 0.5, duration: 400.ms, curve: Curves.easeOut),
        ),
      ]),
    );
  }
}

class _Tag extends StatelessWidget {
  final String label; final Color bg, text;
  const _Tag(this.label, this.bg, this.text);
  @override Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
    decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(20)),
    child: Text(label, style: TextStyle(fontFamily: 'Poppins', fontSize: 11, fontWeight: FontWeight.w600, color: text)));
}

class _TrustBadge extends StatelessWidget {
  final String emoji, title, sub;
  const _TrustBadge(this.emoji, this.title, this.sub);
  @override Widget build(BuildContext context) => Expanded(child: Column(children: [
    Text(emoji, style: const TextStyle(fontSize: 20)),
    const SizedBox(height: 4),
    Text(title, textAlign: TextAlign.center,
      style: const TextStyle(fontFamily: 'Poppins', fontSize: 10, fontWeight: FontWeight.w700, color: AppColors.textDark)),
    Text(sub, textAlign: TextAlign.center,
      style: const TextStyle(fontFamily: 'Poppins', fontSize: 9, color: AppColors.textLight)),
  ]));
}
