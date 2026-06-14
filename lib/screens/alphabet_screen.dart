// lib/screens/alphabet_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/sign_provider.dart';
import '../data/app_theme.dart';
import '../models/sign_model.dart';
import '../screens/sign_detail_screen.dart';

class AlphabetScreen extends StatelessWidget {
  const AlphabetScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Consumer<SignProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading) {
            return const Center(
                child: CircularProgressIndicator(color: AppTheme.primary));
          }

          if (provider.error != null) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline,
                        size: 52, color: AppTheme.cartRed),
                    const SizedBox(height: 16),
                    Text(
                      provider.error!,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          color: AppTheme.textSecondary, fontSize: 14),
                    ),
                  ],
                ),
              ),
            );
          }

          return CustomScrollView(
            slivers: [
              SliverAppBar(
                floating: true,
                backgroundColor: AppTheme.primary,
                title: const Text(
                  'ISL Alphabets',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                      fontSize: 20),
                ),
                centerTitle: false,
                automaticallyImplyLeading: false,
                bottom: PreferredSize(
                  preferredSize: const Size.fromHeight(56),
                  child: Container(
                    padding:
                        const EdgeInsets.fromLTRB(16, 0, 16, 12),
                    child: TextField(
                      onChanged: provider.setSearchQuery,
                      style: const TextStyle(color: AppTheme.textPrimary),
                      decoration: InputDecoration(
                        hintText: 'Search letters...',
                        prefixIcon: const Icon(Icons.search,
                            color: AppTheme.textSecondary, size: 20),
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding:
                            const EdgeInsets.symmetric(vertical: 0),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              // Legend
              const SliverToBoxAdapter(
                child: Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Text(
                    'Tap a letter to view its ISL fingerspelling sign',
                    style: TextStyle(
                        color: AppTheme.textSecondary,
                        fontSize: 13),
                  ),
                ),
              ),

              // Grid
              SliverPadding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16),
                sliver: SliverGrid(
                  gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    childAspectRatio: 0.85,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final sign = provider.filteredAlphabets[index];
                      return _AlphabetCard(sign: sign);
                    },
                    childCount: provider.filteredAlphabets.length,
                  ),
                ),
              ),

              const SliverToBoxAdapter(child: SizedBox(height: 24)),
            ],
          );
        },
      ),
    );
  }
}

class _AlphabetCard extends StatefulWidget {
  final AlphabetSign sign;

  const _AlphabetCard({required this.sign});

  @override
  State<_AlphabetCard> createState() => _AlphabetCardState();
}

class _AlphabetCardState extends State<_AlphabetCard> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final cartItem = CartItem.fromAlphabet(widget.sign);

    return Consumer<SignProvider>(
      builder: (context, provider, _) {
        final inCart = provider.isInCart(cartItem.id);

        return GestureDetector(
          onTapDown: (_) => setState(() => _pressed = true),
          onTapUp: (_) => setState(() => _pressed = false),
          onTapCancel: () => setState(() => _pressed = false),
          onTap: () => Navigator.push(
            context,
            PageRouteBuilder(
              pageBuilder: (_, anim, __) => SignDetailScreen(
                cartItem: cartItem,
                title: 'Letter ${widget.sign.letter}',
              ),
              transitionsBuilder: (_, anim, __, child) => FadeTransition(
                opacity: anim,
                child: child,
              ),
              transitionDuration: const Duration(milliseconds: 250),
            ),
          ),
          child: AnimatedScale(
            scale: _pressed ? 0.95 : 1.0,
            duration: const Duration(milliseconds: 100),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              decoration: BoxDecoration(
                color: AppTheme.surfaceCard,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: inCart
                      ? AppTheme.accent.withValues(alpha: 0.5)
                      : AppTheme.divider,
                  width: inCart ? 2 : 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.primary.withValues(alpha: 0.07),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Letter
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: inCart
                          ? AppTheme.accent.withValues(alpha: 0.12)
                          : AppTheme.primary.withValues(alpha: 0.08),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        widget.sign.letter,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w900,
                          color: inCart
                              ? AppTheme.accent
                              : AppTheme.primary,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Letter ${widget.sign.letter}',
                    style: const TextStyle(
                      fontSize: 11,
                      color: AppTheme.textSecondary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 6),
                  // Cart icon
                  GestureDetector(
                    onTap: () => provider.toggleCart(cartItem),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: inCart
                            ? AppTheme.accent.withValues(alpha: 0.1)
                            : AppTheme.primary.withValues(alpha: 0.05),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        inCart ? Icons.bookmark : Icons.bookmark_border,
                        color: inCart ? AppTheme.accent : AppTheme.primary,
                        size: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
