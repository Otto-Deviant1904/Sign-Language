// lib/widgets/sign_image_widget.dart

import 'package:flutter/material.dart';
import '../data/app_theme.dart';

/// Displays a sign image with graceful fallback placeholder.
/// Supports local assets and network URLs.
/// When real ISL images are added, just update the asset paths in JSON.
class SignImageWidget extends StatelessWidget {
  final String imagePath;
  final double? width;
  final double? height;
  final BoxFit fit;
  final String label;

  const SignImageWidget({
    super.key,
    required this.imagePath,
    this.width,
    this.height,
    this.fit = BoxFit.contain,
    required this.label,
  });

  bool get _isNetwork =>
      imagePath.startsWith('http://') || imagePath.startsWith('https://');

  @override
  Widget build(BuildContext context) {
    if (_isNetwork) {
      return _buildNetworkImage();
    }
    return _buildAssetImage();
  }

  Widget _buildAssetImage() {
    return Image.asset(
      imagePath,
      width: width,
      height: height,
      fit: fit,
      errorBuilder: (context, error, stackTrace) => _buildPlaceholder(),
    );
  }

  Widget _buildNetworkImage() {
    return Image.network(
      imagePath,
      width: width,
      height: height,
      fit: fit,
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return _buildLoadingIndicator(loadingProgress);
      },
      errorBuilder: (context, error, stackTrace) => _buildPlaceholder(),
    );
  }

  Widget _buildLoadingIndicator(ImageChunkEvent progress) {
    return SizedBox(
      width: width,
      height: height,
      child: Center(
        child: CircularProgressIndicator(
          value: progress.expectedTotalBytes != null
              ? progress.cumulativeBytesLoaded / progress.expectedTotalBytes!
              : null,
          color: AppTheme.primary,
          strokeWidth: 2,
        ),
      ),
    );
  }

  Widget _buildPlaceholder() {
    // Beautiful hand-sign placeholder using text + icon
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFE8F5E9),
            Color(0xFFB2DFDB),
          ],
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppTheme.primary.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Text(
              label.length == 1 ? label : label.substring(0, 1).toUpperCase(),
              style: TextStyle(
                fontSize: (height ?? 200) * 0.25,
                fontWeight: FontWeight.w900,
                color: AppTheme.primary,
                height: 1,
              ),
            ),
          ),
          const SizedBox(height: 12),
          const Icon(
            Icons.pan_tool_outlined,
            color: AppTheme.primaryLight,
            size: 28,
          ),
          const SizedBox(height: 8),
          const Text(
            'Image coming soon',
            style: TextStyle(
              fontSize: 11,
              color: AppTheme.textSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Add to assets/alphabet/ or\nassets/words/ folder',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 9,
              color: AppTheme.textLight,
            ),
          ),
        ],
      ),
    );
  }
}

/// Compact sign image for grid/list cards
class SignThumbnail extends StatelessWidget {
  final String imagePath;
  final String label;
  final double size;

  const SignThumbnail({
    super.key,
    required this.imagePath,
    required this.label,
    this.size = 80,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: SignImageWidget(
        imagePath: imagePath,
        width: size,
        height: size,
        fit: BoxFit.cover,
        label: label,
      ),
    );
  }
}
