import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'core/routes/app_router.dart';
import 'core/theme/app_theme.dart';
import 'providers/cart_provider.dart';
import 'providers/wishlist_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.light,
  ));

  runApp(const JagdishFoodsApp());
}

class JagdishFoodsApp extends StatelessWidget {
  const JagdishFoodsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CartProvider()..init()),
        ChangeNotifierProvider(create: (_) => WishlistProvider()..init()),
      ],
      child: MaterialApp.router(
        title: 'Jagdish Foods',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        routerConfig: router,
        builder: (ctx, child) => MediaQuery(
          data: MediaQuery.of(ctx).copyWith(
            textScaler: TextScaler.linear(
              MediaQuery.of(ctx).textScaler.scale(1.0).clamp(0.8, 1.2),
            ),
          ),
          child: child!,
        ),
      ),
    );
  }
}
