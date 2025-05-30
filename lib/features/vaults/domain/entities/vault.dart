class Vault {
  final String id;
  final String name;
  final DateTime createdAt;

  Vault({
    required this.id,
    required this.name,
    required this.createdAt,
  });

  @override
  String toString() => 'Vault{id: $id, name: $name, createdAt: $createdAt}';
}
