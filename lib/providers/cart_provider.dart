import 'package:flutter/foundation.dart';
import '../models/product.dart';

class CartProvider extends ChangeNotifier {
  final List<CartItem> _items = [];
  String? _couponCode;
  String? _couponError;

  List<CartItem> get items => List.unmodifiable(_items);
  String? get couponCode => _couponCode;
  String? get couponError => _couponError;
  bool get isEmpty => _items.isEmpty;
  int get count => _items.fold(0, (s, i) => s + i.quantity);

  double get subtotal => _items.fold(0, (s, i) => s + i.total);
  double get mrpTotal => _items.fold(0, (s, i) => s + i.mrp * i.quantity);
  double get productSaving => mrpTotal - subtotal;

  double get couponDiscount {
    if (_couponCode == null) return 0;
    switch (_couponCode!) {
      case 'SAVE10':
        return subtotal >= 500 ? (subtotal * 0.1).clamp(0, 100) : 0;
      case 'WELCOME20':
        return (subtotal * 0.2).clamp(0, 100);
      case 'FREESHIP':
        return subtotal >= 199 ? 49 : 0;
      case 'DIWALI30':
        return subtotal >= 599 ? (subtotal * 0.3).clamp(0, 200) : 0;
      default:
        return 0;
    }
  }

  double get delivery => (subtotal >= 299 || _couponCode == 'FREESHIP') ? 0 : 49;
  double get total => subtotal - couponDiscount + delivery;
  double get totalSaving => productSaving + couponDiscount + (subtotal >= 299 ? 49 : 0);
  double get toFreeDelivery => (299 - subtotal).clamp(0, 299);

  bool contains(String id) => _items.any((i) => i.productId == id);
  int qtyOf(String id) {
    final idx = _items.indexWhere((i) => i.productId == id);
    return idx >= 0 ? _items[idx].quantity : 0;
  }

  void add(Product p) {
    final idx = _items.indexWhere((i) => i.productId == p.id);
    if (idx >= 0) {
      if (_items[idx].quantity < 10) _items[idx].quantity++;
    } else {
      _items.add(CartItem(
        productId: p.id,
        name: p.name,
        emoji: p.emoji,
        price: p.price,
        mrp: p.mrp,
        weight: p.weight,
      ));
    }
    notifyListeners();
  }

  void increment(String id) {
    final idx = _items.indexWhere((i) => i.productId == id);
    if (idx >= 0 && _items[idx].quantity < 10) {
      _items[idx].quantity++;
      notifyListeners();
    }
  }

  void decrement(String id) {
    final idx = _items.indexWhere((i) => i.productId == id);
    if (idx >= 0) {
      if (_items[idx].quantity > 1) {
        _items[idx].quantity--;
      } else {
        _items.removeAt(idx);
      }
      notifyListeners();
    }
  }

  void remove(String id) {
    _items.removeWhere((i) => i.productId == id);
    notifyListeners();
  }

  bool applyCoupon(String code) {
    final upper = code.toUpperCase().trim();
    final valid = ['SAVE10', 'WELCOME20', 'FREESHIP', 'DIWALI30'];
    if (!valid.contains(upper)) {
      _couponError = 'Invalid or expired coupon code';
      notifyListeners();
      return false;
    }
    _couponCode = upper;
    _couponError = null;
    notifyListeners();
    return true;
  }

  void removeCoupon() {
    _couponCode = null;
    _couponError = null;
    notifyListeners();
  }

  void clearError() {
    _couponError = null;
    notifyListeners();
  }

  void clear() {
    _items.clear();
    _couponCode = null;
    _couponError = null;
    notifyListeners();
  }
}
