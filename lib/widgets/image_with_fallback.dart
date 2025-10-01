import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class ImageWithFallbackEnhanced extends StatefulWidget {
  final String? src;
  final String? alt;
  final double? width;
  final double? height;
  final BoxFit? fit;
  final Color? backgroundColor;
  final BorderRadius? borderRadius;
  final Widget? customErrorWidget;

  const ImageWithFallbackEnhanced({
    super.key,
    required this.src,
    this.alt,
    this.width,
    this.height,
    this.fit,
    this.backgroundColor,
    this.borderRadius,
    this.customErrorWidget,
  });

  @override
  State<ImageWithFallbackEnhanced> createState() => _ImageWithFallbackEnhancedState();
}

class _ImageWithFallbackEnhancedState extends State<ImageWithFallbackEnhanced> {
  bool _didError = false;

  void _handleImageError(Object exception, StackTrace? stackTrace) {
    if (mounted) {
      setState(() {
        _didError = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_didError || widget.src == null || widget.src!.isEmpty) {
      return _buildErrorWidget();
    }

    return Image.network(
      widget.src!,
      width: widget.width,
      height: widget.height,
      fit: widget.fit ?? BoxFit.cover,
      errorBuilder: (context, error, stackTrace) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            setState(() {
              _didError = true;
            });
          }
        });
        return _buildErrorWidget();
      },
    );
  }

  Widget _buildErrorWidget() {
    if (widget.customErrorWidget != null) {
      return widget.customErrorWidget!;
    }

    return Container(
      width: widget.width,
      height: widget.height,
      decoration: BoxDecoration(
        color: widget.backgroundColor ?? Colors.grey[100],
        borderRadius: widget.borderRadius,
      ),
      child: Center(
        child: SvgPicture.network(
          'data:image/svg+xml;base64,PHN2ZyB3aWR0aD0iODgiIGhlaWdodD0iODgiIHhtbG5zPSJodHRwOi8vd3d3LnczLm9yZy8yMDAwL3N2ZyIgc3Ryb2tlPSIjMDAwIiBzdHJva2UtbGluZWpvaW49InJvdW5kIiBvcGFjaXR5PSIuMyIgZmlsbD0ibm9uZSIgc3Ryb2tlLXdpZHRoPSIzLjciPjxyZWN0IHg9IjE2IiB5PSIxNiIgd2lkdGg9IjU2IiBoZWlnaHQ9IjU2IiByeD0iNiIvPjxwYXRoIGQ9Im0xNiA1OCAxNi0xOCAzMiAzMiIvPjxjaXJjbGUgY3g9IjUzIiBjeT0iMzUiIHI9IjciLz48L3N2Zz4KCg==',
          width: widget.width != null ? widget.width! * 0.5 : 44,
          height: widget.height != null ? widget.height! * 0.5 : 44,
          colorFilter: ColorFilter.mode(
            Colors.grey[400]!,
            BlendMode.srcIn,
          ),
        ),
      ),
    );
  }
}