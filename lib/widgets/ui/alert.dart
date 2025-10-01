// Enhanced alert with more variants and built-in icons
class EnhancedAlert extends StatelessWidget {
  final Widget? title;
  final Widget? description;
  final AlertVariant variant;
  final Widget? customIcon;
  final bool showIcon;
  final EdgeInsetsGeometry? padding;
  final double gap;

  const EnhancedAlert({
    super.key,
    this.title,
    this.description,
    this.variant = AlertVariant.defaultVariant,
    this.customIcon,
    this.showIcon = true,
    this.padding,
    this.gap = 4,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = _getColors(context);

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: colors.backgroundColor,
        border: Border.all(
          color: colors.borderColor,
          width: 1,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      padding: padding ?? const EdgeInsets.all(16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon
          if (showIcon) ...[
            Container(
              width: 16,
              height: 16,
              margin: EdgeInsets.only(top: _getIconTopMargin(), right: 12),
              child: _buildIcon(context, colors),
            ),
          ],
          // Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (title != null) ...[
                  DefaultTextStyle(
                    style: theme.textTheme.bodyMedium!.copyWith(
                      fontWeight: FontWeight.w500,
                      color: colors.textColor,
                    ),
                    child: title!,
                  ),
                  if (description != null) SizedBox(height: gap),
                ],
                if (description != null) ...[
                  DefaultTextStyle(
                    style: theme.textTheme.bodySmall!.copyWith(
                      color: colors.descriptionColor,
                    ),
                    child: description!,
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIcon(BuildContext context, AlertColors colors) {
    if (customIcon != null) {
      return IconTheme(
        data: IconThemeData(
          color: colors.iconColor,
          size: 16,
        ),
        child: customIcon!,
      );
    }

    return Icon(
      _getDefaultIcon(),
      color: colors.iconColor,
      size: 16,
    );
  }

  IconData _getDefaultIcon() {
    switch (variant) {
      case AlertVariant.defaultVariant:
        return Icons.info_outline;
      case AlertVariant.destructive:
        return Icons.error_outline;
    }
  }

  double _getIconTopMargin() {
    // Adjust icon position based on content
    if (title != null && description != null) return 2;
    if (title != null) return 2;
    return 0;
  }

  AlertColors _getColors(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    switch (variant) {
      case AlertVariant.defaultVariant:
        return AlertColors(
          backgroundColor: colorScheme.surface,
          borderColor: colorScheme.outline.withOpacity(0.2),
          textColor: colorScheme.onSurface,
          descriptionColor: colorScheme.onSurface.withOpacity(0.7),
          iconColor: colorScheme.primary,
        );
      case AlertVariant.destructive:
        return AlertColors(
          backgroundColor: colorScheme.surface,
          borderColor: colorScheme.error.withOpacity(0.3),
          textColor: colorScheme.error,
          descriptionColor: colorScheme.error.withOpacity(0.9),
          iconColor: colorScheme.error,
        );
    }
  }
}

class AlertColors {
  final Color backgroundColor;
  final Color borderColor;
  final Color textColor;
  final Color descriptionColor;
  final Color iconColor;

  const AlertColors({
    required this.backgroundColor,
    required this.borderColor,
    required this.textColor,
    required this.descriptionColor,
    required this.iconColor,
  });
}

// Pre-built alert variants for common use cases
class InfoAlert extends StatelessWidget {
  final Widget title;
  final Widget? description;
  final Widget? icon;

  const InfoAlert({
    super.key,
    required this.title,
    this.description,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return EnhancedAlert(
      title: title,
      description: description,
      variant: AlertVariant.defaultVariant,
      customIcon: icon ?? const Icon(Icons.info_outline),
    );
  }
}

class ErrorAlert extends StatelessWidget {
  final Widget title;
  final Widget? description;
  final Widget? icon;

  const ErrorAlert({
    super.key,
    required this.title,
    this.description,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return EnhancedAlert(
      title: title,
      description: description,
      variant: AlertVariant.destructive,
      customIcon: icon ?? const Icon(Icons.error_outline),
    );
  }