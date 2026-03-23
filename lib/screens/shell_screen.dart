import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';

class ShellScreen extends StatelessWidget {
  final Widget child;
  const ShellScreen({super.key, required this.child});

  static const _tabs = [
    _Tab(Icons.home_rounded,            'Home',    '/home'),
    _Tab(Icons.shopping_cart_rounded,   'Cart',    '/cart'),
    _Tab(Icons.receipt_long_rounded,    'Orders',  '/orders'),
    _Tab(Icons.person_rounded,          'Profile', '/profile'),
  ];

  int _index(String loc) {
    if (loc.startsWith('/home'))    return 0;
    if (loc.startsWith('/cart'))    return 1;
    if (loc.startsWith('/orders'))  return 2;
    if (loc.startsWith('/profile')) return 3;
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    final loc   = GoRouterState.of(context).matchedLocation;
    final index = _index(loc);
    final cart  = context.watch<CartProvider>();

    return Scaffold(
      body: child,
      bottomNavigationBar: NavigationBar(
        selectedIndex: index,
        onDestinationSelected: (i) => context.go(_tabs[i].path),
        backgroundColor: Colors.white,
        elevation: 8,
        destinations: _tabs.map((t) {
          final isCart = t.path == '/cart';
          return NavigationDestination(
            icon: isCart && cart.count > 0
                ? Badge(label: Text('${cart.count}'), child: Icon(t.icon))
                : Icon(t.icon),
            label: t.label,
          );
        }).toList(),
      ),
    );
  }
}

class _Tab {
  final IconData icon;
  final String label, path;
  const _Tab(this.icon, this.label, this.path);
}
