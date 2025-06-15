// lib/screens/profile_screen.dart

import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter_image_gallery_saver/flutter_image_gallery_saver.dart';

import 'dart:io';

import '../../main.dart';
import 'camera_screen.dart';
// import 'package:collection/collection.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final TextEditingController nameController = TextEditingController(
    text: 'John',
  );
  final TextEditingController emailController = TextEditingController(
    text: 'Johndoe@email.com',
  );
  final TextEditingController passwordController = TextEditingController(
    text: '123456',
  );

  bool obscurePassword = true;

  String? _profileImagePath;

  void _openAddressScreen() {
    Navigator.pushNamed(context, '/address');
  }

  Future<void> _saveImageToGalleryAndUpdateProfile(String imagePath) async {
    try {
      final fileExists = await File(imagePath).exists();
      if (!fileExists) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Erro: Arquivo da imagem não encontrado para o perfil.',
            ),
          ),
        );
        return;
      }

      final file = File(imagePath);
      final bytes = await file.readAsBytes();

      await FlutterImageGallerySaver.saveImage(bytes);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Foto salva na galeria e perfil atualizado!'),
        ),
      );

      setState(() {
        _profileImagePath = imagePath;
      });
    } catch (e) {
      print('Erro ao processar imagem para perfil/galeria: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao salvar ou atualizar foto: $e')),
      );
    }
  }

  void _showChangePictureModal() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Profile Picture",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              ListTile(
                title: const Text("Take a picture"),
                onTap: () async {
                  Navigator.pop(context);

                  if (cameras.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Nenhuma câmera disponível!'),
                      ),
                    );
                    return;
                  }
                  final XFile? image = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) => CameraScreen(availableCameras: cameras),
                    ),
                  );

                  if (image != null) {
                    _saveImageToGalleryAndUpdateProfile(image.path);
                  }
                },
              ),
              ListTile(
                title: const Text("From Gallery"),
                onTap: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Seleção da galeria ainda não implementada.',
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  minimumSize: const Size.fromHeight(48),
                ),
                child: const Text("Cancel"),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        title: const Text("My Account"),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: ListView(
          children: [
            Center(
              child: GestureDetector(
                onTap: _showChangePictureModal,
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 48,
                      backgroundImage:
                          _profileImagePath != null
                              ? FileImage(File(_profileImagePath!))
                                  as ImageProvider<Object>
                              : const NetworkImage(
                                'https://randomuser.me/api/portraits/men/11.jpg',
                              ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Change Picture",
                      style: TextStyle(color: Colors.deepPurple[700]),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: "Name"),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: "Email"),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: passwordController,
              obscureText: obscurePassword,
              decoration: InputDecoration(
                labelText: "Password",
                suffixIcon: IconButton(
                  icon: Icon(
                    obscurePassword ? Icons.visibility_off : Icons.visibility,
                  ),
                  onPressed: () {
                    setState(() {
                      obscurePassword = !obscurePassword;
                    });
                  },
                ),
              ),
            ),
            const SizedBox(height: 16),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.location_pin, color: Colors.deepPurple),
              title: const Text("Address"),
              trailing: const Icon(Icons.chevron_right),
              onTap: _openAddressScreen,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                // implementar lógica de salvar
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                minimumSize: const Size.fromHeight(48),
              ),
              child: const Text("Save Changes"),
            ),
          ],
        ),
      ),
    );
  }
}
