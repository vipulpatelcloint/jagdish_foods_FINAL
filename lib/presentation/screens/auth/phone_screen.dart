// lib/presentation/screens/auth/phone_screen.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';

class PhoneScreen extends StatefulWidget {
  const PhoneScreen({super.key});
  @override State<PhoneScreen> createState() => _PhoneScreenState();
}
class _PhoneScreenState extends State<PhoneScreen> {
  final _phoneCtrl = TextEditingController();
  final _formKey   = GlobalKey<FormState>();
  bool _loading    = false;
  bool _showOtp    = false;
  final _otpCtrls  = List.generate(6, (_) => TextEditingController());
  final _foci      = List.generate(6, (_) => FocusNode());
  int _countdown   = 30;

  @override void dispose() {
    _phoneCtrl.dispose();
    for (final c in _otpCtrls) c.dispose();
    for (final f in _foci) f.dispose();
    super.dispose();
  }

  void _startCountdown() async {
    setState(() => _countdown = 30);
    while (_countdown > 0 && mounted) {
      await Future.delayed(const Duration(seconds: 1));
      if (mounted) setState(() => _countdown--);
    }
  }

  Future<void> _sendOtp() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);
    await Future.delayed(const Duration(seconds: 1));
    if (mounted) { setState(() { _loading = false; _showOtp = true; }); _startCountdown(); }
  }

  Future<void> _verify() async {
    final otp = _otpCtrls.map((c) => c.text).join();
    if (otp.length != 6) return;
    setState(() => _loading = true);
    await Future.delayed(const Duration(seconds: 1));
    if (mounted) context.go('/home');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_showOtp ? 'Verify OTP' : 'Enter Phone Number')),
      body: SafeArea(child: Padding(
        padding: const EdgeInsets.all(24),
        child: _showOtp ? _buildOtpView() : _buildPhoneView(),
      )),
    );
  }

  Widget _buildPhoneView() => Form(
    key: _formKey,
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const SizedBox(height: 16),
      const Text("What's your number?",
        style: TextStyle(fontFamily: 'Poppins', fontSize: 22, fontWeight: FontWeight.w700, color: AppColors.textDark)),
      const SizedBox(height: 8),
      const Text("We'll send a one-time password to verify.",
        style: TextStyle(fontFamily: 'Poppins', fontSize: 13, color: AppColors.textMedium)),
      const SizedBox(height: 32),
      Container(
        decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.border), boxShadow: AppColors.cardShadow),
        child: Row(children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Row(children: [
              Text('🇮🇳', style: TextStyle(fontSize: 20)),
              SizedBox(width: 6),
              Text('+91', style: TextStyle(fontFamily: 'Poppins', fontSize: 15, fontWeight: FontWeight.w600, color: AppColors.textDark)),
            ]),
          ),
          Container(width: 1, height: 28, color: AppColors.border),
          Expanded(child: TextFormField(
            controller: _phoneCtrl,
            keyboardType: TextInputType.phone,
            maxLength: 10,
            style: const TextStyle(fontFamily: 'Poppins', fontSize: 15, fontWeight: FontWeight.w600),
            decoration: const InputDecoration(
              hintText: '98765 43210', counterText: '',
              border: InputBorder.none, enabledBorder: InputBorder.none, focusedBorder: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            ),
            validator: (v) => (v == null || v.length != 10) ? 'Enter valid 10-digit number' : null,
          )),
        ]),
      ),
      const SizedBox(height: 24),
      ElevatedButton(
        onPressed: _loading ? null : _sendOtp,
        child: _loading ? const SizedBox(width: 20, height: 20,
          child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
          : const Text('Send OTP'),
      ),
    ]),
  );

  Widget _buildOtpView() => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
    const SizedBox(height: 16),
    const Text('Enter OTP',
      style: TextStyle(fontFamily: 'Poppins', fontSize: 22, fontWeight: FontWeight.w700, color: AppColors.textDark)),
    const SizedBox(height: 8),
    RichText(text: TextSpan(style: const TextStyle(fontFamily: 'Poppins', fontSize: 13, color: AppColors.textMedium), children: [
      const TextSpan(text: 'Sent to +91 '),
      TextSpan(text: _phoneCtrl.text,
        style: const TextStyle(color: AppColors.textDark, fontWeight: FontWeight.w700)),
    ])),
    const SizedBox(height: 40),
    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: List.generate(6, (i) =>
      SizedBox(width: 46, height: 56, child: TextField(
        controller: _otpCtrls[i],
        focusNode: _foci[i],
        keyboardType: TextInputType.number,
        maxLength: 1,
        textAlign: TextAlign.center,
        style: const TextStyle(fontFamily: 'Poppins', fontSize: 22, fontWeight: FontWeight.w700),
        decoration: InputDecoration(
          counterText: '',
          filled: true, fillColor: Colors.white,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.border)),
          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.primary, width: 2)),
        ),
        onChanged: (v) {
          if (v.isNotEmpty && i < 5) _foci[i + 1].requestFocus();
          else if (v.isEmpty && i > 0) _foci[i - 1].requestFocus();
          if (_otpCtrls.map((c) => c.text).join().length == 6) _verify();
        },
      )),
    )),
    const SizedBox(height: 32),
    ElevatedButton(
      onPressed: _loading ? null : _verify,
      child: _loading ? const SizedBox(width: 20, height: 20,
        child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
        : const Text('Verify & Continue'),
    ),
    const SizedBox(height: 16),
    Center(child: _countdown > 0
      ? Text('Resend OTP in ${_countdown}s',
          style: const TextStyle(fontFamily: 'Poppins', fontSize: 13, color: AppColors.textMedium))
      : TextButton(onPressed: () { _startCountdown(); },
          child: const Text('Resend OTP'))),
  ]);
}
