class VaultMember {
  final String userId;
  final String userName;
  final String email;
  final String role;

  VaultMember({
    required this.userId,
    required this.userName,
    required this.email,
    required this.role,
  });

  @override
  String toString() {
    return 'VaultMember(id: $userId, name: $userName, email: $email, role: $role)';
  }
}
