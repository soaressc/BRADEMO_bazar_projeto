class Address {
  final String id;
  final String usuarioId;
  final String logradouro;
  final int numero;
  final String complemento;
  final String bairro;
  final String cidade;
  final String estado;
  final String cep;
  final double latitude;
  final double longitude;
  final bool principal;

  Address({
    required this.id,
    required this.usuarioId,
    required this.logradouro,
    required this.numero,
    required this.complemento,
    required this.bairro,
    required this.cidade,
    required this.estado,
    required this.cep,
    required this.latitude,
    required this.longitude,
    required this.principal,
  });

  factory Address.fromMap(String id, Map<String, dynamic> data) => Address(
    id: id,
    usuarioId: data['usuarioId'],
    logradouro: data['logradouro'],
    numero: data['numero'],
    complemento: data['complemento'],
    bairro: data['bairro'],
    cidade: data['cidade'],
    estado: data['estado'],
    cep: data['cep'],
    latitude: data['latitude'],
    longitude: data['longitude'],
    principal: data['principal'] ?? false,
  );

  Map<String, dynamic> toMap() => {
    'usuarioId': usuarioId,
    'logradouro': logradouro,
    'numero': numero,
    'complemento': complemento,
    'bairro': bairro,
    'cidade': cidade,
    'estado': estado,
    'cep': cep,
    'latitude': latitude,
    'longitude': longitude,
    'principal': principal,
  };
}
