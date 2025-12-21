import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:quiz_app/screens/main_navigation_screen.dart';
import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:quiz_app/models/question_model.dart';
import 'package:quiz_app/screens/quiz_screen.dart';
import 'package:quiz_app/screens/result_screen.dart';
import 'package:quiz_app/screens/review_screen.dart';
import 'package:quiz_app/screens/settings_screen.dart';
import 'package:quiz_app/screens/splash_screen.dart';
import 'package:quiz_app/screens/modern_onboarding_screen.dart';
import 'package:quiz_app/widgets/offline_indicator.dart';
import 'package:quiz_app/widgets/glass_dialog.dart';

import 'package:quiz_app/screens/statistics_screen.dart';
import 'package:quiz_app/screens/multiplayer/lobby_screen.dart';
import 'package:quiz_app/screens/multiplayer/multiplayer_quiz_screen.dart';
import 'package:quiz_app/screens/bookmarks_screen.dart';
import 'package:quiz_app/screens/achievements_screen.dart';
import 'package:quiz_app/screens/practice_screen.dart';
import 'package:quiz_app/screens/profile_screen.dart';
import 'package:quiz_app/screens/my_quizzes_screen.dart';
import 'package:quiz_app/screens/generate_quiz_screen.dart';
import 'package:quiz_app/screens/join_quiz_screen.dart';
import 'package:quiz_app/screens/auth/login_screen.dart';
import 'package:quiz_app/screens/auth/signup_screen.dart';
import 'package:quiz_app/screens/username_setup_screen.dart';
import 'package:quiz_app/screens/welcome_screen.dart';
import 'package:quiz_app/services/settings_service.dart';
import 'package:quiz_app/services/notification_service.dart';
import 'package:quiz_app/services/professional_notification_service.dart';
import 'package:quiz_app/services/background_service.dart';
import 'package:quiz_app/services/auth_service.dart';
import 'package:quiz_app/models/theme_preset.dart';
import 'package:quiz_app/settings.dart';
import 'package:quiz_app/screens/classes_screen.dart';
import 'package:quiz_app/screens/daily_challenge_screen.dart';
import 'package:quiz_app/screens/create_class_screen.dart';
import 'package:quiz_app/screens/join_class_screen.dart';
import 'package:quiz_app/screens/study_planner_screen.dart';
import 'package:quiz_app/screens/class_detail_screen.dart';
import 'package:quiz_app/screens/teacher_dashboard_screen.dart';
import 'package:quiz_app/screens/class_analytics_screen.dart';
import 'package:quiz_app/screens/role_selection_screen.dart';
import 'package:quiz_app/models/class_model.dart';
import 'package:quiz_app/screens/notifications_screen.dart';
import 'package:quiz_app/screens/schedule_class_screen.dart';
import 'package:quiz_app/screens/notification_preferences_screen.dart';
import 'package:quiz_app/screens/campaign_screen.dart';
import 'package:quiz_app/screens/shop_screen.dart';
import 'package:quiz_app/screens/quick_play_screen.dart';
import 'package:quiz_app/screens/practice_weak_areas_screen.dart';
import 'package:quiz_app/screens/notification_test_screen.dart';
import 'package:quiz_app/screens/multiplayer/leaderboard_screen.dart';
import 'package:quiz_app/screens/document_library_screen.dart';
import 'package:quiz_app/firebase_options.dart';

// Background message handler - must be top-level function
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // Initialize Firebase if not already initialized
  await Firebase.initializeApp();

  debugPrint("Handling a background message: ${message.messageId}");
  debugPrint("Title: ${message.notification?.title}");
  debugPrint("Body: ${message.notification?.body}");
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    // Enable Offline Persistence
    FirebaseFirestore.instance.settings =
        const Settings(persistenceEnabled: true);

    // Initialize Crashlytics
    FlutterError.onError = (errorDetails) {
      FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
    };

    // Pass all uncaught asynchronous errors to Crashlytics
    PlatformDispatcher.instance.onError = (error, stack) {
      FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
      return true;
    };
  } catch (e) {
    debugPrint('Firebase initialization failed: $e');
  }

  // Register FCM background message handler
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  await NotificationService().init();
  // Initialize FCM (optional - requires Firebase setup)
  try {
    await NotificationService().initializeFCM();
  } catch (e) {
    debugPrint('FCM initialization skipped: $e');
  }

  // Initialize Professional Notification Service
  try {
    await ProfessionalNotificationService.instance.initialize();
    debugPrint('✅ Professional Notification Service initialized');
  } catch (e) {
    debugPrint('Professional notification service initialization failed: $e');
  }

  // Initialize Background Service (for offline notifications)
  try {
    await BackgroundService.initialize();
    await BackgroundService.registerPeriodicTask();
    debugPrint('✅ Background Service initialized');
  } catch (e) {
    debugPrint('Background service initialization failed: $e');
  }

  final settingsService = SettingsService();
  await settingsService.loadSettings();

  runApp(MyApp(settingsService: settingsService));
}

// AuthWrapper to determine initial screen based on auth state
class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = AuthService();

    return StreamBuilder<User?>(
      stream: authService.authStateChanges,
      builder: (context, snapshot) {
        // Show loading while checking auth state
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        // If user is logged in, go to home
        if (snapshot.hasData && snapshot.data != null) {
          return const MainNavigationScreen();
        } else {
          return const WelcomeScreen();
        }
      },
    );
  }
}

class MyApp extends StatefulWidget {
  final SettingsService settingsService;

  const MyApp({super.key, required this.settingsService});

  @override
  State<MyApp> createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  late ThemePreset _currentThemePreset;
  bool _isOledMode = false;
  bool _hapticEnabled = true;
  ThemeMode _themeMode = ThemeMode.system;

  @override
  void initState() {
    super.initState();
    final presetName = widget.settingsService.getThemePreset();
    _currentThemePreset = ThemePreset.presets.firstWhere(
      (p) => p.name == presetName,
      orElse: () => ThemePreset.presets.first,
    );
    _isOledMode = widget.settingsService.getOledMode();
    _hapticEnabled = widget.settingsService.getHapticEnabled();
    _themeMode = widget.settingsService.getThemeMode();
  }

  // Public methods for SettingsScreen to call
  void changeThemePreset(ThemePreset preset) {
    setState(() {
      _currentThemePreset = preset;
      widget.settingsService.setThemePreset(preset.name);
    });
  }

  void toggleOledMode(bool value) {
    setState(() {
      _isOledMode = value;
      widget.settingsService.setOledMode(value);
    });
  }

  void toggleHaptic(bool value) {
    setState(() {
      _hapticEnabled = value;
      widget.settingsService.setHapticEnabled(value);
    });
  }

  void changeThemeMode(ThemeMode mode) {
    setState(() {
      _themeMode = mode;
      widget.settingsService.setThemeMode(mode);
    });
  }

  // Public getters
  ThemePreset get currentThemePreset => _currentThemePreset;
  bool get isOledMode => _isOledMode;
  bool get hapticEnabled => _hapticEnabled;
  ThemeMode get themeMode => _themeMode;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      navigatorObservers: [RouteTrackingObserver()],
      title: 'Mindly',
      debugShowCheckedModeBanner: false,
      theme: _currentThemePreset.createLightTheme(),
      darkTheme: _currentThemePreset.createDarkTheme(isOled: _isOledMode),
      themeMode: _themeMode,
      builder: (context, child) {
        return NotificationListenerWrapper(child: child!);
      },
      home: const SplashScreen(), // Start with Splash Screen
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/welcome':
            return MaterialPageRoute(builder: (_) => const WelcomeScreen());
          case '/onboarding':
            return MaterialPageRoute(
                builder: (_) => const ModernOnboardingScreen());
          case '/login':
            return MaterialPageRoute(builder: (_) => const LoginScreen());
          case '/signup':
            return MaterialPageRoute(builder: (_) => const SignupScreen());
          case '/username_setup':
            return MaterialPageRoute(
                builder: (_) => const UsernameSetupScreen());
          case '/home':
            return MaterialPageRoute(
                builder: (_) => const MainNavigationScreen());
          case '/quiz':
            final args = (settings.arguments ?? {}) as Map<String, dynamic>;
            Difficulty difficulty;
            if (args['difficulty'] is String) {
              difficulty = Difficulty.values.firstWhere(
                (d) =>
                    d.name.toLowerCase() ==
                    (args['difficulty'] as String).toLowerCase(),
                orElse: () => Difficulty.easy,
              );
            } else {
              difficulty = args['difficulty'] ?? Difficulty.easy;
            }

            return MaterialPageRoute(
              builder: (_) => QuizScreen(
                difficulty: difficulty,
                category: args['category'],
                timeLimitInMinutes: args['timeLimitInMinutes'],
                quizLength: args['quizLength'] ?? 10,
                customQuestions: args['customQuestions'] != null
                    ? List<Question>.from(args['customQuestions'])
                    : null,
                quiz: args['quiz'],
                levelId: args['levelId'], // Pass levelId
              ),
            );
          case '/result':
            final args = settings.arguments as Map<String, dynamic>;
            return MaterialPageRoute(
              builder: (_) => ResultScreen(
                score: args['score'],
                totalQuestions: args['totalQuestions'],
                questions: args['questions'],
                selectedAnswers: args['selectedAnswers'],
                difficulty: args['difficulty'],
                category: args['category'],
                timeTaken: args['timeTaken'],
                isBlindMode: args['isBlindMode'] ?? false,
                levelId: args['levelId'], // Pass levelId
                streakIncreased: args['streakIncreased'] ?? false,
                showAnswers: args['showAnswers'] ?? true, // Default to true
              ),
            );
          case '/campaign':
            return MaterialPageRoute(builder: (_) => const CampaignScreen());
          case '/shop':
            return MaterialPageRoute(builder: (_) => const ShopScreen());
          case '/quick_play':
            return MaterialPageRoute(builder: (_) => const QuickPlayScreen());
          case '/practice_weak_areas':
            return MaterialPageRoute(
                builder: (_) => const PracticeWeakAreasScreen());
          case '/notification_test':
            return MaterialPageRoute(
                builder: (_) => const NotificationTestScreen());
          case '/review':
            final args = settings.arguments as Map<String, dynamic>;
            return MaterialPageRoute(
              builder: (_) => ReviewScreen(
                questions: List<Question>.from(args['questions'] ?? []),
                selectedAnswers:
                    List<String?>.from(args['selectedAnswers'] ?? []),
              ),
            );
          case '/statistics':
            return MaterialPageRoute(builder: (_) => const StatisticsScreen());
          case '/lobby':
            return MaterialPageRoute(builder: (_) => const LobbyScreen());
          case '/multiplayer_game':
            final args = settings.arguments as Map<String, dynamic>;
            return MaterialPageRoute(
              builder: (_) => MultiplayerQuizScreen(
                code: args['code'],
                isHost: args['isHost'],
              ),
            );
          case '/leaderboard':
            return MaterialPageRoute(builder: (_) => const LeaderboardScreen());
          case '/bookmarks':
            return MaterialPageRoute(builder: (_) => const BookmarksScreen());
          case '/achievements':
            return MaterialPageRoute(
                builder: (_) => const AchievementsScreen());
          case '/documents':
            return MaterialPageRoute(
                builder: (_) => const DocumentLibraryScreen());
          case '/practice':
            final args = (settings.arguments ?? {}) as Map<String, dynamic>;
            return MaterialPageRoute(
              builder: (_) => PracticeScreen(
                questions: List<Question>.from(args['questions'] ?? []),
                title: args['title'] ?? 'Practice Mode',
              ),
            );
          case '/myQuizzes':
            return MaterialPageRoute(builder: (_) => const MyQuizzesScreen());
          case '/joinQuiz':
            return MaterialPageRoute(builder: (_) => const JoinQuizScreen());
          case '/customQuiz':
            final args = (settings.arguments ?? {}) as Map<String, dynamic>;
            return MaterialPageRoute(
              builder: (_) => QuizScreen(
                difficulty: Difficulty.easy,
                category: 'Custom',
                quizLength: (args['questions'] as List).length,
                customQuestions: List<Question>.from(args['questions']),
              ),
            );
          case '/generateQuiz':
            return MaterialPageRoute(
                builder: (_) => const GenerateQuizScreen());
          case '/profile':
            return MaterialPageRoute(builder: (_) => const ProfileScreen());
          case '/classes':
            return MaterialPageRoute(builder: (_) => const ClassesScreen());
          case '/create_class':
            return MaterialPageRoute(builder: (_) => const CreateClassScreen());
          case '/join_class':
            return MaterialPageRoute(builder: (_) => const JoinClassScreen());
          case '/class_detail':
            final args = settings.arguments;
            ClassModel? classModel;

            if (args is ClassModel) {
              classModel = args;
            } else if (args is Map<String, dynamic>) {
              try {
                classModel = ClassModel.fromJson(args);
              } catch (e) {
                debugPrint('Error parsing ClassModel: $e');
              }
            }

            if (classModel == null) {
              return MaterialPageRoute(
                builder: (_) => const Scaffold(
                  body: Center(child: Text('Error: Invalid class arguments')),
                ),
              );
            }

            return MaterialPageRoute(
              builder: (_) => ClassDetailScreen(classModel: classModel!),
            );
          case '/teacher_dashboard':
            return MaterialPageRoute(
                builder: (_) => const TeacherDashboardScreen());
          case '/class_analytics':
            final args = settings.arguments as ClassModel;
            return MaterialPageRoute(
                builder: (_) => ClassAnalyticsScreen(classModel: args));
          case '/settings':
            return MaterialPageRoute(builder: (_) => const SettingsScreen());
          case '/splash':
            return MaterialPageRoute(builder: (_) => const SplashScreen());
          case '/role_selection':
            return MaterialPageRoute(
                builder: (_) => const RoleSelectionScreen());
          case '/notifications':
            return MaterialPageRoute(
                builder: (_) => const NotificationsScreen());
          case '/study_planner':
            return MaterialPageRoute(
                builder: (_) => const StudyPlannerScreen());
          case '/daily_challenge':
            return MaterialPageRoute(
                builder: (_) => const DailyChallengeScreen());
          case '/schedule_class':
            final args = settings.arguments;
            if (args is Map<String, dynamic>) {
              // Edit mode
              return MaterialPageRoute(
                  builder: (_) => ScheduleClassScreen(
                        classModel: args['classModel'] as ClassModel,
                        existingEvent:
                            args['existingEvent'] as Map<String, dynamic>?,
                        eventId: args['eventId'] as String?,
                      ));
            } else {
              // Create mode
              final classModel = args as ClassModel;
              return MaterialPageRoute(
                  builder: (_) => ScheduleClassScreen(classModel: classModel));
            }
          case '/notification_preferences':
            return MaterialPageRoute(
                builder: (_) => const NotificationPreferencesScreen());
          default:
            return MaterialPageRoute(builder: (_) => const WelcomeScreen());
        }
      },
    );
  }
}

final ValueNotifier<String> currentRouteNotifier = ValueNotifier<String>('/');

class RouteTrackingObserver extends NavigatorObserver {
  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    if (route.settings.name != null) {
      currentRouteNotifier.value = route.settings.name!;
    }
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    if (newRoute?.settings.name != null) {
      currentRouteNotifier.value = newRoute!.settings.name!;
    }
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    if (previousRoute?.settings.name != null) {
      currentRouteNotifier.value = previousRoute!.settings.name!;
    }
  }
}

class NotificationListenerWrapper extends StatefulWidget {
  final Widget child;
  const NotificationListenerWrapper({super.key, required this.child});

  @override
  State<NotificationListenerWrapper> createState() =>
      _NotificationListenerWrapperState();
}

class _NotificationListenerWrapperState
    extends State<NotificationListenerWrapper> {
  // Stream subscription
  StreamSubscription? _subscription;
  final List<Map<String, dynamic>> _queue = [];

  @override
  void initState() {
    super.initState();

    // Listen for new notifications
    _subscription =
        ProfessionalNotificationService.instance.alertStream.listen((data) {
      _handleNotification(data);
    });

    // Listen for route changes to flush queue
    currentRouteNotifier.addListener(_checkQueue);
  }

  void _handleNotification(Map<String, dynamic> data) {
    // Block on Splash or Root (if Root is Splash) and during initialization
    final route = currentRouteNotifier.value;
    if (route == '/' ||
        route == '/splash' ||
        route == '/welcome' ||
        route.isEmpty) {
      _queue.add(data);
    } else {
      // Add small delay to ensure UI is ready
      Future.delayed(const Duration(milliseconds: 100), () {
        if (mounted) {
          _showNotificationDialog(data);
        }
      });
    }
  }

  void _checkQueue() {
    final route = currentRouteNotifier.value;
    // Authorized screens to show notifications
    if (route != '/' &&
        route != '/splash' &&
        route != '/welcome' &&
        _queue.isNotEmpty) {
      // Create a copy to iterate
      final pending = List<Map<String, dynamic>>.from(_queue);
      _queue.clear();
      for (final data in pending) {
        _showNotificationDialog(data);
      }
    }
  }

  @override
  void dispose() {
    _subscription?.cancel();
    currentRouteNotifier.removeListener(_checkQueue);
    super.dispose();
  }

  void _showNotificationDialog(Map<String, dynamic> data) {
    if (!mounted) return;

    final navContext = navigatorKey.currentContext;
    if (navContext == null) return;

    GlassDialog.show(
      context: navContext,
      barrierDismissible: false,
      title: data['title'] ?? 'Notification',
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.notifications_active, color: Colors.purple),
              const SizedBox(width: 8),
              Expanded(
                  child: Text(data['message'] ?? '',
                      style: const TextStyle(fontSize: 16))),
            ],
          ),
          if (data['type'] == 'exam_created') ...[
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.purple.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.purple.shade100),
              ),
              child: const Row(
                children: [
                  Icon(Icons.info_outline, size: 20, color: Colors.purple),
                  SizedBox(width: 8),
                  Expanded(child: Text('Reminder set for 15 mins before!')),
                ],
              ),
            ),
          ]
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(navContext),
          child: const Text('Dismiss'),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.pop(navContext);
          },
          child: const Text('Okay'),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.child,
        const OfflineIndicator(),
      ],
    );
  }
}
