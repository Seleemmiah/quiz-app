import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quiz_app/main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:quiz_app/services/settings_service.dart';

void main() {
  setUpAll(() {
    GoogleFonts.config.allowRuntimeFetching = false;
  });

  testWidgets('App starts and shows welcome message',
      (WidgetTester tester) async {
    // Mock SharedPreferences
    SharedPreferences.setMockInitialValues({});

    // Build our app and trigger a frame.
    await tester.pumpWidget(MyApp(settingsService: SettingsService()));

    // Wait for settings load (5s timeout) + splash screen delay (3s) + animations
    await tester.pump(const Duration(seconds: 10));
    await tester.pumpAndSettle();

    // Verify that our app shows the title.
    expect(find.text('Quiz App'), findsWidgets);
  });
}
