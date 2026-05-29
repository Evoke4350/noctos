import 'dart:io' show Platform;

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:health/health.dart';

import 'models.dart';

enum HealthConnectStatus {
  unsupportedPlatform,
  notInstalled,
  needsPermissions,
  granted,
  denied,
}

abstract class HealthConnectService {
  Future<HealthConnectStatus> status();
  Future<HealthConnectStatus> requestPermissions();
  Future<List<HealthSleepRecord>> readSleepSessions(
    DateTime start,
    DateTime end,
  );
  Future<void> installHealthConnectApp();
  Future<void> revokePermissions();
}

class RealHealthConnectService implements HealthConnectService {
  RealHealthConnectService() : _health = Health() {
    _health.configure();
  }

  final Health _health;

  static const _readTypes = [
    HealthDataType.SLEEP_SESSION,
    HealthDataType.SLEEP_AWAKE,
    HealthDataType.SLEEP_DEEP,
    HealthDataType.SLEEP_LIGHT,
    HealthDataType.SLEEP_REM,
    HealthDataType.SLEEP_OUT_OF_BED,
    HealthDataType.HEART_RATE,
    HealthDataType.HEART_RATE_VARIABILITY_RMSSD,
    HealthDataType.RESTING_HEART_RATE,
  ];

  static List<HealthDataAccess> get _readPermissions =>
      List.filled(_readTypes.length, HealthDataAccess.READ);

  @override
  Future<HealthConnectStatus> status() async {
    if (kIsWeb || !Platform.isAndroid) {
      return HealthConnectStatus.unsupportedPlatform;
    }
    final sdkStatus = await _health.getHealthConnectSdkStatus();
    if (sdkStatus != HealthConnectSdkStatus.sdkAvailable) {
      return HealthConnectStatus.notInstalled;
    }
    final granted =
        await _health.hasPermissions(
          _readTypes,
          permissions: _readPermissions,
        ) ??
        false;
    if (granted) return HealthConnectStatus.granted;
    return HealthConnectStatus.needsPermissions;
  }

  @override
  Future<HealthConnectStatus> requestPermissions() async {
    if (kIsWeb || !Platform.isAndroid) {
      return HealthConnectStatus.unsupportedPlatform;
    }
    final ok = await _health.requestAuthorization(
      _readTypes,
      permissions: _readPermissions,
    );
    if (!ok) return HealthConnectStatus.denied;
    return status();
  }

  @override
  Future<List<HealthSleepRecord>> readSleepSessions(
    DateTime start,
    DateTime end,
  ) async {
    final raw = await _health.getHealthDataFromTypes(
      types: _readTypes,
      startTime: start,
      endTime: end,
    );
    return _foldIntoSessions(raw);
  }

  @override
  Future<void> installHealthConnectApp() async {
    await _health.installHealthConnect();
  }

  @override
  Future<void> revokePermissions() async {
    await _health.revokePermissions();
  }

  List<HealthSleepRecord> _foldIntoSessions(List<HealthDataPoint> points) {
    final sessions =
        points.where((p) => p.type == HealthDataType.SLEEP_SESSION).toList()
          ..sort((a, b) => a.dateFrom.compareTo(b.dateFrom));

    return sessions.map((session) {
      final sessionStart = session.dateFrom;
      final now = DateTime.now();
      final sessionEnd = session.dateTo.isAfter(now) ? now : session.dateTo;

      final stages = points
          .where(
            (p) =>
                _isStageType(p.type) &&
                !p.dateFrom.isBefore(sessionStart) &&
                !p.dateTo.isAfter(sessionEnd),
          )
          .map(
            (p) => SleepStageSpan(
              start: p.dateFrom,
              end: p.dateTo,
              stage: _stageFromType(p.type),
            ),
          )
          .toList();

      double? avgNumeric(HealthDataType type, DateTime from, DateTime to) {
        final values = points
            .where(
              (p) =>
                  p.type == type &&
                  !p.dateFrom.isBefore(from) &&
                  !p.dateFrom.isAfter(to),
            )
            .map((p) => (p.value as NumericHealthValue).numericValue.toDouble())
            .toList();
        if (values.isEmpty) return null;
        return values.reduce((a, b) => a + b) / values.length;
      }

      return HealthSleepRecord(
        sessionStart: sessionStart,
        sessionEnd: sessionEnd,
        stages: stages,
        hrAvgBpm: avgNumeric(
          HealthDataType.HEART_RATE,
          sessionStart,
          sessionEnd,
        ),
        hrvAvgMs: avgNumeric(
          HealthDataType.HEART_RATE_VARIABILITY_RMSSD,
          sessionStart,
          sessionEnd,
        ),
        restingHrBpm: avgNumeric(
          HealthDataType.RESTING_HEART_RATE,
          sessionEnd.subtract(const Duration(hours: 24)),
          sessionEnd,
        ),
        sourceApp: session.sourceName,
        sourceDevice: session.deviceModel,
      );
    }).toList();
  }

  bool _isStageType(HealthDataType t) =>
      t == HealthDataType.SLEEP_AWAKE ||
      t == HealthDataType.SLEEP_LIGHT ||
      t == HealthDataType.SLEEP_DEEP ||
      t == HealthDataType.SLEEP_REM ||
      t == HealthDataType.SLEEP_OUT_OF_BED;

  SleepStage _stageFromType(HealthDataType t) {
    switch (t) {
      case HealthDataType.SLEEP_AWAKE:
        return SleepStage.awake;
      case HealthDataType.SLEEP_LIGHT:
        return SleepStage.light;
      case HealthDataType.SLEEP_DEEP:
        return SleepStage.deep;
      case HealthDataType.SLEEP_REM:
        return SleepStage.rem;
      case HealthDataType.SLEEP_OUT_OF_BED:
        return SleepStage.outOfBed;
      default:
        return SleepStage.unknown;
    }
  }
}
