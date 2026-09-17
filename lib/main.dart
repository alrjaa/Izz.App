import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() {
  runApp(const IzzCompetitionsApp());
}

class IzzCompetitionsApp extends StatelessWidget {
  const IzzCompetitionsApp({super.key});

  @override
  Widget build(BuildContext context) {
    const sand = Color(0xFFE8D5B7);
    const dune = Color(0xFFC49A6C);
    const brown = Color(0xFF6D4C41);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      locale: const Locale('ar'),
      supportedLocales: const [Locale('ar')],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: dune,
          brightness: Brightness.light,
          primary: brown,
          secondary: dune,
          surface: sand,
        ),
        scaffoldBackgroundColor: const Color(0xFFF8F1E4),
      ),
      builder: (context, child) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: child!,
        );
      },
      home: const HomeScreen(),
    );
  }
}

class Competition {
  const Competition({
    required this.name,
    required this.type,
    required this.location,
    required this.date,
  });

  final String name;
  final String type;
  final String location;
  final String date;
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Competition> _competitions = const [
    Competition(
      name: 'مهرجان عِزّ المزاين',
      type: 'مزاين الإبل',
      location: 'الرياض',
      date: '10 أكتوبر 2026',
    ),
    Competition(
      name: 'كأس الهجن الصحراوي',
      type: 'سباق هجن',
      location: 'الطائف',
      date: '22 أكتوبر 2026',
    ),
    Competition(
      name: 'تحدي النخبة للهجن',
      type: 'سباق هجن',
      location: 'القصيم',
      date: '03 نوفمبر 2026',
    ),
  ];

  int _selectedBottomIndex = 0;
  String _selectedFilter = 'الكل';

  @override
  Widget build(BuildContext context) {
    final filteredCompetitions = _selectedFilter == 'الكل'
        ? _competitions
        : _competitions.where((c) => c.type == _selectedFilter).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('عِزّ المسابقات'),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: const LinearGradient(
                colors: [Color(0xFFC49A6C), Color(0xFF8D6E63)],
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
              ),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'أهلًا بك في منصة مسابقات الإبل',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'تابع مزاين الإبل وسباقات الهجن القادمة في مكان واحد.',
                  style: TextStyle(color: Colors.white, height: 1.5),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'وصول سريع',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: ['الكل', 'مزاين الإبل', 'سباق هجن']
                .map(
                  (filter) => ChoiceChip(
                    label: Text(filter),
                    selected: _selectedFilter == filter,
                    onSelected: (_) => setState(() => _selectedFilter = filter),
                  ),
                )
                .toList(),
          ),
          const SizedBox(height: 20),
          const Text(
            'المسابقات القادمة',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 10),
          ...filteredCompetitions.map(
            (competition) => Card(
              margin: const EdgeInsets.only(bottom: 12),
              child: ListTile(
                title: Text(
                  competition.name,
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
                subtitle: Padding(
                  padding: const EdgeInsets.only(top: 6),
                  child: Text(
                    '${competition.type} • ${competition.location} • ${competition.date}',
                  ),
                ),
                leading: CircleAvatar(
                  backgroundColor: const Color(0xFFE8D5B7),
                  child: Icon(
                    competition.type == 'مزاين الإبل'
                        ? Icons.emoji_events_outlined
                        : Icons.flag_outlined,
                    color: const Color(0xFF6D4C41),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedBottomIndex,
        onDestinationSelected: (index) {
          setState(() => _selectedBottomIndex = index);
        },
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_outlined), label: 'الرئيسية'),
          NavigationDestination(icon: Icon(Icons.event_outlined), label: 'المسابقات'),
          NavigationDestination(icon: Icon(Icons.bar_chart_outlined), label: 'النتائج'),
          NavigationDestination(icon: Icon(Icons.person_outline), label: 'حسابي'),
        ],
      ),
    );
  }
}
