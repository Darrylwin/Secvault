import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/user_role.dart';
import '../bloc/vault_access_bloc.dart';
import '../bloc/vault_access_event.dart';

class InviteUserDialog extends StatelessWidget {
  final TextEditingController userEmailController;
  final String vaultId;

  const InviteUserDialog({
    super.key,
    required this.userEmailController,
    required this.vaultId,
  });

  @override
  Widget build(BuildContext context) => AlertDialog(
        title: const Text('Invite User'),
        content: TextField(
          controller: userEmailController,
          decoration: const InputDecoration(
            labelText: 'Email Address',
            hintText: 'Enter email to invite',
            prefixIcon: Icon(Icons.email_outlined),
          ),
          keyboardType: TextInputType.emailAddress,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('CANCEL'),
          ),
          ElevatedButton(
            onPressed: () {
              final email = userEmailController.text.trim();
              if (email.isNotEmpty) {
                context.read<VaultAccessBloc>().add(
                      InviteUserToVaultEvent(
                        vaultId: vaultId,
                        userEmail: email,
                        role: UserRole.reader,
                      ),
                    );
              }
              Navigator.of(context).pop();
            },
            child: const Text('INVITE'),
          ),
        ],
      );
}
