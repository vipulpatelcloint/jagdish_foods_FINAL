// lib/presentation/screens/profile/profile_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      body: CustomScrollView(slivers: [
        SliverAppBar(
          expandedHeight: 220,
          pinned: true,
          automaticallyImplyLeading: false,
          backgroundColor: AppColors.primary,
          flexibleSpace: FlexibleSpaceBar(
            background: Container(
              decoration: const BoxDecoration(gradient: AppColors.heroGradient),
              child: Stack(children: [
                Positioned(top: -30, right: -30, child: Container(width: 150, height: 150,
                  decoration: BoxDecoration(color: Colors.white.withOpacity(0.05), shape: BoxShape.circle))),
                SafeArea(child: Padding(padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                  child: Column(children: [
                    Row(children: [
                      Container(width: 64, height: 64,
                        decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.white.withOpacity(0.4), width: 2)),
                        child: const Center(child: Text('👤', style: TextStyle(fontSize: 28)))),
                      const SizedBox(width: 14),
                      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        const Text('Rajesh Patel', style: TextStyle(fontFamily: 'Poppins', color: Colors.white, fontSize: 20, fontWeight: FontWeight.w700)),
                        Text('+91 98765 43210', style: TextStyle(fontFamily: 'Poppins', color: Colors.white.withOpacity(0.8), fontSize: 12)),
                        const SizedBox(height: 4),
                        Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(color: AppColors.yellow, borderRadius: BorderRadius.circular(10)),
                          child: const Text('⭐ Gold Member', style: TextStyle(fontFamily: 'Poppins', fontSize: 10, fontWeight: FontWeight.w800, color: AppColors.textDark))),
                      ])),
                      IconButton(onPressed: () {},
                        icon: const Icon(Icons.edit_rounded, color: Colors.white70, size: 20)),
                    ]),
                    const SizedBox(height: 16),
                    Container(decoration: BoxDecoration(color: Colors.white.withOpacity(0.12), borderRadius: BorderRadius.circular(14)),
                      child: Row(children: [
                        _Stat('23', 'Orders'),
                        Container(width: 1, height: 36, color: Colors.white.withOpacity(0.2)),
                        _Stat('4.8', 'Avg Rating'),
                        Container(width: 1, height: 36, color: Colors.white.withOpacity(0.2)),
                        _Stat('₹480', 'Saved'),
                      ])),
                  ])),
                )),
              ]),
            ),
          ),
        ),

        SliverToBoxAdapter(child: Padding(padding: const EdgeInsets.all(16), child: Column(children: [
          _MenuGroup('MY ACCOUNT', [
            _MI('✏️', 'Edit Profile',     AppColors.primaryLight, () => context.push('/edit-profile')),
            _MI('📍', 'Saved Addresses',  AppColors.primaryLight, () => context.push('/addresses')),
            _MI('❤️', 'My Wishlist',      const Color(0xFFFCE4EC), () => context.push('/wishlist'), badge: '12'),
          ]),
          const SizedBox(height: 12),
          _MenuGroup('ORDERS & OFFERS', [
            _MI('📦', 'My Orders',       AppColors.primaryLight, () => context.go('/orders')),
            _MI('🏷️', 'Offers & Coupons', AppColors.yellowLight,  () => context.push('/offers'), badge: '3 Active'),
            _MI('🎁', 'Festive Gift Packs', AppColors.greenLight, () {}),
          ]),
          const SizedBox(height: 12),
          _MenuGroup('SUPPORT', [
            _MI('💬', 'Help & Support',  AppColors.primaryLight, () {}),
            _MI('⭐', 'Rate the App',    AppColors.yellowLight,  () {}),
          ]),
          const SizedBox(height: 12),
          GestureDetector(
            onTap: () => showDialog(context: context, builder: (_) => AlertDialog(
              title: const Text('Logout?', style: TextStyle(fontFamily: 'Poppins')),
              content: const Text('Are you sure you want to logout?', style: TextStyle(fontFamily: 'Poppins')),
              actions: [
                TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
                TextButton(onPressed: () { Navigator.pop(context); context.go('/welcome'); },
                  child: const Text('Logout', style: TextStyle(color: AppColors.error))),
              ],
            )),
            child: Container(padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(color: const Color(0xFFFCE4EC), borderRadius: BorderRadius.circular(12), boxShadow: AppColors.cardShadow),
              child: Row(children: [
                Container(width: 36, height: 36,
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
                  child: const Center(child: Text('🚪', style: TextStyle(fontSize: 18)))),
                const SizedBox(width: 12),
                const Text('Logout', style: TextStyle(fontFamily: 'Poppins', fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFFC62828))),
              ])),
          ),
          const SizedBox(height: 24),
          const Text('Jagdish Foods v1.0.0', style: TextStyle(fontFamily: 'Poppins', fontSize: 12, color: AppColors.textLight)),
          const Text("Vadodara's Taste Since 1945", style: TextStyle(fontFamily: 'Poppins', fontSize: 11, color: AppColors.textHint)),
          const SizedBox(height: 24),
        ]))),
      ]),
    );
  }
}

class _Stat extends StatelessWidget {
  final String value, label;
  const _Stat(this.value, this.label);
  @override Widget build(BuildContext context) => Expanded(child: Padding(
    padding: const EdgeInsets.symmetric(vertical: 12),
    child: Column(children: [
      Text(value, style: const TextStyle(fontFamily: 'Poppins', color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700)),
      Text(label, style: TextStyle(fontFamily: 'Poppins', color: Colors.white.withOpacity(0.7), fontSize: 10)),
    ])));
}

class _MenuGroup extends StatelessWidget {
  final String title; final List<_MI> items;
  const _MenuGroup(this.title, this.items);
  @override Widget build(BuildContext context) => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
    Padding(padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Text(title, style: const TextStyle(fontFamily: 'Poppins', fontSize: 10, fontWeight: FontWeight.w700, color: AppColors.textLight, letterSpacing: 1))),
    Container(decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14), boxShadow: AppColors.cardShadow),
      child: Column(children: items.asMap().entries.map((e) => Column(children: [
        e.value,
        if (e.key < items.length - 1) const Divider(height: 1, indent: 58),
      ])).toList())),
  ]);
}

class _MI extends StatelessWidget {
  final String icon, label; final Color bg; final VoidCallback onTap; final String? badge;
  const _MI(this.icon, this.label, this.bg, this.onTap, {this.badge});
  @override Widget build(BuildContext context) => InkWell(
    onTap: onTap, borderRadius: BorderRadius.circular(14),
    child: Padding(padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      child: Row(children: [
        Container(width: 36, height: 36,
          decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(10)),
          child: Center(child: Text(icon, style: const TextStyle(fontSize: 17)))),
        const SizedBox(width: 12),
        Text(label, style: const TextStyle(fontFamily: 'Poppins', fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textDark)),
        const Spacer(),
        if (badge != null) ...[
          Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(color: AppColors.yellow, borderRadius: BorderRadius.circular(10)),
            child: Text(badge!, style: const TextStyle(fontFamily: 'Poppins', fontSize: 9, fontWeight: FontWeight.w800, color: AppColors.textDark))),
          const SizedBox(width: 4),
        ],
        const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: AppColors.textLight),
      ])));
}
