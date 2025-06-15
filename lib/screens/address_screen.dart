import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'dart:async';

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

  @override
  void initState() {
    super.initState();
    _checkAndRequestLocationPermission();
  }

  @override
  void dispose() {
    _positionStreamSubscription?.cancel();
    super.dispose();
  }

  Future<void> _checkAndRequestLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    // 1. Verificar se o serviço de localização está ativado no dispositivo
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      setState(() {
        _locationStatus =
            'Serviços de localização desativados. Por favor, ative.';
      });
      // Pode abrir as configurações de localização aqui se desejar
      // Geolocator.openLocationSettings();
      return;
    }

    // 2. Verificar o status da permissão do aplicativo
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      // 3. Solicitar permissão se negada
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
      // Pode abrir as configurações do app aqui se desejar
      // Geolocator.openAppSettings();
      return;
    }

    setState(() {
      _locationStatus = 'Permissão concedida. Obtendo localização...';
    });
    _startLocationStream();
  }

  void _startLocationStream() {
    const LocationSettings locationSettings = LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 10,
    );

    _positionStreamSubscription = Geolocator.getPositionStream(
      locationSettings: locationSettings,
    ).listen((Position position) {
      setState(() {
        _currentPosition = position;
        _locationStatus = 'Localização obtida!';
      });
      _getAddressFromCoordinates(position);
    }, onError: (error) {
      setState(() {
        _locationStatus = 'Erro ao obter localização: $error';
      });
      print("Erro na stream de localização: $error");
    });
  }

  Future<void> _getAddressFromCoordinates(Position position) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
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

  @override
  Widget build(BuildContext context) {
    String logradouro =
        _currentPlacemark?.thoroughfare ?? 'Endereço não disponível';
    if (_currentPlacemark?.subThoroughfare != null &&
        _currentPlacemark!.subThoroughfare!.isNotEmpty) {
      logradouro = '$logradouro, ${_currentPlacemark!.subThoroughfare}';
    }

    String detalhes = '';
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
        addressParts
            .add(_currentPlacemark!.administrativeArea!); // Estado (ex: SP)
      }
      if (_currentPlacemark!.postalCode != null &&
          _currentPlacemark!.postalCode!.isNotEmpty) {
        addressParts.add(_currentPlacemark!.postalCode!); // CEP
      }
      if (_currentPlacemark!.country != null &&
          _currentPlacemark!.country!.isNotEmpty) {
        addressParts.add(_currentPlacemark!.country!); // País
      }
      detalhes = addressParts.join(', ');
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
              // Área do Mapa (ainda simulado, mas agora reflete o status)
              Container(
                height: 250,
                color: Colors.purple[50],
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "🗺️ Mapa da Localização Atual",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),
                      if (_currentPosition == null)
                        CircularProgressIndicator(color: Colors.purple)
                      else
                        Text(
                          'Lat: ${_currentPosition!.latitude.toStringAsFixed(5)}\nLon: ${_currentPosition!.longitude.toStringAsFixed(5)}',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 14),
                        ),
                      const SizedBox(height: 5),
                      Text(
                        _locationStatus,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 12, fontStyle: FontStyle.italic),
                      ),
                    ],
                  ),
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
                  const Icon(Icons.location_on, color: Colors.purple),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          logradouro,
                          style: const TextStyle(fontWeight: FontWeight.w500),
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          detalhes,
                          style: const TextStyle(fontSize: 12),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    onPressed: _currentPlacemark != null
                        ? () {
                            // Implementar lógica para editar endereço (talvez preencher um formulário)
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content: Text(
                                      'Editar endereço para: ${logradouro}, ${detalhes}')),
                            );
                          }
                        : null,
                    icon: const Icon(Icons.edit),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              const Text("Save Address As"),
              const SizedBox(height: 8),
              Row(
                children: [
                  ChoiceChip(
                    label: const Text("Home"),
                    selected: true,
                    selectedColor: Colors.purple[100],
                    onSelected: (_) {},
                  ),
                  const SizedBox(width: 12),
                  ChoiceChip(
                    label: const Text("Offices"),
                    selected: false,
                    onSelected: (_) {},
                  ),
                ],
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _currentPosition != null
                    ? () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content:
                                  Text('Endereço confirmado: ${logradouro}')),
                        );
                        Navigator.pop(context);
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple,
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
