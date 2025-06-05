import './address.dart';

class User {
  final String id;
  final String name;
  final String email;
  final String password;
  final String? fotoUrl;
  final Address? endereco;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.password,
    this.fotoUrl,
    this.endereco,
  });

  factory User.fromMap(String id, Map<String, dynamic> data) => User(
    id: id,
    name: data['name'],
    email: data['email'],
    password: data['password'],
    fotoUrl: data['fotoUrl'],
    endereco:
        data['endereco'] != null
            ? Address.fromMap('no-id', data['endereco'])
            : null,
  );

  Map<String, dynamic> toMap() => {
    'name': name,
    'email': email,
    'password': password,
    'fotoUrl': fotoUrl,
    'endereco': endereco?.toMap(),
  };
}
