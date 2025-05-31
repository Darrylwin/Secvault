import 'package:flutter/material.dart';

class VaultCard extends StatelessWidget {
  const VaultCard({
    super.key,
    required this.name,
    required this.createdAt,
    required this.vaultId,
  });

  final String name;
  final DateTime createdAt;
  final String vaultId;

  @override
  Widget build(BuildContext context) {
    // return ListTile(
    //   title: const Text(
    //     "Vault Name",
    //     style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    //   ),
    //   onTap: () {},
    //   leading: Text(
    //     "$createdAt",
    //     style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
    //   ),
    // );

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: const Icon(Icons.folder, color: Colors.redAccent),
        title: Text(name),
        subtitle: Text('Created: $createdAt'),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: () {
          Navigator.pushNamed(
            context,
            '/vaultDetails',
            arguments: vaultId,
          );
        },
      ),
    );
  }
}
