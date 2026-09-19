import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:izz_app/core/app_copy.dart';
import 'package:izz_app/domain/models.dart';
import 'package:izz_app/state/app_controller.dart';
import 'package:izz_app/state/app_state.dart';

final _router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const HomePage(),
      routes: [
        GoRoute(
          path: 'owners',
          builder: (context, state) => const OwnersPage(),
          routes: [
            GoRoute(
              path: ':ownerId',
              builder: (context, state) => OwnerDetailPage(
                ownerId: state.pathParameters['ownerId']!,
              ),
            ),
          ],
        ),
        GoRoute(
          path: 'camels/:camelId',
          builder: (context, state) => CamelDetailPage(
            camelId: state.pathParameters['camelId']!,
          ),
        ),
        GoRoute(
          path: 'championships',
          builder: (context, state) => const ChampionshipsPage(),
          routes: [
            GoRoute(
              path: ':championshipId',
              builder: (context, state) => ChampionshipDetailPage(
                championshipId: state.pathParameters['championshipId']!,
              ),
            ),
          ],
        ),
        GoRoute(
          path: 'sponsors/:sponsorId',
          builder: (context, state) => SponsorDetailPage(
            sponsorId: state.pathParameters['sponsorId']!,
          ),
        ),
        GoRoute(
          path: 'admin',
          builder: (context, state) => const AdminPage(),
        ),
        GoRoute(
          path: 'login',
          builder: (context, state) => const LoginPage(),
        ),
        GoRoute(
          path: 'notifications',
          builder: (context, state) => const NotificationsPage(),
        ),
        GoRoute(
          path: 'search',
          builder: (context, state) =>
              SearchPage(query: state.uri.queryParameters['q'] ?? ''),
        ),
        GoRoute(
          path: 'winner-cards/:verificationCode',
          builder: (context, state) => WinnerCardPage(
            verificationCode: state.pathParameters['verificationCode']!,
          ),
        ),
      ],
    ),
  ],
);

class IzzApp extends ConsumerWidget {
  const IzzApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(appControllerProvider);
    return MaterialApp.router(
      title: 'Izz App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF8A5A2B),
          brightness: Brightness.light,
        ),
        useMaterial3: true,
        textTheme: GoogleFonts.tajawalTextTheme(),
        scaffoldBackgroundColor: const Color(0xFFF8F5F0),
        cardTheme: const CardThemeData(
          margin: EdgeInsets.zero,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(24)),
          ),
        ),
      ),
      routerConfig: _router,
      locale: Locale(state.localeCode),
      supportedLocales: const [Locale('ar'), Locale('en')],
      localizationsDelegates: const [
        GlobalWidgetsLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
    );
  }
}

class AppShell extends ConsumerWidget {
  const AppShell({
    required this.currentPath,
    required this.child,
    super.key,
  });

  final String currentPath;
  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(appControllerProvider);
    final controller = ref.read(appControllerProvider.notifier);
    final localeCode = state.localeCode;
    final destinations = [
      _NavItem(AppCopy.t('home', localeCode), Icons.home_outlined, '/'),
      _NavItem(AppCopy.t('owners', localeCode), Icons.people_alt_outlined, '/owners'),
      _NavItem(AppCopy.t('championships', localeCode), Icons.emoji_events_outlined,
          '/championships'),
      _NavItem(AppCopy.t('admin', localeCode), Icons.admin_panel_settings_outlined, '/admin'),
    ];
    final selectedIndex = destinations.indexWhere((item) {
      if (item.path == '/') {
        return currentPath == '/';
      }
      return currentPath.startsWith(item.path);
    });

    return LayoutBuilder(
      builder: (context, constraints) {
        final wide = constraints.maxWidth >= 960;
        return Scaffold(
          appBar: AppBar(
            title: Text(AppCopy.t('title', localeCode)),
            actions: [
              IconButton(
                onPressed: controller.toggleLocale,
                icon: const Icon(Icons.translate_outlined),
              ),
              IconButton(
                onPressed: () => context.go('/notifications'),
                icon: const Icon(Icons.notifications_none_outlined),
              ),
              TextButton(
                onPressed: () => context.go('/login'),
                child: Text(
                  state.currentUser == null
                      ? AppCopy.t('login', localeCode)
                      : state.currentUser!.name,
                ),
              ),
            ],
          ),
          body: Row(
            children: [
              if (wide)
                NavigationRail(
                  selectedIndex: selectedIndex < 0 ? 0 : selectedIndex,
                  onDestinationSelected: (index) => context.go(destinations[index].path),
                  labelType: NavigationRailLabelType.all,
                  destinations: [
                    for (final item in destinations)
                      NavigationRailDestination(
                        icon: Icon(item.icon),
                        label: Text(item.label),
                      ),
                  ],
                ),
              Expanded(
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: child,
                  ),
                ),
              ),
            ],
          ),
          bottomNavigationBar: wide
              ? null
              : NavigationBar(
                  selectedIndex: selectedIndex < 0 ? 0 : selectedIndex,
                  onDestinationSelected: (index) => context.go(destinations[index].path),
                  destinations: [
                    for (final item in destinations)
                      NavigationDestination(
                        icon: Icon(item.icon),
                        label: item.label,
                      ),
                  ],
                ),
        );
      },
    );
  }
}

class _NavItem {
  const _NavItem(this.label, this.icon, this.path);
  final String label;
  final IconData icon;
  final String path;
}

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(appControllerProvider);
    final localeCode = state.localeCode;
    final controller = ref.read(appControllerProvider.notifier);
    final currentChampionships = state.championships.where((item) => item.isCurrent).toList();
    final latestCards = state.winnerCards.take(3).toList();
    final searchController = TextEditingController();

    return AppShell(
      currentPath: '/',
      child: ListView(
        children: [
          _HeroBanner(localeCode: localeCode),
          const SizedBox(height: 20),
          _SectionTitle(title: AppCopy.t('search', localeCode)),
          TextField(
            controller: searchController,
            decoration: InputDecoration(
              hintText: localeCode == 'ar'
                  ? 'ابحث في الهجن والملاك والبطولات والرعاة'
                  : 'Search camels, owners, championships, sponsors',
              suffixIcon: IconButton(
                onPressed: () => context.go('/search?q=${searchController.text}'),
                icon: const Icon(Icons.search),
              ),
              filled: true,
            ),
            onSubmitted: (value) => context.go('/search?q=$value'),
          ),
          const SizedBox(height: 20),
          _SectionTitle(title: AppCopy.t('currentChampionships', localeCode)),
          Wrap(
            spacing: 16,
            runSpacing: 16,
            children: [
              for (final item in currentChampionships)
                SizedBox(
                  width: 340,
                  child: _ChampionshipCard(
                    championship: item,
                    onTap: () => context.go('/championships/${item.id}'),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 20),
          _SectionTitle(title: AppCopy.t('officialCards', localeCode)),
          Wrap(
            spacing: 16,
            runSpacing: 16,
            children: [
              for (final card in latestCards)
                SizedBox(
                  width: 340,
                  child: _WinnerCardPreview(card: card),
                ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(child: _SectionTitle(title: AppCopy.t('communityFeed', localeCode))),
              FilledButton.icon(
                onPressed: state.currentUser == null
                    ? null
                    : () => _showCreateContentDialog(context, ref),
                icon: const Icon(Icons.add),
                label: Text(AppCopy.t('addPost', localeCode)),
              ),
            ],
          ),
          const SizedBox(height: 12),
          for (final content in state.contents)
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: _ContentCard(
                content: content,
                onLike: () => controller.toggleLike(content.id),
                onSave: () => controller.toggleSave(content.id),
                onComment: () => _showCommentDialog(context, ref, content.id, null),
                onReport: () => controller.addReport(
                  targetType: ReportTargetType.content,
                  targetId: content.id,
                  reason: 'Reported from feed',
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class OwnersPage extends ConsumerWidget {
  const OwnersPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(appControllerProvider);
    final localeCode = state.localeCode;
    final currentUser = state.currentUser;
    final canCreateOwner = currentUser != null &&
        (currentUser.role == UserRole.owner || currentUser.role == UserRole.admin) &&
        !state.owners.any((item) => item.userId == currentUser.id);
    return AppShell(
      currentPath: '/owners',
      child: ListView(
        children: [
          Row(
            children: [
              Expanded(child: _SectionTitle(title: AppCopy.t('owners', localeCode))),
              FilledButton.icon(
                onPressed: canCreateOwner ? () => _showCreateOwnerDialog(context, ref) : null,
                icon: const Icon(Icons.person_add_alt_1),
                label: Text(AppCopy.t('createOwner', localeCode)),
              ),
            ],
          ),
          const SizedBox(height: 12),
          for (final owner in state.owners)
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Card(
                child: ListTile(
                  contentPadding: const EdgeInsets.all(20),
                  title: Text(owner.name),
                  subtitle: Text('${owner.region} • ${owner.bio}'),
                  trailing: owner.verified
                      ? const Icon(Icons.verified, color: Colors.green)
                      : const Icon(Icons.pending_outlined),
                  onTap: () => context.go('/owners/${owner.id}'),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class OwnerDetailPage extends ConsumerWidget {
  const OwnerDetailPage({required this.ownerId, super.key});

  final String ownerId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(appControllerProvider);
    final controller = ref.read(appControllerProvider.notifier);
    final owner = state.owners.firstWhere((item) => item.id == ownerId);
    final camels = state.camels.where((item) => item.ownerId == ownerId).toList();
    final isFollowing = state.followedOwnerIds.contains(ownerId);
    final localeCode = state.localeCode;
    final currentUser = state.currentUser;
    final canManageOwner = currentUser != null &&
        (currentUser.role == UserRole.admin ||
            (currentUser.role == UserRole.owner && owner.userId == currentUser.id));
    return AppShell(
      currentPath: '/owners',
      child: ListView(
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(owner.name, style: Theme.of(context).textTheme.headlineSmall),
                      ),
                      FilledButton.tonalIcon(
                        onPressed: state.currentUser == null
                            ? null
                            : () => controller.toggleFollowOwner(ownerId),
                        icon: Icon(isFollowing ? Icons.check : Icons.add),
                        label: Text(
                          AppCopy.t(isFollowing ? 'following' : 'follow', localeCode),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(owner.region),
                  const SizedBox(height: 8),
                  Text(owner.bio),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 12,
                    children: [
                      _StatChip(label: localeCode == 'ar' ? 'الهجن' : 'Camels', value: '${camels.length}'),
                      _StatChip(
                        label: localeCode == 'ar' ? 'المتابعون' : 'Followers',
                        value: '${state.followedOwnerIds.where((item) => item == ownerId).length}',
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(child: _SectionTitle(title: localeCode == 'ar' ? 'الهجن' : 'Camels')),
              FilledButton.icon(
                onPressed: canManageOwner ? () => _showAddCamelDialog(context, ref, ownerId) : null,
                icon: const Icon(Icons.pets_outlined),
                label: Text(AppCopy.t('addCamel', localeCode)),
              ),
            ],
          ),
          const SizedBox(height: 12),
          for (final camel in camels)
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Card(
                child: ListTile(
                  contentPadding: const EdgeInsets.all(20),
                  title: Text(camel.name),
                  subtitle: Text('${camel.gender} • ${camel.ageLabel} • ${camel.color}'),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: () => context.go('/camels/${camel.id}'),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class CamelDetailPage extends ConsumerWidget {
  const CamelDetailPage({required this.camelId, super.key});

  final String camelId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(appControllerProvider);
    final camel = state.camels.firstWhere((item) => item.id == camelId);
    final owner = state.owners.firstWhere((item) => item.id == camel.ownerId);
    final results = state.results.where((item) {
      final participant = state.participants.firstWhere((value) => value.id == item.participantId);
      return participant.camelId == camelId;
    }).toList();
    final localeCode = state.localeCode;
    return AppShell(
      currentPath: '/owners',
      child: ListView(
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(camel.name, style: Theme.of(context).textTheme.headlineMedium),
                  const SizedBox(height: 8),
                  Text('${camel.gender} • ${camel.ageLabel} • ${camel.color}'),
                  const SizedBox(height: 8),
                  Text(camel.summary),
                  const SizedBox(height: 16),
                  TextButton(
                    onPressed: () => context.go('/owners/${owner.id}'),
                    child: Text(owner.name),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          _SectionTitle(title: localeCode == 'ar' ? 'النتائج' : 'Results'),
          const SizedBox(height: 12),
          for (final result in results)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _ResultCard(result: result),
            ),
        ],
      ),
    );
  }
}

class ChampionshipsPage extends ConsumerWidget {
  const ChampionshipsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(appControllerProvider);
    return AppShell(
      currentPath: '/championships',
      child: ListView.separated(
        itemBuilder: (context, index) {
          final item = state.championships[index];
          return _ChampionshipCard(
            championship: item,
            onTap: () => context.go('/championships/${item.id}'),
          );
        },
        separatorBuilder: (_, __) => const SizedBox(height: 16),
        itemCount: state.championships.length,
      ),
    );
  }
}

class ChampionshipDetailPage extends ConsumerWidget {
  const ChampionshipDetailPage({required this.championshipId, super.key});

  final String championshipId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(appControllerProvider);
    final championship =
        state.championships.firstWhere((item) => item.id == championshipId);
    final competitions = state.competitions
        .where((item) => item.championshipId == championshipId)
        .toList();
    final sponsors = state.sponsors
        .where((item) => championship.sponsorIds.contains(item.id))
        .toList();
    final localeCode = state.localeCode;
    return AppShell(
      currentPath: '/championships',
      child: ListView(
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(championship.name, style: Theme.of(context).textTheme.headlineSmall),
                  const SizedBox(height: 8),
                  Text('${championship.location} • ${championship.season}'),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 12,
                    children: [
                      for (final sponsor in sponsors)
                        ActionChip(
                          label: Text(sponsor.name),
                          onPressed: () => context.go('/sponsors/${sponsor.id}'),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          for (final competition in competitions) ...[
            _SectionTitle(title: competition.name),
            const SizedBox(height: 12),
            for (final category in state.categories
                .where((item) => item.competitionId == competition.id))
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(category.name, style: Theme.of(context).textTheme.titleLarge),
                        const SizedBox(height: 12),
                        for (final round in state.rounds.where((item) => item.categoryId == category.id))
                          _RoundSummary(round: round),
                      ],
                    ),
                  ),
                ),
              ),
          ],
          const SizedBox(height: 12),
          Text(
            localeCode == 'ar'
                ? 'لا يملك المستخدم العادي صلاحية اعتماد النتيجة الرسمية.'
                : 'Regular users cannot publish official wins.',
          ),
        ],
      ),
    );
  }
}

class SponsorDetailPage extends ConsumerWidget {
  const SponsorDetailPage({required this.sponsorId, super.key});

  final String sponsorId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sponsor = ref.watch(appControllerProvider).sponsors.firstWhere(
          (item) => item.id == sponsorId,
        );
    return AppShell(
      currentPath: '/championships',
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(sponsor.name, style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: 8),
              Text(sponsor.about),
              const SizedBox(height: 12),
              SelectableText(sponsor.website),
            ],
          ),
        ),
      ),
    );
  }
}

class AdminPage extends ConsumerWidget {
  const AdminPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(appControllerProvider);
    final controller = ref.read(appControllerProvider.notifier);
    final user = state.currentUser;
    final localeCode = state.localeCode;
    if (user == null ||
        (user.role != UserRole.admin && user.role != UserRole.organizer)) {
      return AppShell(
        currentPath: '/admin',
        child: Center(
          child: Text(AppCopy.t('accessDenied', localeCode)),
        ),
      );
    }

    final pendingResults =
        state.results.where((item) => item.status == ResultStatus.pending).toList();

    return AppShell(
      currentPath: '/admin',
      child: ListView(
        children: [
          _SectionTitle(title: AppCopy.t('pendingResults', localeCode)),
          const SizedBox(height: 12),
          for (final result in pendingResults)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Card(
                child: ListTile(
                  contentPadding: const EdgeInsets.all(20),
                  title: Text(_resultTitle(state, result)),
                  subtitle: Text(result.notes),
                  trailing: FilledButton(
                    onPressed: () {
                      final card = controller.approveResult(result.id);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('${AppCopy.t('winnerCard', localeCode)}: ${card.verificationCode}'),
                        ),
                      );
                    },
                    child: Text(AppCopy.t('approve', localeCode)),
                  ),
                ),
              ),
            ),
          const SizedBox(height: 20),
          _SectionTitle(title: AppCopy.t('reports', localeCode)),
          const SizedBox(height: 12),
          if (state.reports.isEmpty)
            Text(AppCopy.t('noData', localeCode))
          else
            for (final report in state.reports)
              ListTile(
                title: Text(report.reason),
                subtitle: Text('${report.targetType.name} • ${report.status.name}'),
              ),
          const SizedBox(height: 20),
          _SectionTitle(title: AppCopy.t('audit', localeCode)),
          const SizedBox(height: 12),
          if (state.auditEntries.isEmpty)
            Text(AppCopy.t('noData', localeCode))
          else
            for (final entry in state.auditEntries)
              ListTile(
                title: Text(entry.action),
                subtitle: Text('${entry.entityType} • ${entry.entityId}'),
              ),
        ],
      ),
    );
  }
}

class WinnerCardPage extends ConsumerWidget {
  const WinnerCardPage({required this.verificationCode, super.key});

  final String verificationCode;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(appControllerProvider);
    final controller = ref.read(appControllerProvider.notifier);
    final localeCode = state.localeCode;
    final winnerCard = controller.findWinnerCardByCode(verificationCode);
    if (winnerCard == null) {
      return AppShell(
        currentPath: '/',
        child: Center(child: Text(AppCopy.t('noData', localeCode))),
      );
    }
    final result = state.results.firstWhere((item) => item.id == winnerCard.resultId);
    final participant = state.participants.firstWhere((item) => item.id == result.participantId);
    final camel = state.camels.firstWhere((item) => item.id == participant.camelId);
    final owner = state.owners.firstWhere((item) => item.id == participant.ownerId);
    final round = state.rounds.firstWhere((item) => item.id == participant.roundId);
    final category = state.categories.firstWhere((item) => item.id == round.categoryId);
    final competition =
        state.competitions.firstWhere((item) => item.id == category.competitionId);
    final championship =
        state.championships.firstWhere((item) => item.id == competition.championshipId);
    final award = state.awards.firstWhere(
      (item) => item.roundId == round.id && item.place == result.position,
      orElse: () => Award(
        id: 'none',
        roundId: round.id,
        place: result.position,
        title: '-',
        amountLabel: '-',
      ),
    );

    return AppShell(
      currentPath: '/',
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 720),
          child: Card(
            color: const Color(0xFF28190F),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    winnerCard.badgeTitle,
                    style: Theme.of(context)
                        .textTheme
                        .headlineSmall
                        ?.copyWith(color: Colors.white),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${AppCopy.t('official', localeCode)} • ${winnerCard.verificationCode}',
                    style: const TextStyle(color: Colors.white70),
                  ),
                  const Divider(color: Colors.white24, height: 32),
                  _WinnerCardLine(label: localeCode == 'ar' ? 'الهجن' : 'Camel', value: camel.name),
                  _WinnerCardLine(label: localeCode == 'ar' ? 'المالك' : 'Owner', value: owner.name),
                  _WinnerCardLine(label: localeCode == 'ar' ? 'البطولة' : 'Championship', value: championship.name),
                  _WinnerCardLine(label: localeCode == 'ar' ? 'المسابقة' : 'Competition', value: competition.name),
                  _WinnerCardLine(label: localeCode == 'ar' ? 'الفئة' : 'Category', value: category.name),
                  _WinnerCardLine(label: localeCode == 'ar' ? 'الشوط' : 'Round', value: round.name),
                  _WinnerCardLine(label: localeCode == 'ar' ? 'المركز' : 'Place', value: '${result.position}'),
                  _WinnerCardLine(label: localeCode == 'ar' ? 'الجائزة' : 'Award', value: '${award.title} / ${award.amountLabel}'),
                  _WinnerCardLine(label: localeCode == 'ar' ? 'المكان' : 'Location', value: winnerCard.location),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class LoginPage extends ConsumerWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(appControllerProvider);
    final controller = ref.read(appControllerProvider.notifier);
    final localeCode = state.localeCode;
    return AppShell(
      currentPath: '/login',
      child: ListView(
        children: [
          _SectionTitle(title: AppCopy.t('login', localeCode)),
          const SizedBox(height: 12),
          for (final user in state.users)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Card(
                child: ListTile(
                  title: Text(user.name),
                  subtitle: Text('${user.email} • ${user.role.name}'),
                  trailing: FilledButton(
                    onPressed: () => controller.signIn(user.id),
                    child: const Text('Sign in'),
                  ),
                ),
              ),
            ),
          const SizedBox(height: 12),
          OutlinedButton(
            onPressed: controller.signOut,
            child: Text(AppCopy.t('logout', localeCode)),
          ),
        ],
      ),
    );
  }
}

class NotificationsPage extends ConsumerWidget {
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(appControllerProvider);
    final controller = ref.read(appControllerProvider.notifier);
    final currentUser = state.currentUser;
    final localeCode = state.localeCode;
    final notifications = currentUser == null
        ? <NotificationItem>[]
        : state.notifications.where((item) => item.userId == currentUser.id).toList();

    return AppShell(
      currentPath: '/notifications',
      child: ListView(
        children: [
          _SectionTitle(title: AppCopy.t('notifications', localeCode)),
          const SizedBox(height: 12),
          if (notifications.isEmpty)
            Text(AppCopy.t('noData', localeCode))
          else
            for (final item in notifications)
              Card(
                child: ListTile(
                  title: Text(item.title),
                  subtitle: Text(item.body),
                  trailing: item.read
                      ? const Icon(Icons.done_all, color: Colors.green)
                      : FilledButton.tonal(
                          onPressed: () => controller.markNotificationRead(item.id),
                          child: const Text('Read'),
                        ),
                  onTap: () {
                    controller.markNotificationRead(item.id);
                    context.go(item.route);
                  },
                ),
              ),
        ],
      ),
    );
  }
}

class SearchPage extends ConsumerWidget {
  const SearchPage({required this.query, super.key});

  final String query;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(appControllerProvider);
    final localeCode = state.localeCode;
    final q = query.trim().toLowerCase();
    final results = <_SearchResult>[
      ...state.owners
          .where((item) => item.name.toLowerCase().contains(q))
          .map((item) => _SearchResult(item.name, '/owners/${item.id}')),
      ...state.camels
          .where((item) => item.name.toLowerCase().contains(q))
          .map((item) => _SearchResult(item.name, '/camels/${item.id}')),
      ...state.championships
          .where((item) => item.name.toLowerCase().contains(q))
          .map((item) => _SearchResult(item.name, '/championships/${item.id}')),
      ...state.competitions
          .where((item) => item.name.toLowerCase().contains(q))
          .map((item) => _SearchResult(item.name, '/championships/${item.championshipId}')),
      ...state.sponsors
          .where((item) => item.name.toLowerCase().contains(q))
          .map((item) => _SearchResult(item.name, '/sponsors/${item.id}')),
      ...state.winnerCards
          .where((item) => item.verificationCode.toLowerCase().contains(q))
          .map((item) => _SearchResult(item.verificationCode, '/winner-cards/${item.verificationCode}')),
    ];

    return AppShell(
      currentPath: '/search',
      child: ListView(
        children: [
          _SectionTitle(title: '${AppCopy.t('search', localeCode)}: $query'),
          const SizedBox(height: 12),
          if (results.isEmpty)
            Text(AppCopy.t('noData', localeCode))
          else
            for (final result in results)
              Card(
                child: ListTile(
                  title: Text(result.label),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: () => context.go(result.route),
                ),
              ),
        ],
      ),
    );
  }
}

class _SearchResult {
  const _SearchResult(this.label, this.route);
  final String label;
  final String route;
}

class _HeroBanner extends StatelessWidget {
  const _HeroBanner({required this.localeCode});

  final String localeCode;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(32),
        gradient: const LinearGradient(
          colors: [Color(0xFF301B0E), Color(0xFF94673C)],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppCopy.t('title', localeCode),
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(color: Colors.white),
          ),
          const SizedBox(height: 12),
          Text(
            localeCode == 'ar'
                ? 'منصة متخصصة تربط المالك والهجن بالمشاركة والنتيجة وبطاقة الفوز الرسمية.'
                : 'A focused platform connecting owners, camels, competitions, official results, and winner cards.',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.white70),
          ),
        ],
      ),
    );
  }
}

class _ChampionshipCard extends StatelessWidget {
  const _ChampionshipCard({
    required this.championship,
    required this.onTap,
  });

  final Championship championship;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(24),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(championship.name, style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 8),
              Text('${championship.location} • ${championship.season}'),
              const SizedBox(height: 16),
              Align(
                alignment: AlignmentDirectional.centerStart,
                child: Chip(
                  label: Text(championship.isCurrent ? 'Live' : 'Upcoming'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _WinnerCardPreview extends StatelessWidget {
  const _WinnerCardPreview({required this.card});

  final WinnerCard card;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color(0xFF28190F),
      child: InkWell(
        onTap: () => context.go('/winner-cards/${card.verificationCode}'),
        borderRadius: BorderRadius.circular(24),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                card.badgeTitle,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.white),
              ),
              const SizedBox(height: 8),
              Text(card.verificationCode, style: const TextStyle(color: Colors.white70)),
            ],
          ),
        ),
      ),
    );
  }
}

class _ContentCard extends ConsumerWidget {
  const _ContentCard({
    required this.content,
    required this.onLike,
    required this.onSave,
    required this.onComment,
    required this.onReport,
  });

  final ContentItem content;
  final VoidCallback onLike;
  final VoidCallback onSave;
  final VoidCallback onComment;
  final VoidCallback onReport;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(appControllerProvider);
    final author = state.users.firstWhere((item) => item.id == content.authorUserId);
    final localeCode = state.localeCode;
    final comments = state.comments.where((item) => item.contentId == content.id).toList();
    final linkedLabel = _linkedEntityLabel(state, content);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(content.title, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 4),
            Text(author.name),
            const SizedBox(height: 12),
            Text(content.body),
            if (content.mediaLabel != null) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.black12,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.play_circle_outline),
                    const SizedBox(width: 8),
                    Expanded(child: Text(content.mediaLabel!)),
                  ],
                ),
              ),
            ],
            const SizedBox(height: 12),
            Text('${AppCopy.t('linkedEntity', localeCode)}: $linkedLabel'),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              children: [
                ActionChip(
                  label: Text('${AppCopy.t('like', localeCode)} (${content.likeUserIds.length})'),
                  onPressed: onLike,
                ),
                ActionChip(
                  label: Text(AppCopy.t('save', localeCode)),
                  onPressed: onSave,
                ),
                ActionChip(
                  label: Text(AppCopy.t('comment', localeCode)),
                  onPressed: onComment,
                ),
                ActionChip(
                  label: Text(AppCopy.t('report', localeCode)),
                  onPressed: onReport,
                ),
              ],
            ),
            if (comments.isNotEmpty) ...[
              const Divider(height: 24),
              for (final comment in comments.where((item) => item.parentCommentId == null))
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('• ${comment.body}'),
                      for (final reply in comments.where((item) => item.parentCommentId == comment.id))
                        Padding(
                          padding: const EdgeInsetsDirectional.only(start: 16, top: 4),
                          child: Text('↳ ${reply.body}'),
                        ),
                      TextButton(
                        onPressed: () => _showCommentDialog(context, ref, content.id, comment.id),
                        child: Text(AppCopy.t('comment', localeCode)),
                      ),
                    ],
                  ),
                ),
            ],
          ],
        ),
      ),
    );
  }
}

class _RoundSummary extends ConsumerWidget {
  const _RoundSummary({required this.round});

  final RoundModel round;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(appControllerProvider);
    final participants = state.participants.where((item) => item.roundId == round.id).toList();
    final results = state.results.where((item) {
      final participant = state.participants.firstWhere((value) => value.id == item.participantId);
      return participant.roundId == round.id;
    }).toList();
    return ExpansionTile(
      title: Text(round.name),
      children: [
        for (final participant in participants)
          ListTile(
            title: Text(
              state.camels.firstWhere((item) => item.id == participant.camelId).name,
            ),
            subtitle: Text(participant.bibNumber),
          ),
        for (final result in results) _ResultCard(result: result),
      ],
    );
  }
}

class _ResultCard extends ConsumerWidget {
  const _ResultCard({required this.result});

  final ResultRecord result;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(appControllerProvider);
    final participant = state.participants.firstWhere((item) => item.id == result.participantId);
    final camel = state.camels.firstWhere((item) => item.id == participant.camelId);
    final localeCode = state.localeCode;
    return Card(
      child: ListTile(
        title: Text('${camel.name} • ${result.position}'),
        subtitle: Text(result.notes),
        trailing: Chip(
          label: Text(
            AppCopy.t(result.isOfficial ? 'official' : 'pending', localeCode),
          ),
        ),
      ),
    );
  }
}

class _WinnerCardLine extends StatelessWidget {
  const _WinnerCardLine({
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          SizedBox(
            width: 140,
            child: Text(label, style: const TextStyle(color: Colors.white70)),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  const _StatChip({
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Chip(label: Text('$label: $value'));
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(title, style: Theme.of(context).textTheme.headlineSmall);
  }
}

String _resultTitle(AppState state, ResultRecord result) {
  final participant = state.participants.firstWhere((item) => item.id == result.participantId);
  final camel = state.camels.firstWhere((item) => item.id == participant.camelId);
  return '${camel.name} • ${result.position} • ${result.score}';
}

Future<void> _showCreateOwnerDialog(BuildContext context, WidgetRef ref) async {
  final nameController = TextEditingController();
  final regionController = TextEditingController();
  final bioController = TextEditingController();
  await showDialog<void>(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Create owner'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(controller: nameController, decoration: const InputDecoration(labelText: 'Name')),
          TextField(controller: regionController, decoration: const InputDecoration(labelText: 'Region')),
          TextField(controller: bioController, decoration: const InputDecoration(labelText: 'Bio')),
        ],
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
        FilledButton(
          onPressed: () {
            try {
              ref.read(appControllerProvider.notifier).createOwner(
                    name: nameController.text,
                    region: regionController.text,
                    bio: bioController.text,
                  );
              Navigator.pop(context);
            } on StateError catch (error) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(error.message)),
              );
            }
          },
          child: const Text('Save'),
        ),
      ],
    ),
  );
}

Future<void> _showAddCamelDialog(
  BuildContext context,
  WidgetRef ref,
  String ownerId,
) async {
  final nameController = TextEditingController();
  final genderController = TextEditingController(text: 'بكار');
  final ageController = TextEditingController(text: 'حقايق');
  final colorController = TextEditingController();
  final summaryController = TextEditingController();
  await showDialog<void>(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Add camel'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: nameController, decoration: const InputDecoration(labelText: 'Name')),
            TextField(controller: genderController, decoration: const InputDecoration(labelText: 'Gender')),
            TextField(controller: ageController, decoration: const InputDecoration(labelText: 'Age label')),
            TextField(controller: colorController, decoration: const InputDecoration(labelText: 'Color')),
            TextField(controller: summaryController, decoration: const InputDecoration(labelText: 'Summary')),
          ],
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
        FilledButton(
          onPressed: () {
            try {
              ref.read(appControllerProvider.notifier).addCamel(
                    ownerId: ownerId,
                    name: nameController.text,
                    gender: genderController.text,
                    ageLabel: ageController.text,
                    color: colorController.text,
                    summary: summaryController.text,
                  );
              Navigator.pop(context);
            } on StateError catch (error) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(error.message)),
              );
            }
          },
          child: const Text('Save'),
        ),
      ],
    ),
  );
}

Future<void> _showCreateContentDialog(BuildContext context, WidgetRef ref) async {
  final state = ref.read(appControllerProvider);
  final titleController = TextEditingController();
  final bodyController = TextEditingController();
  ContentType type = ContentType.post;
  LinkedEntityType linkedEntityType = LinkedEntityType.camel;
  var entityOptions = _linkedEntityOptions(state, linkedEntityType);
  String linkedEntityId = entityOptions.first.id;
  await showDialog<void>(
    context: context,
    builder: (context) => StatefulBuilder(
      builder: (context, setState) => AlertDialog(
        title: const Text('Publish content'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: titleController, decoration: const InputDecoration(labelText: 'Title')),
              TextField(controller: bodyController, decoration: const InputDecoration(labelText: 'Body')),
              DropdownButtonFormField<ContentType>(
                value: type,
                items: const [
                  DropdownMenuItem(value: ContentType.post, child: Text('Post')),
                  DropdownMenuItem(value: ContentType.video, child: Text('Video')),
                ],
                onChanged: (value) => setState(() => type = value ?? ContentType.post),
              ),
              DropdownButtonFormField<LinkedEntityType>(
                value: linkedEntityType,
                items: LinkedEntityType.values
                    .map((item) => DropdownMenuItem(value: item, child: Text(item.name)))
                    .toList(),
                onChanged: (value) => setState(() {
                  linkedEntityType = value ?? LinkedEntityType.camel;
                  entityOptions = _linkedEntityOptions(state, linkedEntityType);
                  linkedEntityId = entityOptions.first.id;
                }),
              ),
              DropdownButtonFormField<String>(
                value: linkedEntityId,
                items: entityOptions
                    .map((item) => DropdownMenuItem(
                          value: item.id,
                          child: Text(item.label),
                        ))
                    .toList(),
                onChanged: (value) => setState(() => linkedEntityId = value ?? linkedEntityId),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          FilledButton(
            onPressed: () {
              ref.read(appControllerProvider.notifier).addContent(
                    type: type,
                    title: titleController.text,
                    body: bodyController.text,
                    linkedEntityType: linkedEntityType,
                    linkedEntityId: linkedEntityId,
                    mediaLabel: type == ContentType.video
                        ? 'Video prepared for future CDN/storage integration'
                        : null,
                  );
              Navigator.pop(context);
            },
            child: const Text('Publish'),
          ),
        ],
      ),
    ),
  );
}

List<_EntityOption> _linkedEntityOptions(AppState state, LinkedEntityType type) {
  switch (type) {
    case LinkedEntityType.owner:
      return state.owners.map((item) => _EntityOption(item.id, item.name)).toList();
    case LinkedEntityType.camel:
      return state.camels.map((item) => _EntityOption(item.id, item.name)).toList();
    case LinkedEntityType.championship:
      return state.championships.map((item) => _EntityOption(item.id, item.name)).toList();
    case LinkedEntityType.competition:
      return state.competitions.map((item) => _EntityOption(item.id, item.name)).toList();
    case LinkedEntityType.sponsor:
      return state.sponsors.map((item) => _EntityOption(item.id, item.name)).toList();
  }
}

class _EntityOption {
  const _EntityOption(this.id, this.label);

  final String id;
  final String label;
}

String _linkedEntityLabel(AppState state, ContentItem content) {
  switch (content.linkedEntityType) {
    case LinkedEntityType.owner:
      return state.owners.firstWhere((item) => item.id == content.linkedEntityId).name;
    case LinkedEntityType.camel:
      return state.camels.firstWhere((item) => item.id == content.linkedEntityId).name;
    case LinkedEntityType.championship:
      return state.championships
          .firstWhere((item) => item.id == content.linkedEntityId)
          .name;
    case LinkedEntityType.competition:
      return state.competitions
          .firstWhere((item) => item.id == content.linkedEntityId)
          .name;
    case LinkedEntityType.sponsor:
      return state.sponsors.firstWhere((item) => item.id == content.linkedEntityId).name;
  }
}

Future<void> _showCommentDialog(
  BuildContext context,
  WidgetRef ref,
  String contentId,
  String? parentCommentId,
) async {
  final controller = TextEditingController();
  await showDialog<void>(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Comment'),
      content: TextField(
        controller: controller,
        decoration: const InputDecoration(labelText: 'Comment'),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
        FilledButton(
          onPressed: () {
            ref.read(appControllerProvider.notifier).addComment(
                  contentId: contentId,
                  body: controller.text,
                  parentCommentId: parentCommentId,
                );
            Navigator.pop(context);
          },
          child: const Text('Send'),
        ),
      ],
    ),
  );
}
