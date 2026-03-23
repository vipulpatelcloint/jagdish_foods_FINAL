// lib/presentation/screens/product/category_screen.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_constants.dart';
import '../../../data/models/models.dart';
import '../../../providers/cart_provider.dart';

class CategoryScreen extends StatefulWidget {
  final String categoryId;
  const CategoryScreen({super.key, required this.categoryId});
  @override State<CategoryScreen> createState() => _CategoryScreenState();
}
class _CategoryScreenState extends State<CategoryScreen> {
  int _filter = 0;
  final _filters = ['All', 'Under ₹200', 'Best Seller', 'New', 'Veg'];

  List<Product> get _products {
    var list = widget.categoryId == 'all'
        ? MockData.products
        : MockData.products.where((p) => p.categoryId == widget.categoryId).toList();
    switch (_filter) {
      case 1: return list.where((p) => p.minPrice < 200).toList();
      case 2: return list.where((p) => p.isBestSeller).toList();
      case 3: return list.where((p) => p.isNew).toList();
      case 4: return list.where((p) => p.isVeg).toList();
      default: return list;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      appBar: AppBar(title: Text(widget.categoryId == 'all' ? 'All Categories' : 'Snacks')),
      body: Column(children: [
        Container(color: Colors.white, padding: const EdgeInsets.fromLTRB(16, 10, 16, 12),
          child: SizedBox(height: 34, child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: _filters.length,
            separatorBuilder: (_, __) => const SizedBox(width: 8),
            itemBuilder: (_, i) => GestureDetector(
              onTap: () => setState(() => _filter = i),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                decoration: BoxDecoration(
                  color: i == _filter ? AppColors.primary : Colors.white,
                  border: Border.all(color: i == _filter ? AppColors.primary : AppColors.border),
                  borderRadius: BorderRadius.circular(20)),
                child: Text(_filters[i], style: TextStyle(
                  fontFamily: 'Poppins', fontSize: 12, fontWeight: FontWeight.w600,
                  color: i == _filter ? Colors.white : AppColors.textMedium)),
              ),
            ),
          ))),
        Expanded(child: GridView.builder(
          padding: const EdgeInsets.all(16),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, crossAxisSpacing: 12, mainAxisSpacing: 12, childAspectRatio: 0.72),
          itemCount: _products.length,
          itemBuilder: (context, i) {
            final p = _products[i];
            final emoji = MockData.productEmojis[p.categoryId] ?? '🥐';
            final bg = Color(MockData.productBgColors[p.categoryId] ?? 0xFFFFF3CD);
            return GestureDetector(
              onTap: () => context.push('/product/${p.id}'),
              child: Container(decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14), boxShadow: AppColors.cardShadow),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Stack(children: [
                    Container(height: 108, decoration: BoxDecoration(color: bg,
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(14))),
                      child: Center(child: Text(emoji, style: const TextStyle(fontSize: 50)))),
                    if (p.isBestSeller) Positioned(top: 8, left: 8, child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                      decoration: BoxDecoration(color: AppColors.yellow, borderRadius: BorderRadius.circular(8)),
                      child: const Text('⭐ BEST', style: TextStyle(fontFamily: 'Poppins', fontSize: 8, fontWeight: FontWeight.w800)))),
                  ]),
                  Padding(padding: const EdgeInsets.all(10), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(p.name, style: const TextStyle(fontFamily: 'Poppins', fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.textDark), maxLines: 1, overflow: TextOverflow.ellipsis),
                    Text(p.defaultVariant.weight, style: const TextStyle(fontFamily: 'Poppins', fontSize: 10, color: AppColors.textLight)),
                    const SizedBox(height: 6),
                    Row(children: [
                      Text('₹${p.defaultVariant.price.toInt()}', style: const TextStyle(fontFamily: 'Poppins', fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.primary)),
                      const Spacer(),
                      GestureDetector(
                        onTap: () => context.read<CartProvider>().add(CartItem(
                          productId: p.id, variantId: p.defaultVariant.id,
                          name: p.name, emoji: emoji, price: p.defaultVariant.price,
                          mrp: p.defaultVariant.mrp, weight: p.defaultVariant.weight)),
                        child: Container(width: 28, height: 28,
                          decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(8)),
                          child: const Icon(Icons.add, color: Colors.white, size: 16))),
                    ]),
                  ])),
                ])),
            );
          },
        )),
      ]),
    );
  }
}
