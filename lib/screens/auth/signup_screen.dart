import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:myapp/widgets/custom_button.dart';
import 'package:myapp/widgets/custom_input_field.dart';
import 'signup_success.dart';
import 'package:myapp/screens/auth/welcome_back_screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool showPassword = false;
  bool isLoading = false;

  bool isPasswordValid(String password) {
    final lengthValid = password.length >= 8;
    final hasNumber = password.contains(RegExp(r'[0-9]'));
    final hasLetter = password.contains(RegExp(r'[a-zA-Z]'));
    return lengthValid && hasNumber && hasLetter;
  }

  Future<void> registerUser() async {
    setState(() => isLoading = true);

    final email = emailController.text;
    final password = passwordController.text;

    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const SignUpSuccess()),
      );
    } on FirebaseAuthException catch (e) {
      String message = "Error registering new user";
      if (e.code == 'invalid-email') {
        message = 'Email not valid';
      } else if (e.code == 'email-already-in-use') {
        message = 'This email is already in use. Try another one.';
      }

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(message)));
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final password = passwordController.text;
    final isValid = isPasswordValid(password);
    final isFormComplete =
        nameController.text.isNotEmpty &&
        emailController.text.isNotEmpty &&
        passwordController.text.isNotEmpty;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: ListView(
          children: [
            const SizedBox(height: 60),
            const Text(
              "Sign Up",
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            const Text(
              "Create account and choose favorite menu",
              style: TextStyle(color: Colors.grey),
            ),

            const SizedBox(height: 24),
            CustomInputField(
              label: "Name",
              hint: "Your name",
              controller: nameController,
            ),
            const SizedBox(height: 16),
            CustomInputField(
              label: "Email",
              hint: "Your email",
              controller: emailController,
            ),
            const SizedBox(height: 16),
            CustomInputField(
              label: "Password",
              hint: "Your password",
              controller: passwordController,
              obscure: !showPassword,
              onChanged: (_) => setState(() {}),
              suffixIcon: IconButton(
                icon: Icon(
                  showPassword
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined,
                  color: Colors.grey.shade400,
                ),
                onPressed: () => setState(() => showPassword = !showPassword),
              ),
            ),

            const SizedBox(height: 8),
            if (password.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildValidationItem(
                    "Minimum 8 characters",
                    password.length >= 8,
                  ),
                  _buildValidationItem(
                    "At least 1 number (1-9)",
                    RegExp(r'[0-9]').hasMatch(password),
                  ),
                  _buildValidationItem(
                    "At least lowercase or uppercase letters",
                    RegExp(r'[a-zA-Z]').hasMatch(password),
                  ),
                ],
              ),

            CustomButton(
              text: "Register",
              onPressed:
                  isFormComplete && isValid && !isLoading
                      ? () {
                        registerUser();
                      }
                      : () {},
            ),

            const SizedBox(height: 16),
            Center(
              child: TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const WelcomeBackScreen(),
                    ),
                  );
                },
                child: const Text.rich(
                  TextSpan(
                    text: "Have an account? ",
                    style: TextStyle(color: Colors.grey),
                    children: [
                      TextSpan(
                        text: "Sign In",
                        style: TextStyle(
                          color: Color(0xFF54408C),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 16),
            Column(
              children: [
                const Text(
                  "By clicking Register, you agree to our",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
                const SizedBox(height: 4),
                Text(
                  "Terms and Data Policy.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12,
                    color: Color(0xFF54408C),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildValidationItem(String text, bool valid) {
    return Row(
      children: [
        Icon(
          valid ? Icons.check : Icons.close,
          color: valid ? const Color(0xFFA28CE0) : Colors.red,
          size: 16,
        ),
        const SizedBox(width: 6),
        Text(text, style: const TextStyle(fontSize: 12, color: Colors.grey)),
      ],
    );
  }
}
