import 'package:flutter/material.dart';

import '../admin/admin_dashboard_screen.dart';
import '../home/home_dashboard_screen.dart';
import '../media/media_center_screen.dart';
import '../profiles/owner_profile_screen.dart';
import '../sections/hejin_section_screen.dart';
import '../sections/mazayin_section_screen.dart';
import 'session.dart';

class MainShell extends StatefulWidget {
  const MainShell({
    required this.session,
    required this.onLogout,
    super.key,
  });

  final AppSession session;
  final VoidCallback onLogout;

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    final pages = [
      HomeDashboardScreen(session: widget.session),
      const MazayinSectionScreen(),
      const HejinSectionScreen(),
      const MediaCenterScreen(),
      OwnerProfileScreen(session: widget.session),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('عِزّ المسابقات'),
        actions: [
          if (widget.session.role == 'admin')
            IconButton(
              tooltip: 'لوحة الإدارة',
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (_) => const AdminDashboardScreen(),
                  ),
                );
              },
              icon: const Icon(Icons.admin_panel_settings_outlined),
            ),
          IconButton(
            tooltip: 'تسجيل الخروج',
            onPressed: widget.onLogout,
            icon: const Icon(Icons.logout_outlined),
          ),
        ],
      ),
      body: pages[_index],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (index) => setState(() => _index = index),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_outlined), label: 'الرئيسية'),
          NavigationDestination(icon: Icon(Icons.emoji_events_outlined), label: 'المزاين'),
          NavigationDestination(icon: Icon(Icons.flag_outlined), label: 'الهجن'),
          NavigationDestination(icon: Icon(Icons.perm_media_outlined), label: 'الوسائط'),
          NavigationDestination(icon: Icon(Icons.person_outline), label: 'حسابي'),
        ],
      ),
    );
  }
}
