import 'package:flutter/material.dart';

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

  void _openAddressScreen() {
    Navigator.pushNamed(context, '/address');
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
                onTap: () {
                  Navigator.pop(context);
                  // implement camera logic
                },
              ),
              ListTile(
                title: const Text("From Gallery"),
                onTap: () {
                  Navigator.pop(context);
                  // implement gallery picker logic
                },
              ),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple,
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
                    const CircleAvatar(
                      radius: 48,
                      backgroundImage: NetworkImage(
                        'https://randomuser.me/api/portraits/men/11.jpg',
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Change Picture",
                      style: TextStyle(color: Colors.purple[700]),
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
              leading: const Icon(Icons.location_pin, color: Colors.purple),
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
                backgroundColor: Colors.purple,
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
