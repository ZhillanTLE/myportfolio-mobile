import 'package:flutter_test/flutter_test.dart';

import 'package:myportofolio_mobile/main.dart';

void main() {
  testWidgets('Home page shows portfolio info', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('MyPortfolio'), findsOneWidget);
    expect(find.text('NPM'), findsOneWidget);
    expect(find.text('Lihat Proyek'), findsOneWidget);
  });
}
