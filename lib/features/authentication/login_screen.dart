import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/routing/app_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/theme/app_tokens.dart';
import '../../data/repositories/user_repository.dart';
import '../../shared/widgets/app_text_field.dart';
import '../../shared/widgets/artinium_logo.dart';
import '../../shared/widgets/primary_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController(text: 'Praveen');
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  bool _rememberMe = true;
  bool _loading = false;
  String? _error;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _loading = true;
      _error = null;
    });
    final userRepo = context.read<UserRepository>();
    final ok = await userRepo.login(email: _emailCtrl.text, password: _passwordCtrl.text);
    if (!mounted) return;
    setState(() => _loading = false);
    if (ok) {
      Navigator.of(context).pushReplacementNamed(AppRoutes.personalization);
    } else {
      setState(() => _error = 'Enter a valid email and a password of at least 4 characters.');
    }
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.xl),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Center(child: ArtiniumLogo(size: ArtiniumLogoSize.medium)),
                const SizedBox(height: AppSpacing.xl),
                Text('Welcome Back!', style: AppTextStyles.h1(scheme.onSurface), textAlign: TextAlign.center),
                const SizedBox(height: 6),
                Text(
                  'Control your home. Simplify your life.',
                  style: AppTextStyles.body(scheme.onSurface.withOpacity(0.6)),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppSpacing.xl),
                AppTextField(label: 'Full Name', icon: Icons.person_outline, controller: _nameCtrl,
                    validator: (v) => (v == null || v.trim().isEmpty) ? 'Enter your name' : null),
                const SizedBox(height: AppSpacing.md),
                AppTextField(
                  label: 'Email Address',
                  icon: Icons.mail_outline,
                  controller: _emailCtrl,
                  keyboardType: TextInputType.emailAddress,
                  validator: (v) => (v == null || !v.contains('@')) ? 'Enter a valid email' : null,
                ),
                const SizedBox(height: AppSpacing.md),
                AppTextField(
                  label: 'Password',
                  icon: Icons.lock_outline,
                  controller: _passwordCtrl,
                  obscurable: true,
                  validator: (v) => (v == null || v.length < 4) ? 'Minimum 4 characters' : null,
                ),
                const SizedBox(height: AppSpacing.sm),
                Row(
                  children: [
                    Checkbox(
                      value: _rememberMe,
                      activeColor: AppColors.gold,
                      onChanged: (v) => setState(() => _rememberMe = v ?? true),
                    ),
                    Text('Remember Me', style: AppTextStyles.body(scheme.onSurface.withOpacity(0.8))),
                    const Spacer(),
                    TextButton(
                      onPressed: () {},
                      child: const Text('Forgot Password?', style: TextStyle(color: AppColors.gold)),
                    ),
                  ],
                ),
                if (_error != null) ...[
                  const SizedBox(height: AppSpacing.xs),
                  Text(_error!, style: const TextStyle(color: AppColors.error, fontSize: 13)),
                ],
                const SizedBox(height: AppSpacing.sm),
                PrimaryButton(label: 'LOGIN', onPressed: _submit, loading: _loading),
                const SizedBox(height: AppSpacing.md),
                Center(
                  child: RichText(
                    text: TextSpan(
                      style: AppTextStyles.body(scheme.onSurface.withOpacity(0.6)),
                      children: const [
                        TextSpan(text: "Don't have an account? "),
                        TextSpan(text: 'Sign Up', style: TextStyle(color: AppColors.gold, fontWeight: FontWeight.w700)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
