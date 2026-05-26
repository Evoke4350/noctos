import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:noctos/features/diary/widgets/health_connect_nudge_banner.dart';
import 'package:noctos/services/health/health_connect_service.dart';
import 'package:noctos/services/health/models.dart';
import 'package:noctos/services/health/providers.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FakeSvc implements HealthConnectService {
  FakeSvc(this.statusValue);
  HealthConnectStatus statusValue;
  @override
  Future<HealthConnectStatus> status() async => statusValue;
  @override
  Future<HealthConnectStatus> requestPermissions() async => statusValue;
  @override
  Future<List<HealthSleepRecord>> readSleepSessions(
          DateTime s, DateTime e) async =>
      const [];
  @override
  Future<void> installHealthConnectApp() async {}
  @override
  Future<void> revokePermissions() async {}
}

Widget wrap({
  required int currentWeek,
  required HealthConnectStatus status,
}) {
  return ProviderScope(
    overrides: [
      healthConnectServiceProvider.overrideWithValue(FakeSvc(status)),
    ],
    child: MaterialApp(
      home: Scaffold(
        body: HealthConnectNudgeBanner(currentWeek: currentWeek),
      ),
    ),
  );
}

void main() {
  setUp(() => SharedPreferences.setMockInitialValues({}));

  testWidgets('hidden when currentWeek < 2', (tester) async {
    await tester.pumpWidget(
      wrap(currentWeek: 1, status: HealthConnectStatus.needsPermissions),
    );
    await tester.pumpAndSettle();
    expect(find.byType(Card), findsNothing);
  });

  testWidgets('hidden when HC already granted', (tester) async {
    await tester.pumpWidget(
      wrap(currentWeek: 2, status: HealthConnectStatus.granted),
    );
    await tester.pumpAndSettle();
    expect(find.byType(Card), findsNothing);
  });

  testWidgets('shows when week>=2 and not granted', (tester) async {
    await tester.pumpWidget(
      wrap(currentWeek: 2, status: HealthConnectStatus.needsPermissions),
    );
    await tester.pumpAndSettle();
    expect(find.text('Connect Health Connect'), findsOneWidget);
    expect(find.text('Not now'), findsOneWidget);
  });

  testWidgets('"Not now" dismisses and persists', (tester) async {
    await tester.pumpWidget(
      wrap(currentWeek: 2, status: HealthConnectStatus.needsPermissions),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Not now'));
    await tester.pumpAndSettle();
    expect(find.byType(Card), findsNothing);
    final prefs = await SharedPreferences.getInstance();
    expect(prefs.getString('health.nudgeShownAt'), isNotNull);
  });

  testWidgets('hidden if nudgeShownAt already set', (tester) async {
    SharedPreferences.setMockInitialValues({
      'health.nudgeShownAt': DateTime.now().toIso8601String(),
    });
    await tester.pumpWidget(
      wrap(currentWeek: 2, status: HealthConnectStatus.needsPermissions),
    );
    await tester.pumpAndSettle();
    expect(find.byType(Card), findsNothing);
  });
}
