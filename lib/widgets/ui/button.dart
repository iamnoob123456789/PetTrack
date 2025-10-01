// Updated button.dart with proper utility integration
import 'package:flutter/material.dart';
import 'utils.dart';

class Button extends StatelessWidget {
  // ... (previous constructor and properties remain the same)

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

  // ... rest of the button implementation
}