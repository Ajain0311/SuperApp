import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:super_app/main.dart';

void main() {
  testWidgets('SuperApp smoke test - initializes properly', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: SuperApp(),
      ),
    );

    // Let splash screen animations and timer settle
    await tester.pump(const Duration(seconds: 1));
    await tester.pump(const Duration(seconds: 2));
    await tester.pumpAndSettle();

    // Verify SuperApp boots up
    expect(find.byType(SuperApp), findsOneWidget);
  });
}
