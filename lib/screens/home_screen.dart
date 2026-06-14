// lib/screens/home_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/sign_provider.dart';
import '../data/app_theme.dart';
import '../screens/alphabet_screen.dart';
import '../screens/words_screen.dart';
import '../screens/cart_screen.dart';
import '../screens/search_results_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    _HomeContent(),
    AlphabetScreen(),
    WordsScreen(),
    CartScreen(),
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: Consumer<SignProvider>(
        builder: (context, provider, _) {
          return Container(
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.08),
                  blurRadius: 20,
                  offset: const Offset(0, -4),
                ),
              ],
            ),
            child: BottomNavigationBar(
              currentIndex: _currentIndex,
              onTap: (index) => setState(() => _currentIndex = index),
              items: [
                const BottomNavigationBarItem(
                  icon: Icon(Icons.home_outlined),
                  activeIcon: Icon(Icons.home),
                  label: 'Home',
                ),
                const BottomNavigationBarItem(
                  icon: Icon(Icons.sort_by_alpha_outlined),
                  activeIcon: Icon(Icons.sort_by_alpha),
                  label: 'Alphabet',
                ),
                const BottomNavigationBarItem(
                  icon: Icon(Icons.library_books_outlined),
                  activeIcon: Icon(Icons.library_books),
                  label: 'Words',
                ),
                BottomNavigationBarItem(
                  icon: Badge(
                    isLabelVisible: provider.cartCount > 0,
                    label: Text('${provider.cartCount}'),
                    backgroundColor: AppTheme.accent,
                    child: const Icon(Icons.bookmark_border),
                  ),
                  activeIcon: Badge(
                    isLabelVisible: provider.cartCount > 0,
                    label: Text('${provider.cartCount}'),
                    backgroundColor: AppTheme.accent,
                    child: const Icon(Icons.bookmark),
                  ),
                  label: 'Cart',
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _HomeContent extends StatefulWidget {
  const _HomeContent();

  @override
  State<_HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<_HomeContent>
    with SingleTickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  late AnimationController _animController;
  late Animation<double> _fadeAnim;
  late Animation<Offset> _slideAnim;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeAnim = CurvedAnimation(
      parent: _animController,
      curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
    );
    _slideAnim = Tween<Offset>(
      begin: const Offset(0, 0.15),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animController,
      curve: const Interval(0.0, 0.7, curve: Curves.easeOut),
    ));
    _animController.forward();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _animController.dispose();
    super.dispose();
  }

  void _onSearch(String query) {
    if (query.trim().isEmpty) return;
    context.read<SignProvider>().setSearchQuery(query.trim());
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => SearchResultsScreen(query: query.trim()),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: FadeTransition(
        opacity: _fadeAnim,
        child: SlideTransition(
          position: _slideAnim,
          child: CustomScrollView(
            slivers: [
              // Header
              SliverToBoxAdapter(
                child: Container(
                  padding:
                      const EdgeInsets.fromLTRB(20, 32, 20, 28),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [AppTheme.primary, AppTheme.primaryDark],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.vertical(
                      bottom: Radius.circular(28),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Icon(
                              Icons.pan_tool,
                              color: Colors.white,
                              size: 24,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'ISL Pocket Signs',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 22,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: 0.2,
                                ),
                              ),
                              Text(
                                'Indian Sign Language Reference',
                                style: TextStyle(
                                  color: Colors.white.withValues(alpha: 0.78),
                                  fontSize: 13,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      // Search bar
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(14),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.08),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: TextField(
                          controller: _searchController,
                          onSubmitted: _onSearch,
                          textInputAction: TextInputAction.search,
                          style: const TextStyle(
                            color: AppTheme.textPrimary,
                            fontSize: 15,
                          ),
                          decoration: InputDecoration(
                            hintText: 'Search signs, words, letters...',
                            hintStyle: const TextStyle(
                                color: AppTheme.textLight, fontSize: 15),
                            prefixIcon: const Icon(Icons.search,
                                color: AppTheme.textSecondary),
                            suffixIcon: IconButton(
                              icon: Container(
                                width: 28,
                                height: 28,
                                decoration: BoxDecoration(
                                  color: AppTheme.primary.withValues(alpha: 0.08),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(Icons.arrow_forward,
                                    color: AppTheme.primary, size: 18),
                              ),
                              onPressed: () =>
                                  _onSearch(_searchController.text),
                            ),
                            border: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 14),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Error banner (shown if initialization failed)
              SliverToBoxAdapter(
                child: Consumer<SignProvider>(
                  builder: (context, provider, _) {
                    if (provider.error == null) return const SizedBox.shrink();
                    return Container(
                      margin: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: AppTheme.cartRed.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                            color: AppTheme.cartRed.withValues(alpha: 0.3)),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.error_outline,
                              color: AppTheme.cartRed, size: 18),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              provider.error!,
                              style: const TextStyle(
                                  fontSize: 12, color: AppTheme.cartRed),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),

              // Quick stats
              SliverToBoxAdapter(
                child: Consumer<SignProvider>(
                  builder: (context, provider, _) => Padding(
                    padding: const EdgeInsets.fromLTRB(20, 24, 20, 8),
                    child: Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: [
                        _StatChip(
                          icon: Icons.sort_by_alpha,
                          label: '26 Letters',
                          color: AppTheme.primary,
                        ),
                        _StatChip(
                          icon: Icons.library_books,
                          label:
                              '${provider.words.length} Words',
                          color: AppTheme.accent,
                        ),
                        _StatChip(
                          icon: Icons.bookmark,
                          label:
                              '${provider.cartCount} Saved',
                          color: AppTheme.primaryLight,
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // Section title
              const SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(20, 20, 20, 12),
                  child: Text(
                    'What would you like to explore?',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                ),
              ),

              // Main menu cards
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      _MainMenuCard(
                        title: 'Browse Alphabets',
                        subtitle: 'A to Z · Fingerspelling guide',
                        icon: Icons.sort_by_alpha,
                        color: AppTheme.primary,
                        onTap: () {
                          final homeState = context
                              .findAncestorStateOfType<_HomeScreenState>();
                          homeState?.setState(() => homeState._currentIndex = 1);
                        },
                      ),
                      const SizedBox(height: 12),
                      _MainMenuCard(
                        title: 'Browse Words',
                        subtitle: 'Common signs · Greetings · Daily life',
                        icon: Icons.library_books,
                        color: const Color(0xFF1565C0),
                        onTap: () {
                          final homeState = context
                              .findAncestorStateOfType<_HomeScreenState>();
                          homeState?.setState(() => homeState._currentIndex = 2);
                        },
                      ),
                      const SizedBox(height: 12),
                      _MainMenuCard(
                        title: 'My Sign Cart',
                        subtitle: 'Your personal sign collection',
                        icon: Icons.bookmark,
                        color: AppTheme.accent,
                        onTap: () {
                          final homeState = context
                              .findAncestorStateOfType<_HomeScreenState>();
                          homeState?.setState(() => homeState._currentIndex = 3);
                        },
                      ),
                    ],
                  ),
                ),
              ),

              // ISL info footer
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppTheme.primary.withValues(alpha: 0.06),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                          color: AppTheme.primary.withValues(alpha: 0.15)),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.info_outline,
                            color: AppTheme.primary, size: 18),
                        const SizedBox(width: 10),
                        const Expanded(
                          child: Text(
                            'Signs are based on ISLRTC standards. Add images to assets/ for full experience.',
                            style: TextStyle(
                              fontSize: 12,
                              color: AppTheme.textSecondary,
                              height: 1.5,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              const SliverToBoxAdapter(child: SizedBox(height: 20)),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const _StatChip(
      {required this.icon, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 15),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 12.5,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _MainMenuCard extends StatefulWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _MainMenuCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  State<_MainMenuCard> createState() => _MainMenuCardState();
}

class _MainMenuCardState extends State<_MainMenuCard> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) => setState(() => _pressed = false),
      onTapCancel: () => setState(() => _pressed = false),
      onTap: widget.onTap,
      child: AnimatedScale(
        scale: _pressed ? 0.97 : 1.0,
        duration: const Duration(milliseconds: 120),
        child: Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: AppTheme.surfaceCard,
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: widget.color.withValues(alpha: 0.1),
                blurRadius: 16,
                offset: const Offset(0, 4),
              ),
            ],
            border: Border.all(
              color: widget.color.withValues(alpha: 0.12),
              width: 1.5,
            ),
          ),
          child: Row(
            children: [
              Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                  color: widget.color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Center(
                  child: Icon(
                    widget.icon,
                    color: widget.color,
                    size: 28,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      widget.subtitle,
                      style: const TextStyle(
                        fontSize: 13,
                        color: AppTheme.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right,
                color: widget.color.withValues(alpha: 0.6),
                size: 22,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
