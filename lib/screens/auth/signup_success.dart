import 'package:flutter/material.dart';
import 'package:myapp/screens/auth/welcome_back_screen.dart';
import 'package:myapp/widgets/custom_button.dart';

class SignUpSuccess extends StatelessWidget {
  const SignUpSuccess({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/congratulations.png'),
              const SizedBox(height: 24),
              const Text(
                "Congratulations!",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                "Your account is complete, please enjoy the best menu from us.",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey),
              ),
              CustomButton(
                text: "Get Started",
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (_) => WelcomeBackScreen()),
                    (route) => false,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
