import 'package:flutter/material.dart';

class Input extends StatelessWidget {
  final String? placeholder;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final bool enabled;
  final bool obscureText;
  final TextInputType? keyboardType;
  final int? maxLines;
  final int? minLines;
  final bool autofocus;
  final FocusNode? focusNode;
  final FormFieldValidator<String>? validator;
  final EdgeInsetsGeometry? padding;
  final Color? backgroundColor;
  final Color? borderColor;
  final Color? focusedBorderColor;
  final Color? errorBorderColor;
  final double borderRadius;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final String? errorText;
  final bool hasError;

  const Input({
    super.key,
    this.placeholder,
    this.controller,
    this.onChanged,
    this.enabled = true,
    this.obscureText = false,
    this.keyboardType,
    this.maxLines = 1,
    this.minLines,
    this.autofocus = false,
    this.focusNode,
    this.validator,
    this.padding,
    this.backgroundColor,
    this.borderColor,
    this.focusedBorderColor,
    this.errorBorderColor,
    this.borderRadius = 8,
    this.prefixIcon,
    this.suffixIcon,
    this.errorText,
    this.hasError = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final effectiveBackgroundColor = backgroundColor ?? colorScheme.surface;
    final effectiveBorderColor = hasError 
        ? (errorBorderColor ?? colorScheme.error)
        : (borderColor ?? colorScheme.outline.withOpacity(0.3));
    final effectiveFocusedBorderColor = hasError
        ? (errorBorderColor ?? colorScheme.error)
        : (focusedBorderColor ?? colorScheme.primary);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            color: effectiveBackgroundColor,
            border: Border.all(
              color: effectiveBorderColor,
              width: 1,
            ),
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          child: TextField(
            controller: controller,
            onChanged: onChanged,
            enabled: enabled,
            obscureText: obscureText,
            keyboardType: keyboardType,
            maxLines: maxLines,
            minLines: minLines,
            autofocus: autofocus,
            focusNode: focusNode,
            decoration: InputDecoration(
              hintText: placeholder,
              isDense: true,
              contentPadding: padding ?? const EdgeInsets.all(12),
              border: InputBorder.none,
              focusedBorder: InputBorder.none,
              enabledBorder: InputBorder.none,
              disabledBorder: InputBorder.none,
              errorBorder: InputBorder.none,
              focusedErrorBorder: InputBorder.none,
              prefixIcon: prefixIcon,
              suffixIcon: suffixIcon,
              filled: false,
            ),
            style: TextStyle(
              fontSize: 16,
              color: theme.colorScheme.onSurface,
            ),
          ),
        ),
        if (hasError && errorText != null) ...[
          const SizedBox(height: 4),
          Text(
            errorText!,
            style: TextStyle(
              color: colorScheme.error,
              fontSize: 12,
            ),
          ),
        ],
      ],
    );
  }
}

// Enhanced version with focus and validation
class InputField extends StatefulWidget {
  final String? placeholder;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final bool enabled;
  final bool obscureText;
  final TextInputType? keyboardType;
  final int? maxLines;
  final int? minLines;
  final bool autofocus;
  final FormFieldValidator<String>? validator;
  final EdgeInsetsGeometry? padding;
  final Color? backgroundColor;
  final Color? borderColor;
  final Color? focusedBorderColor;
  final Color? errorBorderColor;
  final double borderRadius;
  final Widget? prefixIcon;
  final Widget? suffixIcon;

  const InputField({
    super.key,
    this.placeholder,
    this.controller,
    this.onChanged,
    this.enabled = true,
    this.obscureText = false,
    this.keyboardType,
    this.maxLines = 1,
    this.minLines,
    this.autofocus = false,
    this.validator,
    this.padding,
    this.backgroundColor,
    this.borderColor,
    this.focusedBorderColor,
    this.errorBorderColor,
    this.borderRadius = 8,
    this.prefixIcon,
    this.suffixIcon,
  });

  @override
  State<InputField> createState() => _InputFieldState();
}

class _InputFieldState extends State<InputField> {
  final FocusNode _focusNode = FocusNode();
  String? _errorText;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(_onFocusChange);
  }

  void _onFocusChange() {
    if (!_focusNode.hasFocus && widget.validator != null) {
      final error = widget.validator!(widget.controller?.text ?? '');
      setState(() {
        _errorText = error;
      });
    }
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChange);
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final hasError = _errorText != null;
    final effectiveBackgroundColor = widget.backgroundColor ?? colorScheme.surface;
    final effectiveBorderColor = hasError 
        ? (widget.errorBorderColor ?? colorScheme.error)
        : (widget.borderColor ?? colorScheme.outline.withOpacity(0.3));
    final effectiveFocusedBorderColor = hasError
        ? (widget.errorBorderColor ?? colorScheme.error)
        : (widget.focusedBorderColor ?? colorScheme.primary);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            color: effectiveBackgroundColor,
            border: Border.all(
              color: _focusNode.hasFocus ? effectiveFocusedBorderColor : effectiveBorderColor,
              width: _focusNode.hasFocus ? 2 : 1,
            ),
            borderRadius: BorderRadius.circular(widget.borderRadius),
            boxShadow: _focusNode.hasFocus
                ? [
                    BoxShadow(
                      color: effectiveFocusedBorderColor.withOpacity(0.1),
                      blurRadius: 8,
                      spreadRadius: 2,
                    ),
                  ]
                : null,
          ),
          child: TextField(
            controller: widget.controller,
            onChanged: (value) {
              widget.onChanged?.call(value);
              if (_focusNode.hasFocus && widget.validator != null) {
                final error = widget.validator!(value);
                setState(() {
                  _errorText = error;
                });
              }
            },
            enabled: widget.enabled,
            obscureText: widget.obscureText,
            keyboardType: widget.keyboardType,
            maxLines: widget.maxLines,
            minLines: widget.minLines,
            autofocus: widget.autofocus,
            focusNode: _focusNode,
            decoration: InputDecoration(
              hintText: widget.placeholder,
              isDense: true,
              contentPadding: widget.padding ?? const EdgeInsets.all(12),
              border: InputBorder.none,
              focusedBorder: InputBorder.none,
              enabledBorder: InputBorder.none,
              disabledBorder: InputBorder.none,
              errorBorder: InputBorder.none,
              focusedErrorBorder: InputBorder.none,
              prefixIcon: widget.prefixIcon,
              suffixIcon: widget.suffixIcon,
              filled: false,
            ),
            style: TextStyle(
              fontSize: 16,
              color: theme.colorScheme.onSurface,
            ),
          ),
        ),
        if (hasError) ...[
          const SizedBox(height: 4),
          Text(
            _errorText!,
            style: TextStyle(
              color: colorScheme.error,
              fontSize: 12,
            ),
          ),
        ],
      ],
    );
  }
}