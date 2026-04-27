import 'package:flutter_test/flutter_test.dart';
import 'package:society_app/main.dart';

void main() {
  testWidgets('loads splash screen from mock data', (tester) async {
    await tester.pumpWidget(const SocietyApp());
    await tester.pump(const Duration(milliseconds: 400));

    expect(find.text('SocietyApp'), findsOneWidget);
    expect(find.text('Get Started'), findsOneWidget);
  });
}
