import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../presentation/screens/auth/splash_screen.dart';
import '../../presentation/screens/auth/welcome_screen.dart';
import '../../presentation/screens/auth/phone_screen.dart';
import '../../presentation/screens/home/main_shell.dart';
import '../../presentation/screens/home/home_screen.dart';
import '../../presentation/screens/home/search_screen.dart';
import '../../presentation/screens/product/product_detail_screen.dart';
import '../../presentation/screens/product/category_screen.dart';
import '../../presentation/screens/cart/cart_screen.dart';
import '../../presentation/screens/checkout/checkout_screen.dart';
import '../../presentation/screens/checkout/order_success_screen.dart';
import '../../presentation/screens/orders/orders_screen.dart';
import '../../presentation/screens/orders/order_tracking_screen.dart';
import '../../presentation/screens/profile/profile_screen.dart';
import '../../presentation/screens/profile/edit_profile_screen.dart';
import '../../presentation/screens/profile/address_screen.dart';
import '../../presentation/screens/wishlist/wishlist_screen.dart';
import '../../presentation/screens/offers/offers_screen.dart';

final _root  = GlobalKey<NavigatorState>();
final _shell = GlobalKey<NavigatorState>();

final router = GoRouter(
  navigatorKey: _root,
  initialLocation: '/splash',
  routes: [
    GoRoute(path: '/splash',   builder: (_, __) => const SplashScreen()),
    GoRoute(path: '/welcome',  pageBuilder: _fade(const WelcomeScreen())),
    GoRoute(path: '/phone',    pageBuilder: _slide(const PhoneScreen())),

    ShellRoute(
      navigatorKey: _shell,
      builder: (_, __, child) => MainShell(child: child),
      routes: [
        GoRoute(path: '/home',     pageBuilder: (_, __) => const NoTransitionPage(child: HomeScreen())),
        GoRoute(path: '/cart',     pageBuilder: (_, __) => const NoTransitionPage(child: CartScreen())),
        GoRoute(path: '/orders',   pageBuilder: (_, __) => const NoTransitionPage(child: OrdersScreen())),
        GoRoute(path: '/profile',  pageBuilder: (_, __) => const NoTransitionPage(child: ProfileScreen())),
        GoRoute(path: '/categories', pageBuilder: (_, __) => const NoTransitionPage(child: CategoryScreen(categoryId: 'all'))),
      ],
    ),

    GoRoute(path: '/search',          pageBuilder: _slide(const SearchScreen())),
    GoRoute(path: '/category/:id',    pageBuilder: (c, s) => _slideP(CategoryScreen(categoryId: s.pathParameters['id']!), s)),
    GoRoute(path: '/product/:id',     pageBuilder: (c, s) => _slideP(ProductDetailScreen(id: s.pathParameters['id']!), s)),
    GoRoute(path: '/checkout',        pageBuilder: _slide(const CheckoutScreen())),
    GoRoute(path: '/success/:id',     pageBuilder: (c, s) => _fadeP(OrderSuccessScreen(orderId: s.pathParameters['id']!), s)),
    GoRoute(path: '/tracking/:id',    pageBuilder: (c, s) => _slideP(OrderTrackingScreen(orderId: s.pathParameters['id']!), s)),
    GoRoute(path: '/wishlist',        pageBuilder: _slide(const WishlistScreen())),
    GoRoute(path: '/offers',          pageBuilder: _slide(const OffersScreen())),
    GoRoute(path: '/edit-profile',    pageBuilder: _slide(const EditProfileScreen())),
    GoRoute(path: '/addresses',       pageBuilder: _slide(const AddressScreen())),
  ],
);

GoRouterPageBuilder _slide(Widget w) => (_, s) => _slideP(w, s);
GoRouterPageBuilder _fade(Widget w)  => (_, s) => _fadeP(w, s);

CustomTransitionPage _slideP(Widget w, GoRouterState s) => CustomTransitionPage(
  key: s.pageKey, child: w,
  transitionDuration: const Duration(milliseconds: 300),
  transitionsBuilder: (_, a, __, c) => SlideTransition(
    position: a.drive(Tween(begin: const Offset(1, 0), end: Offset.zero)
        .chain(CurveTween(curve: Curves.easeOutCubic))),
    child: c,
  ),
);
CustomTransitionPage _fadeP(Widget w, GoRouterState s) => CustomTransitionPage(
  key: s.pageKey, child: w,
  transitionDuration: const Duration(milliseconds: 300),
  transitionsBuilder: (_, a, __, c) => FadeTransition(opacity: a, child: c),
);
