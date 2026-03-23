import 'package:flutter_test/flutter_test.dart';
import 'package:jagdish_foods/data/models/models.dart';
import 'package:jagdish_foods/providers/cart_provider.dart';

void main() {
  group('CartProvider', () {
    late CartProvider cart;

    setUp(() => cart = CartProvider());

    final item = CartItem(
      productId: 'p1', variantId: 'v1',
      name: 'Bhakharwadi', emoji: '🥐',
      price: 180.0, mrp: 220.0, weight: '250g',
    );

    test('starts empty', () {
      expect(cart.isEmpty, true);
      expect(cart.itemCount, 0);
    });

    test('adds item', () async {
      await cart.add(item);
      expect(cart.itemCount, 1);
      expect(cart.subtotal, 180.0);
    });

    test('increments qty on duplicate add', () async {
      await cart.add(item);
      await cart.add(item);
      expect(cart.items.length, 1);
      expect(cart.items.first.quantity, 2);
      expect(cart.subtotal, 360.0);
    });

    test('removes item', () async {
      await cart.add(item);
      await cart.remove('p1', 'v1');
      expect(cart.isEmpty, true);
    });

    test('free delivery above 299', () async {
      final big = CartItem(productId: 'p2', variantId: 'v2', name: 'Big',
        emoji: '📦', price: 350.0, mrp: 400.0, weight: '1kg');
      await cart.add(big);
      expect(cart.deliveryFee, 0.0);
    });

    test('charges delivery below 299', () async {
      await cart.add(item);
      expect(cart.deliveryFee, 49.0);
    });

    test('clears cart', () async {
      await cart.add(item);
      await cart.clear();
      expect(cart.isEmpty, true);
    });
  });
}
