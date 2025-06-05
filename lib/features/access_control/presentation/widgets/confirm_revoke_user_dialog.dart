import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:secvault/features/access_control/presentation/bloc/vault_access_event.dart';

import '../bloc/vault_access_bloc.dart';

class ConfirmRevokeUserDialog extends StatelessWidget {
  final String? userName;
  final String vaultId;
  final String userId;

  const ConfirmRevokeUserDialog({
    super.key,
    required this.userName,
    required this.vaultId,
    required this.userId,
  });

  @override
  Widget build(BuildContext context) => AlertDialog(
        title: const Text('Remove Member'),
        content: Text(
            'Are you sure you want to remove ${userName ?? 'this user'} from this vault?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('CANCEL'),
          ),
          ElevatedButton(
            onPressed: () {
              final bloc = context.read<VaultAccessBloc>();
              Navigator.of(context).pop();
              bloc.add(
                RevokeUserAccessEvent(
                  vaultId: vaultId,
                  userId: userId,
                ),
              );
              // Rafraîchir la liste des membres après la révocation
              Future.delayed(const Duration(milliseconds: 300), () {
                bloc.add(ListVaultMembersEvent(vaultId: vaultId));
              });
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
            child: const Text('REMOVE'),
          ),
        ],
      );
}
