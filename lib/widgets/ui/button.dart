import 'package:flutter/material.dart';

enum ButtonVariant {
  primary,
  destructive,
  outline,
  secondary,
  ghost,
  link,
}

enum ButtonSize {
  small,
  defaultSize,
  large,
  icon,
}

class Button extends StatelessWidget {
  final Widget child;
  final VoidCallback? onPressed;
  final ButtonVariant variant;
  final ButtonSize size;
  final bool asChild;
  final Widget? icon;
  final bool disabled;
  final bool loading;
  final EdgeInsetsGeometry? padding;
  final double? width;
  final double? height;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final BorderSide? borderSide;
  final BorderRadiusGeometry? borderRadius;
  final FocusNode? focusNode;
  final bool autofocus;

  const Button({
    super.key,
    required this.child,
    this.onPressed,
    this.variant = ButtonVariant.primary,
    this.size = ButtonSize.defaultSize,
    this.asChild = false,
    this.icon,
    this.disabled = false,
    this.loading = false,
    this.padding,
    this.width,
    this.height,
    this.backgroundColor,
    this.foregroundColor,
    this.borderSide,
    this.borderRadius,
    this.focusNode,
    this.autofocus = false,
  });

  const Button.primary({
    super.key,
    required this.child,
    this.onPressed,
    this.size = ButtonSize.defaultSize,
    this.asChild = false,
    this.icon,
    this.disabled = false,
    this.loading = false,
    this.padding,
    this.width,
    this.height,
    this.backgroundColor,
    this.foregroundColor,
    this.borderSide,
    this.borderRadius,
    this.focusNode,
    this.autofocus = false,
  }) : variant = ButtonVariant.primary;

  const Button.destructive({
    super.key,
    required this.child,
    this.onPressed,
    this.size = ButtonSize.defaultSize,
    this.asChild = false,
    this.icon,
    this.disabled = false,
    this.loading = false,
    this.padding,
    this.width,
    this.height,
    this.backgroundColor,
    this.foregroundColor,
    this.borderSide,
    this.borderRadius,
    this.focusNode,
    this.autofocus = false,
  }) : variant = ButtonVariant.destructive;

  const Button.outline({
    super.key,
    required this.child,
    this.onPressed,
    this.size = ButtonSize.defaultSize,
    this.asChild = false,
    this.icon,
    this.disabled = false,
    this.loading = false,
    this.padding,
    this.width,
    this.height,
    this.backgroundColor,
    this.foregroundColor,
    this.borderSide,
    this.borderRadius,
    this.focusNode,
    this.autofocus = false,
  }) : variant = ButtonVariant.outline;

  const Button.secondary({
    super.key,
    required this.child,
    this.onPressed,
    this.size = ButtonSize.defaultSize,
    this.asChild = false,
    this.icon,
    this.disabled = false,
    this.loading = false,
    this.padding,
    this.width,
    this.height,
    this.backgroundColor,
    this.foregroundColor,
    this.borderSide,
    this.borderRadius,
    this.focusNode,
    this.autofocus = false,
  }) : variant = ButtonVariant.secondary;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = _getButtonColors(context, theme);
    final dimensions = _getButtonDimensions();

    if (asChild) {
      return _buildAsChild(colors, dimensions, context);
    }

    return _buildButton(colors, dimensions, context);
  }

  Widget _buildButton(ButtonColors colors, ButtonDimensions dimensions, BuildContext context) {
    final effectiveOnPressed = disabled || loading ? null : onPressed;

    Widget buttonContent = Container(
      width: width ?? dimensions.width,
      height: height ?? dimensions.height,
      padding: padding ?? dimensions.padding,
      decoration: BoxDecoration(
        color: colors.backgroundColor,
        border: borderSide != null ? Border.fromBorderSide(borderSide!) : colors.border,
        borderRadius: borderRadius ?? dimensions.borderRadius,
      ),
      child: Center(
        child: _buildContent(colors, dimensions, context),
      ),
    );

    // Add focus and hover effects
    buttonContent = MouseRegion(
      cursor: effectiveOnPressed != null ? SystemMouseCursors.click : SystemMouseCursors.basic,
      child: GestureDetector(
        onTap: effectiveOnPressed,
        child: buttonContent,
      ),
    );

    // Add focus ring for accessibility
    buttonContent = Focus(
      focusNode: focusNode,
      autofocus: autofocus,
      canRequestFocus: effectiveOnPressed != null,
      child: buttonContent,
    );

    return buttonContent;
  }

  Widget _buildAsChild(ButtonColors colors, ButtonDimensions dimensions, BuildContext context) {
    return DefaultTextStyle(
      style: TextStyle(
        color: colors.foregroundColor,
        fontSize: dimensions.fontSize,
        fontWeight: FontWeight.w500,
      ),
      child: IconTheme(
        data: IconThemeData(
          color: colors.foregroundColor,
          size: dimensions.iconSize,
        ),
        child: child,
      ),
    );
  }

  Widget _buildContent(ButtonColors colors, ButtonDimensions dimensions, BuildContext context) {
    if (loading) {
      return SizedBox(
        width: dimensions.iconSize,
        height: dimensions.iconSize,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(colors.foregroundColor),
        ),
      );
    }

    final hasIcon = icon != null;
    final hasText = child is Text;

    if (hasIcon && hasText) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          icon!,
          SizedBox(width: dimensions.gap),
          Flexible(child: child),
        ],
      );
    } else if (hasIcon) {
      return icon!;
    } else {
      return child;
    }
  }

  ButtonColors _getButtonColors(BuildContext context, ThemeData theme) {
    final colorScheme = theme.colorScheme;

    switch (variant) {
      case ButtonVariant.primary:
        return ButtonColors(
          backgroundColor: backgroundColor ?? colorScheme.primary,
          foregroundColor: foregroundColor ?? colorScheme.onPrimary,
          border: BorderSide.none,
        );
      case ButtonVariant.destructive:
        return ButtonColors(
          backgroundColor: backgroundColor ?? colorScheme.error,
          foregroundColor: foregroundColor ?? colorScheme.onError,
          border: BorderSide.none,
        );
      case ButtonVariant.outline:
        return ButtonColors(
          backgroundColor: backgroundColor ?? Colors.transparent,
          foregroundColor: foregroundColor ?? colorScheme.onSurface,
          border: BorderSide(
            color: borderSide?.color ?? colorScheme.outline,
            width: borderSide?.width ?? 1,
          ),
        );
      case ButtonVariant.secondary:
        return ButtonColors(
          backgroundColor: backgroundColor ?? colorScheme.secondary,
          foregroundColor: foregroundColor ?? colorScheme.onSecondary,
          border: BorderSide.none,
        );
      case ButtonVariant.ghost:
        return ButtonColors(
          backgroundColor: backgroundColor ?? Colors.transparent,
          foregroundColor: foregroundColor ?? colorScheme.onSurface,
          border: BorderSide.none,
        );
      case ButtonVariant.link:
        return ButtonColors(
          backgroundColor: Colors.transparent,
          foregroundColor: foregroundColor ?? colorScheme.primary,
          border: BorderSide.none,
        );
    }
  }

  ButtonDimensions _getButtonDimensions() {
    switch (size) {
      case ButtonSize.small:
        return const ButtonDimensions(
          height: 32,
          padding: EdgeInsets.symmetric(horizontal: 12),
          borderRadius: BorderRadius.all(Radius.circular(6)),
          fontSize: 14,
          iconSize: 16,
          gap: 6,
        );
      case ButtonSize.defaultSize:
        return const ButtonDimensions(
          height: 36,
          padding: EdgeInsets.symmetric(horizontal: 16),
          borderRadius: BorderRadius.all(Radius.circular(8)),
          fontSize: 14,
          iconSize: 16,
          gap: 8,
        );
      case ButtonSize.large:
        return const ButtonDimensions(
          height: 40,
          padding: EdgeInsets.symmetric(horizontal: 24),
          borderRadius: BorderRadius.all(Radius.circular(8)),
          fontSize: 16,
          iconSize: 20,
          gap: 8,
        );
      case ButtonSize.icon:
        return const ButtonDimensions(
          height: 36,
          width: 36,
          padding: EdgeInsets.all(8),
          borderRadius: BorderRadius.all(Radius.circular(8)),
          fontSize: 14,
          iconSize: 16,
          gap: 0,
        );
    }
  }
}

class ButtonColors {
  final Color backgroundColor;
  final Color foregroundColor;
  final BorderSide border;

  const ButtonColors({
    required this.backgroundColor,
    required this.foregroundColor,
    required this.border,
  });
}

class ButtonDimensions {
  final double? width;
  final double height;
  final EdgeInsetsGeometry padding;
  final BorderRadiusGeometry borderRadius;
  final double fontSize;
  final double iconSize;
  final double gap;

  const ButtonDimensions({
    this.width,
    required this.height,
    required this.padding,
    required this.borderRadius,
    required this.fontSize,
    required this.iconSize,
    required this.gap,
  });
}

// Export button variants for use in other components (like AlertDialog)
ButtonVariant getButtonVariant(String variant) {
  switch (variant) {
    case 'destructive':
      return ButtonVariant.destructive;
    case 'outline':
      return ButtonVariant.outline;
    case 'secondary':
      return ButtonVariant.secondary;
    case 'ghost':
      return ButtonVariant.ghost;
    case 'link':
      return ButtonVariant.link;
    default:
      return ButtonVariant.primary;
  }
}