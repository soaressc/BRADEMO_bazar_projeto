import './address.dart';

class AppUser {
  final String id;
  final String name;
  final String email;
  final String? fotoUrl;
  final Address? endereco;

  AppUser({
    required this.id,
    required this.name,
    required this.email,
    this.fotoUrl,
    this.endereco,
  });

  factory AppUser.fromMap(String id, Map<String, dynamic> data) => AppUser(
    id: id,
    name: data['name'],
    email: data['email'],
    fotoUrl: data['fotoUrl'],
    endereco:
        data['endereco'] != null
            ? Address.fromMap('no-id', data['endereco'])
            : null,
  );

  Map<String, dynamic> toMap() => {
    'name': name,
    'email': email,
    'fotoUrl': fotoUrl,
    'endereco': endereco?.toMap(),
  };
}
