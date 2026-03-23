// lib/presentation/screens/profile/address_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/constants/app_colors.dart';
import '../../../data/models/models.dart';

class AddressScreen extends StatefulWidget {
  const AddressScreen({super.key});
  @override State<AddressScreen> createState() => _AddressScreenState();
}

class _AddressScreenState extends State<AddressScreen> {
  int _selected = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      appBar: AppBar(title: const Text('My Addresses')),
      body: Column(children: [
        Expanded(child: ListView(padding: const EdgeInsets.all(16), children: [
          ...MockData.addresses.asMap().entries.map((e) {
            final i   = e.key;
            final a   = e.value;
            final sel = i == _selected;
            return GestureDetector(
              onTap: () => setState(() => _selected = i),
              child: Container(
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: sel ? AppColors.primaryLight : Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: sel ? AppColors.primary : AppColors.border, width: sel ? 2 : 1),
                  boxShadow: AppColors.cardShadow,
                ),
                child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Container(
                    width: 20, height: 20,
                    margin: const EdgeInsets.only(top: 2),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: sel ? AppColors.primary : AppColors.textLight, width: 2),
                    ),
                    child: sel ? Center(child: Container(width: 10, height: 10,
                        decoration: const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle))) : null,
                  ),
                  const SizedBox(width: 12),
                  Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Row(children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
                        decoration: BoxDecoration(
                          color: sel ? AppColors.primary : AppColors.textLight,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Text(a.label.toUpperCase(),
                            style: const TextStyle(fontFamily: 'Poppins', fontSize: 9, fontWeight: FontWeight.w800, color: Colors.white)),
                      ),
                      if (a.isDefault) ...[
                        const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                          decoration: BoxDecoration(color: AppColors.greenLight, borderRadius: BorderRadius.circular(5)),
                          child: const Text('DEFAULT', style: TextStyle(fontFamily: 'Poppins', fontSize: 9, fontWeight: FontWeight.w700, color: AppColors.greenDeep)),
                        ),
                      ],
                    ]),
                    const SizedBox(height: 6),
                    Text(a.name, style: const TextStyle(fontFamily: 'Poppins', fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textDark)),
                    const SizedBox(height: 2),
                    Text(a.full, style: const TextStyle(fontFamily: 'Poppins', fontSize: 12, color: AppColors.textMedium, height: 1.4)),
                    const SizedBox(height: 4),
                    Text(a.phone, style: const TextStyle(fontFamily: 'Poppins', fontSize: 12, color: AppColors.textLight)),
                  ])),
                  Column(children: [
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.edit_rounded, color: AppColors.primary, size: 20),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                    ),
                    IconButton(
                      onPressed: () => showDialog(context: context, builder: (_) => AlertDialog(
                        title: const Text('Delete Address?', style: TextStyle(fontFamily: 'Poppins')),
                        content: const Text('Are you sure you want to delete this address?', style: TextStyle(fontFamily: 'Poppins')),
                        actions: [
                          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
                          TextButton(onPressed: () => Navigator.pop(context),
                              child: const Text('Delete', style: TextStyle(color: AppColors.error))),
                        ],
                      )),
                      icon: const Icon(Icons.delete_outline_rounded, color: AppColors.error, size: 20),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                    ),
                  ]),
                ]),
              ).animate().fadeIn(delay: (i * 100).ms).slideY(begin: 0.1),
            );
          }),

          // Add new address card
          GestureDetector(
            onTap: () => _showAddAddressSheet(context),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.primary.withOpacity(0.4), width: 1.5, style: BorderStyle.solid),
                boxShadow: AppColors.cardShadow,
              ),
              child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Container(width: 32, height: 32,
                  decoration: BoxDecoration(color: AppColors.primaryLight, shape: BoxShape.circle),
                  child: const Icon(Icons.add_rounded, color: AppColors.primary, size: 20)),
                const SizedBox(width: 10),
                const Text('Add New Address',
                    style: TextStyle(fontFamily: 'Poppins', fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.primary)),
              ]),
            ).animate().fadeIn(delay: 300.ms),
          ),
        ])),

        // Bottom confirm button
        Container(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 28),
          decoration: BoxDecoration(color: Colors.white,
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 16, offset: const Offset(0, -4))]),
          child: ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 52)),
            child: const Text('Confirm Address'),
          ),
        ),
      ]),
    );
  }

  void _showAddAddressSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: const _AddAddressForm(),
      ),
    );
  }
}

class _AddAddressForm extends StatelessWidget {
  const _AddAddressForm();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          const Text('Add New Address', style: TextStyle(fontFamily: 'Poppins', fontSize: 18, fontWeight: FontWeight.w700)),
          const Spacer(),
          IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.close_rounded)),
        ]),
        const SizedBox(height: 16),
        _Field(hint: 'Full Name', icon: Icons.person_outline_rounded),
        const SizedBox(height: 10),
        _Field(hint: 'Phone Number', icon: Icons.phone_outlined, inputType: TextInputType.phone),
        const SizedBox(height: 10),
        _Field(hint: 'Address Line 1', icon: Icons.location_on_outlined),
        const SizedBox(height: 10),
        Row(children: [
          Expanded(child: _Field(hint: 'City', icon: Icons.location_city_outlined)),
          const SizedBox(width: 10),
          Expanded(child: _Field(hint: 'Pincode', icon: Icons.pin_drop_outlined, inputType: TextInputType.number)),
        ]),
        const SizedBox(height: 10),
        Row(children: [
          _LabelChip('🏠 Home'),
          const SizedBox(width: 8),
          _LabelChip('💼 Work'),
          const SizedBox(width: 8),
          _LabelChip('📍 Other'),
        ]),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: () => Navigator.pop(context),
          style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 50)),
          child: const Text('Save Address'),
        ),
        const SizedBox(height: 8),
      ]),
    );
  }
}

class _Field extends StatelessWidget {
  final String hint;
  final IconData icon;
  final TextInputType inputType;
  const _Field({required this.hint, required this.icon, this.inputType = TextInputType.text});

  @override
  Widget build(BuildContext context) => TextField(
    keyboardType: inputType,
    decoration: InputDecoration(
      hintText: hint,
      prefixIcon: Icon(icon, color: AppColors.textLight, size: 20),
    ),
  );
}

class _LabelChip extends StatefulWidget {
  final String label;
  const _LabelChip(this.label);
  @override State<_LabelChip> createState() => _LabelChipState();
}
class _LabelChipState extends State<_LabelChip> {
  bool _sel = false;
  @override Widget build(BuildContext context) => GestureDetector(
    onTap: () => setState(() => _sel = !_sel),
    child: AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: _sel ? AppColors.primaryLight : Colors.white,
        border: Border.all(color: _sel ? AppColors.primary : AppColors.border, width: _sel ? 2 : 1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(widget.label, style: TextStyle(fontFamily: 'Poppins', fontSize: 12, fontWeight: FontWeight.w600,
          color: _sel ? AppColors.primary : AppColors.textMedium)),
    ),
  );
}
