import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:secvault/features/access_control/presentation/bloc/vault_access_bloc.dart';
import 'package:secvault/features/access_control/presentation/bloc/vault_access_state.dart';
import 'package:secvault/features/access_control/presentation/widgets/confirm_revoke_user_dialog.dart';
import 'package:secvault/features/access_control/presentation/widgets/invite_user_dialog.dart';
import 'package:secvault/features/access_control/presentation/widgets/vault_member_card.dart';

import '../../../../core/themes/light_theme.dart';

class VaultMembersPage extends StatelessWidget {
  final String vaultId;
  final TextEditingController userEmailController = TextEditingController();

  VaultMembersPage({
    super.key,
    required this.vaultId,
  });

  void showInviteUserDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => InviteUserDialog(
        userEmailController: userEmailController,
        vaultId: vaultId,
      ),
    );
  }

  void showConfirmRevokeUserDialog(
    BuildContext context, {
    required String userName,
    required String userId,
  }) {
    showDialog(
      context: context,
      builder: (context) => ConfirmRevokeUserDialog(
        userName: userName,
        vaultId: vaultId,
        userId: userId,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Vault Members",
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
        onPressed: () => showInviteUserDialog(context),
        backgroundColor: primaryColor,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text(
          'Invite a user',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: BlocBuilder<VaultAccessBloc, VaultAccessState>(
        builder: (context, state) {
          if (state is VaultAccessLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is VaultAccessError) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.error_outline,
                      color: Theme.of(context).colorScheme.error, size: 48),
                  const SizedBox(height: 16),
                  Text(
                    state.errorMessage,
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.error,
                        fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          } else if (state is VaultMembersLoaded) {
            final members = state.members;
            if (members.isEmpty) {
              return Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.lock_outline,
                      size: 200,
                      color: primaryColor,
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'No members found',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Add members to your vault by clicking the button below',
                      style: Theme.of(context).textTheme.bodyMedium,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              );
            }
            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(4, 16, 4, 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Members',
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: primaryColor,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            '${members.length}',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Divider(height: 1),
                  const SizedBox(height: 8),
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: members.length,
                    separatorBuilder: (context, index) => const Divider(
                      height: 1,
                      indent: 70,
                    ),
                    itemBuilder: (context, index) {
                      final member = members[index];
                      return VaultMemberCard(
                        userEmail: member.email,
                        role: member.role,
                        userName: member.userName,
                        showConfirmRevokeUserDialog: () =>
                            showConfirmRevokeUserDialog(
                          context,
                          userName: member.userName,
                          userId: member.userId,
                        ),
                      );
                    },
                  ),
                ],
              ),
            );
          }
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.group_outlined, size: 64, color: Colors.grey[400]),
                const SizedBox(height: 16),
                Text(
                  'No data available',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        color: Colors.grey[600],
                      ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
