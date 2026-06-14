// lib/screens/words_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/sign_provider.dart';
import '../data/app_theme.dart';
import '../models/sign_model.dart';
import '../screens/sign_detail_screen.dart';
import '../widgets/sign_image_widget.dart';

class WordsScreen extends StatefulWidget {
  const WordsScreen({super.key});

  @override
  State<WordsScreen> createState() => _WordsScreenState();
}

class _WordsScreenState extends State<WordsScreen> {
  String? _selectedCategory;

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

          final categories = ['All', ...provider.wordCategories];
          final words = _selectedCategory == null || _selectedCategory == 'All'
              ? provider.filteredWords
              : provider.filteredWords
                  .where((w) => w.category == _selectedCategory)
                  .toList();

          return CustomScrollView(
            slivers: [
              SliverAppBar(
                floating: true,
                backgroundColor: AppTheme.primaryDark,
                title: const Text(
                  'ISL Words',
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
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                    child: TextField(
                      onChanged: provider.setSearchQuery,
                      style:
                          const TextStyle(color: AppTheme.textPrimary, fontSize: 15),
                      decoration: InputDecoration(
                        hintText: 'Search words...',
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

              // Category chips
              SliverToBoxAdapter(
                child: SizedBox(
                  height: 56,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    itemCount: categories.length,
                    itemBuilder: (context, index) {
                      final cat = categories[index];
                      final selected =
                          (_selectedCategory == null && cat == 'All') ||
                              _selectedCategory == cat;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: GestureDetector(
                          onTap: () => setState(() =>
                              _selectedCategory = cat == 'All' ? null : cat),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 15, vertical: 8),
                            decoration: BoxDecoration(
                              color: selected
                                  ? AppTheme.primary
                                  : AppTheme.surfaceCard,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: selected
                                    ? AppTheme.primary
                                    : AppTheme.divider,
                              ),
                            ),
                            child: Text(
                              cat,
                              style: TextStyle(
                                color: selected
                                    ? Colors.white
                                    : AppTheme.textSecondary,
                                fontWeight: FontWeight.w600,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),

              // Word count
              SliverToBoxAdapter(
                child: Padding(
                  padding:
                      const EdgeInsets.fromLTRB(16, 4, 16, 8),
                  child: Text(
                    '${words.length} sign${words.length != 1 ? 's' : ''}',
                    style: const TextStyle(
                        color: AppTheme.textSecondary, fontSize: 13.5),
                  ),
                ),
              ),

              // Words list
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: _WordCard(word: words[index]),
                      );
                    },
                    childCount: words.length,
                  ),
                ),
              ),

              if (words.isEmpty)
                const SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.all(40),
                    child: Center(
                      child: Column(
                        children: [
                          Icon(Icons.search_off,
                              size: 48, color: AppTheme.textLight),
                          SizedBox(height: 12),
                          Text('No signs found',
                              style: TextStyle(
                                  color: AppTheme.textSecondary,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600)),
                          SizedBox(height: 4),
                          Text('Try a different search term',
                              style: TextStyle(
                                  color: AppTheme.textLight, fontSize: 13)),
                        ],
                      ),
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

class _WordCard extends StatefulWidget {
  final WordSign word;

  const _WordCard({required this.word});

  @override
  State<_WordCard> createState() => _WordCardState();
}

class _WordCardState extends State<_WordCard> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final cartItem = CartItem.fromWord(widget.word);

    return Consumer<SignProvider>(
      builder: (context, provider, _) {
        final inCart = provider.isInCart(cartItem.id);
        final categoryColor = AppTheme.categoryColor(widget.word.category);

        return GestureDetector(
          onTapDown: (_) => setState(() => _pressed = true),
          onTapUp: (_) => setState(() => _pressed = false),
          onTapCancel: () => setState(() => _pressed = false),
          onTap: () => Navigator.push(
            context,
            PageRouteBuilder(
              pageBuilder: (_, anim, __) => SignDetailScreen(
                cartItem: cartItem,
                title: widget.word.word,
              ),
              transitionsBuilder: (_, anim, __, child) => SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(1.0, 0.0),
                  end: Offset.zero,
                ).animate(CurvedAnimation(
                    parent: anim, curve: Curves.easeOutCubic)),
                child: child,
              ),
              transitionDuration: const Duration(milliseconds: 280),
            ),
          ),
          child: AnimatedScale(
            scale: _pressed ? 0.97 : 1.0,
            duration: const Duration(milliseconds: 100),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppTheme.surfaceCard,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: inCart
                      ? AppTheme.accent.withValues(alpha: 0.4)
                      : AppTheme.divider,
                  width: inCart ? 2 : 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: categoryColor.withValues(alpha: 0.06),
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
                      imagePath: widget.word.image,
                      label: widget.word.word,
                      size: 72,
                    ),
                  ),
                  const SizedBox(width: 14),
                  // Info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.word.word,
                          style: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                            color: AppTheme.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: categoryColor.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            widget.word.category,
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: categoryColor,
                            ),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          widget.word.description,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 13,
                            color: AppTheme.textSecondary,
                            height: 1.45,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  // Bookmark
                  GestureDetector(
                    onTap: () => provider.toggleCart(cartItem),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: inCart
                            ? AppTheme.accent.withValues(alpha: 0.1)
                            : AppTheme.primary.withValues(alpha: 0.05),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        inCart ? Icons.bookmark : Icons.bookmark_border,
                        color:
                            inCart ? AppTheme.accent : AppTheme.primary,
                        size: 20,
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
