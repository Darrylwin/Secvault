import 'package:flutter/cupertino.dart';
import 'package:secvault/features/access_control/presentation/screens/vault_members_page.dart';
import 'package:secvault/features/vaults/presentation/screens/home_page.dart';
import '../features/auth/presentation/screens/login_page.dart';
import '../features/auth/presentation/screens/register_page.dart';

final Map<String, Widget Function(BuildContext)> routes = {
  '/login': (context) => const LoginPage(),
  '/register': (context) => const RegisterPage(),
  '/home': (context) => const HomePage(),
  '/vault-members': (context) => VaultMembersPage(
        vaultId: ModalRoute.of(context)?.settings.arguments as String,
      ),
};
