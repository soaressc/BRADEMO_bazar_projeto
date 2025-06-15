// lib/screens/camera_screen.dart

import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'image_crop_screen.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key, required this.availableCameras});

  final List<CameraDescription> availableCameras;

  @override
  CameraScreenState createState() => CameraScreenState();
}

class CameraScreenState extends State<CameraScreen> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;
  late CameraDescription _currentCamera;
  FlashMode _currentFlashMode = FlashMode.off;

  @override
  void initState() {
    super.initState();
    _currentCamera = widget.availableCameras.firstWhere(
      (camera) => camera.lensDirection == CameraLensDirection.back,
      orElse: () => widget.availableCameras.first,
    );

    _controller = CameraController(_currentCamera, ResolutionPreset.medium);

    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // Método para alternar entre as câmeras disponíveis
  void _switchCamera() async {
    if (widget.availableCameras.length < 2) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Apenas uma câmera disponível.')),
      );
      return;
    }

    final int currentCameraIndex = widget.availableCameras.indexOf(
      _currentCamera,
    );
    final int nextCameraIndex =
        (currentCameraIndex + 1) % widget.availableCameras.length;
    final CameraDescription nextCamera =
        widget.availableCameras[nextCameraIndex];

    await _controller.dispose();

    _currentCamera = nextCamera;
    _controller = CameraController(_currentCamera, ResolutionPreset.medium);

    _initializeControllerFuture = _controller.initialize();

    if (mounted) {
      setState(() {});
    }
  }

  // Método para controlar o flash
  void _toggleFlash() async {
    try {
      if (_controller.value.isInitialized) {
        FlashMode newFlashMode;
        if (_currentFlashMode == FlashMode.off) {
          newFlashMode = FlashMode.torch;
        } else if (_currentFlashMode == FlashMode.torch) {
          newFlashMode = FlashMode.off;
        } else {
          newFlashMode = FlashMode.off;
        }
        await _controller.setFlashMode(newFlashMode);
        if (mounted) {
          setState(() {
            _currentFlashMode = newFlashMode;
          });
        }
      }
    } catch (e) {
      print("Erro ao controlar o flash: $e");
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Erro ao controlar o flash: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple,
        foregroundColor: Colors.white,
        actions: [
          // Botão do Flash
          FutureBuilder<void>(
            future: _initializeControllerFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done &&
                  _controller.value.isInitialized) {
                return IconButton(
                  icon: Icon(
                    _currentFlashMode == FlashMode.off
                        ? Icons.flash_off
                        : _currentFlashMode == FlashMode.torch
                        ? Icons.flash_on
                        : Icons.flash_auto,
                  ),
                  onPressed: _toggleFlash,
                );
              } else {
                return const SizedBox.shrink();
              }
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: FutureBuilder<void>(
              future: _initializeControllerFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return SizedBox.expand(
                    child: FittedBox(
                      fit: BoxFit.cover,
                      child: SizedBox(
                        width: _controller.value.previewSize!.height,
                        height: _controller.value.previewSize!.width,
                        child: CameraPreview(_controller),
                      ),
                    ),
                  );
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              },
            ),
          ),

          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              padding: const EdgeInsets.only(
                top: 8.0,
                bottom: 16.0,
                left: 24.0,
                right: 24.0,
              ),
              color: Colors.purple,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'PHOTO',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Expanded(
                        child: TextButton(
                          onPressed: () => Navigator.pop(context),
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.white,
                          ),
                          child: const Text(
                            'Cancel',
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      SizedBox(
                        height: 60,
                        width: 60,
                        child: FloatingActionButton(
                          onPressed: () async {
                            try {
                              await _initializeControllerFuture;
                              final image = await _controller.takePicture();
                              if (!mounted) return;
                              final croppedImagePath = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (context) => ImageCropScreen(
                                        imageFile: image,
                                      ), // Passa o XFile capturado
                                ),
                              );

                              // Se uma imagem cortada foi retornada pela ImageCropScreen,
                              // então retorne-a para o ProfileScreen.
                              if (croppedImagePath != null) {
                                Navigator.pop(
                                  context,
                                  XFile(croppedImagePath),
                                ); // Retorna um XFile com o caminho cortado
                              } else {
                                // Se o usuário cancelou o corte, apenas volte para o ProfileScreen sem imagem
                                Navigator.pop(context);
                              }
                            } catch (e) {
                              print(e);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Falha ao tirar foto: $e'),
                                ),
                              );
                            }
                          },
                          backgroundColor: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 16),
                      // Botão de Virar Câmera
                      Expanded(
                        child: Opacity(
                          opacity:
                              widget.availableCameras.length > 1 ? 1.0 : 0.0,
                          child: IconButton(
                            onPressed:
                                widget.availableCameras.length > 1
                                    ? _switchCamera
                                    : null,
                            icon: Icon(
                              _currentCamera.lensDirection ==
                                      CameraLensDirection.back
                                  ? Icons.flip_camera_ios_outlined
                                  : Icons.flip_camera_ios,
                              color: Colors.white,
                              size: 30,
                            ),
                            tooltip: 'Switch Camera',
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
