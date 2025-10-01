import 'package:flutter/material.dart';
import './button.dart' show Button, ButtonVariant;
import './utils.dart';

class AlertDialog extends StatelessWidget {
  final Widget? title;
  final Widget? content;
  final List<Widget>? actions;
  final bool isOpen;
  final VoidCallback? onOpenChange;
  final EdgeInsetsGeometry? contentPadding;
  final double? elevation;
  final Color? backgroundColor;
  final ShapeBorder? shape;

  const AlertDialog({
    super.key,
    this.title,
    this.content,
    this.actions,
    this.isOpen = false,
    this.onOpenChange,
    this.contentPadding,
    this.elevation,
    this.backgroundColor,
    this.shape,
  });

  void _showDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => _buildDialogContent(context),
    );
  }

  Widget _buildDialogContent(BuildContext context) {
    return Dialog(
      backgroundColor: backgroundColor ?? Theme.of(context).colorScheme.surface,
      elevation: elevation ?? 24,
      shape: shape ?? RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      insetPadding: const EdgeInsets.all(32),
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          maxWidth: 400,
          minWidth: 300,
        ),
        child: Container(
          padding: contentPadding ?? const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              if (title != null) ...[
                AlertDialogHeader(
                  child: title!,
                ),
                const SizedBox(height: 8),
              ],
              // Content
              if (content != null) ...[
                Flexible(
                  child: AlertDialogDescription(
                    child: content!,
                  ),
                ),
                const SizedBox(height: 24),
              ],
              // Footer with actions
              if (actions != null && actions!.isNotEmpty) ...[
                AlertDialogFooter(
                  children: actions!,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // In Flutter, we typically trigger dialogs via button presses
    // This widget serves as a configuration component
    return const SizedBox.shrink();
  }
}

// Helper function to show alert dialog
Future<bool?> showAlertDialog({
  required BuildContext context,
  required Widget title,
  required Widget content,
  String? confirmText,
  String? cancelText,
  VoidCallback? onConfirm,
  VoidCallback? onCancel,
  bool barrierDismissible = true,
}) async {
  return showDialog<bool>(
    context: context,
    barrierDismissible: barrierDismissible,
    builder: (context) {
      return AlertDialog(
        title: title,
        content: content,
        actions: [
          if (cancelText != null)
            AlertDialogCancel(
              onPressed: onCancel ?? () => Navigator.of(context).pop(false),
              child: Text(cancelText),
            ),
          if (confirmText != null)
            AlertDialogAction(
              onPressed: onConfirm ?? () => Navigator.of(context).pop(true),
              child: Text(confirmText),
            ),
        ],
      );
    },
  );
}

// Individual dialog components
class AlertDialogTrigger extends StatelessWidget {
  final Widget child;
  final VoidCallback onPressed;

  const AlertDialogTrigger({
    super.key,
    required this.child,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: child,
    );
  }
}

class AlertDialogHeader extends StatelessWidget {
  final Widget child;

  const AlertDialogHeader({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return DefaultTextStyle(
      style: Theme.of(context).textTheme.headlineSmall!.copyWith(
            fontWeight: FontWeight.w600,
          ),
      child: child,
    );
  }
}

class AlertDialogDescription extends StatelessWidget {
  final Widget child;

  const AlertDialogDescription({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return DefaultTextStyle(
      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
          ),
      child: child,
    );
  }
}

class AlertDialogFooter extends StatelessWidget {
  final List<Widget> children;

  const AlertDialogFooter({
    super.key,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        for (int i = 0; i < children.length; i++) ...[
          if (i > 0) const SizedBox(width: 8),
          children[i],
        ],
      ],
    );
  }
}

class AlertDialogTitle extends StatelessWidget {
  final Widget child;

  const AlertDialogTitle({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return DefaultTextStyle(
      style: Theme.of(context).textTheme.headlineSmall!.copyWith(
            fontWeight: FontWeight.w600,
          ),
      child: child,
    );
  }
}

class AlertDialogAction extends StatelessWidget {
  final Widget child;
  final VoidCallback onPressed;
  final ButtonVariant? variant;

  const AlertDialogAction({
    super.key,
    required this.child,
    required this.onPressed,
    this.variant,
  });

  @override
  Widget build(BuildContext context) {
    return Button(
      onPressed: onPressed,
      variant: variant ?? ButtonVariant.primary,
      child: child,
    );
  }
}

class AlertDialogCancel extends StatelessWidget {
  final Widget child;
  final VoidCallback onPressed;

  const AlertDialogCancel({
    super.key,
    required this.child,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Button(
      onPressed: onPressed,
      variant: ButtonVariant.outline,
      child: child,
    );
  }
}