import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

import 'app_themes.dart';

PaintingEffect _shimmerOf(AppPalette palette) {
  return ShimmerEffect(baseColor: palette.skeletonBase, highlightColor: palette.skeletonHighlight);
}

/// Shows [child] as a shimmering skeleton while [enabled]: the real layout is kept and its
/// texts, icons and images become placeholder "bones" in the colors of the current theme.
class AppSkeletonizer extends StatelessWidget {
  final bool enabled;
  final Widget child;

  const AppSkeletonizer({super.key, required this.child, this.enabled = true});

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(enabled: enabled, effect: _shimmerOf(context.palette), child: child);
  }
}

/// Shimmering placeholder shown where an image is being downloaded.
class ImageLoadingSkeleton extends StatelessWidget {
  final double? width;
  final double? height;

  const ImageLoadingSkeleton({super.key, this.width, this.height});

  @override
  Widget build(BuildContext context) {
    return Skeletonizer.zone(
      effect: _shimmerOf(context.palette),
      child: Bone(width: width ?? double.infinity, height: height ?? double.infinity),
    );
  }
}
