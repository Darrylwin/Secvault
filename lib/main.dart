import 'package:flutter/material.dart';

void main() {
  runApp(const Secvault());
}

class Secvault extends StatelessWidget {
  const Secvault({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Secvault',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const Scaffold(),
    );
  }
}
