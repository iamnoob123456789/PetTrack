import 'package:flutter/material.dart';
import 'bottom_nav.dart';

class Layout extends StatelessWidget {
  final Widget child;
  final String activeTab;
  final Function(String) onTabChange;
  final bool hideNav;

  const Layout({
    super.key,
    required this.child,
    required this.activeTab,
    required this.onTabChange,
    this.hideNav = false,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SafeArea(
        child: child,
      ),
      bottomNavigationBar: hideNav
          ? null
          : BottomNav(
              activeTab: activeTab,
              onTabChange: onTabChange,
            ),
    );
  }
}