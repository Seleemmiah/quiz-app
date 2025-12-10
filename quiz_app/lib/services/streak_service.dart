import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:quiz_app/models/streak_data.dart';

class StreakService {
  static const String _streakDataKey = 'streak_data_v2';
  static const String _calendarKey = 'study_calendar';

  // Get current streak data
  Future<StreakData> getStreak() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonStr = prefs.getString(_streakDataKey);

    if (jsonStr == null) {
      return StreakData();
    }

    StreakData data = StreakData.fromMap(jsonDecode(jsonStr));

    // Check if streak is broken (missed yesterday)
    // But don't reset it permanently until they study again,
    // just return 0 for display if they missed yesterday and haven't studied today.
    // Actually, usually we show 0 if they broke it.

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    if (data.lastCompletionDate != null) {
      final last = data.lastCompletionDate!;
      final lastDate = DateTime(last.year, last.month, last.day);
      final difference = today.difference(lastDate).inDays;

      if (difference > 1) {
        // Missed more than 1 day (yesterday), so streak is broken.
        // But we might want to keep the "longest streak" history.
        return data.copyWith(currentStreak: 0);
      }
    }

    return data;
  }

  // Record a study session (e.g., finished a quiz)
  // Returns true if streak increased
  Future<bool> recordActivity() async {
    final prefs = await SharedPreferences.getInstance();

    // Get raw data directly to avoid the "reset to 0" logic above for calculation
    final jsonStr = prefs.getString(_streakDataKey);
    StreakData data = jsonStr != null
        ? StreakData.fromMap(jsonDecode(jsonStr))
        : StreakData();

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    // Check if already studied today
    if (data.lastCompletionDate != null) {
      final last = data.lastCompletionDate!;
      final lastDate = DateTime(last.year, last.month, last.day);
      if (lastDate.isAtSameMomentAs(today)) {
        return false; // Already recorded today
      }
    }

    // Check if streak continues
    bool isConsecutive = false;
    if (data.lastCompletionDate != null) {
      final last = data.lastCompletionDate!;
      final lastDate = DateTime(last.year, last.month, last.day);
      final difference = today.difference(lastDate).inDays;
      if (difference == 1) {
        isConsecutive = true;
      }
    } else {
      isConsecutive = true; // First time
    }

    int newStreak = isConsecutive ? data.currentStreak + 1 : 1;

    // Update data
    final newData = data.copyWith(
      currentStreak: newStreak,
      longestStreak:
          newStreak > data.longestStreak ? newStreak : data.longestStreak,
      lastCompletionDate: now,
      totalChallengesCompleted: data.totalChallengesCompleted +
          1, // Using this as "sessions completed"
    );

    await prefs.setString(_streakDataKey, jsonEncode(newData.toMap()));
    await _markCalendar(today);

    return isConsecutive; // Return true if it was a streak increase
  }

  Future<void> _markCalendar(DateTime date) async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> calendar = prefs.getStringList(_calendarKey) ?? [];
    final dateStr = date.toIso8601String().split('T')[0];

    if (!calendar.contains(dateStr)) {
      calendar.add(dateStr);
      await prefs.setStringList(_calendarKey, calendar);
    }
  }

  Future<List<DateTime>> getStudyDates() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> calendar = prefs.getStringList(_calendarKey) ?? [];
    return calendar.map((e) => DateTime.parse(e)).toList();
  }
}
