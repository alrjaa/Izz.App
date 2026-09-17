import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import '../features/onboarding/onboarding_flow.dart';
import '../features/shell/main_shell.dart';
import '../features/shell/session.dart';
import 'theme/app_theme.dart';

class IzzCompetitionsApp extends StatefulWidget {
  const IzzCompetitionsApp({super.key});

  @override
  State<IzzCompetitionsApp> createState() => _IzzCompetitionsAppState();
}

class _IzzCompetitionsAppState extends State<IzzCompetitionsApp> {
  AppSession? _session;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      locale: const Locale('ar'),
      supportedLocales: const [Locale('ar')],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      theme: AppTheme.lightTheme,
      builder: (context, child) => Directionality(
        textDirection: TextDirection.rtl,
        child: child!,
      ),
      home: _session == null
          ? OnboardingFlow(
              onCompleted: (session) {
                setState(() => _session = session);
              },
            )
          : MainShell(
              session: _session!,
              onLogout: () => setState(() => _session = null),
            ),
    );
  }
}
