import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../features/onboarding/intake_screen.dart';
import '../features/onboarding/chronotype_quiz_screen.dart';
import '../features/onboarding/schedule_setup_screen.dart';
import '../features/onboarding/onboarding_gate.dart';
import '../features/diary/home_screen.dart';
import '../features/diary/diary_entry_screen.dart';
import '../features/diary/diary_history_screen.dart';
import '../features/diary/sleep_record_detail_screen.dart';
import '../features/program/program_overview_screen.dart';
import '../features/program/week_detail_screen.dart';
import '../features/caffeine/caffeine_log_screen.dart';
import '../features/worry_journal/worry_journal_screen.dart';
import '../features/settings/settings_screen.dart';

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(path: '/', builder: (_, __) => const OnboardingGate()),
      GoRoute(
        path: '/onboarding/intake',
        builder: (_, __) => const IntakeScreen(),
      ),
      GoRoute(
        path: '/onboarding/chronotype',
        builder: (_, __) => const ChronotypeQuizScreen(),
      ),
      GoRoute(
        path: '/onboarding/schedule',
        builder: (_, __) => const ScheduleSetupScreen(),
      ),
      GoRoute(path: '/home', builder: (_, __) => const HomeScreen()),
      GoRoute(path: '/diary/new', builder: (_, __) => const DiaryEntryScreen()),
      GoRoute(
        path: '/diary/history',
        builder: (_, __) => const DiaryHistoryScreen(),
      ),
      GoRoute(
        path: '/diary/:date/sleep-record',
        builder: (_, state) => SleepRecordDetailScreen(
          diaryDate: DateTime.parse(state.pathParameters['date']!),
        ),
      ),
      GoRoute(
        path: '/program',
        builder: (_, __) => const ProgramOverviewScreen(),
      ),
      GoRoute(
        path: '/program/:weekIndex',
        builder: (_, state) => WeekDetailScreen(
          weekIndex: int.parse(state.pathParameters['weekIndex']!),
        ),
      ),
      GoRoute(path: '/caffeine', builder: (_, __) => const CaffeineLogScreen()),
      GoRoute(path: '/worry', builder: (_, __) => const WorryJournalScreen()),
      GoRoute(path: '/settings', builder: (_, __) => const SettingsScreen()),
    ],
  );
});
