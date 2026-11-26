import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';

class AuthTextField extends StatefulWidget {
  final String label;
  final String? hint;
  final TextEditingController controller;
  final IconData? prefixIcon;
  final bool isPassword;
  final TextInputType keyboardType;
  final String? errorText;
  final bool enabled;
  final bool figmaStyle;

  const AuthTextField({
    super.key,
    required this.label,
    this.hint,
    required this.controller,
    this.prefixIcon,
    this.isPassword = false,
    this.keyboardType = TextInputType.text,
    this.errorText,
    this.enabled = true,
    this.figmaStyle = false,
  });

  @override
  State<AuthTextField> createState() => _AuthTextFieldState();
}

class _AuthTextFieldState extends State<AuthTextField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    final figma = widget.figmaStyle;

    return TextField(
      controller: widget.controller,
      obscureText: widget.isPassword && _obscureText,
      keyboardType: widget.keyboardType,
      enabled: widget.enabled,
      style: TextStyle(color: AppTheme.brunFonce, fontSize: figma ? 14 : 16),
      decoration: InputDecoration(
        labelText: figma ? null : widget.label,
        hintText: figma ? widget.label : widget.hint,
        errorText: widget.errorText,

        labelStyle: const TextStyle(color: AppTheme.brunFonce),
        hintStyle: TextStyle(
          color: figma
              ? const Color(0xFFB8A897)
              : AppTheme.brunFonce.withValues(alpha: 0.5),
          fontSize: figma ? 13 : 16,
        ),

        prefixIcon: figma || widget.prefixIcon == null
            ? null
            : Icon(widget.prefixIcon, color: AppTheme.terracotta),

        suffixIcon: widget.isPassword
            ? IconButton(
                icon: Icon(
                  _obscureText ? Icons.visibility_off : Icons.visibility,
                  color: AppTheme.brunFonce,
                  size: figma ? 20 : 24,
                ),
                onPressed: () {
                  setState(() {
                    _obscureText = !_obscureText;
                  });
                },
              )
            : null,

        filled: true,
        fillColor: figma ? Colors.white : AppTheme.creme,

        isDense: figma,
        contentPadding: figma
            ? const EdgeInsets.symmetric(horizontal: 12, vertical: 12)
            : null,

        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(figma ? 6 : 12),
          borderSide: BorderSide(
            color: figma ? const Color(0xFFE0E0E0) : AppTheme.caramel,
          ),
        ),

        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(figma ? 6 : 12),
          borderSide: BorderSide(
            color: figma ? const Color(0xFFE0E0E0) : AppTheme.caramel,
          ),
        ),

        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(figma ? 6 : 12),
          borderSide: const BorderSide(color: AppTheme.terracotta, width: 1.5),
        ),

        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(figma ? 6 : 12),
          borderSide: BorderSide(color: Colors.red.shade700, width: 1.5),
        ),

        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(figma ? 6 : 12),
          borderSide: BorderSide(color: Colors.red.shade700, width: 1.5),
        ),
      ),
    );
  }
}
