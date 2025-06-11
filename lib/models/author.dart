class Author {
  final String id;
  final String name;
  final String imageUrl;
  final String description;

  Author({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.description,
  });

  static fromMap(Map<String, dynamic> map) {}

  toMap() {}
}
