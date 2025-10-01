import 'package:flutter/material.dart';

class Label extends StatelessWidget {
  final Widget child;
  final bool disabled;
  final bool selectable;
  final EdgeInsetsGeometry? padding;
  final TextStyle? textStyle;
  final TextAlign textAlign;

  const Label({
    super.key,
    required this.child,
    this.disabled = false,
    this.selectable = false,
    this.padding,
    this.textStyle,
    this.textAlign = TextAlign.start,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final defaultStyle = theme.textTheme.bodyMedium?.copyWith(
      fontWeight: FontWeight.w500,
      height: 1.0,
    );

    Widget labelChild = child is Text
        ? child
        : DefaultTextStyle(
            style: (textStyle ?? defaultStyle)!.copyWith(
              color: disabled
                  ? theme.colorScheme.onSurface.withOpacity(0.5)
                  : theme.colorScheme.onSurface,
            ),
            child: child,
          );

    if (padding != null) {
      labelChild = Padding(
        padding: padding!,
        child: labelChild,
      );
    }

    // Handle selection if needed
    if (selectable) {
      labelChild = SelectableText(
        _extractText(child),
        style: (textStyle ?? defaultStyle)!.copyWith(
          color: disabled
              ? theme.colorScheme.onSurface.withOpacity(0.5)
              : theme.colorScheme.onSurface,
        ),
      );
    }

    return labelChild;
  }

  String _extractText(Widget child) {
    if (child is Text) return child.data ?? '';
    if (child is RichText) {
      // For RichText, we'd need to extract text spans
      return '';
    }
    return '';
  }
}

// Enhanced version with form field association
class FormLabel extends StatelessWidget {
  final String text;
  final bool required;
  final bool disabled;
  final FocusNode? focusNode;
  final String? htmlFor;

  const FormLabel({
    super.key,
    required this.text,
    this.required = false,
    this.disabled = false,
    this.focusNode,
    this.htmlFor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: focusNode != null ? () => focusNode!.requestFocus() : null,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            text,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w500,
              color: disabled
                  ? theme.colorScheme.onSurface.withOpacity(0.5)
                  : theme.colorScheme.onSurface,
            ),
          ),
          if (required) ...[
            const SizedBox(width: 4),
            Text(
              '*',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.error,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

// Label with icon
class LabelWithIcon extends StatelessWidget {
  final String text;
  final Widget icon;
  final bool disabled;
  final MainAxisAlignment alignment;

  const LabelWithIcon({
    super.key,
    required this.text,
    required this.icon,
    this.disabled = false,
    this.alignment = MainAxisAlignment.start,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: alignment,
      children: [
        IconTheme(
          data: IconThemeData(
            size: 16,
            color: disabled
                ? theme.colorScheme.onSurface.withOpacity(0.5)
                : theme.colorScheme.onSurface,
          ),
          child: icon,
        ),
        const SizedBox(width: 8),
        Text(
          text,
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w500,
            color: disabled
                ? theme.colorScheme.onSurface.withOpacity(0.5)
                : theme.colorScheme.onSurface,
          ),
        ),
      ],
    );
  }
}