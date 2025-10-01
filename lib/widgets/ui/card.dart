import 'package:flutter/material.dart';

class Card extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final Color? backgroundColor;
  final Color? borderColor;
  final double borderRadius;
  final double elevation;
  final EdgeInsetsGeometry? margin;

  const Card({
    super.key,
    required this.child,
    this.padding,
    this.backgroundColor,
    this.borderColor,
    this.borderRadius = 12,
    this.elevation = 0,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Container(
      margin: margin,
      decoration: BoxDecoration(
        color: backgroundColor ?? theme.colorScheme.surface,
        border: borderColor != null
            ? Border.all(color: borderColor!)
            : Border.all(
                color: theme.colorScheme.outline.withOpacity(0.2),
              ),
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: elevation > 0
            ? [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: elevation,
                  offset: const Offset(0, 1),
                ),
              ]
            : null,
      ),
      child: padding != null
          ? Padding(padding: padding!, child: child)
          : child,
    );
  }
}

class CardHeader extends StatelessWidget {
  final Widget child;
  final bool withBorder;

  const CardHeader({
    super.key,
    required this.child,
    this.withBorder = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: withBorder
          ? BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
                ),
              ),
            )
          : null,
      child: child,
    );
  }
}

class CardTitle extends StatelessWidget {
  final Widget child;

  const CardTitle({
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

class CardDescription extends StatelessWidget {
  final Widget child;

  const CardDescription({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return DefaultTextStyle(
      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
          ),
      child: child,
    );
  }
}

class CardContent extends StatelessWidget {
  final Widget child;
  final bool isLastChild;

  const CardContent({
    super.key,
    required this.child,
    this.isLastChild = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(24, 0, 24, isLastChild ? 24 : 0),
      child: child,
    );
  }
}

class CardFooter extends StatelessWidget {
  final Widget child;
  final bool withBorder;

  const CardFooter({
    super.key,
    required this.child,
    this.withBorder = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: withBorder
          ? BoxDecoration(
              border: Border(
                top: BorderSide(
                  color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
                ),
              ),
            )
          : null,
      child: child,
    );
  }
}

class CardAction extends StatelessWidget {
  final Widget child;

  const CardAction({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: child,
    );
  }
}

// Composite card for common patterns
class StyledCard extends StatelessWidget {
  final String? title;
  final String? description;
  final Widget? content;
  final List<Widget>? actions;
  final bool hasHeaderBorder;
  final bool hasFooterBorder;

  const StyledCard({
    super.key,
    this.title,
    this.description,
    this.content,
    this.actions,
    this.hasHeaderBorder = false,
    this.hasFooterBorder = false,
  });

  @override
  Widget build(BuildContext context) {
    final hasHeader = title != null || description != null;
    final hasFooter = actions != null && actions!.isNotEmpty;

    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          if (hasHeader) ...[
            CardHeader(
              withBorder: hasHeaderBorder,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (title != null)
                    CardTitle(child: Text(title!)),
                  if (description != null) ...[
                    if (title != null) const SizedBox(height: 4),
                    CardDescription(child: Text(description!)),
                  ],
                ],
              ),
            ),
          ],
          // Content
          if (content != null)
            CardContent(
              child: content!,
              isLastChild: !hasFooter,
            ),
          // Footer
          if (hasFooter) ...[
            CardFooter(
              withBorder: hasFooterBorder,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  for (final action in actions!) ...[
                    action,
                    if (action != actions!.last) const SizedBox(width: 8),
                  ],
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}