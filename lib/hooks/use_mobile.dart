import 'package:flutter/material.dart';

const double mobileBreakpoint = 768;

bool useIsMobile(BuildContext context) {
  final mediaQuery = MediaQuery.of(context);
  return mediaQuery.size.width < mobileBreakpoint;
}

// Alternative: Hook-like approach for state management
class MobileBreakpoint extends InheritedWidget {
  final bool isMobile;

  const MobileBreakpoint({
    super.key,
    required this.isMobile,
    required super.child,
  });

  static MobileBreakpoint? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<MobileBreakpoint>();
  }

  @override
  bool updateShouldNotify(MobileBreakpoint oldWidget) {
    return isMobile != oldWidget.isMobile;
  }
}

// Widget wrapper for responsive design
class ResponsiveBuilder extends StatelessWidget {
  final Widget Function(bool isMobile) builder;

  const ResponsiveBuilder({
    super.key,
    required this.builder,
  });

  @override
  Widget build(BuildContext context) {
    final isMobile = useIsMobile(context);
    return builder(isMobile);
  }
}

// Usage in widget tree
class ResponsiveLayout extends StatelessWidget {
  final Widget mobile;
  final Widget desktop;

  const ResponsiveLayout({
    super.key,
    required this.mobile,
    required this.desktop,
  });

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      builder: (isMobile) => isMobile ? mobile : desktop,
    );
  }
}