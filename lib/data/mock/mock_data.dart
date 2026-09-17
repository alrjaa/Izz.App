import '../../domain/models/models.dart';

class MockData {
  MockData._();

  static const competitions = [
    Competition(
      id: 'cmp-1',
      title: 'مهرجان الملك عبدالعزيز للإبل',
      type: 'mazayin',
      location: 'الصياهد',
      latitude: 24.476,
      longitude: 46.413,
      startDate: DateTime(2026, 10, 10),
      endDate: DateTime(2026, 10, 20),
      status: 'upcoming',
      bannerUrl: null,
    ),
    Competition(
      id: 'cmp-2',
      title: 'سباق المرموم للهجن',
      type: 'hejin',
      location: 'دبي',
      latitude: 25.040,
      longitude: 55.340,
      startDate: DateTime(2026, 11, 2),
      endDate: DateTime(2026, 11, 9),
      status: 'live',
      bannerUrl: null,
    ),
  ];

  static const rounds = [
    CompetitionRound(
      id: 'rnd-1',
      competitionId: 'cmp-1',
      title: 'فردي مجاهيم',
      distance: null,
      scheduledTime: DateTime(2026, 10, 10, 16),
    ),
    CompetitionRound(
      id: 'rnd-2',
      competitionId: 'cmp-2',
      title: 'حقايق بكار - 3 كم',
      distance: 3000,
      scheduledTime: DateTime(2026, 11, 2, 14),
    ),
  ];

  static const media = [
    MediaItem(
      id: 'md-1',
      uploaderId: 'usr-1',
      competitionId: 'cmp-2',
      animalId: null,
      mediaType: 'video',
      mediaUrl: 'local://media/race-highlight.mp4',
      thumbnailUrl: null,
      viewsCount: 5240,
      likesCount: 860,
      createdAt: DateTime(2026, 11, 2, 15, 20),
    ),
    MediaItem(
      id: 'md-2',
      uploaderId: 'usr-2',
      competitionId: 'cmp-1',
      animalId: 'anm-1',
      mediaType: 'image',
      mediaUrl: 'local://media/mazayin-camel.jpg',
      thumbnailUrl: null,
      viewsCount: 3100,
      likesCount: 560,
      createdAt: DateTime(2026, 10, 10, 17),
    ),
  ];

  static const sponsors = [
    Sponsor(
      id: 'sp-1',
      competitionId: 'cmp-1',
      name: 'راعي الصحراء',
      tier: 'platinum',
      logoUrl: null,
      websiteUrl: null,
    ),
    Sponsor(
      id: 'sp-2',
      competitionId: 'cmp-2',
      name: 'ذهب الميدان',
      tier: 'gold',
      logoUrl: null,
      websiteUrl: null,
    ),
  ];
}
