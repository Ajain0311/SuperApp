import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:super_app/core/theme/app_colors.dart';
import 'package:super_app/core/network/api_client.dart';
import 'package:super_app/core/constants/app_constants.dart';
import 'package:super_app/shared/widgets/app_button.dart';

class OtpVerificationScreen extends ConsumerStatefulWidget {
  final String mobileNumber;
  final bool isNewUser;
  final bool isAdmin;

  const OtpVerificationScreen({
    super.key,
    required this.mobileNumber,
    required this.isNewUser,
    required this.isAdmin,
  });

  @override
  ConsumerState<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends ConsumerState<OtpVerificationScreen> {
  final _otpController = TextEditingController();
  final _nameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  int _timerSeconds = AppConstants.otpTimeoutSeconds;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer?.cancel();
    _timerSeconds = AppConstants.otpTimeoutSeconds;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_timerSeconds > 0) {
        setState(() => _timerSeconds--);
      } else {
        timer.cancel();
      }
    });
  }

  @override
  void dispose() {
    _otpController.dispose();
    _nameController.dispose();
    _passwordController.dispose();
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _verifyOtp() async {
    if (_otpController.text.length != AppConstants.otpLength) {
      _showError('Please enter complete OTP');
      return;
    }

    if (widget.isNewUser && _nameController.text.trim().isEmpty) {
      _showError('Please enter your name');
      return;
    }

    setState(() => _isLoading = true);

    try {
      final apiClient = ref.read(apiClientProvider);
      
      late final dynamic response;
      
      if (widget.isAdmin) {
        // Admin login: password + OTP
        if (_passwordController.text.isEmpty) {
          _showError('Please enter password');
          setState(() => _isLoading = false);
          return;
        }
        response = await apiClient.post(
          '/auth/admin-login',
          data: {
            'mobileNumber': widget.mobileNumber,
            'password': _passwordController.text,
            'otpCode': _otpController.text,
          },
        );
      } else {
        // Normal user: OTP only
        response = await apiClient.post(
          '/auth/verify-otp',
          data: {
            'mobileNumber': widget.mobileNumber,
            'otpCode': _otpController.text,
            if (widget.isNewUser) 'fullName': _nameController.text.trim(),
          },
        );
      }

      if (!mounted) return;

      final data = response.data;
      if (data['success'] == true) {
        // Save token
        await apiClient.setToken(data['token']);
        if (!mounted) return;
        context.go('/home');
      } else {
        _showError(data['message'] ?? 'Verification failed');
      }
    } catch (e) {
      if (!mounted) return;
      _showError('Connection error. Please try again.');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _resendOtp() async {
    try {
      final apiClient = ref.read(apiClientProvider);
      await apiClient.post(
        '/auth/send-otp',
        data: {'mobileNumber': widget.mobileNumber},
      );
      if (!mounted) return;
      _startTimer();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('OTP resent successfully')),
      );
    } catch (e) {
      _showError('Failed to resend OTP');
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  String get _formattedTime {
    final minutes = (_timerSeconds ~/ 60).toString().padLeft(2, '0');
    final seconds = (_timerSeconds % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              Text(
                widget.isAdmin ? 'Admin Login' : 'Verify OTP',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 8),
              RichText(
                text: TextSpan(
                  style: Theme.of(context).textTheme.bodyMedium,
                  children: [
                    const TextSpan(text: 'Enter the OTP sent to '),
                    TextSpan(
                      text: '+91 ${widget.mobileNumber}',
                      style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Dev OTP: ${AppConstants.devOtp}',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.secondary,
                  fontStyle: FontStyle.italic,
                ),
              ),
              const SizedBox(height: 32),
              // Name field for new users
              if (widget.isNewUser) ...[
                TextFormField(
                  controller: _nameController,
                  style: const TextStyle(color: AppColors.textPrimary),
                  decoration: const InputDecoration(
                    hintText: 'Full Name',
                    prefixIcon: Icon(Icons.person_outline, color: AppColors.textSecondary),
                  ),
                ),
                const SizedBox(height: 16),
              ],
              // Password field for admin
              if (widget.isAdmin) ...[
                TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  style: const TextStyle(color: AppColors.textPrimary),
                  decoration: const InputDecoration(
                    hintText: 'Admin Password',
                    prefixIcon: Icon(Icons.lock_outline, color: AppColors.textSecondary),
                  ),
                ),
                const SizedBox(height: 24),
              ],
              // OTP Fields
              PinCodeTextField(
                appContext: context,
                length: AppConstants.otpLength,
                controller: _otpController,
                animationType: AnimationType.fade,
                keyboardType: TextInputType.number,
                textStyle: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
                pinTheme: PinTheme(
                  shape: PinCodeFieldShape.box,
                  borderRadius: BorderRadius.circular(12),
                  fieldHeight: 56,
                  fieldWidth: 48,
                  activeFillColor: AppColors.surfaceLight,
                  inactiveFillColor: AppColors.surfaceLight,
                  selectedFillColor: AppColors.surfaceLight,
                  activeColor: AppColors.primary,
                  inactiveColor: AppColors.border,
                  selectedColor: AppColors.primary,
                ),
                enableActiveFill: true,
                onChanged: (value) {},
                onCompleted: (value) {
                  // Auto-verify on completion
                },
              ),
              const SizedBox(height: 16),
              // Timer & Resend
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (_timerSeconds > 0) ...[
                    Text(
                      'Resend OTP in ',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    Text(
                      _formattedTime,
                      style: const TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ] else
                    TextButton(
                      onPressed: _resendOtp,
                      child: const Text('Resend OTP'),
                    ),
                ],
              ),
              const SizedBox(height: 32),
              AppButton(
                text: 'Verify & Continue',
                onPressed: _verifyOtp,
                isLoading: _isLoading,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
