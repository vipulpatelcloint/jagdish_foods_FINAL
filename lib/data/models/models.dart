// ─── Product ──────────────────────────────────────────────────────────────
class Product {
  final String id, name, description, categoryId, categoryName;
  final List<ProductVariant> variants;
  final double rating;
  final int reviewCount;
  final bool isVeg, isBestSeller, isNew;
  final List<String> ingredients;
  final String shelfLife;

  const Product({
    required this.id,
    required this.name,
    required this.description,
    required this.categoryId,
    required this.categoryName,
    required this.variants,
    this.rating = 4.5,
    this.reviewCount = 0,
    this.isVeg = true,
    this.isBestSeller = false,
    this.isNew = false,
    this.ingredients = const [],
    this.shelfLife = '45 days',
  });

  ProductVariant get defaultVariant => variants.first;
  double get minPrice => variants.map((v) => v.price).reduce((a, b) => a < b ? a : b);
}

class ProductVariant {
  final String id, weight;
  final double mrp, price;
  final int stock;

  const ProductVariant({
    required this.id,
    required this.weight,
    required this.mrp,
    required this.price,
    this.stock = 100,
  });

  double get discountPct => mrp > price ? ((mrp - price) / mrp) * 100 : 0;
  bool get hasDiscount => discountPct > 0;
  int get discountInt => discountPct.toInt();
}

// ─── Cart ─────────────────────────────────────────────────────────────────
class CartItem {
  final String productId, variantId, name, emoji, weight;
  final double price, mrp;
  int quantity;

  CartItem({
    required this.productId,
    required this.variantId,
    required this.name,
    required this.emoji,
    required this.price,
    required this.mrp,
    required this.weight,
    this.quantity = 1,
  });

  double get total    => price * quantity;
  double get mrpTotal => mrp * quantity;
  double get saving   => mrpTotal - total;

  CartItem copyWith({int? quantity}) => CartItem(
    productId: productId, variantId: variantId,
    name: name, emoji: emoji, price: price, mrp: mrp,
    weight: weight, quantity: quantity ?? this.quantity,
  );

  Map<String, dynamic> toJson() => {
    'productId': productId, 'variantId': variantId,
    'name': name, 'emoji': emoji,
    'price': price, 'mrp': mrp,
    'weight': weight, 'quantity': quantity,
  };

  factory CartItem.fromJson(Map<String, dynamic> j) => CartItem(
    productId: j['productId'], variantId: j['variantId'],
    name: j['name'], emoji: j['emoji'] ?? '🥐',
    price: (j['price'] as num).toDouble(),
    mrp: (j['mrp'] as num).toDouble(),
    weight: j['weight'], quantity: j['quantity'] ?? 1,
  );
}

// ─── Address ──────────────────────────────────────────────────────────────
class Address {
  final String id, label, name, phone, line1, city, state, pincode;
  final bool isDefault;

  const Address({
    required this.id, required this.label, required this.name,
    required this.phone, required this.line1, required this.city,
    required this.state, required this.pincode, this.isDefault = false,
  });

  String get full => '$line1, $city, $state – $pincode';
}

// ─── Coupon ───────────────────────────────────────────────────────────────
class Coupon {
  final String id, code, title, description;
  final double value, minOrder;
  final double? maxDiscount;
  final CouponType type;
  final DateTime validTill;

  const Coupon({
    required this.id, required this.code, required this.title,
    required this.description, required this.value,
    required this.type, this.minOrder = 0, this.maxDiscount,
    required this.validTill,
  });

  double discount(double amount) {
    if (amount < minOrder) return 0;
    switch (type) {
      case CouponType.percent:
        final d = amount * value / 100;
        return maxDiscount != null ? d.clamp(0, maxDiscount!) : d;
      case CouponType.flat:
        return value.clamp(0, amount);
      case CouponType.freeShip:
        return 49.0;
    }
  }
}

enum CouponType { percent, flat, freeShip }

// ─── Order ────────────────────────────────────────────────────────────────
class Order {
  final String id, number, paymentMethod;
  final List<CartItem> items;
  final Address address;
  final double total;
  final OrderStatus status;
  final DateTime createdAt;

  const Order({
    required this.id, required this.number, required this.paymentMethod,
    required this.items, required this.address, required this.total,
    required this.status, required this.createdAt,
  });
}

enum OrderStatus { placed, confirmed, packing, outForDelivery, delivered, cancelled }

extension OrderStatusLabel on OrderStatus {
  String get label {
    switch (this) {
      case OrderStatus.placed:         return 'Order Placed';
      case OrderStatus.confirmed:      return 'Confirmed';
      case OrderStatus.packing:        return 'Being Packed';
      case OrderStatus.outForDelivery: return 'Out for Delivery';
      case OrderStatus.delivered:      return 'Delivered';
      case OrderStatus.cancelled:      return 'Cancelled';
    }
  }
  String get emoji {
    switch (this) {
      case OrderStatus.placed:         return '📋';
      case OrderStatus.confirmed:      return '✅';
      case OrderStatus.packing:        return '📦';
      case OrderStatus.outForDelivery: return '🛵';
      case OrderStatus.delivered:      return '🏠';
      case OrderStatus.cancelled:      return '❌';
    }
  }
}

// ─── Mock Data ────────────────────────────────────────────────────────────
class MockData {
  static final List<Product> products = [
    const Product(
      id: 'p1', name: 'Bhakharwadi Classic', categoryId: '1', categoryName: 'Bhakharwadi',
      description: 'Our signature Bhakharwadi crafted from a 75-year-old secret recipe. Made from whole wheat flour with aromatic spices, fried to golden perfection.',
      variants: [
        ProductVariant(id: 'v1a', weight: '100g', mrp: 90,  price: 75,  stock: 50),
        ProductVariant(id: 'v1b', weight: '250g', mrp: 220, price: 180, stock: 100),
        ProductVariant(id: 'v1c', weight: '500g', mrp: 420, price: 350, stock: 80),
        ProductVariant(id: 'v1d', weight: '1 kg', mrp: 820, price: 680, stock: 40),
      ],
      rating: 4.7, reviewCount: 2341, isVeg: true, isBestSeller: true,
      ingredients: ['Whole wheat flour', 'Refined oil', 'Spices', 'Salt', 'Sesame seeds'],
    ),
    const Product(
      id: 'p2', name: 'Spicy Chevdo Mix', categoryId: '2', categoryName: 'Chevdo',
      description: 'Premium Gujarati Chevdo with a perfect blend of spices. A classic tea-time snack loved across Gujarat.',
      variants: [
        ProductVariant(id: 'v2a', weight: '200g', mrp: 130, price: 110, stock: 60),
        ProductVariant(id: 'v2b', weight: '400g', mrp: 250, price: 220, stock: 90),
      ],
      rating: 4.5, reviewCount: 1820, isVeg: true, isBestSeller: true,
      ingredients: ['Poha', 'Groundnuts', 'Spices', 'Curry leaves', 'Oil'],
    ),
    const Product(
      id: 'p3', name: 'Masala Khakhra', categoryId: '4', categoryName: 'Khakhra',
      description: 'Thin crispy wheat crackers with aromatic masala seasoning. Low calorie, high taste!',
      variants: [
        ProductVariant(id: 'v3a', weight: '200g', mrp: 170, price: 145, stock: 70),
        ProductVariant(id: 'v3b', weight: '400g', mrp: 330, price: 280, stock: 50),
      ],
      rating: 4.6, reviewCount: 1540, isVeg: true, isNew: true,
      ingredients: ['Wheat flour', 'Oil', 'Salt', 'Masala spices'],
    ),
    const Product(
      id: 'p4', name: 'Mohanthal Premium', categoryId: '5', categoryName: 'Sweets',
      description: 'Rich gram flour sweet made with pure desi ghee and saffron. A festive delicacy from Gujarat.',
      variants: [
        ProductVariant(id: 'v4a', weight: '250g', mrp: 300, price: 280, stock: 30),
        ProductVariant(id: 'v4b', weight: '500g', mrp: 580, price: 540, stock: 20),
      ],
      rating: 4.8, reviewCount: 980, isVeg: true,
      ingredients: ['Gram flour', 'Pure ghee', 'Sugar', 'Saffron', 'Cardamom'],
    ),
    const Product(
      id: 'p5', name: 'Gathiya Fine Sev', categoryId: '3', categoryName: 'Sev',
      description: 'Super fine, crispy Gathiya Sev - the essential Gujarati snack for chai time.',
      variants: [
        ProductVariant(id: 'v5a', weight: '200g', mrp: 100, price: 85,  stock: 120),
        ProductVariant(id: 'v5b', weight: '500g', mrp: 240, price: 200, stock: 80),
      ],
      rating: 4.4, reviewCount: 2100, isVeg: true, isBestSeller: true,
      ingredients: ['Chickpea flour', 'Oil', 'Salt', 'Carom seeds'],
    ),
    const Product(
      id: 'p6', name: 'Diwali Gift Hamper', categoryId: '6', categoryName: 'Gift Packs',
      description: 'Premium festive gift hamper with 6 assorted snacks. Perfect for gifting!',
      variants: [
        ProductVariant(id: 'v6a', weight: '1.2 kg', mrp: 999, price: 799, stock: 25),
        ProductVariant(id: 'v6b', weight: '2.5 kg', mrp: 1999, price: 1599, stock: 10),
      ],
      rating: 4.9, reviewCount: 450, isVeg: true,
      ingredients: ['Bhakharwadi', 'Chevdo', 'Sev', 'Khakhra', 'Mohanthal', 'Packaging'],
    ),
  ];

  static final List<Address> addresses = const [
    Address(id: 'a1', label: 'Home', name: 'Rajesh Patel',
      phone: '+91 98765 43210', line1: '12, Shyamal Society, Alkapuri',
      city: 'Vadodara', state: 'Gujarat', pincode: '390007', isDefault: true),
    Address(id: 'a2', label: 'Work', name: 'Rajesh Patel',
      phone: '+91 98765 43210', line1: 'Plot 45, GIDC, Makarpura',
      city: 'Vadodara', state: 'Gujarat', pincode: '390010'),
  ];

  static final List<Coupon> coupons = [
    Coupon(id: 'c1', code: 'SAVE10', title: '10% Off',
      description: '10% off on orders above ₹500. Max discount ₹100.',
      type: CouponType.percent, value: 10, minOrder: 500, maxDiscount: 100,
      validTill: DateTime(2026, 12, 31)),
    Coupon(id: 'c2', code: 'WELCOME20', title: '20% Off',
      description: 'Welcome offer! 20% off, max ₹100.',
      type: CouponType.percent, value: 20, maxDiscount: 100,
      validTill: DateTime(2026, 12, 31)),
    Coupon(id: 'c3', code: 'FREESHIP', title: 'Free Delivery',
      description: 'Free delivery on orders above ₹199.',
      type: CouponType.freeShip, value: 49, minOrder: 199,
      validTill: DateTime(2026, 12, 31)),
    Coupon(id: 'c4', code: 'DIWALI30', title: '30% Off',
      description: 'Diwali special! 30% off, max ₹200.',
      type: CouponType.percent, value: 30, minOrder: 599, maxDiscount: 200,
      validTill: DateTime(2026, 11, 1)),
  ];

  static const Map<String, String> productEmojis = {
    '1': '🥐', '2': '🌾', '3': '🪢', '4': '🫓', '5': '🍬', '6': '🎁',
  };

  static const Map<String, int> productBgColors = {
    '1': 0xFFFFF3CD, '2': 0xFFD4EDFF, '3': 0xFFD4F5C4,
    '4': 0xFFFFE0D0, '5': 0xFFF3E8FF, '6': 0xFFFFF3CD,
  };
}
