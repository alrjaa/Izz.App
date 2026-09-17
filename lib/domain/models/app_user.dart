class AppUser {
  const AppUser({
    required this.id,
    required this.fullName,
    required this.phoneNumber,
    required this.email,
    required this.role,
    required this.avatarUrl,
    required this.createdAt,
  });

  final String id;
  final String fullName;
  final String phoneNumber;
  final String? email;
  final String role;
  final String? avatarUrl;
  final DateTime createdAt;
}
