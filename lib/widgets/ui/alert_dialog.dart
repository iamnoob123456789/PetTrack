// Enhanced alert dialog with animations and more customization
class AdvancedAlertDialog extends StatelessWidget {
  final Widget title;
  final Widget content;
  final List<Widget> actions;
  final bool barrierDismissible;
  final Color? barrierColor;
  final Duration? animationDuration;
  final Curve? animationCurve;

  const AdvancedAlertDialog({
    super.key,
    required this.title,
    required this.content,
    this.actions = const [],
    this.barrierDismissible = true,
    this.barrierColor,
    this.animationDuration,
    this.animationCurve,
  });

  static Future<T?> show<T>({
    required BuildContext context,
    required Widget title,
    required Widget content,
    List<Widget> actions = const [],
    bool barrierDismissible = true,
    Color? barrierColor,
    Duration? animationDuration,
    Curve? animationCurve,
  }) {
    return showGeneralDialog<T>(
      context: context,
      barrierDismissible: barrierDismissible,
      barrierColor: barrierColor ?? Colors.black54,
      barrierLabel: 'Alert Dialog',
      transitionDuration: animationDuration ?? const Duration(milliseconds: 200),
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        final curve = animationCurve ?? Curves.easeInOut;
        return FadeTransition(
          opacity: CurvedAnimation(parent: animation, curve: curve),
          child: ScaleTransition(
            scale: CurvedAnimation(
              parent: animation,
              curve: Interval(0.0, 0.5, curve: curve),
            ),
            child: child,
          ),
        );
      },
      pageBuilder: (context, animation, secondaryAnimation) {
        return AdvancedAlertDialog(
          title: title,
          content: content,
          actions: actions,
          barrierDismissible: barrierDismissible,
          barrierColor: barrierColor,
          animationDuration: animationDuration,
          animationCurve: animationCurve,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Theme.of(context).colorScheme.surface,
      elevation: 24,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      insetPadding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          maxWidth: 500,
          minWidth: 300,
        ),
        child: Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title
              DefaultTextStyle(
                style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                child: title,
              ),
              const SizedBox(height: 16),
              // Content
              Flexible(
                child: DefaultTextStyle(
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                      ),
                  child: content,
                ),
              ),
              const SizedBox(height: 24),
              // Actions
              if (actions.isNotEmpty) ...[
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    for (int i = 0; i < actions.length; i++) ...[
                      if (i > 0) const SizedBox(width: 12),
                      actions[i],
                    ],
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}