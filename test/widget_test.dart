import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:izz_app/app/app.dart';

void main() {
  testWidgets('onboarding flow appears first', (tester) async {
    await tester.pumpWidget(const IzzCompetitionsApp());

    expect(find.text('مرحبًا بك في عِزّ المسابقات'), findsOneWidget);
    expect(find.byKey(const Key('phone_input')), findsOneWidget);
  });

  testWidgets('user can complete mock onboarding and see shell', (tester) async {
    await tester.pumpWidget(const IzzCompetitionsApp());

    await tester.enterText(find.byKey(const Key('phone_input')), '0555555555');
    await tester.tap(find.byKey(const Key('send_otp_button')));
    await tester.pumpAndSettle();

    await tester.enterText(find.byKey(const Key('otp_input')), '1234');
    await tester.tap(find.byKey(const Key('verify_otp_button')));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('select_role_button')));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('finish_onboarding_button')));
    await tester.pumpAndSettle();

    expect(find.text('عِزّ المسابقات'), findsOneWidget);
    expect(find.byKey(const Key('home_dashboard')), findsOneWidget);
  });
}
