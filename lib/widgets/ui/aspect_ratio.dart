import 'package:flutter/material.dart';

class AspectRatio extends StatelessWidget {
  final double ratio;
  final Widget? child;

  const AspectRatio({
    super.key,
    required this.ratio,
    this.child,
  });

  /// Common aspect ratio presets
  const AspectRatio.square({
    super.key,
    Widget? child,
  })  : ratio = 1,
        child = child;

  const AspectRatio.video({
    super.key,
    Widget? child,
  })  : ratio = 16 / 9,
        child = child;

  const AspectRatio.photo({
    super.key,
    Widget? child,
  })  : ratio = 4 / 3,
        child = child;

  const AspectRatio.panorama({
    super.key,
    Widget? child,
  })  : ratio = 2 / 1,
        child = child;

  const AspectRatio.portrait({
    super.key,
    Widget? child,
  })  : ratio = 3 / 4,
        child = child;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double maxWidth = constraints.maxWidth;
        final double maxHeight = constraints.maxHeight;

        double width = maxWidth;
        double height = maxWidth / ratio;

        // If the calculated height exceeds available height, adjust width
        if (height > maxHeight) {
          height = maxHeight;
          width = maxHeight * ratio;
        }

        return SizedBox(
          width: width,
          height: height,
          child: child,
        );
      },
    );
  }
}

// Alternative implementation using Flutter's built-in AspectRatio widget
class AspectRatioBox extends StatelessWidget {
  final double ratio;
  final Widget? child;

  const AspectRatioBox({
    super.key,
    required this.ratio,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: ratio,
      child: child,
    );
  }
}

// Enhanced version with more features
class AdvancedAspectRatio extends StatelessWidget {
  final double ratio;
  final Widget? child;
  final double? maxWidth;
  final double? maxHeight;
  final AlignmentGeometry alignment;
  final BoxFit? fit;

  const AdvancedAspectRatio({
    super.key,
    required this.ratio,
    this.child,
    this.maxWidth,
    this.maxHeight,
    this.alignment = Alignment.center,
    this.fit,
  });

  @override
  Widget build(BuildContext context) {
    Widget content = AspectRatio(
      aspectRatio: ratio,
      child: child,
    );

    // Apply max constraints if provided
    if (maxWidth != null || maxHeight != null) {
      content = ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: maxWidth ?? double.infinity,
          maxHeight: maxHeight ?? double.infinity,
        ),
        child: content,
      );
    }

    // Apply alignment
    if (alignment != Alignment.center) {
      content = Align(
        alignment: alignment,
        child: content,
      );
    }

    return content;
  }
}

// Aspect ratio container that maintains ratio while allowing content to be positioned
class AspectRatioContainer extends StatelessWidget {
  final double ratio;
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final Color? color;
  final Decoration? decoration;
  final BoxConstraints? constraints;

  const AspectRatioContainer({
    super.key,
    required this.ratio,
    required this.child,
    this.padding,
    this.color,
    this.decoration,
    this.constraints,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: constraints,
      child: AspectRatio(
        aspectRatio: ratio,
        child: Container(
          padding: padding,
          color: color,
          decoration: decoration,
          child: child,
        ),
      ),
    );
  }
}