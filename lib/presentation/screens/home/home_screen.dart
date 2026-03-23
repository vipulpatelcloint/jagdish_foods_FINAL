// lib/presentation/screens/home/home_screen.dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_constants.dart';
import '../../../data/models/models.dart';
import '../../../providers/cart_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override State<HomeScreen> createState() => _HomeState();
}

class _HomeState extends State<HomeScreen> {
  final _pageCtrl = PageController();
  Timer? _timer;
  int _page = 0;

  static const _banners = [
    _BannerData('🪔 Diwali Offers',  'Festive Gift\nHampers',     'Up to 30% off · Free delivery', '🎁', Color(0xFFF4A300), Color(0xFFE8891A)),
    _BannerData('⭐ Best Seller',    'Signature\nBhakharwadi',    'Original recipe · Since 1945',  '🥐', Color(0xFF0083BC), Color(0xFF005F8A)),
    _BannerData('🌿 Pure Veg',       'Premium\nSnack Box',        '5 varieties · ₹499 only',       '📦', Color(0xFF52B52A), Color(0xFF2E7D32)),
  ];

  @override void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 4), (_) {
      if (_pageCtrl.hasClients) {
        _page = (_page + 1) % _banners.length;
        _pageCtrl.animateToPage(_page, duration: const Duration(milliseconds: 500), curve: Curves.easeInOut);
      }
    });
  }
  @override void dispose() { _timer?.cancel(); _pageCtrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.creamLight,
      body: CustomScrollView(slivers: [
        _buildAppBar(context),
        SliverToBoxAdapter(child: _buildBanners()),
        SliverToBoxAdapter(child: _buildCategories(context)),
        SliverToBoxAdapter(child: _buildOrderAgain(context)),
        SliverToBoxAdapter(child: _buildBestSellers(context)),
        SliverToBoxAdapter(child: _buildCombos(context)),
        const SliverToBoxAdapter(child: SizedBox(height: 24)),
      ]),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return SliverAppBar(
      pinned: true,
      backgroundColor: AppColors.primary,
      automaticallyImplyLeading: false,
      titleSpacing: 0,
      title: Padding(
        padding: const EdgeInsets.fromLTRB(16, 4, 16, 0),
        child: Row(children: [
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              const Icon(Icons.location_on, color: AppColors.yellow, size: 13),
              const SizedBox(width: 4),
              Text('Deliver to', style: TextStyle(fontFamily: 'Poppins', color: Colors.white.withOpacity(0.8), fontSize: 11)),
            ]),
            const Row(children: [
              Text('Alkapuri, Vadodara', style: TextStyle(fontFamily: 'Poppins', color: Colors.white, fontSize: 13, fontWeight: FontWeight.w600)),
              Icon(Icons.arrow_drop_down, color: Colors.white, size: 18),
            ]),
          ])),
          GestureDetector(
            onTap: () => context.push('/search'),
            child: Container(
              width: 36, height: 36,
              decoration: BoxDecoration(color: Colors.white.withOpacity(0.15), borderRadius: BorderRadius.circular(10)),
              child: const Icon(Icons.search, color: Colors.white, size: 20),
            ),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: () => context.go('/cart'),
            child: Consumer<CartProvider>(builder: (_, cart, __) => Stack(clipBehavior: Clip.none, children: [
              Container(
                width: 36, height: 36,
                decoration: BoxDecoration(color: Colors.white.withOpacity(0.15), borderRadius: BorderRadius.circular(10)),
                child: const Icon(Icons.shopping_cart_rounded, color: Colors.white, size: 20),
              ),
              if (cart.itemCount > 0) Positioned(top: -4, right: -4,
                child: Container(padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(color: AppColors.yellow, shape: BoxShape.circle),
                  child: Text('${cart.itemCount}', style: const TextStyle(fontSize: 9, fontWeight: FontWeight.w800, color: AppColors.textDark)))),
            ])),
          ),
        ]),
      ),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(50),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
          child: GestureDetector(
            onTap: () => context.push('/search'),
            child: Container(
              height: 42,
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12),
                boxShadow: AppColors.cardShadow),
              child: Row(children: [
                const SizedBox(width: 14),
                const Icon(Icons.search, color: AppColors.textLight, size: 18),
                const SizedBox(width: 8),
                Text('Search snacks, sweets, combos...', style: TextStyle(
                  fontFamily: 'Poppins', fontSize: 13, color: AppColors.textHint)),
                const Spacer(),
                Container(margin: const EdgeInsets.only(right: 10),
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(8)),
                  child: const Text('🔥 Offers', style: TextStyle(
                    fontFamily: 'Poppins', color: Colors.white, fontSize: 10, fontWeight: FontWeight.w700))),
              ]),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBanners() {
    return Padding(
      padding: const EdgeInsets.only(top: 16, bottom: 8),
      child: Column(children: [
        SizedBox(height: 156, child: PageView.builder(
          controller: _pageCtrl,
          onPageChanged: (i) => setState(() => _page = i),
          itemCount: _banners.length,
          itemBuilder: (_, i) {
            final b = _banners[i];
            return Padding(
              padding: EdgeInsets.only(left: i == 0 ? 16 : 6, right: i == _banners.length - 1 ? 16 : 6),
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [b.c1, b.c2], begin: Alignment.topLeft, end: Alignment.bottomRight),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Stack(children: [
                  Padding(padding: const EdgeInsets.all(18), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(color: Colors.white.withOpacity(0.22), borderRadius: BorderRadius.circular(20)),
                      child: Text(b.tag, style: const TextStyle(fontFamily: 'Poppins', color: Colors.white, fontSize: 10, fontWeight: FontWeight.w700))),
                    const SizedBox(height: 8),
                    Text(b.title, style: const TextStyle(fontFamily: 'Poppins', color: Colors.white, fontSize: 19, fontWeight: FontWeight.w700, height: 1.2)),
                    const SizedBox(height: 4),
                    Text(b.sub, style: TextStyle(fontFamily: 'Poppins', color: Colors.white.withOpacity(0.85), fontSize: 11)),
                    const SizedBox(height: 10),
                    Container(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
                      child: Text('Shop Now →', style: TextStyle(fontFamily: 'Poppins', fontSize: 11, fontWeight: FontWeight.w700, color: b.c2))),
                  ])),
                  Positioned(bottom: 10, right: 16, child: Text(b.emoji, style: const TextStyle(fontSize: 54))),
                ]),
              ),
            );
          },
        )),
        const SizedBox(height: 10),
        SmoothPageIndicator(controller: _pageCtrl, count: _banners.length,
          effect: const ExpandingDotsEffect(activeDotColor: AppColors.primary,
            dotColor: AppColors.border, dotHeight: 6, dotWidth: 6, expansionFactor: 3)),
      ]),
    );
  }

  Widget _buildCategories(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Column(children: [
        _SectionHeader('Categories', onAll: () {}),
        const SizedBox(height: 12),
        SizedBox(height: 88, child: ListView.separated(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: AppConstants.categories.length,
          separatorBuilder: (_, __) => const SizedBox(width: 14),
          itemBuilder: (context, i) {
            final c = AppConstants.categories[i];
            return GestureDetector(
              onTap: () => context.push('/category/${c['id']}'),
              child: Column(children: [
                Container(width: 60, height: 60,
                  decoration: BoxDecoration(color: Color(c['color'] as int),
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: [BoxShadow(color: Color(c['color'] as int).withOpacity(0.4), blurRadius: 8, offset: const Offset(0, 3))]),
                  child: Center(child: Text(c['emoji'] as String, style: const TextStyle(fontSize: 26)))),
                const SizedBox(height: 6),
                SizedBox(width: 60, child: Text(c['name'] as String, textAlign: TextAlign.center,
                  maxLines: 2, style: const TextStyle(fontFamily: 'Poppins', fontSize: 10, fontWeight: FontWeight.w600, color: AppColors.textMedium, height: 1.2))),
              ]),
            ).animate().fadeIn(delay: (i * 60).ms);
          },
        )),
      ]),
    );
  }

  Widget _buildOrderAgain(BuildContext context) {
    final items = MockData.products.take(4).toList();
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: Column(children: [
        _SectionHeader('🔁 Order Again', onAll: () {}),
        const SizedBox(height: 12),
        SizedBox(height: 178, child: ListView.separated(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: items.length,
          separatorBuilder: (_, __) => const SizedBox(width: 12),
          itemBuilder: (context, i) {
            final p = items[i];
            final emoji = MockData.productEmojis[p.categoryId] ?? '🥐';
            final bg    = Color(MockData.productBgColors[p.categoryId] ?? 0xFFFFF3CD);
            return Container(
              width: 138,
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.border), boxShadow: AppColors.cardShadow),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Container(height: 86, decoration: BoxDecoration(color: bg,
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(14))),
                  child: Center(child: Text(emoji, style: const TextStyle(fontSize: 42)))),
                Padding(padding: const EdgeInsets.fromLTRB(9, 8, 9, 10), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(p.name, style: const TextStyle(fontFamily: 'Poppins', fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.textDark), maxLines: 1, overflow: TextOverflow.ellipsis),
                  Text('₹${p.defaultVariant.price.toInt()}', style: const TextStyle(fontFamily: 'Poppins', fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.primary)),
                  const SizedBox(height: 6),
                  SizedBox(width: double.infinity, child: ElevatedButton(
                    onPressed: () {
                      context.read<CartProvider>().add(CartItem(
                        productId: p.id, variantId: p.defaultVariant.id,
                        name: p.name, emoji: emoji,
                        price: p.defaultVariant.price, mrp: p.defaultVariant.mrp,
                        weight: p.defaultVariant.weight,
                      ));
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text('${p.name} added!'),
                        backgroundColor: AppColors.green, duration: const Duration(seconds: 2),
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ));
                    },
                    style: ElevatedButton.styleFrom(minimumSize: const Size(0, 28), padding: EdgeInsets.zero,
                      textStyle: const TextStyle(fontFamily: 'Poppins', fontSize: 11, fontWeight: FontWeight.w700),
                      backgroundColor: AppColors.primaryLight, foregroundColor: AppColors.primary,
                      shadowColor: Colors.transparent, elevation: 0),
                    child: const Text('+ Add Again'),
                  )),
                ])),
              ]),
            );
          },
        )),
      ]),
    );
  }

  Widget _buildBestSellers(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: Column(children: [
        _SectionHeader('🏆 Best Sellers', onAll: () {}),
        const SizedBox(height: 12),
        SizedBox(height: 220, child: ListView.separated(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: MockData.products.length,
          separatorBuilder: (_, __) => const SizedBox(width: 12),
          itemBuilder: (context, i) => _ProductCard(product: MockData.products[i],
            onTap: () => context.push('/product/${MockData.products[i].id}')),
        )),
      ]),
    );
  }

  Widget _buildCombos(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: Column(children: [
        _SectionHeader('🎁 Featured Combos', onAll: () {}),
        const SizedBox(height: 12),
        SizedBox(height: 154, child: ListView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          children: [
            _ComboCard(title: 'Snack Party Box', items: ['🥐', '🌾', '🪢', '🫓'],
              sub: 'Bhakharwadi + Chevdo + Sev + Khakhra', price: 549, mrp: 669, badgeColor: AppColors.yellow),
            const SizedBox(width: 12),
            _ComboCard(title: 'Sweet Festive Box', items: ['🍬', '🥮', '🍡'],
              sub: 'Mohanthal + Ghughra + Ladoo', price: 799, mrp: 999, badgeColor: AppColors.gold),
          ],
        )),
      ]),
    );
  }
}

// ─── Sub-widgets ──────────────────────────────────────────────────────────
class _SectionHeader extends StatelessWidget {
  final String title;
  final VoidCallback onAll;
  const _SectionHeader(this.title, {required this.onAll});
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16),
    child: Row(children: [
      Text(title, style: const TextStyle(fontFamily: 'Poppins', fontSize: 17, fontWeight: FontWeight.w700, color: AppColors.textDark)),
      const Spacer(),
      GestureDetector(onTap: onAll,
        child: const Text('View All', style: TextStyle(fontFamily: 'Poppins', fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.primary))),
    ]),
  );
}

class _ProductCard extends StatefulWidget {
  final Product product;
  final VoidCallback onTap;
  const _ProductCard({required this.product, required this.onTap});
  @override State<_ProductCard> createState() => _ProductCardState();
}
class _ProductCardState extends State<_ProductCard> {
  bool _added = false;
  @override
  Widget build(BuildContext context) {
    final emoji = MockData.productEmojis[widget.product.categoryId] ?? '🥐';
    final bg    = Color(MockData.productBgColors[widget.product.categoryId] ?? 0xFFFFF3CD);
    final v     = widget.product.defaultVariant;
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        width: 154,
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.border), boxShadow: AppColors.cardShadow),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Stack(children: [
            Container(height: 104, decoration: BoxDecoration(color: bg,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(14))),
              child: Center(child: Text(emoji, style: const TextStyle(fontSize: 50)))),
            if (widget.product.isBestSeller)
              Positioned(top: 8, left: 8, child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                decoration: BoxDecoration(color: AppColors.yellow, borderRadius: BorderRadius.circular(8)),
                child: const Text('⭐ BEST', style: TextStyle(fontFamily: 'Poppins', fontSize: 8, fontWeight: FontWeight.w800)))),
            if (widget.product.isNew)
              Positioned(top: 8, left: 8, child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                decoration: BoxDecoration(color: AppColors.green, borderRadius: BorderRadius.circular(8)),
                child: const Text('✨ NEW', style: TextStyle(fontFamily: 'Poppins', fontSize: 8, fontWeight: FontWeight.w800, color: Colors.white)))),
          ]),
          Padding(padding: const EdgeInsets.all(10), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(widget.product.name,
              style: const TextStyle(fontFamily: 'Poppins', fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.textDark),
              maxLines: 1, overflow: TextOverflow.ellipsis),
            Text(v.weight, style: const TextStyle(fontFamily: 'Poppins', fontSize: 10, color: AppColors.textLight)),
            const SizedBox(height: 6),
            Row(children: [
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('₹${v.price.toInt()}', style: const TextStyle(fontFamily: 'Poppins', fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.textDark)),
                if (v.hasDiscount)
                  Text('₹${v.mrp.toInt()}', style: const TextStyle(fontFamily: 'Poppins', fontSize: 10, color: AppColors.textLight, decoration: TextDecoration.lineThrough)),
              ]),
              const Spacer(),
              GestureDetector(
                onTap: () async {
                  await context.read<CartProvider>().add(CartItem(
                    productId: widget.product.id, variantId: v.id,
                    name: widget.product.name, emoji: emoji,
                    price: v.price, mrp: v.mrp, weight: v.weight,
                  ));
                  setState(() => _added = true);
                  await Future.delayed(const Duration(seconds: 2));
                  if (mounted) setState(() => _added = false);
                },
                child: AnimatedContainer(duration: const Duration(milliseconds: 200),
                  width: 28, height: 28,
                  decoration: BoxDecoration(color: _added ? AppColors.green : AppColors.primary, borderRadius: BorderRadius.circular(8)),
                  child: Icon(_added ? Icons.check : Icons.add, color: Colors.white, size: 16)),
              ),
            ]),
          ])),
        ]),
      ),
    );
  }
}

class _ComboCard extends StatelessWidget {
  final String title, sub;
  final List<String> items;
  final double price, mrp;
  final Color badgeColor;
  const _ComboCard({required this.title, required this.items, required this.sub,
    required this.price, required this.mrp, required this.badgeColor});
  @override
  Widget build(BuildContext context) {
    final saving = ((mrp - price) / mrp * 100).toInt();
    return Container(
      width: 246,
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border), boxShadow: AppColors.cardShadow),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Padding(padding: const EdgeInsets.fromLTRB(14, 12, 14, 0), child: Row(children: [
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(title, style: const TextStyle(fontFamily: 'Poppins', fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.textDark)),
            Text('Save $saving% 🎉', style: const TextStyle(fontFamily: 'Poppins', fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.green)),
          ])),
          Container(padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
            decoration: BoxDecoration(color: badgeColor, borderRadius: BorderRadius.circular(10)),
            child: Text('COMBO', style: TextStyle(fontFamily: 'Poppins', fontSize: 9, fontWeight: FontWeight.w800,
              color: badgeColor == AppColors.yellow ? AppColors.textDark : Colors.white))),
        ])),
        Padding(padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          child: Row(children: items.map((e) => Padding(padding: const EdgeInsets.only(right: 4),
            child: Text(e, style: const TextStyle(fontSize: 26)))).toList())),
        Padding(padding: const EdgeInsets.symmetric(horizontal: 14),
          child: Text(sub, style: const TextStyle(fontFamily: 'Poppins', fontSize: 10, color: AppColors.textLight))),
        Container(margin: const EdgeInsets.only(top: 8),
          padding: const EdgeInsets.fromLTRB(14, 10, 14, 12),
          decoration: const BoxDecoration(border: Border(top: BorderSide(color: AppColors.border))),
          child: Row(children: [
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('₹${price.toInt()}', style: const TextStyle(fontFamily: 'Poppins', fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.primary)),
              Text('₹${mrp.toInt()} MRP', style: const TextStyle(fontFamily: 'Poppins', fontSize: 10, color: AppColors.textLight, decoration: TextDecoration.lineThrough)),
            ]),
            const Spacer(),
            ElevatedButton(onPressed: () {},
              style: ElevatedButton.styleFrom(minimumSize: const Size(0, 32), padding: const EdgeInsets.symmetric(horizontal: 14),
                textStyle: const TextStyle(fontFamily: 'Poppins', fontSize: 11, fontWeight: FontWeight.w700)),
              child: const Text('Add to Cart')),
          ])),
      ]),
    );
  }
}

class _BannerData {
  final String tag, title, sub, emoji;
  final Color c1, c2;
  const _BannerData(this.tag, this.title, this.sub, this.emoji, this.c1, this.c2);
}
