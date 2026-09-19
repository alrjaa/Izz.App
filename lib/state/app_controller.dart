import 'dart:math';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:izz_app/domain/models.dart';
import 'package:izz_app/state/app_state.dart';

final appControllerProvider =
    StateNotifierProvider<AppController, AppState>((ref) {
  return AppController();
});

class AppController extends StateNotifier<AppState> {
  AppController() : super(_seedState());

  void toggleLocale() {
    state = state.copyWith(localeCode: state.localeCode == 'ar' ? 'en' : 'ar');
  }

  void signIn(String userId) {
    final user = state.users.where((item) => item.id == userId).firstOrNull;
    if (user == null) {
      return;
    }

    state = state.copyWith(
      currentUserId: userId,
      localeCode: user.localeCode,
    );
  }

  void signOut() {
    state = state.copyWith(currentUserId: null);
  }

  OwnerProfile createOwner({
    required String name,
    required String region,
    required String bio,
  }) {
    _assertRole(const {UserRole.owner, UserRole.admin});
    final user = _requireUser();
    final existing = state.owners.where((item) => item.userId == user.id).firstOrNull;
    if (existing != null) {
      throw StateError('Owner profile already exists');
    }
    final owner = OwnerProfile(
      id: _id('owner'),
      userId: user.id,
      name: name,
      region: region,
      bio: bio,
      verified: false,
    );
    state = state.copyWith(owners: [...state.owners, owner]);
    return owner;
  }

  CamelProfile addCamel({
    required String ownerId,
    required String name,
    required String gender,
    required String ageLabel,
    required String color,
    required String summary,
  }) {
    _assertCanManageOwner(ownerId);
    final camel = CamelProfile(
      id: _id('camel'),
      ownerId: ownerId,
      name: name,
      gender: gender,
      ageLabel: ageLabel,
      color: color,
      summary: summary,
      mediaUrls: const [],
    );
    state = state.copyWith(camels: [...state.camels, camel]);
    return camel;
  }

  ResultRecord createPendingResult({
    required String participantId,
    required int position,
    required double score,
    required String notes,
  }) {
    _assertRole(const {UserRole.organizer, UserRole.admin});
    final result = ResultRecord(
      id: _id('result'),
      participantId: participantId,
      position: position,
      score: score,
      status: ResultStatus.pending,
      isOfficial: false,
      notes: notes,
    );
    state = state.copyWith(results: [...state.results, result]);
    return result;
  }

  WinnerCard approveResult(String resultId) {
    _assertRole(const {UserRole.organizer, UserRole.admin});
    final approver = _requireUser();
    final result = state.results.firstWhere((item) => item.id == resultId);
    final updated = result.copyWith(
      status: ResultStatus.approved,
      isOfficial: true,
      approvedByUserId: approver.id,
      winnerCardId: _id('wc'),
    );

    final participant =
        state.participants.firstWhere((item) => item.id == result.participantId);
    final round = state.rounds.firstWhere((item) => item.id == participant.roundId);
    final category =
        state.categories.firstWhere((item) => item.id == round.categoryId);
    final competition = state.competitions
        .firstWhere((item) => item.id == category.competitionId);
    final championship = state.championships
        .firstWhere((item) => item.id == competition.championshipId);

    final winnerCard = WinnerCard(
      id: updated.winnerCardId!,
      resultId: updated.id,
      verificationCode: _verificationCode(updated.id),
      badgeTitle: 'Official Winner Card',
      location: championship.location,
      dateLabel: championship.season,
    );

    final results = [
      for (final item in state.results) item.id == resultId ? updated : item,
    ];

    final audit = AuditEntry(
      id: _id('audit'),
      actorUserId: approver.id,
      action: 'approve_result',
      entityType: 'result',
      entityId: resultId,
    );

    final notifications = [...state.notifications];
    final ownerId = participant.ownerId;
    final owner = state.owners.firstWhere((item) => item.id == ownerId);
    notifications.insert(
      0,
      NotificationItem(
        id: _id('notification'),
        userId: owner.userId,
        title: 'Official result approved',
        body: '${competition.name} / ${round.name}',
        route: '/winner-cards/${winnerCard.verificationCode}',
      ),
    );

    state = state.copyWith(
      results: results,
      winnerCards: [winnerCard, ...state.winnerCards],
      auditEntries: [audit, ...state.auditEntries],
      notifications: notifications,
    );
    return winnerCard;
  }

  void toggleLike(String contentId) {
    final user = _requireUser();
    final content = state.contents.firstWhere((item) => item.id == contentId);
    final liked = content.likeUserIds.contains(user.id);
    final likes = liked
        ? content.likeUserIds.where((item) => item != user.id).toList()
        : [...content.likeUserIds, user.id];
    _updateContent(content.copyWith(likeUserIds: likes));
    if (!liked) {
      _notify(content.authorUserId, 'New like', content.title, '/');
    }
  }

  void toggleSave(String contentId) {
    final user = _requireUser();
    final content = state.contents.firstWhere((item) => item.id == contentId);
    final saved = content.savedByUserIds.contains(user.id);
    final saves = saved
        ? content.savedByUserIds.where((item) => item != user.id).toList()
        : [...content.savedByUserIds, user.id];
    _updateContent(content.copyWith(savedByUserIds: saves));
  }

  void toggleFollowOwner(String ownerId) {
    final user = _requireUser();
    final followed = state.followedOwnerIds.contains(ownerId);
    final next = followed
        ? state.followedOwnerIds.where((item) => item != ownerId).toList()
        : [...state.followedOwnerIds, ownerId];
    state = state.copyWith(followedOwnerIds: next);
    if (!followed) {
      final owner = state.owners.firstWhere((item) => item.id == ownerId);
      _notify(owner.userId, 'New follower', user.name, '/owners/$ownerId');
    }
  }

  void addComment({
    required String contentId,
    required String body,
    String? parentCommentId,
  }) {
    final user = _requireUser();
    final comment = CommentItem(
      id: _id('comment'),
      contentId: contentId,
      authorUserId: user.id,
      body: body,
      replyIds: const [],
      parentCommentId: parentCommentId,
    );

    final comments = [...state.comments, comment];
    final content = state.contents.firstWhere((item) => item.id == contentId);
    final updatedContent = content.copyWith(commentIds: [...content.commentIds, comment.id]);
    final updatedComments = comments.map((item) {
      if (item.id != parentCommentId) {
        return item;
      }
      return item.copyWith(replyIds: [...item.replyIds, comment.id]);
    }).toList();

    state = state.copyWith(
      comments: updatedComments,
      contents: [
        for (final item in state.contents)
          item.id == contentId ? updatedContent : item,
      ],
    );
    _notify(content.authorUserId, 'New comment', body, '/');
  }

  void addContent({
    required ContentType type,
    required String title,
    required String body,
    required LinkedEntityType linkedEntityType,
    required String linkedEntityId,
    String? mediaLabel,
  }) {
    final user = _requireUser();
    final content = ContentItem(
      id: _id('content'),
      authorUserId: user.id,
      type: type,
      title: title,
      body: body,
      linkedEntityType: linkedEntityType,
      linkedEntityId: linkedEntityId,
      likeUserIds: const [],
      savedByUserIds: const [],
      commentIds: const [],
      mediaLabel: mediaLabel,
    );
    state = state.copyWith(contents: [content, ...state.contents]);
  }

  void addReport({
    required ReportTargetType targetType,
    required String targetId,
    required String reason,
  }) {
    final user = _requireUser();
    final report = ReportItem(
      id: _id('report'),
      reporterUserId: user.id,
      targetType: targetType,
      targetId: targetId,
      reason: reason,
      status: ResultStatus.pending,
    );
    state = state.copyWith(reports: [report, ...state.reports]);
  }

  WinnerCard? findWinnerCardByCode(String verificationCode) {
    for (final item in state.winnerCards) {
      if (item.verificationCode == verificationCode) {
        return item;
      }
    }
    return null;
  }

  void markNotificationRead(String notificationId) {
    state = state.copyWith(
      notifications: [
        for (final item in state.notifications)
          item.id == notificationId ? item.copyWith(read: true) : item,
      ],
    );
  }

  void _updateContent(ContentItem updated) {
    state = state.copyWith(
      contents: [
        for (final item in state.contents)
          item.id == updated.id ? updated : item,
      ],
    );
  }

  void _notify(String userId, String title, String body, String route) {
    state = state.copyWith(
      notifications: [
        NotificationItem(
          id: _id('notification'),
          userId: userId,
          title: title,
          body: body,
          route: route,
        ),
        ...state.notifications,
      ],
    );
  }

  AppUser _requireUser() {
    final user = state.currentUser;
    if (user == null) {
      throw StateError('Authentication required');
    }
    return user;
  }

  void _assertCanManageOwner(String ownerId) {
    final user = _requireUser();
    if (user.role == UserRole.admin) {
      return;
    }

    final owner = state.owners.firstWhere((item) => item.id == ownerId);
    if (user.role == UserRole.owner && owner.userId == user.id) {
      return;
    }

    throw StateError('Forbidden');
  }

  void _assertRole(Set<UserRole> roles) {
    final user = _requireUser();
    if (!roles.contains(user.role)) {
      throw StateError('Forbidden');
    }
  }

  String _id(String prefix) => '$prefix-${Random().nextInt(9999999)}';

  String _verificationCode(String resultId) {
    final suffix = resultId.replaceAll(RegExp(r'[^0-9]'), '').padLeft(6, '0');
    return 'IZZ-$suffix';
  }
}

AppState _seedState() {
  const users = [
    AppUser(
      id: 'user-follower',
      name: 'فاطمة / Fatima',
      email: 'fatima@izz.app',
      role: UserRole.follower,
      localeCode: 'ar',
    ),
    AppUser(
      id: 'user-owner',
      name: 'سالم الراشد / Salem',
      email: 'salem@izz.app',
      role: UserRole.owner,
      localeCode: 'ar',
    ),
    AppUser(
      id: 'user-sponsor',
      name: 'Desert Energy',
      email: 'sponsor@izz.app',
      role: UserRole.sponsor,
      localeCode: 'en',
    ),
    AppUser(
      id: 'user-organizer',
      name: 'نادي العز',
      email: 'organizer@izz.app',
      role: UserRole.organizer,
      localeCode: 'ar',
    ),
    AppUser(
      id: 'user-admin',
      name: 'Platform Admin',
      email: 'admin@izz.app',
      role: UserRole.admin,
      localeCode: 'en',
    ),
  ];

  const owners = [
    OwnerProfile(
      id: 'owner-1',
      userId: 'user-owner',
      name: 'سالم بن راشد',
      region: 'الرياض',
      bio: 'مالك هجن سباقات ومزاين مع سجل نتائج رسمي وغير رسمي.',
      verified: true,
    ),
  ];

  const camels = [
    CamelProfile(
      id: 'camel-1',
      ownerId: 'owner-1',
      name: 'وضحا',
      gender: 'بكار',
      ageLabel: 'حقايق',
      color: 'وضحاء',
      summary: 'مطية منافسة في أشواط السرعة النهائية.',
      mediaUrls: [],
    ),
    CamelProfile(
      id: 'camel-2',
      ownerId: 'owner-1',
      name: 'شاهين',
      gender: 'قعدان',
      ageLabel: 'لقايا',
      color: 'أشعل',
      summary: 'مطية مشاركة في بطولات الموسم الحالية.',
      mediaUrls: [],
    ),
  ];

  const sponsors = [
    SponsorProfile(
      id: 'sponsor-1',
      userId: 'user-sponsor',
      name: 'طاقة الصحراء',
      about: 'راعي رئيسي للبطولات الكبرى والجوائز.',
      website: 'https://example.com/sponsor',
    ),
  ];

  const championships = [
    Championship(
      id: 'champ-1',
      name: 'بطولة عز الكبرى',
      location: 'الرياض',
      season: '2026',
      isCurrent: true,
      sponsorIds: ['sponsor-1'],
    ),
    Championship(
      id: 'champ-2',
      name: 'Izz Winter Championship',
      location: 'Hail',
      season: '2026',
      isCurrent: false,
      sponsorIds: ['sponsor-1'],
    ),
  ];

  const competitions = [
    Competition(
      id: 'competition-1',
      championshipId: 'champ-1',
      name: 'سباق حقايق',
    ),
  ];

  const categories = [
    Category(
      id: 'category-1',
      competitionId: 'competition-1',
      name: 'بكار',
    ),
  ];

  const rounds = [
    RoundModel(
      id: 'round-1',
      categoryId: 'category-1',
      name: 'الشوط النهائي',
    ),
  ];

  const participants = [
    Participant(
      id: 'participant-1',
      roundId: 'round-1',
      camelId: 'camel-1',
      ownerId: 'owner-1',
      bibNumber: 'A12',
    ),
    Participant(
      id: 'participant-2',
      roundId: 'round-1',
      camelId: 'camel-2',
      ownerId: 'owner-1',
      bibNumber: 'A14',
    ),
  ];

  const awards = [
    Award(
      id: 'award-1',
      roundId: 'round-1',
      place: 1,
      title: 'كأس المركز الأول',
      amountLabel: '100,000 SAR',
    ),
    Award(
      id: 'award-2',
      roundId: 'round-1',
      place: 2,
      title: 'جائزة الوصيف',
      amountLabel: '50,000 SAR',
    ),
  ];

  const approvedResult = ResultRecord(
    id: 'result-1',
    participantId: 'participant-1',
    position: 1,
    score: 94.8,
    status: ResultStatus.approved,
    isOfficial: true,
    notes: 'اعتماد رسمي',
    approvedByUserId: 'user-admin',
    winnerCardId: 'wc-1',
  );

  const pendingResult = ResultRecord(
    id: 'result-2',
    participantId: 'participant-2',
    position: 2,
    score: 89.4,
    status: ResultStatus.pending,
    isOfficial: false,
    notes: 'بانتظار اعتماد اللجنة',
  );

  const winnerCards = [
    WinnerCard(
      id: 'wc-1',
      resultId: 'result-1',
      verificationCode: 'IZZ-000001',
      badgeTitle: 'Official Winner Card',
      location: 'الرياض',
      dateLabel: '2026',
    ),
  ];

  const contents = [
    ContentItem(
      id: 'content-1',
      authorUserId: 'user-owner',
      type: ContentType.post,
      title: 'فرحة التتويج',
      body: 'وضحا أنهت الشوط النهائي بقوة وتستعد لبطولة الموسم القادمة.',
      linkedEntityType: LinkedEntityType.camel,
      linkedEntityId: 'camel-1',
      likeUserIds: ['user-follower'],
      savedByUserIds: [],
      commentIds: ['comment-1'],
      mediaLabel: null,
    ),
    ContentItem(
      id: 'content-2',
      authorUserId: 'user-sponsor',
      type: ContentType.video,
      title: 'Sponsor recap',
      body: 'Short-form coverage linked to the current championship sponsor.',
      linkedEntityType: LinkedEntityType.sponsor,
      linkedEntityId: 'sponsor-1',
      likeUserIds: const [],
      savedByUserIds: const [],
      commentIds: const [],
      mediaLabel: 'Video metadata ready for CDN playback integration',
    ),
  ];

  const comments = [
    CommentItem(
      id: 'comment-1',
      contentId: 'content-1',
      authorUserId: 'user-follower',
      body: 'مبروك يا بطل!',
      replyIds: const [],
    ),
  ];

  const notifications = [
    NotificationItem(
      id: 'notification-1',
      userId: 'user-owner',
      title: 'Official winner card published',
      body: 'تم نشر بطاقة الفوز الرسمية لوضحا',
      route: '/winner-cards/IZZ-000001',
    ),
  ];

  return const AppState(
    localeCode: 'ar',
    users: users,
    currentUserId: 'user-owner',
    owners: owners,
    camels: camels,
    sponsors: sponsors,
    championships: championships,
    competitions: competitions,
    categories: categories,
    rounds: rounds,
    participants: participants,
    awards: awards,
    results: [approvedResult, pendingResult],
    winnerCards: winnerCards,
    contents: contents,
    comments: comments,
    notifications: notifications,
    reports: [],
    auditEntries: [],
    followedOwnerIds: [],
  );
}

extension<T> on Iterable<T> {
  T? get firstOrNull {
    if (isEmpty) {
      return null;
    }
    return first;
  }
}
