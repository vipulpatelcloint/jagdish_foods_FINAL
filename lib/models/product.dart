class Product {
  final String id;
  final String name;
  final String category;
  final String emoji;
  final int bgColor;
  final double price;
  final double mrp;
  final String weight;
  final String description;
  final double rating;
  final int reviews;
  final bool isBestSeller;
  final bool isNew;

  const Product({
    required this.id,
    required this.name,
    required this.category,
    required this.emoji,
    required this.bgColor,
    required this.price,
    required this.mrp,
    required this.weight,
    required this.description,
    required this.rating,
    required this.reviews,
    this.isBestSeller = false,
    this.isNew = false,
  });

  double get discount => mrp > price ? ((mrp - price) / mrp * 100) : 0;
  bool get hasDiscount => discount > 0;
}

class CartItem {
  final String productId;
  final String name;
  final String emoji;
  final double price;
  final double mrp;
  final String weight;
  int quantity;

  CartItem({
    required this.productId,
    required this.name,
    required this.emoji,
    required this.price,
    required this.mrp,
    required this.weight,
    this.quantity = 1,
  });

  double get total => price * quantity;
}

const List<Product> kProducts = [
  Product(
    id: 'p1',
    name: 'Bhakharwadi Classic',
    category: 'Namkeen',
    emoji: '🥐',
    bgColor: 0xFFFFF3CD,
    price: 180,
    mrp: 220,
    weight: '250g',
    description: 'Our signature Bhakharwadi crafted from a 75-year-old secret recipe. Made from whole wheat flour with aromatic spices, fried to golden perfection.',
    rating: 4.7,
    reviews: 2341,
    isBestSeller: true,
  ),
  Product(
    id: 'p2',
    name: 'Spicy Chevdo Mix',
    category: 'Chevdo',
    emoji: '🌾',
    bgColor: 0xFFD4EDFF,
    price: 220,
    mrp: 250,
    weight: '400g',
    description: 'Premium Gujarati Chevdo with a perfect blend of spices. A classic tea-time snack loved across Gujarat.',
    rating: 4.5,
    reviews: 1820,
    isBestSeller: true,
  ),
  Product(
    id: 'p3',
    name: 'Masala Khakhra',
    category: 'Khakhra',
    emoji: '🫓',
    bgColor: 0xFFFFE0D0,
    price: 145,
    mrp: 170,
    weight: '200g',
    description: 'Thin crispy wheat crackers with aromatic masala seasoning. Low calorie, high taste!',
    rating: 4.6,
    reviews: 1540,
    isNew: true,
  ),
  Product(
    id: 'p4',
    name: 'Mohanthal Premium',
    category: 'Sweets',
    emoji: '🍬',
    bgColor: 0xFFF3E8FF,
    price: 280,
    mrp: 300,
    weight: '250g',
    description: 'Rich gram flour sweet made with pure desi ghee and saffron. A festive delicacy from Gujarat.',
    rating: 4.8,
    reviews: 980,
  ),
  Product(
    id: 'p5',
    name: 'Gathiya Fine Sev',
    category: 'Sev',
    emoji: '🪢',
    bgColor: 0xFFD4F5C4,
    price: 85,
    mrp: 100,
    weight: '200g',
    description: 'Super fine, crispy Gathiya Sev - the essential Gujarati snack for chai time.',
    rating: 4.4,
    reviews: 2100,
    isBestSeller: true,
  ),
  Product(
    id: 'p6',
    name: 'Diwali Gift Hamper',
    category: 'Gift Packs',
    emoji: '🎁',
    bgColor: 0xFFFFF3CD,
    price: 799,
    mrp: 999,
    weight: '1.2 kg',
    description: 'Premium festive gift hamper with 6 assorted snacks. Perfect for gifting this Diwali!',
    rating: 4.9,
    reviews: 450,
  ),
];

const List<Map<String, dynamic>> kCategories = [
  {'id': '1', 'name': 'Namkeen',   'emoji': '🥐', 'color': 0xFFFFF3CD},
  {'id': '2', 'name': 'Chevdo',    'emoji': '🌾', 'color': 0xFFD4EDFF},
  {'id': '3', 'name': 'Sev',       'emoji': '🪢', 'color': 0xFFD4F5C4},
  {'id': '4', 'name': 'Khakhra',   'emoji': '🫓', 'color': 0xFFFFE0D0},
  {'id': '5', 'name': 'Sweets',    'emoji': '🍬', 'color': 0xFFF3E8FF},
  {'id': '6', 'name': 'Gift Packs','emoji': '🎁', 'color': 0xFFFFF3CD},
];

const List<Map<String, String>> kCoupons = [
  {'code': 'SAVE10',    'desc': '10% off on orders above ₹500. Max ₹100.'},
  {'code': 'WELCOME20', 'desc': '20% off for new users. Max ₹100.'},
  {'code': 'FREESHIP',  'desc': 'Free delivery on orders above ₹199.'},
  {'code': 'DIWALI30',  'desc': '30% off on festive packs. Max ₹200.'},
];
