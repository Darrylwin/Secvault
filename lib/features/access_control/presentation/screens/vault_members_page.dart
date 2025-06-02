import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:secvault/features/access_control/domain/entities/user_role.dart';
import 'package:secvault/features/access_control/presentation/bloc/vault_access_bloc.dart';
import 'package:secvault/features/access_control/presentation/bloc/vault_access_event.dart';

import '../../../../core/themes/light_theme.dart';

class VaultMembersPage extends StatelessWidget {
  final String vaultId;
  final TextEditingController userEmailController = TextEditingController();

  VaultMembersPage({
    super.key,
    required this.vaultId,
  });

  void Function()? showInviteUserDialog() {}

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
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          context.read<VaultAccessBloc>().add(
                InviteUserToVaultEvent(
                  vaultId: vaultId,
                  userEmail: userEmailController.text.trim(),
                  role: UserRole.reader,
                ),
              );
          showInviteUserDialog;
        },
        backgroundColor: primaryColor,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text(
          'Invite a user',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Secured Files',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  CircleAvatar(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    radius: 12,
                    child: Text(
                      '${_members.length}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            ListView.builder(
              itemBuilder: (context, index) {},
              itemCount: null,
            )
          ],
        ),
      ),
    );
  }
}
