class OwnerProfile {
  const OwnerProfile({
    required this.id,
    required this.userId,
    required this.catteryOrStableName,
    required this.logoUrl,
    required this.bio,
    required this.verifiedStatus,
    required this.socialLinks,
  });

  final String id;
  final String userId;
  final String catteryOrStableName;
  final String? logoUrl;
  final String? bio;
  final bool verifiedStatus;
  final Map<String, String> socialLinks;
}
