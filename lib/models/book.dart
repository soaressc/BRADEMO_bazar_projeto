class Book {
  final String id;
  final String title;
  final String author;
  final String imageUrl;
  final String description;
  final String price;
  final double rating;
  final int reviewCount;
  final String store;

  Book({
    required this.id,
    required this.title,
    required this.author,
    required this.imageUrl,
    required this.description,
    required this.price,
    required this.rating,
    required this.reviewCount,
    required this.store,
  });

  double get priceValue =>
      double.tryParse(price.replaceAll(RegExp(r'[^0-9.]'), '')) ?? 0.0;

  /// Método principal de deserialização
  factory Book.fromMap(Map<String, dynamic> map) {
    return Book(
      id: map['id'] ?? '', // Se não tiver o ID no doc, pode ser vazio
      title: map['title'] ?? 'Título desconhecido',
      author: map['author'] ?? 'Autor desconhecido',
      imageUrl: map['imageUrl'] ?? '',
      description: map['description'] ?? '',
      price: map['price'] ?? '\$0.00',
      rating: (map['rating'] ?? 0).toDouble(),
      reviewCount: (map['reviewCount'] ?? 0) as int,
      store: map['store'] ?? 'Loja desconhecida',
    );
  }

  /// Método auxiliar para compatibilidade com JSON
  factory Book.fromJson(Map<String, dynamic> json) => Book.fromMap(json);

  /// Método principal de serialização
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'author': author,
      'imageUrl': imageUrl,
      'description': description,
      'price': price,
      'rating': rating,
      'reviewCount': reviewCount,
      'store': store,
    };
  }

  /// Método auxiliar para compatibilidade com JSON
  Map<String, dynamic> toJson() => toMap();

  Book copyWith({
    String? id,
    String? title,
    String? author,
    String? imageUrl,
    String? description,
    String? price,
    double? rating,
    int? reviewCount,
    String? store,
  }) {
    return Book(
      id: id ?? this.id,
      title: title ?? this.title,
      author: author ?? this.author,
      imageUrl: imageUrl ?? this.imageUrl,
      description: description ?? this.description,
      price: price ?? this.price,
      rating: rating ?? this.rating,
      reviewCount: reviewCount ?? this.reviewCount,
      store: store ?? this.store,
    );
  }
}
