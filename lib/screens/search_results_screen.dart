// lib/screens/search_results_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/sign_provider.dart';
import '../data/app_theme.dart';
import '../models/sign_model.dart';
import '../screens/sign_detail_screen.dart';
import '../widgets/sign_image_widget.dart';

class SearchResultsScreen extends StatefulWidget {
  final String query;

  const SearchResultsScreen({super.key, required this.query});

  @override
  State<SearchResultsScreen> createState() => _SearchResultsScreenState();
}

class _SearchResultsScreenState extends State<SearchResultsScreen> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.query);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SignProvider>().setSearchQuery(widget.query);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.surface,
      appBar: AppBar(
        backgroundColor: AppTheme.primaryDark,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new,
              color: Colors.white, size: 20),
          onPressed: () {
            context.read<SignProvider>().clearSearch();
            Navigator.pop(context);
          },
        ),
        title: Container(
          height: 42,
          padding: const EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.14),
            borderRadius: BorderRadius.circular(12),
          ),
          child: TextField(
            controller: _controller,
            autofocus: true,
            style: const TextStyle(color: Colors.white, fontSize: 16),
            cursorColor: Colors.white70,
            decoration: const InputDecoration(
              hintText: 'Search signs...',
              hintStyle: TextStyle(color: Colors.white70, fontSize: 15),
              border: InputBorder.none,
            ),
            onChanged: (val) =>
                context.read<SignProvider>().setSearchQuery(val),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.clear, color: Colors.white70, size: 20),
            onPressed: () {
              _controller.clear();
              context.read<SignProvider>().clearSearch();
            },
          ),
        ],
      ),
      body: Consumer<SignProvider>(
        builder: (context, provider, _) {
          final alphaResults = provider.filteredAlphabets;
          final wordResults = provider.filteredWords;
          final totalResults = alphaResults.length + wordResults.length;

          if (provider.searchQuery.isEmpty) {
            return _buildEmptySearch();
          }

          if (totalResults == 0) {
            return _buildNoResults(provider.searchQuery);
          }

          return ListView(
            padding: const EdgeInsets.all(18),
            children: [
              // Results count
              Padding(
                padding: const EdgeInsets.only(bottom: 14),
                child: Text(
                  '$totalResults result${totalResults != 1 ? 's' : ''} for "${provider.searchQuery}"',
                  style: const TextStyle(
                    color: AppTheme.textSecondary,
                    fontSize: 13.5,
                  ),
                ),
              ),

              // Alphabet results
              if (alphaResults.isNotEmpty) ...[
                _SectionHeader(
                  title: 'Letters',
                  count: alphaResults.length,
                  icon: Icons.sort_by_alpha,
                  color: AppTheme.primary,
                ),
                const SizedBox(height: 10),
                SizedBox(
                  height: 90,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: alphaResults.length,
                    itemBuilder: (context, index) {
                      final sign = alphaResults[index];
                      final cartItem = CartItem.fromAlphabet(sign);
                      return Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: GestureDetector(
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => SignDetailScreen(
                                cartItem: cartItem,
                                title: 'Letter ${sign.letter}',
                              ),
                            ),
                          ),
                          child: Container(
                            width: 72,
                            decoration: BoxDecoration(
                              color: AppTheme.surfaceCard,
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(color: AppTheme.divider),
                              boxShadow: [
                                BoxShadow(
                                  color: AppTheme.primary.withValues(alpha: 0.06),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  sign.letter,
                                  style: const TextStyle(
                                    fontSize: 28,
                                    fontWeight: FontWeight.w900,
                                    color: AppTheme.primary,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                const Text(
                                  'Letter',
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: AppTheme.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 20),
              ],

              // Word results
              if (wordResults.isNotEmpty) ...[
                _SectionHeader(
                  title: 'Words',
                  count: wordResults.length,
                  icon: Icons.library_books,
                  color: const Color(0xFF1565C0),
                ),
                const SizedBox(height: 10),
                ...wordResults.map((word) {
                  final cartItem = CartItem.fromWord(word);
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: GestureDetector(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => SignDetailScreen(
                            cartItem: cartItem,
                            title: word.word,
                          ),
                        ),
                      ),
                      child: Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: AppTheme.surfaceCard,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: AppTheme.divider),
                          boxShadow: [
                            BoxShadow(
                              color: AppTheme.primary.withValues(alpha: 0.05),
                              blurRadius: 10,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: SignThumbnail(
                                imagePath: word.image,
                                label: word.word,
                                size: 60,
                              ),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    word.word,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                      color: AppTheme.textPrimary,
                                    ),
                                  ),
                                  const SizedBox(height: 3),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 7, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: AppTheme.categoryColor(word.category)
                                          .withValues(alpha: 0.1),
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: Text(
                                      word.category,
                                      style: TextStyle(
                                        fontSize: 10,
                                        color: AppTheme.categoryColor(
                                            word.category),
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    word.description,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: AppTheme.textSecondary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Icon(Icons.chevron_right,
                                color: AppTheme.textLight),
                          ],
                        ),
                      ),
                    ),
                  );
                }),
              ],
            ],
          );
        },
      ),
    );
  }

  Widget _buildEmptySearch() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search, size: 52, color: AppTheme.textLight),
          SizedBox(height: 12),
          Text(
            'Type to search signs',
            style: TextStyle(
                color: AppTheme.textSecondary,
                fontSize: 16,
                fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  Widget _buildNoResults(String query) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.search_off, size: 52, color: AppTheme.textLight),
            const SizedBox(height: 16),
            Text(
              'No signs found for "$query"',
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: AppTheme.textPrimary,
                fontSize: 17,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Try searching a different letter, word, or description.',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppTheme.textSecondary, fontSize: 13),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final int count;
  final IconData icon;
  final Color color;

  const _SectionHeader({
    required this.title,
    required this.count,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: color, size: 16),
        const SizedBox(width: 6),
        Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 15,
            color: color,
          ),
        ),
        const SizedBox(width: 6),
        Container(
          padding:
              const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            '$count',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
        ),
      ],
    );
  }
}
