// lib/screens/cart_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/sign_provider.dart';
import '../data/app_theme.dart';
import '../models/sign_model.dart';
import '../screens/sign_detail_screen.dart';
import '../widgets/sign_image_widget.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Consumer<SignProvider>(
        builder: (context, provider, _) {
          return CustomScrollView(
            slivers: [
              SliverAppBar(
                floating: false,
                pinned: true,
                backgroundColor: AppTheme.accent,
                title: Row(
                  children: [
                    const Text(
                      'My Sign Cart',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                          fontSize: 20),
                    ),
                    if (provider.cartCount > 0) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.25),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          '${provider.cartCount}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                centerTitle: false,
                automaticallyImplyLeading: false,
                actions: [
                  if (provider.cartCount > 0)
                    TextButton.icon(
                      onPressed: () => _confirmClear(context, provider),
                      icon: const Icon(Icons.delete_outline,
                          color: Colors.white70, size: 18),
                      label: const Text(
                        'Clear all',
                        style:
                            TextStyle(color: Colors.white70, fontSize: 13),
                      ),
                    ),
                ],
              ),

              if (provider.cart.isEmpty)
                SliverFillRemaining(
                  child: _EmptyCart(),
                )
              else ...[
                // Summary header
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                    child: Text(
                      '${provider.cartCount} sign${provider.cartCount != 1 ? 's' : ''} saved',
                      style: const TextStyle(
                          color: AppTheme.textSecondary, fontSize: 13),
                    ),
                  ),
                ),

                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final item = provider.cart[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: _CartItemCard(item: item),
                        );
                      },
                      childCount: provider.cartCount,
                    ),
                  ),
                ),

                const SliverToBoxAdapter(child: SizedBox(height: 24)),
              ],
            ],
          );
        },
      ),
    );
  }

  void _confirmClear(BuildContext context, SignProvider provider) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        title: const Text('Clear Cart?',
            style: TextStyle(fontWeight: FontWeight.w700)),
        content:
            const Text('Remove all saved signs from your cart?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel',
                style: TextStyle(color: AppTheme.textSecondary)),
          ),
          ElevatedButton(
            onPressed: () {
              provider.clearCart();
              Navigator.pop(ctx);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.cartRed,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
            ),
            child: const Text('Clear All'),
          ),
        ],
      ),
    );
  }
}

class _CartItemCard extends StatefulWidget {
  final CartItem item;

  const _CartItemCard({required this.item});

  @override
  State<_CartItemCard> createState() => _CartItemCardState();
}

class _CartItemCardState extends State<_CartItemCard> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final isAlphabet = widget.item.type == CartItemType.alphabet;
    final accentColor = isAlphabet ? AppTheme.primary : const Color(0xFF1565C0);

    return Dismissible(
      key: Key(widget.item.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        decoration: BoxDecoration(
          color: AppTheme.cartRed.withOpacity(0.12),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.delete_outline, color: AppTheme.cartRed, size: 24),
            const SizedBox(height: 4),
            Text('Remove',
                style: TextStyle(
                    color: AppTheme.cartRed,
                    fontSize: 11,
                    fontWeight: FontWeight.w600)),
          ],
        ),
      ),
      onDismissed: (_) =>
          context.read<SignProvider>().removeFromCart(widget.item.id),
      child: GestureDetector(
        onTapDown: (_) => setState(() => _pressed = true),
        onTapUp: (_) => setState(() => _pressed = false),
        onTapCancel: () => setState(() => _pressed = false),
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => SignDetailScreen(
              cartItem: widget.item,
              title: widget.item.displayName,
            ),
          ),
        ),
        child: AnimatedScale(
          scale: _pressed ? 0.97 : 1.0,
          duration: const Duration(milliseconds: 100),
          child: Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppTheme.surfaceCard,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppTheme.divider, width: 1.5),
              boxShadow: [
                BoxShadow(
                  color: accentColor.withOpacity(0.05),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                // Thumbnail
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: SignThumbnail(
                    imagePath: widget.item.image,
                    label: widget.item.displayName,
                    size: 68,
                  ),
                ),
                const SizedBox(width: 14),
                // Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: accentColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              isAlphabet ? 'ALPHABET' : 'WORD',
                              style: TextStyle(
                                fontSize: 9,
                                fontWeight: FontWeight.w800,
                                color: accentColor,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        widget.item.displayName,
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        widget.item.description,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppTheme.textSecondary,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                // Remove button
                GestureDetector(
                  onTap: () =>
                      context.read<SignProvider>().removeFromCart(widget.item.id),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppTheme.cartRed.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.close,
                        color: AppTheme.cartRed, size: 18),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _EmptyCart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(28),
              decoration: BoxDecoration(
                color: AppTheme.accent.withOpacity(0.08),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.bookmark_border,
                size: 56,
                color: AppTheme.accent,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Your sign cart is empty',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: AppTheme.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Browse alphabets or words and tap the\nbookmark icon to save signs here.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: AppTheme.textSecondary,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 28),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: AppTheme.primary.withOpacity(0.06),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppTheme.primary.withOpacity(0.2)),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.swipe_left_outlined,
                      color: AppTheme.primary, size: 16),
                  SizedBox(width: 8),
                  Text(
                    'Swipe left to remove saved signs',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppTheme.primary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
