import 'package:flutter/material.dart';
import 'package:glass/glass.dart';

class GlassContainer extends StatelessWidget {
  const GlassContainer({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.tintColor,
    this.blurX = 20,
    this.blurY = 20,
    this.borderRadius = 28,
    this.constraints,
    this.alignment,
  });

  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final Color? tintColor;
  final double blurX;
  final double blurY;
  final double borderRadius;
  final BoxConstraints? constraints;
  final AlignmentGeometry? alignment;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      padding: padding,
      constraints: constraints,
      alignment: alignment,
      child: child,
    ).asGlass(
      tintColor: tintColor ?? Colors.white.withOpacity(0.1),
      blurX: blurX,
      blurY: blurY,
      clipBorderRadius: BorderRadius.circular(borderRadius),
    );
  }
} 