import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../models/product.dart';
import '../providers/cart_provider.dart';

const _blue = Color(0xFF0083BC);
const _yellow = Color(0xFFF4A300);
const _green = Color(0xFF52B52A);

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _pageCtrl = PageController();
  int _page = 0;

  @override
  void dispose() {
    _pageCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: CustomScrollView(
        slivers: [
          // ── App Bar ──────────────────────────────────────
          SliverAppBar(
            pinned: true,
            backgroundColor: _blue,
            automaticallyImplyLeading: false,
            toolbarHeight: 56,
            title: Row(children: [
              const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('Deliver to', style: TextStyle(color: Colors.white70, fontSize: 11)),
                Row(children: [
                  Text('Alkapuri, Vadodara', style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600)),
                  Icon(Icons.arrow_drop_down, color: Colors.white, size: 18),
                ]),
              ]),
              const Spacer(),
              GestureDetector(
                onTap: () => context.go('/cart'),
                child: Stack(clipBehavior: Clip.none, children: [
                  Container(
                    width: 36, height: 36,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.shopping_cart_rounded, color: Colors.white, size: 20),
                  ),
                  if (cart.count > 0)
                    Positioned(
                      top: -4, right: -4,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(color: _yellow, shape: BoxShape.circle),
                        child: Text('${cart.count}', style: const TextStyle(fontSize: 9, fontWeight: FontWeight.w800, color: Colors.black)),
                      ),
                    ),
                ]),
              ),
            ]),
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(48),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
                child: Container(
                  height: 40,
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
                  child: const Row(children: [
                    SizedBox(width: 12),
                    Icon(Icons.search, color: Colors.grey, size: 18),
                    SizedBox(width: 8),
                    Text('Search snacks, sweets, combos...', style: TextStyle(color: Colors.grey, fontSize: 13)),
                  ]),
                ),
              ),
            ),
          ),

          SliverToBoxAdapter(child: Column(children: [

            // ── Banner ─────────────────────────────────────
            const SizedBox(height: 14),
            SizedBox(
              height: 150,
              child: PageView(
                controller: _pageCtrl,
                onPageChanged: (i) => setState(() => _page = i),
                children: const [
                  _BannerCard(
                    tag: '🪔 Diwali Offers',
                    title: 'Festive Gift\nHampers',
                    sub: 'Up to 30% off',
                    emoji: '🎁',
                    c1: Color(0xFFF4A300),
                    c2: Color(0xFFE8891A),
                  ),
                  _BannerCard(
                    tag: '⭐ Best Seller',
                    title: 'Signature\nBhakharwadi',
                    sub: 'Original · Since 1945',
                    emoji: '🥐',
                    c1: Color(0xFF0083BC),
                    c2: Color(0xFF005F8A),
                  ),
                  _BannerCard(
                    tag: '🌿 Pure Veg',
                    title: 'Premium\nSnack Box',
                    sub: '5 varieties · ₹499',
                    emoji: '📦',
                    c1: Color(0xFF52B52A),
                    c2: Color(0xFF2E7D32),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(3, (i) => AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                margin: const EdgeInsets.symmetric(horizontal: 3),
                width: i == _page ? 18 : 6,
                height: 6,
                decoration: BoxDecoration(
                  color: i == _page ? _blue : Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(3),
                ),
              )),
            ),

            // ── Categories ─────────────────────────────────
            const SizedBox(height: 20),
            _SectionHeader('Categories', onAll: () {}),
            const SizedBox(height: 12),
            SizedBox(
              height: 90,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: kCategories.length,
                separatorBuilder: (_, __) => const SizedBox(width: 14),
                itemBuilder: (_, i) {
                  final c = kCategories[i];
                  return GestureDetector(
                    onTap: () {},
                    child: Column(children: [
                      Container(
                        width: 58, height: 58,
                        decoration: BoxDecoration(
                          color: Color(c['color'] as int),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Center(child: Text(c['emoji'] as String, style: const TextStyle(fontSize: 26))),
                      ),
                      const SizedBox(height: 5),
                      Text(c['name'] as String, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600)),
                    ]),
                  );
                },
              ),
            ),

            // ── Order Again ────────────────────────────────
            const SizedBox(height: 20),
            _SectionHeader('🔁 Order Again', onAll: () {}),
            const SizedBox(height: 12),
            SizedBox(
              height: 178,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: kProducts.take(4).length,
                separatorBuilder: (_, __) => const SizedBox(width: 12),
                itemBuilder: (context, i) {
                  final p = kProducts[i];
                  return _ReorderCard(product: p, cart: cart);
                },
              ),
            ),

            // ── Best Sellers ───────────────────────────────
            const SizedBox(height: 20),
            _SectionHeader('🏆 Best Sellers', onAll: () {}),
            const SizedBox(height: 12),
            SizedBox(
              height: 220,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: kProducts.length,
                separatorBuilder: (_, __) => const SizedBox(width: 12),
                itemBuilder: (context, i) {
                  final p = kProducts[i];
                  return _ProductCard(product: p, cart: cart,
                    onTap: () => context.push('/product/${p.id}'));
                },
              ),
            ),

            const SizedBox(height: 28),
          ])),
        ],
      ),
    );
  }
}

// ── Sub-widgets ──────────────────────────────────────────────────────────────

class _SectionHeader extends StatelessWidget {
  final String title;
  final VoidCallback onAll;
  const _SectionHeader(this.title, {required this.onAll});
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16),
    child: Row(children: [
      Text(title, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w700)),
      const Spacer(),
      GestureDetector(
        onTap: onAll,
        child: const Text('View All', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: _blue)),
      ),
    ]),
  );
}

class _BannerCard extends StatelessWidget {
  final String tag, title, sub, emoji;
  final Color c1, c2;
  const _BannerCard({required this.tag, required this.title, required this.sub,
    required this.emoji, required this.c1, required this.c2});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [c1, c2], begin: Alignment.topLeft, end: Alignment.bottomRight),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Stack(children: [
          Padding(
            padding: const EdgeInsets.all(18),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(20)),
                child: Text(tag, style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w700)),
              ),
              const SizedBox(height: 8),
              Text(title, style: const TextStyle(color: Colors.white, fontSize: 19, fontWeight: FontWeight.w700, height: 1.2)),
              const SizedBox(height: 4),
              Text(sub, style: TextStyle(color: Colors.white.withOpacity(0.85), fontSize: 11)),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
                child: Text('Shop Now →', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: c2)),
              ),
            ]),
          ),
          Positioned(bottom: 10, right: 16, child: Text(emoji, style: const TextStyle(fontSize: 54))),
        ]),
      ),
    );
  }
}

class _ReorderCard extends StatelessWidget {
  final Product product;
  final CartProvider cart;
  const _ReorderCard({required this.product, required this.cart});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 138,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(
          height: 86,
          decoration: BoxDecoration(
            color: Color(product.bgColor),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(14)),
          ),
          child: Center(child: Text(product.emoji, style: const TextStyle(fontSize: 42))),
        ),
        Padding(padding: const EdgeInsets.fromLTRB(9, 8, 9, 10), child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(product.name, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600), maxLines: 1, overflow: TextOverflow.ellipsis),
          Text('₹${product.price.toInt()}', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: _blue)),
          const SizedBox(height: 6),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => cart.add(product),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(0, 28),
                padding: EdgeInsets.zero,
                backgroundColor: const Color(0xFFE6F4FB),
                foregroundColor: _blue,
                elevation: 0,
                textStyle: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: const Text('+ Add Again'),
            ),
          ),
        ])),
      ]),
    );
  }
}

class _ProductCard extends StatefulWidget {
  final Product product;
  final CartProvider cart;
  final VoidCallback onTap;
  const _ProductCard({required this.product, required this.cart, required this.onTap});
  @override
  State<_ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<_ProductCard> {
  bool _added = false;

  @override
  Widget build(BuildContext context) {
    final p = widget.product;
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        width: 154,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Stack(children: [
            Container(
              height: 104,
              decoration: BoxDecoration(
                color: Color(p.bgColor),
                borderRadius: const BorderRadius.vertical(top: Radius.circular(14)),
              ),
              child: Center(child: Text(p.emoji, style: const TextStyle(fontSize: 50))),
            ),
            if (p.isBestSeller)
              Positioned(top: 8, left: 8, child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                decoration: BoxDecoration(color: _yellow, borderRadius: BorderRadius.circular(8)),
                child: const Text('⭐ BEST', style: TextStyle(fontSize: 8, fontWeight: FontWeight.w800)),
              )),
            if (p.isNew)
              Positioned(top: 8, left: 8, child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                decoration: BoxDecoration(color: _green, borderRadius: BorderRadius.circular(8)),
                child: const Text('✨ NEW', style: TextStyle(fontSize: 8, fontWeight: FontWeight.w800, color: Colors.white)),
              )),
          ]),
          Padding(padding: const EdgeInsets.all(10), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(p.name, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600), maxLines: 1, overflow: TextOverflow.ellipsis),
            Text(p.weight, style: TextStyle(fontSize: 10, color: Colors.grey.shade500)),
            const SizedBox(height: 6),
            Row(children: [
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('₹${p.price.toInt()}', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700)),
                if (p.hasDiscount)
                  Text('₹${p.mrp.toInt()}', style: TextStyle(fontSize: 10, color: Colors.grey.shade400, decoration: TextDecoration.lineThrough)),
              ]),
              const Spacer(),
              GestureDetector(
                onTap: () async {
                  widget.cart.add(p);
                  setState(() => _added = true);
                  await Future.delayed(const Duration(seconds: 2));
                  if (mounted) setState(() => _added = false);
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 28, height: 28,
                  decoration: BoxDecoration(
                    color: _added ? _green : _blue,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(_added ? Icons.check : Icons.add, color: Colors.white, size: 16),
                ),
              ),
            ]),
          ])),
        ]),
      ),
    );
  }
}
