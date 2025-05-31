import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:secvault/features/vaults/presentation/bloc/vault_bloc.dart';
import 'package:secvault/features/vaults/presentation/bloc/vault_event.dart';
import 'package:secvault/features/vaults/presentation/widgets/vault_card.dart';

import '../bloc/vault_state.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    context.read<VaultBloc>().add(LoadVaults());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Vaults"),
        centerTitle: true,
      ),
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/createVault');
        },
        backgroundColor: const Color(0xFFFD3951),
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
      body: BlocBuilder<VaultBloc, VaultState>(
        builder: (context, state) {
          if (state is VaultLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is VaultLoaded) {
            final vaults = state.vaults;
            if (vaults.isEmpty) {
              return const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.lock_outline, size: 80, color: Colors.grey),
                    SizedBox(height: 16),
                    Text('No vaults yet'),
                  ],
                ),
              );
            }
            return ListView.separated(
              itemBuilder: (context, index) {
                final vault = vaults[index];
                return VaultCard(
                  name: vault.name,
                  createdAt: vault.createdAt,
                  vaultId: vault.id,
                );
              },
              separatorBuilder: (context, index) => const SizedBox(height: 5),
              itemCount: vaults.length,
            );
          } else if (state is VaultError) {
            return Center(
              child: Text(
                state.failureMessage,
                style: const TextStyle(color: Colors.red, fontSize: 16),
              ),
            );
          }
          return const SizedBox.shrink(); // Fallback for any other state
        },
      ),
    );
  }
}
