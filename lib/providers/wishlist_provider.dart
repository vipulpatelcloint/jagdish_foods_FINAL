import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../data/models/models.dart';

class WishlistProvider extends ChangeNotifier {
  final Set<String> _ids = {};
  final List<Product> _products = [];

  Set<String>    get ids      => Set.unmodifiable(_ids);
  List<Product>  get products => List.unmodifiable(_products);
  int            get count    => _ids.length;
  bool isIn(String id)        => _ids.contains(id);

  Future<void> toggle(Product product) async {
    if (_ids.contains(product.id)) {
      _ids.remove(product.id);
      _products.removeWhere((p) => p.id == product.id);
    } else {
      _ids.add(product.id);
      _products.add(product);
    }
    notifyListeners();
    await _save();
  }

  Future<void> _save() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('wishlist', _ids.toList());
  }

  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getStringList('wishlist') ?? [];
    _ids.addAll(saved);
    _products.addAll(MockData.products.where((p) => _ids.contains(p.id)));
    notifyListeners();
  }
}
