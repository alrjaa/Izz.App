class MediaItem {
  const MediaItem({
    required this.id,
    required this.uploaderId,
    required this.competitionId,
    required this.animalId,
    required this.mediaType,
    required this.mediaUrl,
    required this.thumbnailUrl,
    required this.viewsCount,
    required this.likesCount,
    required this.createdAt,
  });

  final String id;
  final String uploaderId;
  final String? competitionId;
  final String? animalId;
  final String mediaType;
  final String mediaUrl;
  final String? thumbnailUrl;
  final int viewsCount;
  final int likesCount;
  final DateTime createdAt;
}

class Sponsor {
  const Sponsor({
    required this.id,
    required this.competitionId,
    required this.name,
    required this.tier,
    required this.logoUrl,
    required this.websiteUrl,
  });

  final String id;
  final String competitionId;
  final String name;
  final String tier;
  final String? logoUrl;
  final String? websiteUrl;
}
