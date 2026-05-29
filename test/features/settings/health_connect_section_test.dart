import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:noctos/features/settings/widgets/health_connect_section.dart';
import 'package:noctos/services/health/health_connect_service.dart';
import 'package:noctos/services/health/models.dart';
import 'package:noctos/services/health/providers.dart';

class StubService implements HealthConnectService {
  StubService(this._status);
  HealthConnectStatus _status;
  @override
  Future<HealthConnectStatus> status() async => _status;
  @override
  Future<HealthConnectStatus> requestPermissions() async {
    _status = HealthConnectStatus.granted;
    return _status;
  }
  @override
  Future<List<HealthSleepRecord>> readSleepSessions(
          DateTime s, DateTime e) async =>
      const [];
  @override
  Future<void> installHealthConnectApp() async {}
  @override
  Future<void> revokePermissions() async {}
}

Widget wrap(HealthConnectStatus status) {
  return ProviderScope(
    overrides: [
      healthConnectServiceProvider.overrideWithValue(StubService(status)),
    ],
    child: const MaterialApp(
      home: Scaffold(body: HealthConnectSection()),
    ),
  );
}

void main() {
  testWidgets('shows "Not installed" when HC missing', (tester) async {
    await tester.pumpWidget(wrap(HealthConnectStatus.notInstalled));
    await tester.pumpAndSettle();
    expect(find.text('Health Connect not installed'), findsOneWidget);
    expect(find.text('Install from Play Store'), findsOneWidget);
  });

  testWidgets('shows Connect button when needs permissions',
      (tester) async {
    await tester.pumpWidget(wrap(HealthConnectStatus.needsPermissions));
    await tester.pumpAndSettle();
    expect(find.text('Connect'), findsOneWidget);
  });

  testWidgets('shows Connected + Sync now + Disconnect when granted',
      (tester) async {
    await tester.pumpWidget(wrap(HealthConnectStatus.granted));
    await tester.pumpAndSettle();
    expect(find.textContaining('Connected'), findsOneWidget);
    expect(find.text('Sync now'), findsOneWidget);
    expect(find.text('Disconnect'), findsOneWidget);
  });

  testWidgets('shows "Available on Android" when unsupported platform',
      (tester) async {
    await tester.pumpWidget(wrap(HealthConnectStatus.unsupportedPlatform));
    await tester.pumpAndSettle();
    expect(
      find.textContaining('Available on Android'),
      findsOneWidget,
    );
  });
}
