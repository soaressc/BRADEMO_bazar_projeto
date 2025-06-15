// lib/screens/profile_screen.dart

import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter_image_gallery_saver/flutter_image_gallery_saver.dart';

import 'dart:io';
import 'dart:async';

import '../../main.dart';
import 'camera_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myapp/models/app_user.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool obscurePassword = true;

  String? _profileImagePath;
  AppUser? _currentUser;
  StreamSubscription<User?>? _authStateSubscription;

  @override
  void initState() {
    super.initState();
    _authStateSubscription = FirebaseAuth.instance.authStateChanges().listen((
      user,
    ) {
      if (user != null) {
        _loadUserData(user.uid);
      } else {
        setState(() {
          _currentUser = null;
          nameController.clear();
          emailController.clear();
          passwordController.clear();
          _profileImagePath = null;
        });
      }
    });
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    _authStateSubscription?.cancel();
    super.dispose();
  }

  Future<void> _loadUserData(String userId) async {
    try {
      final userDoc =
          await FirebaseFirestore.instance
              .collection('users')
              .doc(userId)
              .get();
      if (userDoc.exists) {
        setState(() {
          _currentUser = AppUser.fromMap(
            userDoc.id,
            userDoc.data() as Map<String, dynamic>,
          );
          nameController.text = _currentUser!.name;
          emailController.text = _currentUser!.email;
          _profileImagePath = null;
        });
      } else {
        print(
          'PROFILESCREEN: Documento do usuário não encontrado no Firestore.',
        );
        setState(() {
          _currentUser = null;
        });
      }
    } catch (e) {
      print('PROFILESCREEN: Erro ao carregar dados do usuário: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao carregar seus dados: $e')),
      );
    }
  }

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

      // 1. Salvar na galeria local
      await FlutterImageGallerySaver.saveImage(bytes);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Foto salva na galeria e perfil atualizado localmente!',
          ),
        ),
      );

      // 2. Atualizar estado local para exibição imediata
      setState(() {
        _profileImagePath = imagePath;
      });
    } catch (e) {
      print('Erro ao processar imagem para perfil/galeria: $e');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Erro ao processar foto: $e')));
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
                          // Prioriza a imagem local recém-tirada/cortada
                          _profileImagePath != null &&
                                  _profileImagePath!.startsWith('/')
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
              leading: const Icon(Icons.location_on, color: Colors.deepPurple),
              title: const Text("Address"),
              trailing: const Icon(Icons.chevron_right),
              onTap: _openAddressScreen,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () async {
                // Lógica para salvar as alterações de Nome/Email do usuário no Firestore
                if (_currentUser != null) {
                  try {
                    await FirebaseFirestore.instance
                        .collection('users')
                        .doc(_currentUser!.id)
                        .update({
                          'name': nameController.text,
                          'email': emailController.text,
                        });
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Dados atualizados com sucesso!'),
                      ),
                    );
                    _loadUserData(_currentUser!.id);
                  } catch (e) {
                    print('Erro ao salvar dados do perfil: $e');
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Erro ao salvar dados do perfil: $e'),
                      ),
                    );
                  }
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Nenhum usuário logado para salvar dados.'),
                    ),
                  );
                }
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
