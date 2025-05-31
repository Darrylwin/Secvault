import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:secvault/features/vaults/presentation/bloc/vault_bloc.dart';
import 'package:secvault/features/vaults/presentation/bloc/vault_event.dart';
import 'package:secvault/features/vaults/presentation/screens/vault_details.dart';
import 'package:secvault/features/vaults/presentation/widgets/vault_card.dart';

import '../bloc/vault_state.dart';
import '../widgets/create_vault_dialog.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController vaultNameController = TextEditingController();
  final Color primaryColor = const Color(0xFFFD3951);

  void onVaultTaped({
    required String vaultId,
    required String vaultName,
    required DateTime createdAt,
  }) {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => VaultDetails(
            vaultId: vaultId,
            vaultName: vaultName,
            createdAt: createdAt,
          ),
        ));
  }

  @override
  void initState() {
    super.initState();
    context.read<VaultBloc>().add(LoadVaults());
  }

  void Function()? showCreateVaultDialog() {
    showDialog(
      context: context,
      builder: (context) => CreateVaultDialog(
        vaultNameController: vaultNameController,
        onCreateVaultPressed: () {
          final vaultName = vaultNameController.text.trim();
          if (vaultName.isNotEmpty) {
            context.read<VaultBloc>().add(CreateVault(vaultName));
            Navigator.of(context).pop();
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Please enter a vault name')),
            );
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "My Vaults",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        backgroundColor: primaryColor,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.white),
            onPressed: () {
              // Search functionality
            },
          ),
        ],
      ),
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: showCreateVaultDialog,
        backgroundColor: primaryColor,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text('New Vault', style: TextStyle(color: Colors.white)),
      ),
      body: Column(
        children: [
          // Header section
          Container(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Welcome to SecVault',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Keep your files secure and organized',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),

          // Main content
          Expanded(
            child: BlocBuilder<VaultBloc, VaultState>(
              builder: (context, state) {
                if (state is VaultLoading) {
                  return Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
                    ),
                  );
                } else if (state is VaultLoaded) {
                  final vaults = state.vaults;
                  if (vaults.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.folder_off_outlined,
                            size: 80,
                            color: Colors.grey[400],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No vaults yet',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.grey[600],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Create a new vault to get started',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[500],
                            ),
                          ),
                          const SizedBox(height: 24),
                          ElevatedButton.icon(
                            onPressed: showCreateVaultDialog,
                            icon: const Icon(Icons.add),
                            label: const Text('Create Vault'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: primaryColor,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24,
                                vertical: 12,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                  if (vaults == null) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.error_outline, size: 80, color: Colors.red[300]),
                          const SizedBox(height: 16),
                          const Text(
                            'Unable to load vaults',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                          ),
                          const SizedBox(height: 8),
                          TextButton(
                            onPressed: () => context.read<VaultBloc>().add(LoadVaults()),
                            child: Text(
                              'Retry',
                              style: TextStyle(color: primaryColor, fontSize: 16),
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                  return ListView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 80),
                    itemBuilder: (context, index) {
                      final vault = vaults[index];
                      return VaultCard(
                        name: vault.name,
                        createdAt: vault.createdAt,
                        vaultId: vault.id,
                        onTap: () => onVaultTaped(
                          vaultId: vault.id,
                          vaultName: vault.name,
                          createdAt: vault.createdAt,
                        ),
                      );
                    },
                    itemCount: vaults.length,
                  );
                } else if (state is VaultError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.error_outline, size: 80, color: Colors.red[300]),
                        const SizedBox(height: 16),
                        Text(
                          state.failureMessage,
                          style: const TextStyle(color: Colors.red, fontSize: 16),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () => context.read<VaultBloc>().add(LoadVaults()),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryColor,
                            foregroundColor: Colors.white,
                          ),
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
    );
  }
}
