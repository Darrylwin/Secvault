import 'package:flutter/material.dart';

class CreateVaultDialog extends StatelessWidget {
  const CreateVaultDialog({
    super.key,
    required this.vaultNameController,
    required this.onCreateVaultPressed,
  });

  final TextEditingController vaultNameController;

  final VoidCallback onCreateVaultPressed;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Create a new vault',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 20),
          const TextField(
            decoration: InputDecoration(
              labelText: 'Vault Name',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: onCreateVaultPressed,
            child: const Text('Create Vault'),
          ),
        ],
      ),
    );
  }
}
