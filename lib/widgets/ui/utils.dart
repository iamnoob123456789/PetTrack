// Utility functions for class name merging and conditional styling
class Cn {
  /// Merges multiple style conditions into a single style
  /// Similar to clsx + twMerge in React
  static String merge(List<String?> classes) {
    return classes
        .where((cls) => cls != null && cls.isNotEmpty)
        .join(' ')
        .trim();
  }

  /// Conditional class merging for responsive design
  static String conditional({
    required String base,
    String? mobile,
    String? desktop,
    String? tablet,
    bool isMobile = false,
    bool isTablet = false,
    bool isDesktop = false,
  }) {
    final classes = [base];
    
    if (isMobile && mobile != null) classes.add(mobile);
    if (isTablet && tablet != null) classes.add(tablet);
    if (isDesktop && desktop != null) classes.add(desktop);
    
    return merge(classes);
  }
}

// Enhanced styling utilities
class StyleUtils {
  /// Creates a border radius based on size
  static BorderRadius borderRadius(double size) {
    return BorderRadius.circular(size);
  }

  /// Creates responsive padding
  static EdgeInsets responsivePadding({
    required bool isMobile,
    double mobile = 16,
    double desktop = 24,
  }) {
    return EdgeInsets.all(isMobile ? mobile : desktop);
  }

  /// Creates spacing based on design system
  static EdgeInsets spacing({
    double all = 0,
    double horizontal = 0,
    double vertical = 0,
    double top = 0,
    double bottom = 0,
    double left = 0,
    double right = 0,
  }) {
    if (all != 0) return EdgeInsets.all(all);
    if (horizontal != 0 || vertical != 0) {
      return EdgeInsets.symmetric(horizontal: horizontal, vertical: vertical);
    }
    return EdgeInsets.only(
      top: top,
      bottom: bottom,
      left: left,
      right: right,
    );
  }

  /// Creates box shadow based on elevation
  static List<BoxShadow> shadow({int level = 1}) {
    switch (level) {
      case 1:
        return [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ];
      case 2:
        return [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ];
      case 3:
        return [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ];
      default:
        return [];
    }
  }
}

// Color utilities for theme consistency
class ColorUtils {
  /// Blend colors with opacity (similar to Tailwind's opacity utilities)
  static Color withOpacity(Color color, double opacity) {
    return color.withOpacity(opacity);
  }

  /// Get text color based on background color (for accessibility)
  static Color getTextColor(Color backgroundColor) {
    final brightness = ThemeData.estimateBrightnessForColor(backgroundColor);
    return brightness == Brightness.light ? Colors.black : Colors.white;
  }
}