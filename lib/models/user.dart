class User {
  final String id;
  final String name;
  final String email;
  final String? fotoUrl;

  User({
    required this.id,
    required this.name,
    required this.email,
    this.fotoUrl,
  });

  factory User.fromMap(String id, Map<String, dynamic> data) => User(
    id: id,
    name: data['name'],
    email: data['email'],
    fotoUrl: data['fotoUrl'],
  );

  Map<String, dynamic> toMap() => {
    'name': name,
    'email': email,
    'fotoUrl': fotoUrl,
  };
}
