import 'package:flutter/material.dart';
import '../../core/theme/app_tokens.dart';

class AppTextField extends StatefulWidget {
  final String label;
  final IconData icon;
  final bool obscurable;
  final TextEditingController controller;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;

  const AppTextField({
    super.key,
    required this.label,
    required this.icon,
    required this.controller,
    this.obscurable = false,
    this.keyboardType,
    this.validator,
  });

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  bool _obscured = true;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(widget.label, style: TextStyle(color: scheme.onSurface.withOpacity(0.7), fontSize: 13)),
        const SizedBox(height: AppSpacing.xs),
        TextFormField(
          controller: widget.controller,
          obscureText: widget.obscurable && _obscured,
          keyboardType: widget.keyboardType,
          validator: widget.validator,
          style: TextStyle(color: scheme.onSurface),
          decoration: InputDecoration(
            prefixIcon: Icon(widget.icon, size: AppSizes.iconMd - 4, color: scheme.onSurface.withOpacity(0.6)),
            suffixIcon: widget.obscurable
                ? IconButton(
                    icon: Icon(
                      _obscured ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                      color: scheme.onSurface.withOpacity(0.6),
                    ),
                    onPressed: () => setState(() => _obscured = !_obscured),
                  )
                : null,
          ),
        ),
      ],
    );
  }
}
