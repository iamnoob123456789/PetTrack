// Enhanced avatar with status indicators and badges
class EnhancedAvatar extends StatelessWidget {
  final String? imageUrl;
  final String? alt;
  final double size;
  final AvatarStatus? status;
  final Color? statusColor;
  final Widget? badge;
  final bool isOnline;
  final BorderRadius? borderRadius;
  final Color? backgroundColor;
  final VoidCallback? onTap;
  final BoxFit? fit;

  const EnhancedAvatar({
    super.key,
    this.imageUrl,
    this.alt,
    this.size = 40,
    this.status,
    this.statusColor,
    this.badge,
    this.isOnline = false,
    this.borderRadius,
    this.backgroundColor,
    this.onTap,
    this.fit,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = _getButtonColors(context, theme);
    final dimensions = _getButtonDimensions();
    final isMobile = MediaQuery.of(context).size.width < 768;

    // Use our new utils for responsive design
    final responsivePadding = StyleUtils.responsivePadding(
      isMobile: isMobile,
      mobile: 12,
      desktop: 16,
    );

    if (asChild) {
      return _buildAsChild(colors, dimensions, context);
    }

    return _buildButton(colors, dimensions, responsivePadding, context);
  }

  Widget _buildButton(
    ButtonColors colors, 
    ButtonDimensions dimensions, 
    EdgeInsetsGeometry responsivePadding,
    BuildContext context,
  ) {
    final effectiveOnPressed = disabled || loading ? null : onPressed;

    // Use StyleUtils for consistent styling
    final boxShadow = StyleUtils.shadow(level: 1);
    final borderRadius = StyleUtils.borderRadius(8);

    Widget buttonContent = Container(
      width: width ?? dimensions.width,
      height: height ?? dimensions.height,
      padding: padding ?? dimensions.padding ?? responsivePadding,
      decoration: BoxDecoration(
        color: colors.backgroundColor,
        border: borderSide != null ? Border.fromBorderSide(borderSide!) : colors.border,
        borderRadius: borderRadius,
        boxShadow: boxShadow,
      ),
      child: Center(
        child: _buildContent(colors, dimensions, context),
      ),
    );

    // Add interactive states
    buttonContent = AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOut,
      child: buttonContent,
    );

    return MouseRegion(
      cursor: effectiveOnPressed != null ? SystemMouseCursors.click : SystemMouseCursors.basic,
      child: GestureDetector(
        onTap: effectiveOnPressed,
        child: buttonContent,
      ),
    );
  }

  Color _getStatusColor(BuildContext context) {
    final theme = Theme.of(context);
    
    if (statusColor != null) return statusColor!;
    if (isOnline) return Colors.green;

    switch (status) {
      case AvatarStatus.online:
        return Colors.green;
      case AvatarStatus.away:
        return Colors.orange;
      case AvatarStatus.busy:
        return Colors.red;
      case AvatarStatus.offline:
        return Colors.grey;
      default:
        return Colors.grey;
    }
  }
}

enum AvatarStatus {
  online,
  away,
  busy,
  offline,