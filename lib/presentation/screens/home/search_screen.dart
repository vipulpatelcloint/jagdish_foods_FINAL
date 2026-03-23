// lib/presentation/screens/home/search_screen.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../data/models/models.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});
  @override State<SearchScreen> createState() => _SearchState();
}
class _SearchState extends State<SearchScreen> {
  final _ctrl = TextEditingController();
  String _q = '';
  final _trending = ['Bhakharwadi', 'Chevdo Mix', 'Diwali Gift Pack', 'Sev', 'Khakhra', 'Mohanthal'];

  @override void dispose() { _ctrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    final results = _q.isEmpty ? <Product>[] : MockData.products
        .where((p) => p.name.toLowerCase().contains(_q.toLowerCase())).toList();

    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: Padding(
          padding: const EdgeInsets.only(right: 16),
          child: TextField(
            controller: _ctrl, autofocus: true,
            style: const TextStyle(color: Colors.white, fontFamily: 'Poppins'),
            cursorColor: Colors.white,
            decoration: InputDecoration(
              hintText: 'Search snacks, sweets...',
              hintStyle: TextStyle(color: Colors.white.withOpacity(0.6), fontFamily: 'Poppins', fontSize: 14),
              border: InputBorder.none, enabledBorder: InputBorder.none, focusedBorder: InputBorder.none, filled: false),
            onChanged: (v) => setState(() => _q = v),
          ),
        ),
        actions: [if (_q.isNotEmpty)
          IconButton(icon: const Icon(Icons.close, color: Colors.white),
            onPressed: () { _ctrl.clear(); setState(() => _q = ''); })],
      ),
      body: _q.isEmpty
          ? Padding(padding: const EdgeInsets.all(16), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Text('🔥 Trending', style: TextStyle(fontFamily: 'Poppins', fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.textDark)),
              const SizedBox(height: 12),
              Wrap(spacing: 8, runSpacing: 8, children: _trending.map((t) => GestureDetector(
                onTap: () => setState(() { _ctrl.text = t; _q = t; }),
                child: Container(padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AppColors.border), boxShadow: AppColors.cardShadow),
                  child: Text(t, style: const TextStyle(fontFamily: 'Poppins', fontSize: 12, fontWeight: FontWeight.w500, color: AppColors.textMedium))),
              )).toList()),
            ]))
          : results.isEmpty
              ? Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                  const Text('🔍', style: TextStyle(fontSize: 48)),
                  const SizedBox(height: 12),
                  Text('No results for "$_q"', style: const TextStyle(fontFamily: 'Poppins', fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.textDark)),
                ]))
              : ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: results.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 10),
                  itemBuilder: (context, i) {
                    final p = results[i];
                    final emoji = MockData.productEmojis[p.categoryId] ?? '🥐';
                    final bg = Color(MockData.productBgColors[p.categoryId] ?? 0xFFFFF3CD);
                    return GestureDetector(
                      onTap: () => context.push('/product/${p.id}'),
                      child: Container(padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14), boxShadow: AppColors.cardShadow),
                        child: Row(children: [
                          Container(width: 56, height: 56, decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(10)),
                            child: Center(child: Text(emoji, style: const TextStyle(fontSize: 28)))),
                          const SizedBox(width: 12),
                          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                            Text(p.name, style: const TextStyle(fontFamily: 'Poppins', fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textDark)),
                            Text(p.categoryName, style: const TextStyle(fontFamily: 'Poppins', fontSize: 11, color: AppColors.textLight)),
                          ])),
                          Text('₹${p.minPrice.toInt()}', style: const TextStyle(fontFamily: 'Poppins', fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.primary)),
                          const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: AppColors.textLight),
                        ])),
                    );
                  },
                ),
    );
  }
}
