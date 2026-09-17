import 'package:flutter/material.dart';

import '../../app/theme/app_theme.dart';
import '../../data/mock/mock_data.dart';
import '../shell/session.dart';

class HomeDashboardScreen extends StatefulWidget {
  const HomeDashboardScreen({required this.session, super.key});

  final AppSession session;

  @override
  State<HomeDashboardScreen> createState() => _HomeDashboardScreenState();
}

class _HomeDashboardScreenState extends State<HomeDashboardScreen> {
  String _activeTab = 'mazayin';

  @override
  Widget build(BuildContext context) {
    final competitions = MockData.competitions
        .where((item) => _activeTab == 'all' || item.type == _activeTab)
        .toList();

    return ListView(
      key: const Key('home_dashboard'),
      padding: const EdgeInsets.all(16),
      children: [
        SegmentedButton<String>(
          showSelectedIcon: false,
          segments: const [
            ButtonSegment(value: 'mazayin', label: Text('مزاين الإبل')),
            ButtonSegment(value: 'hejin', label: Text('سباقات الهجن')),
            ButtonSegment(value: 'all', label: Text('الكل')),
          ],
          selected: {_activeTab},
          onSelectionChanged: (selection) {
            setState(() => _activeTab = selection.first);
          },
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: AppTheme.heroGradient,
          ),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'البث المباشر / الشوط الحالي',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'شوط حقايق بكار - 3 كم • تبقى 07:35',
                style: TextStyle(color: Colors.white),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        const _SectionHeader(title: 'المسابقات القادمة'),
        const SizedBox(height: 8),
        ...competitions.map(
          (item) => Card(
            child: ListTile(
              title: Text(item.title),
              subtitle: Text(
                '${item.type == 'mazayin' ? 'مزاين' : 'هجن'} • ${item.location} • ${_date(item.startDate)}',
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        const _SectionHeader(title: 'أحدث الوسائط والتغطيات'),
        const SizedBox(height: 8),
        SizedBox(
          height: 120,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: MockData.media.length,
            separatorBuilder: (_, __) => const SizedBox(width: 8),
            itemBuilder: (context, index) {
              final item = MockData.media[index];
              return Container(
                width: 180,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppTheme.dune.withOpacity(0.4)),
                ),
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(item.mediaType == 'video' ? '🎬 فيديو' : '📷 صورة'),
                    const SizedBox(height: 6),
                    Text('مشاهدات ${item.viewsCount}'),
                    Text('إعجابات ${item.likesCount}'),
                  ],
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 16),
        const _SectionHeader(title: 'الرعاة المميزون'),
        const SizedBox(height: 8),
        SizedBox(
          height: 58,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: MockData.sponsors.length,
            separatorBuilder: (_, __) => const SizedBox(width: 8),
            itemBuilder: (context, index) {
              final sponsor = MockData.sponsors[index];
              return Chip(
                backgroundColor: AppTheme.gold.withOpacity(0.2),
                label: Text('${sponsor.name} (${sponsor.tier})'),
              );
            },
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'مرحبًا ${widget.session.phoneNumber} • دورك: ${widget.session.role}',
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }

  static String _date(DateTime dateTime) =>
      '${dateTime.day.toString().padLeft(2, '0')}/${dateTime.month.toString().padLeft(2, '0')}/${dateTime.year}';
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w800,
          ),
    );
  }
}
