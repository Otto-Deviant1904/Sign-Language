// lib/providers/sign_provider.dart

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/sign_model.dart';

class SignProvider extends ChangeNotifier {
  List<AlphabetSign> _alphabets = [];
  List<WordSign> _words = [];
  List<CartItem> _cart = [];
  String _searchQuery = '';
  bool _isLoading = true;
  String? _error;

  // Cached filtered lists — rebuilt only when _searchQuery or data changes
  List<AlphabetSign> _cachedFilteredAlphabets = [];
  List<WordSign> _cachedFilteredWords = [];
  String _lastCachedQuery = '';

  void _rebuildFilterCache() {
    _lastCachedQuery = _searchQuery;
    if (_searchQuery.isEmpty) {
      _cachedFilteredAlphabets = _alphabets;
      _cachedFilteredWords = _words;
      return;
    }
    final q = _searchQuery.toLowerCase();
    _cachedFilteredAlphabets = _alphabets
        .where((a) =>
            a.letter.toLowerCase().contains(q) ||
            a.description.toLowerCase().contains(q))
        .toList();
    _cachedFilteredWords = _words
        .where((w) =>
            w.word.toLowerCase().contains(q) ||
            w.description.toLowerCase().contains(q) ||
            w.category.toLowerCase().contains(q))
        .toList();
  }

  // Getters
  List<AlphabetSign> get alphabets => _alphabets;
  List<WordSign> get words => _words;
  List<CartItem> get cart => _cart;
  bool get isLoading => _isLoading;
  String? get error => _error;
  int get cartCount => _cart.length;

  List<AlphabetSign> get filteredAlphabets {
    if (_lastCachedQuery != _searchQuery) _rebuildFilterCache();
    return _cachedFilteredAlphabets;
  }

  List<WordSign> get filteredWords {
    if (_lastCachedQuery != _searchQuery) _rebuildFilterCache();
    return _cachedFilteredWords;
  }

  bool get hasSearchResults =>
      filteredAlphabets.isNotEmpty || filteredWords.isNotEmpty;

  String get searchQuery => _searchQuery;

  // Initialize - load data
  Future<void> initialize() async {
    try {
      _isLoading = true;
      notifyListeners();

      // Load alphabet data
      final alphaJson = await rootBundle.loadString('assets/data/alphabet.json');
      final alphaList = json.decode(alphaJson) as List;
      _alphabets = alphaList.map((e) => AlphabetSign.fromJson(e)).toList();

      // Load words data
      final wordsJson = await rootBundle.loadString('assets/data/words.json');
      final wordsList = json.decode(wordsJson) as List;
      _words = wordsList.map((e) => WordSign.fromJson(e)).toList();

      // Load saved cart
      await _loadCart();

      _isLoading = false;
      _error = null;
      _rebuildFilterCache();
    } catch (e) {
      _error = 'Failed to load sign data: $e';
      _isLoading = false;
    }
    notifyListeners();
  }

  // Search
  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void clearSearch() {
    _searchQuery = '';
    notifyListeners();
  }

  // Cart management
  bool isInCart(String cartId) {
    return _cart.any((item) => item.id == cartId);
  }

  void addToCart(CartItem item) {
    if (!isInCart(item.id)) {
      _cart.add(item);
      _saveCart();
      notifyListeners();
    }
  }

  void removeFromCart(String cartId) {
    _cart.removeWhere((item) => item.id == cartId);
    _saveCart();
    notifyListeners();
  }

  void toggleCart(CartItem item) {
    if (isInCart(item.id)) {
      removeFromCart(item.id);
    } else {
      addToCart(item);
    }
  }

  void clearCart() {
    _cart.clear();
    _saveCart();
    notifyListeners();
  }

  // Persistence
  Future<void> _saveCart() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cartJson = json.encode(_cart.map((e) => e.toJson()).toList());
      await prefs.setString('sign_cart', cartJson);
    } catch (e) {
      debugPrint('Failed to save cart: $e');
    }
  }

  Future<void> _loadCart() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cartJson = prefs.getString('sign_cart');
      if (cartJson != null) {
        final list = json.decode(cartJson) as List;
        _cart = list.map((e) => CartItem.fromJson(e)).toList();
      }
    } catch (e) {
      debugPrint('Failed to load cart: $e');
      _cart = [];
    }
  }

  // Category filter for words
  List<String> get wordCategories {
    return _words.map((w) => w.category).toSet().toList()..sort();
  }

  List<WordSign> wordsByCategory(String category) {
    return _words.where((w) => w.category == category).toList();
  }
}
