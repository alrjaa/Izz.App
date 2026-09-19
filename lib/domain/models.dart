enum UserRole { follower, owner, sponsor, organizer, admin }

enum ResultStatus { draft, pending, approved }

enum ContentType { post, video }

enum LinkedEntityType { owner, camel, championship, competition, sponsor }

enum ReportTargetType { user, owner, camel, content, comment, result }

class AppUser {
  const AppUser({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    required this.localeCode,
  });

  final String id;
  final String name;
  final String email;
  final UserRole role;
  final String localeCode;

  AppUser copyWith({
    String? id,
    String? name,
    String? email,
    UserRole? role,
    String? localeCode,
  }) {
    return AppUser(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      role: role ?? this.role,
      localeCode: localeCode ?? this.localeCode,
    );
  }
}

class OwnerProfile {
  const OwnerProfile({
    required this.id,
    required this.userId,
    required this.name,
    required this.region,
    required this.bio,
    required this.verified,
  });

  final String id;
  final String userId;
  final String name;
  final String region;
  final String bio;
  final bool verified;

  OwnerProfile copyWith({
    String? id,
    String? userId,
    String? name,
    String? region,
    String? bio,
    bool? verified,
  }) {
    return OwnerProfile(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      name: name ?? this.name,
      region: region ?? this.region,
      bio: bio ?? this.bio,
      verified: verified ?? this.verified,
    );
  }
}

class CamelProfile {
  const CamelProfile({
    required this.id,
    required this.ownerId,
    required this.name,
    required this.gender,
    required this.ageLabel,
    required this.color,
    required this.summary,
    required this.mediaUrls,
  });

  final String id;
  final String ownerId;
  final String name;
  final String gender;
  final String ageLabel;
  final String color;
  final String summary;
  final List<String> mediaUrls;

  CamelProfile copyWith({
    String? id,
    String? ownerId,
    String? name,
    String? gender,
    String? ageLabel,
    String? color,
    String? summary,
    List<String>? mediaUrls,
  }) {
    return CamelProfile(
      id: id ?? this.id,
      ownerId: ownerId ?? this.ownerId,
      name: name ?? this.name,
      gender: gender ?? this.gender,
      ageLabel: ageLabel ?? this.ageLabel,
      color: color ?? this.color,
      summary: summary ?? this.summary,
      mediaUrls: mediaUrls ?? this.mediaUrls,
    );
  }
}

class SponsorProfile {
  const SponsorProfile({
    required this.id,
    required this.userId,
    required this.name,
    required this.about,
    required this.website,
  });

  final String id;
  final String userId;
  final String name;
  final String about;
  final String website;
}

class Championship {
  const Championship({
    required this.id,
    required this.name,
    required this.location,
    required this.season,
    required this.isCurrent,
    required this.sponsorIds,
  });

  final String id;
  final String name;
  final String location;
  final String season;
  final bool isCurrent;
  final List<String> sponsorIds;

  Championship copyWith({
    String? id,
    String? name,
    String? location,
    String? season,
    bool? isCurrent,
    List<String>? sponsorIds,
  }) {
    return Championship(
      id: id ?? this.id,
      name: name ?? this.name,
      location: location ?? this.location,
      season: season ?? this.season,
      isCurrent: isCurrent ?? this.isCurrent,
      sponsorIds: sponsorIds ?? this.sponsorIds,
    );
  }
}

class Competition {
  const Competition({
    required this.id,
    required this.championshipId,
    required this.name,
  });

  final String id;
  final String championshipId;
  final String name;
}

class Category {
  const Category({
    required this.id,
    required this.competitionId,
    required this.name,
  });

  final String id;
  final String competitionId;
  final String name;
}

class RoundModel {
  const RoundModel({
    required this.id,
    required this.categoryId,
    required this.name,
  });

  final String id;
  final String categoryId;
  final String name;
}

class Participant {
  const Participant({
    required this.id,
    required this.roundId,
    required this.camelId,
    required this.ownerId,
    required this.bibNumber,
  });

  final String id;
  final String roundId;
  final String camelId;
  final String ownerId;
  final String bibNumber;
}

class Award {
  const Award({
    required this.id,
    required this.roundId,
    required this.place,
    required this.title,
    required this.amountLabel,
  });

  final String id;
  final String roundId;
  final int place;
  final String title;
  final String amountLabel;
}

class ResultRecord {
  const ResultRecord({
    required this.id,
    required this.participantId,
    required this.position,
    required this.score,
    required this.status,
    required this.isOfficial,
    required this.notes,
    this.approvedByUserId,
    this.winnerCardId,
  });

  final String id;
  final String participantId;
  final int position;
  final double score;
  final ResultStatus status;
  final bool isOfficial;
  final String notes;
  final String? approvedByUserId;
  final String? winnerCardId;

  ResultRecord copyWith({
    String? id,
    String? participantId,
    int? position,
    double? score,
    ResultStatus? status,
    bool? isOfficial,
    String? notes,
    String? approvedByUserId,
    String? winnerCardId,
  }) {
    return ResultRecord(
      id: id ?? this.id,
      participantId: participantId ?? this.participantId,
      position: position ?? this.position,
      score: score ?? this.score,
      status: status ?? this.status,
      isOfficial: isOfficial ?? this.isOfficial,
      notes: notes ?? this.notes,
      approvedByUserId: approvedByUserId ?? this.approvedByUserId,
      winnerCardId: winnerCardId ?? this.winnerCardId,
    );
  }
}

class WinnerCard {
  const WinnerCard({
    required this.id,
    required this.resultId,
    required this.verificationCode,
    required this.badgeTitle,
    required this.location,
    required this.dateLabel,
  });

  final String id;
  final String resultId;
  final String verificationCode;
  final String badgeTitle;
  final String location;
  final String dateLabel;
}

class ContentItem {
  const ContentItem({
    required this.id,
    required this.authorUserId,
    required this.type,
    required this.title,
    required this.body,
    required this.linkedEntityType,
    required this.linkedEntityId,
    required this.likeUserIds,
    required this.savedByUserIds,
    required this.commentIds,
    this.mediaLabel,
  });

  final String id;
  final String authorUserId;
  final ContentType type;
  final String title;
  final String body;
  final LinkedEntityType linkedEntityType;
  final String linkedEntityId;
  final List<String> likeUserIds;
  final List<String> savedByUserIds;
  final List<String> commentIds;
  final String? mediaLabel;

  ContentItem copyWith({
    String? id,
    String? authorUserId,
    ContentType? type,
    String? title,
    String? body,
    LinkedEntityType? linkedEntityType,
    String? linkedEntityId,
    List<String>? likeUserIds,
    List<String>? savedByUserIds,
    List<String>? commentIds,
    String? mediaLabel,
  }) {
    return ContentItem(
      id: id ?? this.id,
      authorUserId: authorUserId ?? this.authorUserId,
      type: type ?? this.type,
      title: title ?? this.title,
      body: body ?? this.body,
      linkedEntityType: linkedEntityType ?? this.linkedEntityType,
      linkedEntityId: linkedEntityId ?? this.linkedEntityId,
      likeUserIds: likeUserIds ?? this.likeUserIds,
      savedByUserIds: savedByUserIds ?? this.savedByUserIds,
      commentIds: commentIds ?? this.commentIds,
      mediaLabel: mediaLabel ?? this.mediaLabel,
    );
  }
}

class CommentItem {
  const CommentItem({
    required this.id,
    required this.contentId,
    required this.authorUserId,
    required this.body,
    required this.replyIds,
    this.parentCommentId,
  });

  final String id;
  final String contentId;
  final String authorUserId;
  final String body;
  final List<String> replyIds;
  final String? parentCommentId;

  CommentItem copyWith({
    String? id,
    String? contentId,
    String? authorUserId,
    String? body,
    List<String>? replyIds,
    String? parentCommentId,
  }) {
    return CommentItem(
      id: id ?? this.id,
      contentId: contentId ?? this.contentId,
      authorUserId: authorUserId ?? this.authorUserId,
      body: body ?? this.body,
      replyIds: replyIds ?? this.replyIds,
      parentCommentId: parentCommentId ?? this.parentCommentId,
    );
  }
}

class NotificationItem {
  const NotificationItem({
    required this.id,
    required this.userId,
    required this.title,
    required this.body,
    required this.route,
    this.read = false,
  });

  final String id;
  final String userId;
  final String title;
  final String body;
  final String route;
  final bool read;

  NotificationItem copyWith({
    String? id,
    String? userId,
    String? title,
    String? body,
    String? route,
    bool? read,
  }) {
    return NotificationItem(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      body: body ?? this.body,
      route: route ?? this.route,
      read: read ?? this.read,
    );
  }
}

class ReportItem {
  const ReportItem({
    required this.id,
    required this.reporterUserId,
    required this.targetType,
    required this.targetId,
    required this.reason,
    required this.status,
  });

  final String id;
  final String reporterUserId;
  final ReportTargetType targetType;
  final String targetId;
  final String reason;
  final ResultStatus status;
}

class AuditEntry {
  const AuditEntry({
    required this.id,
    required this.actorUserId,
    required this.action,
    required this.entityType,
    required this.entityId,
  });

  final String id;
  final String actorUserId;
  final String action;
  final String entityType;
  final String entityId;
}
