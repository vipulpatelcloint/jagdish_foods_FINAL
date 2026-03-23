// lib/presentation/screens/wishlist/wishlist_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../data/models/models.dart';
import '../../../providers/cart_provider.dart';
import '../../../providers/wishlist_provider.dart';

class WishlistScreen extends StatelessWidget {
  const WishlistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final wishlist = context.watch<WishlistProvider>();
    // Show mock products if wishlist is empty (demo mode)
    final items = wishlist.products.isEmpty ? MockData.products : wishlist.products;

    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      appBar: AppBar(
        title: Text('❤️ Wishlist (${items.length})'),
      ),
      body: items.isEmpty
          ? Center(
              child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                const Text('🤍', style: TextStyle(fontSize: 72)),
                const SizedBox(height: 16),
                const Text('Your wishlist is empty',
                    style: TextStyle(fontFamily: 'Poppins', fontSize: 20, fontWeight: FontWeight.w700, color: AppColors.textDark)),
                const SizedBox(height: 8),
                const Text('Tap the ❤️ icon on any product to save it',
                    style: TextStyle(fontFamily: 'Poppins', fontSize: 13, color: AppColors.textMedium)),
                const SizedBox(height: 28),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 60),
                  child: ElevatedButton.icon(
                    onPressed: () => context.go('/home'),
                    icon: const Icon(Icons.explore_rounded),
                    label: const Text('Explore Products'),
                  ),
                ),
              ]),
            )
          : GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.72,
              ),
              itemCount: items.length,
              itemBuilder: (context, i) {
                final p     = items[i];
                final emoji = MockData.productEmojis[p.categoryId] ?? '🥐';
                final bg    = Color(MockData.productBgColors[p.categoryId] ?? 0xFFFFF3CD);
                final wished = wishlist.isIn(p.id);

                return GestureDetector(
                  onTap: () => context.push('/product/${p.id}'),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: AppColors.cardShadow,
                    ),
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Stack(children: [
                        Container(
                          height: 112,
                          decoration: BoxDecoration(
                            color: bg,
                            borderRadius: const BorderRadius.vertical(top: Radius.circular(14)),
                          ),
                          child: Center(child: Text(emoji, style: const TextStyle(fontSize: 52))),
                        ),
                        Positioned(
                          top: 8, right: 8,
                          child: GestureDetector(
                            onTap: () => wishlist.toggle(p),
                            child: Container(
                              width: 32, height: 32,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(9),
                                boxShadow: AppColors.cardShadow,
                              ),
                              child: Center(child: Text(
                                wished ? '❤️' : '🤍',
                                style: const TextStyle(fontSize: 15),
                              )),
                            ),
                          ),
                        ),
                      ]),
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Text(p.name,
                              style: const TextStyle(fontFamily: 'Poppins', fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.textDark),
                              maxLines: 1, overflow: TextOverflow.ellipsis),
                          const SizedBox(height: 2),
                          Text(p.defaultVariant.weight,
                              style: const TextStyle(fontFamily: 'Poppins', fontSize: 10, color: AppColors.textLight)),
                          const SizedBox(height: 6),
                          Text('₹${p.defaultVariant.price.toInt()}',
                              style: const TextStyle(fontFamily: 'Poppins', fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.primary)),
                          const SizedBox(height: 8),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () {
                                context.read<CartProvider>().add(CartItem(
                                  productId: p.id,
                                  variantId: p.defaultVariant.id,
                                  name: p.name,
                                  emoji: emoji,
                                  price: p.defaultVariant.price,
                                  mrp: p.defaultVariant.mrp,
                                  weight: p.defaultVariant.weight,
                                ));
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                  content: Text('${p.name} added to cart!'),
                                  backgroundColor: AppColors.green,
                                  behavior: SnackBarBehavior.floating,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                  duration: const Duration(seconds: 2),
                                ));
                              },
                              style: ElevatedButton.styleFrom(
                                minimumSize: const Size(0, 34),
                                padding: EdgeInsets.zero,
                                textStyle: const TextStyle(fontFamily: 'Poppins', fontSize: 11, fontWeight: FontWeight.w700),
                              ),
                              child: const Text('Add to Cart'),
                            ),
                          ),
                        ]),
                      ),
                    ]),
                  ).animate().fadeIn(delay: (i * 60).ms).scale(begin: const Offset(0.95, 0.95)),
                );
              },
            ),
    );
  }
}
