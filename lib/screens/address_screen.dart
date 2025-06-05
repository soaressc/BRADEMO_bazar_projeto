import 'package:flutter/material.dart';

class AddressScreen extends StatelessWidget {
  const AddressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Simulação de dados de endereço
    final mockAddress = {
      "logradouro": "Utama Street No.20",
      "detalhes": "State Street No.15, New York 10001, United States",
    };

    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        title: const Text("Location"),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Column(
        children: [
          // Mapa simulado
          Container(
            height: 250,
            color: Colors.purple[50],
            child: const Center(
              child: Text(
                "🗺️ Mapa Simulado\n(New York)",
                textAlign: TextAlign.center,
              ),
            ),
          ),

          Expanded(
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 6)],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Detail Address",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const Icon(Icons.location_on, color: Colors.purple),
                      const SizedBox(width: 8),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            mockAddress["logradouro"]!,
                            style: const TextStyle(fontWeight: FontWeight.w500),
                          ),
                          Text(
                            mockAddress["detalhes"]!,
                            style: const TextStyle(fontSize: 12),
                          ),
                        ],
                      ),
                      const Spacer(),
                      IconButton(
                        onPressed: () {
                          // abrir editor de endereço
                        },
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
                  const Spacer(),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
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
        ],
      ),
    );
  }
}
