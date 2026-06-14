// lib/widgets/cart_button.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/sign_provider.dart';
import '../models/sign_model.dart';
import '../data/app_theme.dart';

class CartButton extends StatefulWidget {
  final CartItem item;
  final bool fullWidth;

  const CartButton({
    super.key,
    required this.item,
    this.fullWidth = true,
  });

  @override
  State<CartButton> createState() => _CartButtonState();
}

class _CartButtonState extends State<CartButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _scaleAnim = Tween<double>(begin: 1.0, end: 0.93).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  Future<void> _handleTap(SignProvider provider) async {
    await _animController.forward();
    await _animController.reverse();
    provider.toggleCart(widget.item);

    if (mounted) {
      final inCart = provider.isInCart(widget.item.id);
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(
                inCart ? Icons.bookmark_added : Icons.bookmark_remove,
                color: Colors.white,
                size: 18,
              ),
              const SizedBox(width: 8),
              Text(
                inCart
                    ? '${widget.item.displayName} added to cart'
                    : '${widget.item.displayName} removed from cart',
              ),
            ],
          ),
          backgroundColor:
              inCart ? AppTheme.primary : AppTheme.textSecondary,
          behavior: SnackBarBehavior.floating,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          duration: const Duration(seconds: 2),
          margin: const EdgeInsets.all(16),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SignProvider>(
      builder: (context, provider, _) {
        final inCart = provider.isInCart(widget.item.id);

        return ScaleTransition(
          scale: _scaleAnim,
          child: SizedBox(
            width: widget.fullWidth ? double.infinity : null,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              child: ElevatedButton.icon(
                onPressed: () => _handleTap(provider),
                icon: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 250),
                  child: Icon(
                    inCart ? Icons.bookmark : Icons.bookmark_border,
                    key: ValueKey(inCart),
                    size: 20,
                  ),
                ),
                label: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 250),
                  child: Text(
                    inCart ? AppStrings.inCart : AppStrings.addToCart,
                    key: ValueKey(inCart),
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      inCart ? AppTheme.accent : AppTheme.primary,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 24, vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  textStyle: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.3,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

// Compact icon-only cart button for cards
class CartIconButton extends StatelessWidget {
  final CartItem item;

  const CartIconButton({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Consumer<SignProvider>(
      builder: (context, provider, _) {
        final inCart = provider.isInCart(item.id);
        return GestureDetector(
          onTap: () => provider.toggleCart(item),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color:
                  inCart ? AppTheme.accent : AppTheme.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              inCart ? Icons.bookmark : Icons.bookmark_border,
              color: inCart ? Colors.white : AppTheme.primary,
              size: 20,
            ),
          ),
        );
      },
    );
  }
}

