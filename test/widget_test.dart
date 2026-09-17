import 'package:flutter_test/flutter_test.dart';
import 'package:izz_app/main.dart';

void main() {
  testWidgets('renders Arabic home sections and app title', (tester) async {
    await tester.pumpWidget(const IzzCompetitionsApp());

    expect(find.text('عِزّ المسابقات'), findsOneWidget);
    expect(find.text('وصول سريع'), findsOneWidget);
    expect(find.text('المسابقات القادمة'), findsOneWidget);
  });
}
