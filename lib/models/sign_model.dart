// lib/models/sign_model.dart

class AlphabetSign {
  final String letter;
  final String image;
  final String description;

  const AlphabetSign({
    required this.letter,
    required this.image,
    required this.description,
  });

  factory AlphabetSign.fromJson(Map<String, dynamic> json) {
    return AlphabetSign(
      letter: json['letter'] as String,
      image: json['image'] as String,
      description: json['description'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
        'letter': letter,
        'image': image,
        'description': description,
      };

  // Unique ID for cart storage
  String get cartId => 'alpha_$letter';
  String get displayName => 'Letter $letter';
}

class WordSign {
  final String id;
  final String word;
  final String image;
  final String category;
  final String description;

  const WordSign({
    required this.id,
    required this.word,
    required this.image,
    required this.category,
    required this.description,
  });

  factory WordSign.fromJson(Map<String, dynamic> json) {
    return WordSign(
      id: json['id'] as String,
      word: json['word'] as String,
      image: json['image'] as String,
      category: json['category'] as String,
      description: json['description'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'word': word,
        'image': image,
        'category': category,
        'description': description,
      };

  String get cartId => 'word_$id';
  String get displayName => word;
}

// Unified cart item that can hold either type
class CartItem {
  final String id;
  final String displayName;
  final String image;
  final String description;
  final CartItemType type;

  const CartItem({
    required this.id,
    required this.displayName,
    required this.image,
    required this.description,
    required this.type,
  });

  factory CartItem.fromAlphabet(AlphabetSign sign) {
    return CartItem(
      id: sign.cartId,
      displayName: sign.displayName,
      image: sign.image,
      description: sign.description,
      type: CartItemType.alphabet,
    );
  }

  factory CartItem.fromWord(WordSign sign) {
    return CartItem(
      id: sign.cartId,
      displayName: sign.displayName,
      image: sign.image,
      description: sign.description,
      type: CartItemType.word,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'displayName': displayName,
        'image': image,
        'description': description,
        'type': type.name,
      };

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      id: json['id'],
      displayName: json['displayName'],
      image: json['image'],
      description: json['description'],
      type: CartItemType.values.firstWhere((e) => e.name == json['type']),
    );
  }
}

enum CartItemType { alphabet, word }
