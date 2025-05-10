class Product {
  final String title;
  final String seller;
  final double price;
  final double rating;
  final int quantity;
  final String imageUrl;

  Product({
    required this.title,
    required this.seller,
    required this.price,
    required this.rating,
    this.quantity = 1,
    required this.imageUrl,
  });
}
