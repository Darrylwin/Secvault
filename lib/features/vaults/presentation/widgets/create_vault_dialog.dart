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
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Create a new vault',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: vaultNameController,
              decoration: const InputDecoration(
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
      ),
    );
  }
}
