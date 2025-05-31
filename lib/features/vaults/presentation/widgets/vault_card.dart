import 'package:flutter/material.dart';

class VaultCard extends StatelessWidget {
  const VaultCard({
    super.key,
    required this.name,
    required this.createdAt,
    required this.vaultId,
    required this.onTap,
  });

  final String name;
  final DateTime createdAt;
  final String vaultId;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: const Icon(Icons.folder, color: Colors.redAccent),
        title: Text(name),
        subtitle: Text('Created: $createdAt'),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }
}
