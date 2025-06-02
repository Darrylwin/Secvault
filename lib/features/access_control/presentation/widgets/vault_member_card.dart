import 'package:flutter/material.dart';
import 'package:secvault/features/access_control/domain/entities/user_role.dart';

import '../../../../core/themes/light_theme.dart';

class VaultMemberCard extends StatelessWidget {
  final String? userName;
  final String userEmail;
  final UserRole role;
  final VoidCallback showConfirmRevokeUserDialog;

  const VaultMemberCard({
    super.key,
    required this.userName,
    required this.userEmail,
    required this.role,
    required this.showConfirmRevokeUserDialog,
  });

  @override
  Widget build(BuildContext context) => Card(
        elevation: 0,
        margin: const EdgeInsets.symmetric(vertical: 4),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: Colors.grey.shade200),
        ),
        child: ListTile(
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          leading: CircleAvatar(
            backgroundColor: primaryColor.withOpacity(0.2),
            child: Text(
              userName!.isNotEmpty ? userName![0].toUpperCase() : '?',
              style: const TextStyle(
                color: primaryColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          title: Text(
            userName ?? '?',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontSize: 16,
                ),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 4),
              Text(
                userEmail,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  role.name.toUpperCase(),
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
            ],
          ),
          trailing: IconButton(
            icon: Icon(
              Icons.delete_outline,
              color: Theme.of(context).colorScheme.error,
            ),
            onPressed: () => showConfirmRevokeUserDialog,
          ),
        ),
      );
}
