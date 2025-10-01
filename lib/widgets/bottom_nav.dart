import 'package:flutter/material.dart';

class BottomNav extends StatelessWidget {
  final String activeTab;
  final Function(String) onTabChange;

  const BottomNav({
    super.key,
    required this.activeTab,
    required this.onTabChange,
  });

  @override
  Widget build(BuildContext context) {
    final navItems = [
      NavItem(id: 'home', label: 'Home', icon: Icons.home),
      NavItem(id: 'search', label: 'Search', icon: Icons.search),
      NavItem(id: 'post', label: 'Post', icon: Icons.add_circle),
      NavItem(id: 'map', label: 'Map', icon: Icons.map),
      NavItem(id: 'profile', label: 'Profile', icon: Icons.person),
    ];

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        border: Border(
          top: BorderSide(
            color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Container(
          height: 64,
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Row(
            children: [
              for (final item in navItems)
                Expanded(
                  child: _NavItem(
                    item: item,
                    isActive: activeTab == item.id,
                    onTap: () => onTabChange(item.id),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class NavItem {
  final String id;
  final String label;
  final IconData icon;

  const NavItem({
    required this.id,
    required this.label,
    required this.icon,
  });
}

class _NavItem extends StatelessWidget {
  final NavItem item;
  final bool isActive;
  final VoidCallback onTap;

  const _NavItem({
    required this.item,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final activeColor = theme.colorScheme.primary;
    final inactiveColor = theme.colorScheme.onSurface.withOpacity(0.6);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        decoration: BoxDecoration(
          color: isActive 
              ? theme.colorScheme.secondary.withOpacity(0.2)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              item.icon,
              size: 20,
              color: isActive ? activeColor : inactiveColor,
            ),
            const SizedBox(height: 2),
            Text(
              item.label,
              style: TextStyle(
                fontSize: 10,
                fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                color: isActive ? activeColor : inactiveColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}