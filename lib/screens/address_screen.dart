// lib/screens/address_screen.dart

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'dart:async';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:myapp/models/address.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddressScreen extends StatefulWidget {
  const AddressScreen({super.key});

  @override
  State<AddressScreen> createState() => _AddressScreenState();
}

class _AddressScreenState extends State<AddressScreen> {
  Position? _currentPosition;
  Placemark? _currentPlacemark;
  String _locationStatus = 'Buscando localização...';
  StreamSubscription<Position>? _positionStreamSubscription;

  GoogleMapController? _mapController;
  LatLng? _initialMapCenter;
  Set<Marker> _markers = {};

  String _selectedAddressType = "Home";

  @override
  void initState() {
    super.initState();
    _checkAndRequestLocationPermission();
  }

  @override
  void dispose() {
    _positionStreamSubscription?.cancel();
    _mapController?.dispose();
    super.dispose();
  }

  // Método para verificar permissões e solicitar localização
  Future<void> _checkAndRequestLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      setState(() {
        _locationStatus =
            'Serviços de localização desativados. Por favor, ative.';
      });
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        setState(() {
          _locationStatus =
              'Permissão de localização negada. Recurso indisponível.';
        });
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      setState(() {
        _locationStatus =
            'Permissão de localização negada permanentemente. Por favor, habilite nas configurações do app.';
      });
      return;
    }

    setState(() {
      _locationStatus = 'Permissão concedida. Obtendo localização...';
    });
    _startLocationStream();
  }

  // Método para iniciar a escuta de atualizações da localização
  void _startLocationStream() {
    const LocationSettings locationSettings = LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 10,
    );

    _positionStreamSubscription = Geolocator.getPositionStream(
      locationSettings: locationSettings,
    ).listen(
      (Position position) {
        setState(() {
          _currentPosition = position;
          _locationStatus = 'Localização obtida!';
          _initialMapCenter = LatLng(position.latitude, position.longitude);
          _updateMapAndMarker();
        });
        _getAddressFromCoordinates(position);
      },
      onError: (error) {
        setState(() {
          _locationStatus = 'Erro ao obter localização: $error';
        });
        print("Erro na stream de localização: $error");
      },
    );
  }

  // Método para atualizar a câmera do mapa e o marcador
  void _updateMapAndMarker() {
    if (_mapController != null && _currentPosition != null) {
      final newLatLng = LatLng(
        _currentPosition!.latitude,
        _currentPosition!.longitude,
      );
      _mapController!.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(target: newLatLng, zoom: 16.0),
        ),
      );
      setState(() {
        _markers = {
          Marker(
            markerId: const MarkerId('currentLocation'),
            position: newLatLng,
            infoWindow: InfoWindow(
              title: _currentPlacemark?.name ?? 'Sua Localização',
              snippet: _currentPlacemark?.thoroughfare ?? '',
            ),
          ),
        };
      });
    }
  }

  // Método para converter coordenadas em endereço legível
  Future<void> _getAddressFromCoordinates(Position position) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
        // localeIdentifier: 'pt_BR',
      );

      if (placemarks.isNotEmpty) {
        setState(() {
          _currentPlacemark = placemarks.first;
        });
      } else {
        setState(() {
          _currentPlacemark = null;
        });
      }
    } catch (e) {
      print("Erro ao obter endereço: $e");
      setState(() {
        _currentPlacemark = null;
      });
    }
  }

  // Método para mapear o Placemark para o Address
  Address? _mapPlacemarkToAddress(Placemark? placemark, Position? position) {
    if (placemark == null || position == null) {
      return null;
    }
    return Address(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      userId: FirebaseAuth.instance.currentUser?.uid ?? 'unknown',
      street: placemark.thoroughfare ?? '',
      number: int.tryParse(placemark.subThoroughfare ?? '') ?? 0,
      complement: placemark.subLocality ?? '',
      district: placemark.subLocality ?? '',
      city: placemark.locality ?? '',
      state: placemark.administrativeArea ?? '',
      postalCode: placemark.postalCode ?? '',
      latitude: position.latitude,
      longitude: position.longitude,
      principal: _selectedAddressType == "Home",
    );
  }

// Método para salvar o endereço no Firestore
  Future<void> _saveAddressToFirestore() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Você precisa estar logado para salvar o endereço.'),
        ),
      );
      return;
    }
    if (_currentPlacemark == null || _currentPosition == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Não há endereço para salvar.')),
      );
      return;
    }

    final addressToSave = _mapPlacemarkToAddress(
      _currentPlacemark,
      _currentPosition,
    );

    if (addressToSave == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erro ao formatar o endereço.')),
      );
      return;
    }

    try {
      final userDocRef = FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid);

      final addressData = addressToSave.toMap();

      await userDocRef.update({
        'endereco': addressData,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Endereço "${_selectedAddressType}" salvo com sucesso!',
          ),
        ),
      );
      Navigator.pop(context);
    } catch (e) {
      print("Erro ao salvar endereço no Firestore: $e");
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Erro ao salvar endereço: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    String logradouroDisplay =
        _currentPlacemark?.thoroughfare ?? 'Endereço não disponível';
    if (_currentPlacemark?.subThoroughfare != null &&
        _currentPlacemark!.subThoroughfare!.isNotEmpty) {
      logradouroDisplay =
          '$logradouroDisplay, ${_currentPlacemark!.subThoroughfare}';
    }

    String detalhesDisplay = '';
    if (_currentPlacemark != null) {
      List<String> addressParts = [];
      if (_currentPlacemark!.subLocality != null &&
          _currentPlacemark!.subLocality!.isNotEmpty) {
        addressParts.add(_currentPlacemark!.subLocality!); // Bairro
      }
      if (_currentPlacemark!.locality != null &&
          _currentPlacemark!.locality!.isNotEmpty) {
        addressParts.add(_currentPlacemark!.locality!); // Cidade
      }
      if (_currentPlacemark!.administrativeArea != null &&
          _currentPlacemark!.administrativeArea!.isNotEmpty) {
        addressParts.add(
          _currentPlacemark!.administrativeArea!,
        ); // Estado
      }
      if (_currentPlacemark!.postalCode != null &&
          _currentPlacemark!.postalCode!.isNotEmpty) {
        addressParts.add(_currentPlacemark!.postalCode!); // CEP
      }
      if (_currentPlacemark!.country != null &&
          _currentPlacemark!.country!.isNotEmpty) {
        addressParts.add(_currentPlacemark!.country!); // País
      }
      detalhesDisplay = addressParts.join(', ');
    }

    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        title: const Text("Location"),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // <<< ÁREA DO MAPA DO GOOGLE REAL
              Container(
                height: 250,
                decoration: BoxDecoration(
                  color: Colors.deepPurple[50],
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child:
                    _initialMapCenter == null
                        ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CircularProgressIndicator(
                                color: Colors.deepPurple,
                              ),
                              const SizedBox(height: 10),
                              Text(
                                _locationStatus,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 12,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            ],
                          ),
                        )
                        : GoogleMap(
                          initialCameraPosition: CameraPosition(
                            target: _initialMapCenter!,
                            zoom: 16.0,
                          ),
                          onMapCreated: (controller) {
                            _mapController = controller;
                            _updateMapAndMarker();
                          },
                          markers: _markers,
                          myLocationEnabled: true,
                          myLocationButtonEnabled: true,
                        ),
              ),

              const SizedBox(height: 24),
              const Text(
                "Detail Address",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  const Icon(Icons.location_on, color: Colors.deepPurple),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          logradouroDisplay,
                          style: const TextStyle(fontWeight: FontWeight.w500),
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          detalhesDisplay,
                          style: const TextStyle(fontSize: 12),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                ],
              ),
              const SizedBox(height: 24),
              const Text("Save Address As"),
              const SizedBox(height: 8),
              Row(
                children: [
                  ChoiceChip(
                    label: const Text("Home"),
                    selected: _selectedAddressType == "Home",
                    selectedColor: Colors.deepPurple[100],
                    onSelected: (selected) {
                      if (selected) {
                        setState(() {
                          _selectedAddressType = "Home";
                        });
                      }
                    },
                  ),
                  const SizedBox(width: 12),
                  ChoiceChip(
                    label: const Text("Offices"),
                    selected: _selectedAddressType == "Offices",
                    selectedColor: Colors.deepPurple[100],
                    onSelected: (selected) {
                      if (selected) {
                        setState(() {
                          _selectedAddressType = "Offices";
                        });
                      }
                    },
                  ),
                ],
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed:
                    _currentPosition != null ? _saveAddressToFirestore : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  minimumSize: const Size.fromHeight(48),
                ),
                child: const Text("Confirmation"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
