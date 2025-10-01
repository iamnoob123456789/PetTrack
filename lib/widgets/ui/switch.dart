import 'package:flutter/material.dart';

class Switch extends StatefulWidget {
  final bool value;
  final ValueChanged<bool>? onChanged;
  final bool disabled;
  final Color? activeColor;
  final Color? inactiveColor;
  final Color? thumbColor;
  final double width;
  final double height;
  final Duration duration;

  const Switch({
    super.key,
    required this.value,
    this.onChanged,
    this.disabled = false,
    this.activeColor,
    this.inactiveColor,
    this.thumbColor,
    this.width = 32,
    this.height = 18,
    this.duration = const Duration(milliseconds: 200),
  });

  @override
  State<Switch> createState() => _SwitchState();
}

class _SwitchState extends State<Switch> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
      value: widget.value ? 1.0 : 0.0,
    );
  }

  @override
  void didUpdateWidget(Switch oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != oldWidget.value) {
      if (widget.value) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTap() {
    if (widget.disabled || widget.onChanged == null) return;
    widget.onChanged!(!widget.value);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final effectiveActiveColor = widget.activeColor ?? colorScheme.primary;
    final effectiveInactiveColor = widget.inactiveColor ?? colorScheme.outline.withOpacity(0.3);
    final effectiveThumbColor = widget.thumbColor ?? colorScheme.surface;

    return GestureDetector(
      onTap: _handleTap,
      child: AnimatedContainer(
        duration: widget.duration,
        width: widget.width,
        height: widget.height,
        decoration: BoxDecoration(
          color: widget.value ? effectiveActiveColor : effectiveInactiveColor,
          borderRadius: BorderRadius.circular(widget.height / 2),
        ),
        child: Stack(
          children: [
            // Thumb
            AnimatedAlign(
              duration: widget.duration,
              alignment: widget.value ? Alignment.centerRight : Alignment.centerLeft,
              child: Container(
                width: widget.height - 4,
                height: widget.height - 4,
                margin: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  color: widget.disabled 
                      ? effectiveThumbColor.withOpacity(0.5)
                      : effectiveThumbColor,
                  borderRadius: BorderRadius.circular((widget.height - 4) / 2),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 2,
                      offset: const Offset(0, 1),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Enhanced version with focus and accessibility
class EnhancedSwitch extends StatelessWidget {
  final bool value;
  final ValueChanged<bool>? onChanged;
  final bool disabled;
  final Color? activeColor;
  final Color? inactiveColor;
  final Color? thumbColor;
  final String? semanticLabel;
  final FocusNode? focusNode;
  final bool autofocus;

  const EnhancedSwitch({
    super.key,
    required this.value,
    this.onChanged,
    this.disabled = false,
    this.activeColor,
    this.inactiveColor,
    this.thumbColor,
    this.semanticLabel,
    this.focusNode,
    this.autofocus = false,
  });

  @override
  Widget build(BuildContext context) {
    return Focus(
      focusNode: focusNode,
      autofocus: autofocus,
      child: Semantics(
        label: semanticLabel,
        value: value ? 'on' : 'off',
        child: ExcludeSemantics(
          child: Switch(
            value: value,
            onChanged: disabled ? null : onChanged,
            disabled: disabled,
            activeColor: activeColor,
            inactiveColor: inactiveColor,
            thumbColor: thumbColor,
          ),
        ),
      ),
    );
  }
}

// Switch with label
class LabeledSwitch extends StatelessWidget {
  final String label;
  final bool value;
  final ValueChanged<bool>? onChanged;
  final bool disabled;
  final Widget? leading;
  final Widget? trailing;
  final EdgeInsetsGeometry padding;

  const LabeledSwitch({
    super.key,
    required this.label,
    required this.value,
    this.onChanged,
    this.disabled = false,
    this.leading,
    this.trailing,
    this.padding = const EdgeInsets.symmetric(vertical: 8),
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Row(
        children: [
          if (leading != null) ...[
            leading!,
            const SizedBox(width: 12),
          ],
          Expanded(
            child: Text(
              label,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: disabled 
                    ? Theme.of(context).colorScheme.onSurface.withOpacity(0.5)
                    : Theme.of(context).colorScheme.onSurface,
              ),
            ),
          ),
          if (trailing != null) ...[
            const SizedBox(width: 12),
            trailing!,
          ],
          const SizedBox(width: 12),
          Switch(
            value: value,
            onChanged: disabled ? null : onChanged,
            disabled: disabled,
          ),
        ],
      ),
    );
  }
}