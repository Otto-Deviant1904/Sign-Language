import 'package:flutter_test/flutter_test.dart';

import 'package:isl_pocket_signs/main.dart';

void main() {
  testWidgets('Splash screen smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const ISLPocketSignsApp());

    expect(find.text('ISL Pocket Signs'), findsOneWidget);
    expect(find.text('Indian Sign Language Reference'), findsOneWidget);
    expect(find.text('Loading signs...'), findsOneWidget);
  });
}
