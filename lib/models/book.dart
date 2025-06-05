class Book {
  final String title;
  final String author;
  final String imageUrl;
  final String description;
  final String price;
  final double rating;
  final int reviewCount;
  final String store;

  Book({
    required this.title,
    required this.author,
    required this.imageUrl,
    required this.description,
    required this.price,
    required this.rating,
    required this.reviewCount,
    required this.store,
  });

  double get priceValue => double.tryParse(price.replaceAll(RegExp(r'[^0-9.]'), '')) ?? 0.0;
}