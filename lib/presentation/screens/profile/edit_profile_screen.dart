// lib/presentation/screens/profile/edit_profile_screen.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});
  @override State<EditProfileScreen> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfileScreen> {
  final _nameCtrl  = TextEditingController(text: 'Rajesh Patel');
  final _emailCtrl = TextEditingController(text: 'rajesh@example.com');
  final _phoneCtrl = TextEditingController(text: '+91 98765 43210');
  bool _saving = false;

  @override void dispose() {
    _nameCtrl.dispose(); _emailCtrl.dispose(); _phoneCtrl.dispose(); super.dispose();
  }

  Future<void> _save() async {
    setState(() => _saving = true);
    await Future.delayed(const Duration(milliseconds: 800));
    if (!mounted) return;
    setState(() => _saving = false);
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('Profile updated successfully!'),
      backgroundColor: AppColors.green,
      behavior: SnackBarBehavior.floating,
    ));
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      appBar: AppBar(title: const Text('Edit Profile')),
      body: ListView(padding: const EdgeInsets.all(20), children: [
        // Avatar
        Center(child: Stack(children: [
          Container(
            width: 90, height: 90,
            decoration: BoxDecoration(
              color: AppColors.primaryLight,
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.primary, width: 2),
            ),
            child: const Center(child: Text('👤', style: TextStyle(fontSize: 40))),
          ),
          Positioned(bottom: 0, right: 0, child: Container(
            width: 28, height: 28,
            decoration: BoxDecoration(
              color: AppColors.primary, shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 2),
            ),
            child: const Icon(Icons.camera_alt_rounded, color: Colors.white, size: 14),
          )),
        ])),
        const SizedBox(height: 8),
        const Center(child: Text('Tap to change photo',
            style: TextStyle(fontFamily: 'Poppins', fontSize: 12, color: AppColors.textLight))),
        const SizedBox(height: 28),

        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(16),
            boxShadow: AppColors.cardShadow,
          ),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Text('Personal Information',
                style: TextStyle(fontFamily: 'Poppins', fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.textDark)),
            const SizedBox(height: 16),

            _Label('Full Name'),
            TextField(controller: _nameCtrl, decoration: const InputDecoration(prefixIcon: Icon(Icons.person_outline_rounded))),
            const SizedBox(height: 14),

            _Label('Email Address'),
            TextField(controller: _emailCtrl, keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(prefixIcon: Icon(Icons.email_outlined))),
            const SizedBox(height: 14),

            _Label('Phone Number'),
            TextField(
              controller: _phoneCtrl,
              readOnly: true,
              style: const TextStyle(color: AppColors.textLight),
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.phone_outlined),
                suffixIcon: Icon(Icons.lock_outline_rounded, size: 16, color: AppColors.textLight),
              ),
            ),
            const SizedBox(height: 4),
            const Text('Phone number cannot be changed',
                style: TextStyle(fontFamily: 'Poppins', fontSize: 11, color: AppColors.textLight)),
          ]),
        ),
        const SizedBox(height: 28),

        ElevatedButton(
          onPressed: _saving ? null : _save,
          style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 52)),
          child: _saving
              ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
              : const Text('Save Changes'),
        ),
      ]),
    );
  }
}

class _Label extends StatelessWidget {
  final String text;
  const _Label(this.text);
  @override Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 6),
    child: Text(text, style: const TextStyle(fontFamily: 'Poppins', fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.textMedium)),
  );
}
