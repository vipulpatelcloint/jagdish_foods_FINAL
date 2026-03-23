// lib/presentation/screens/home/main_shell.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../providers/cart_provider.dart';

class MainShell extends StatelessWidget {
  final Widget child;
  const MainShell({super.key, required this.child});

  static const _tabs = [
    _Tab(Icons.home_rounded,       'Home',       '/home'),
    _Tab(Icons.grid_view_rounded,  'Categories', '/categories'),
    _Tab(Icons.shopping_cart_rounded, 'Cart',    '/cart'),
    _Tab(Icons.receipt_long_rounded, 'Orders',   '/orders'),
    _Tab(Icons.person_rounded,     'Profile',    '/profile'),
  ];

  int _idx(String loc) {
    if (loc.startsWith('/home'))       return 0;
    if (loc.startsWith('/categor'))   return 1;
    if (loc.startsWith('/cart'))      return 2;
    if (loc.startsWith('/order'))     return 3;
    if (loc.startsWith('/profile'))   return 4;
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    final loc   = GoRouterState.of(context).matchedLocation;
    final idx   = _idx(loc);
    final cart  = context.watch<CartProvider>();

    return Scaffold(
      body: child,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.09), blurRadius: 20, offset: const Offset(0, -4))],
        ),
        child: SafeArea(
          child: SizedBox(
            height: 62,
            child: Row(children: List.generate(_tabs.length, (i) {
              final tab    = _tabs[i];
              final active = i == idx;
              return Expanded(
                child: GestureDetector(
                  onTap: () => context.go(tab.path),
                  behavior: HitTestBehavior.opaque,
                  child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                    Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Icon(tab.icon, size: 24, color: active ? AppColors.primary : AppColors.textLight),
                        if (i == 2 && cart.itemCount > 0)
                          Positioned(top: -4, right: -6, child: Container(
                            padding: const EdgeInsets.all(3),
                            decoration: const BoxDecoration(color: AppColors.yellow, shape: BoxShape.circle),
                            child: Text('${cart.itemCount}',
                              style: const TextStyle(fontSize: 9, fontWeight: FontWeight.w800, color: AppColors.textDark)),
                          )),
                      ],
                    ),
                    const SizedBox(height: 3),
                    Text(tab.label, style: TextStyle(
                      fontFamily: 'Poppins', fontSize: 10,
                      fontWeight: active ? FontWeight.w700 : FontWeight.w500,
                      color: active ? AppColors.primary : AppColors.textLight,
                    )),
                    if (active) ...[
                      const SizedBox(height: 2),
                      Container(width: 18, height: 3, decoration: BoxDecoration(
                        color: AppColors.primary, borderRadius: BorderRadius.circular(2))),
                    ],
                  ]),
                ),
              );
            })),
          ),
        ),
      ),
    );
  }
}

class _Tab {
  final IconData icon;
  final String label, path;
  const _Tab(this.icon, this.label, this.path);
}
