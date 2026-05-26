import 'package:flutter_test/flutter_test.dart';
import 'package:noctos/services/health/models.dart';

void main() {
  group('SleepStage.fromHealthValue', () {
    test('maps Health Connect stage ints to enum', () {
      // health pub package uses these int codes for HC stages:
      // 1=AWAKE, 2=SLEEPING, 3=OUT_OF_BED, 4=LIGHT, 5=DEEP, 6=REM, 7=UNKNOWN
      expect(SleepStage.fromHealthValue(1), SleepStage.awake);
      expect(SleepStage.fromHealthValue(3), SleepStage.outOfBed);
      expect(SleepStage.fromHealthValue(4), SleepStage.light);
      expect(SleepStage.fromHealthValue(5), SleepStage.deep);
      expect(SleepStage.fromHealthValue(6), SleepStage.rem);
      expect(SleepStage.fromHealthValue(99), SleepStage.unknown);
    });
  });

  group('HealthSleepRecord.totalMinutes', () {
    test('computes duration from session window', () {
      final start = DateTime(2026, 5, 26, 23, 30);
      final end = DateTime(2026, 5, 27, 6, 0);
      final record = HealthSleepRecord(
        sessionStart: start,
        sessionEnd: end,
        stages: const [],
        hrAvgBpm: null,
        hrvAvgMs: null,
        restingHrBpm: null,
        sourceApp: null,
        sourceDevice: null,
      );
      expect(record.totalMinutes, 6 * 60 + 30);
    });
  });

  group('SleepStageSpan JSON roundtrip', () {
    test('encodes and decodes', () {
      final span = SleepStageSpan(
        start: DateTime.utc(2026, 5, 26, 23, 30),
        end: DateTime.utc(2026, 5, 26, 23, 45),
        stage: SleepStage.light,
      );
      final json = span.toJson();
      final back = SleepStageSpan.fromJson(json);
      expect(back.start, span.start);
      expect(back.end, span.end);
      expect(back.stage, span.stage);
    });
  });

  group('HealthSleepRecord.stagesJson roundtrip', () {
    test('encodes and decodes stages list', () {
      final stages = [
        SleepStageSpan(
          start: DateTime.utc(2026, 5, 26, 23, 30),
          end: DateTime.utc(2026, 5, 27, 0, 15),
          stage: SleepStage.light,
        ),
        SleepStageSpan(
          start: DateTime.utc(2026, 5, 27, 0, 15),
          end: DateTime.utc(2026, 5, 27, 1, 0),
          stage: SleepStage.deep,
        ),
      ];
      final record = HealthSleepRecord(
        sessionStart: DateTime.utc(2026, 5, 26, 23, 30),
        sessionEnd: DateTime.utc(2026, 5, 27, 6, 0),
        stages: stages,
        hrAvgBpm: null,
        hrvAvgMs: null,
        restingHrBpm: null,
        sourceApp: null,
        sourceDevice: null,
      );
      final json = record.stagesJson;
      expect(json, isNotNull);
      final back = HealthSleepRecord.stagesFromJson(json);
      expect(back, hasLength(2));
      expect(back[0].stage, SleepStage.light);
      expect(back[1].stage, SleepStage.deep);
      expect(back[0].start, DateTime.utc(2026, 5, 26, 23, 30));
      expect(back[1].end, DateTime.utc(2026, 5, 27, 1, 0));
    });

    test('stagesJson is null when stages list is empty', () {
      final record = HealthSleepRecord(
        sessionStart: DateTime.utc(2026, 5, 26, 23, 30),
        sessionEnd: DateTime.utc(2026, 5, 27, 6, 0),
        stages: const [],
        hrAvgBpm: null,
        hrvAvgMs: null,
        restingHrBpm: null,
        sourceApp: null,
        sourceDevice: null,
      );
      expect(record.stagesJson, isNull);
    });

    test('stagesFromJson returns empty list for null or empty input', () {
      expect(HealthSleepRecord.stagesFromJson(null), isEmpty);
      expect(HealthSleepRecord.stagesFromJson(''), isEmpty);
    });
  });
}
