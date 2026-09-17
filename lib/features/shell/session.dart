class AppSession {
  const AppSession({
    required this.phoneNumber,
    required this.role,
    required this.interests,
  });

  final String phoneNumber;
  final String role;
  final List<String> interests;
}
