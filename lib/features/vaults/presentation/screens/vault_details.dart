import 'package:flutter/material.dart';

class VaultDetails extends StatelessWidget {
  const VaultDetails({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Vault Details"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Center(
              child: Text(
                'Vault Details',
                style: TextStyle(fontSize: 18),
              ),
            ),
            const Text("Created At: 28 mai 2025"),
            const Text("Elements: 12"),
            const Divider(),
            Row(
              children: [
                TextButton(
                  onPressed: () {},
                  child: const Text("Delete this vault"),
                ),
                TextButton(
                  onPressed: () {},
                  child: const Text("Add Element"),
                ),
              ],
            ),
            const Divider(),
            ListView(
              children: [
                ListTile(
                  title: const Text("Element 1"),
                  subtitle: const Text("Description of Element 1"),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () {
                      // Logic to delete the element
                    },
                  ),
                ),
                ListTile(
                  title: const Text("Element 2"),
                  subtitle: const Text("Description of Element 2"),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () {
                      // Logic to delete the element
                    },
                  ),
                ),
                // Add more ListTiles for additional elements
              ],
            ),
          ],
        ),
      ),
    );
  }
}
