class Address {
  final String id;
  final String userId;
  final String street;
  final int number;
  final String complement;
  final String district;
  final String city;
  final String state;
  final String postalCode;
  final double latitude;
  final double longitude;
  final bool principal;

  Address({
    required this.id,
    required this.userId,
    required this.street,
    required this.number,
    required this.complement,
    required this.district,
    required this.city,
    required this.state,
    required this.postalCode,
    required this.latitude,
    required this.longitude,
    required this.principal,
  });

  factory Address.fromMap(String id, Map<String, dynamic> data) => Address(
    id: id,
    userId: data['userId'],
    street: data['street'],
    number: data['number'],
    complement: data['complement'],
    district: data['district'],
    city: data['city'],
    state: data['state'],
    postalCode: data['postalCode'],
    latitude: data['latitude'],
    longitude: data['longitude'],
    principal: data['principal'] ?? false,
  );

  Map<String, dynamic> toMap() => {
    'userId': userId,
    'street': street,
    'number': number,
    'complement': complement,
    'district': district,
    'city': city,
    'state': state,
    'postalCode': postalCode,
    'latitude': latitude,
    'longitude': longitude,
  };
}
