import 'package:izz_app/domain/models.dart';

class AppState {
  const AppState({
    required this.localeCode,
    required this.users,
    required this.currentUserId,
    required this.owners,
    required this.camels,
    required this.sponsors,
    required this.championships,
    required this.competitions,
    required this.categories,
    required this.rounds,
    required this.participants,
    required this.awards,
    required this.results,
    required this.winnerCards,
    required this.contents,
    required this.comments,
    required this.notifications,
    required this.reports,
    required this.auditEntries,
    required this.followedOwnerIds,
  });

  final String localeCode;
  final List<AppUser> users;
  final String? currentUserId;
  final List<OwnerProfile> owners;
  final List<CamelProfile> camels;
  final List<SponsorProfile> sponsors;
  final List<Championship> championships;
  final List<Competition> competitions;
  final List<Category> categories;
  final List<RoundModel> rounds;
  final List<Participant> participants;
  final List<Award> awards;
  final List<ResultRecord> results;
  final List<WinnerCard> winnerCards;
  final List<ContentItem> contents;
  final List<CommentItem> comments;
  final List<NotificationItem> notifications;
  final List<ReportItem> reports;
  final List<AuditEntry> auditEntries;
  final List<String> followedOwnerIds;

  AppUser? get currentUser {
    if (currentUserId == null) {
      return null;
    }

    for (final user in users) {
      if (user.id == currentUserId) {
        return user;
      }
    }
    return null;
  }

  AppState copyWith({
    String? localeCode,
    List<AppUser>? users,
    Object? currentUserId = _sentinel,
    List<OwnerProfile>? owners,
    List<CamelProfile>? camels,
    List<SponsorProfile>? sponsors,
    List<Championship>? championships,
    List<Competition>? competitions,
    List<Category>? categories,
    List<RoundModel>? rounds,
    List<Participant>? participants,
    List<Award>? awards,
    List<ResultRecord>? results,
    List<WinnerCard>? winnerCards,
    List<ContentItem>? contents,
    List<CommentItem>? comments,
    List<NotificationItem>? notifications,
    List<ReportItem>? reports,
    List<AuditEntry>? auditEntries,
    List<String>? followedOwnerIds,
  }) {
    return AppState(
      localeCode: localeCode ?? this.localeCode,
      users: users ?? this.users,
      currentUserId: identical(currentUserId, _sentinel)
          ? this.currentUserId
          : currentUserId as String?,
      owners: owners ?? this.owners,
      camels: camels ?? this.camels,
      sponsors: sponsors ?? this.sponsors,
      championships: championships ?? this.championships,
      competitions: competitions ?? this.competitions,
      categories: categories ?? this.categories,
      rounds: rounds ?? this.rounds,
      participants: participants ?? this.participants,
      awards: awards ?? this.awards,
      results: results ?? this.results,
      winnerCards: winnerCards ?? this.winnerCards,
      contents: contents ?? this.contents,
      comments: comments ?? this.comments,
      notifications: notifications ?? this.notifications,
      reports: reports ?? this.reports,
      auditEntries: auditEntries ?? this.auditEntries,
      followedOwnerIds: followedOwnerIds ?? this.followedOwnerIds,
    );
  }
}

const _sentinel = Object();
