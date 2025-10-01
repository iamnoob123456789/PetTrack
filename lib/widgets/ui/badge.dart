import 'package:flutter/material.dart';

enum BadgeVariant {
  primary,
  secondary,
  destructive,
  outline,
}

class Badge extends StatelessWidget {
  final Widget child;
  final BadgeVariant variant;
  final Widget? icon;
  final EdgeInsetsGeometry? padding;
  final Color? backgroundColor;
  final Color? textColor;
  final Color? borderColor;
  final BorderRadiusGeometry? borderRadius;
  final VoidCallback? onTap;

  const Badge({
    super.key,
    required this.child,
    this.variant = BadgeVariant.primary,
    this.icon,
    this.padding,
    this.backgroundColor,
    this.textColor,
    this.borderColor,
    this.borderRadius,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = _getBadgeColors(theme);
    final dimensions = _getBadgeDimensions();

    Widget badgeContent = Container(
      padding: padding ?? dimensions.padding,
      decoration: BoxDecoration(
        color: colors.backgroundColor,
        border: borderColor != null 
            ? Border.all(color: borderColor!) 
            : colors.border,
        borderRadius: borderRadius ?? dimensions.borderRadius,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (icon != null) ...[
            IconTheme(
              data: IconThemeData(
                size: 12,
                color: colors.textColor,
              ),
              child: icon!,
            ),
            const SizedBox(width: 4),
          ],
          DefaultTextStyle(
            style: TextStyle(
              color: colors.textColor,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
            child: child,
          ),
        ],
      ),
    );

    if (onTap != null) {
      return GestureDetector(
        onTap: onTap,
        child: badgeContent,
      );
    }

    return badgeContent;
  }

  BadgeColors _getBadgeColors(ThemeData theme) {
    final colorScheme = theme.colorScheme;

    switch (variant) {
      case BadgeVariant.primary:
        return BadgeColors(
          backgroundColor: backgroundColor ?? colorScheme.primary,
          textColor: textColor ?? colorScheme.onPrimary,
          border: BorderSide.none,
        );
      case BadgeVariant.secondary:
        return BadgeColors(
          backgroundColor: backgroundColor ?? colorScheme.secondary,
          textColor: textColor ?? colorScheme.onSecondary,
          border: BorderSide.none,
        );
      case BadgeVariant.destructive:
        return BadgeColors(
          backgroundColor: backgroundColor ?? colorScheme.error,
          textColor: textColor ?? colorScheme.onError,
          border: BorderSide.none,
        );
      case BadgeVariant.outline:
        return BadgeColors(
          backgroundColor: Colors.transparent,
          textColor: textColor ?? colorScheme.onSurface,
          border: BorderSide(
            color: borderColor ?? colorScheme.outline,
            width: 1,
          ),
        );
    }
  }

  BadgeDimensions _getBadgeDimensions() {
    return const BadgeDimensions(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      borderRadius: BorderRadius.all(Radius.circular(6)),
    );
  }
}

class BadgeColors {
  final Color backgroundColor;
  final Color textColor;
  final BorderSide border;

  const BadgeColors({
    required this.backgroundColor,
    required this.textColor,
    required this.border,
  });
}

class BadgeDimensions {
  final EdgeInsetsGeometry padding;
  final BorderRadiusGeometry borderRadius;

  const BadgeDimensions({
    required this.padding,
    required this.borderRadius,
  });
}