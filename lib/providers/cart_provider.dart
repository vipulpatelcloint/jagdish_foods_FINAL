import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../data/models/models.dart';
import '../core/constants/app_constants.dart';

class CartProvider extends ChangeNotifier {
  final List<CartItem> _items = [];
  Coupon? _coupon;
  bool _loading = false;
  String? _error;

  List<CartItem> get items      => List.unmodifiable(_items);
  Coupon?        get coupon     => _coupon;
  bool           get isLoading  => _loading;
  String?        get error      => _error;
  bool           get isEmpty    => _items.isEmpty;
  int            get itemCount  => _items.fold(0, (s, i) => s + i.quantity);

  double get subtotal       => _items.fold(0, (s, i) => s + i.total);
  double get mrpTotal       => _items.fold(0, (s, i) => s + i.mrpTotal);
  double get productSaving  => mrpTotal - subtotal;
  double get couponSaving   => _coupon?.discount(subtotal) ?? 0;
  double get deliveryFee    => (subtotal >= AppConstants.freeDeliveryAt || _coupon?.type == CouponType.freeShip) ? 0 : AppConstants.deliveryFee;
  double get totalSaving    => productSaving + couponSaving + (subtotal >= AppConstants.freeDeliveryAt ? AppConstants.deliveryFee : 0);
  double get finalTotal     => subtotal - couponSaving + deliveryFee;
  double get toFreeDelivery => (AppConstants.freeDeliveryAt - subtotal).clamp(0, AppConstants.freeDeliveryAt);

  Future<void> init() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final json  = prefs.getString(AppConstants.kCartBox);
      if (json != null) {
        final list = jsonDecode(json) as List;
        _items.addAll(list.map((e) => CartItem.fromJson(e as Map<String, dynamic>)));
        notifyListeners();
      }
    } catch (_) {}
  }

  Future<void> _save() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(AppConstants.kCartBox, jsonEncode(_items.map((e) => e.toJson()).toList()));
    } catch (_) {}
  }

  bool contains(String productId, String variantId) =>
      _items.any((i) => i.productId == productId && i.variantId == variantId);

  int qtyOf(String productId, String variantId) =>
      _items.firstWhere((i) => i.productId == productId && i.variantId == variantId,
          orElse: () => CartItem(productId: '', variantId: '', name: '', emoji: '', price: 0, mrp: 0, weight: '')).quantity;

  Future<void> add(CartItem item) async {
    final idx = _items.indexWhere((i) => i.productId == item.productId && i.variantId == item.variantId);
    if (idx >= 0) {
      if (_items[idx].quantity < AppConstants.maxCartQty) {
        _items[idx] = _items[idx].copyWith(quantity: _items[idx].quantity + 1);
      }
    } else {
      _items.add(item);
    }
    notifyListeners();
    await _save();
  }

  Future<void> remove(String productId, String variantId) async {
    _items.removeWhere((i) => i.productId == productId && i.variantId == variantId);
    notifyListeners();
    await _save();
  }

  Future<void> setQty(String productId, String variantId, int qty) async {
    if (qty <= 0) { await remove(productId, variantId); return; }
    final idx = _items.indexWhere((i) => i.productId == productId && i.variantId == variantId);
    if (idx >= 0) {
      _items[idx] = _items[idx].copyWith(quantity: qty.clamp(1, AppConstants.maxCartQty));
      notifyListeners();
      await _save();
    }
  }

  Future<bool> applyCoupon(String code) async {
    _loading = true; _error = null; notifyListeners();
    await Future.delayed(const Duration(milliseconds: 800));
    _loading = false;
    final found = MockData.coupons.cast<Coupon?>().firstWhere(
      (c) => c!.code == code.toUpperCase(), orElse: () => null);
    if (found == null) {
      _error = 'Invalid or expired coupon code';
      notifyListeners(); return false;
    }
    if (subtotal < found.minOrder) {
      _error = 'Min order ₹${found.minOrder.toInt()} required';
      notifyListeners(); return false;
    }
    _coupon = found; notifyListeners(); return true;
  }

  void removeCoupon() { _coupon = null; _error = null; notifyListeners(); }
  void clearError()   { _error = null; notifyListeners(); }

  Future<void> clear() async {
    _items.clear(); _coupon = null; notifyListeners(); await _save();
  }
}
