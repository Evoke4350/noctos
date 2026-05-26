import 'dart:convert';

enum SleepStage { awake, light, deep, rem, outOfBed, unknown }

class SleepStageSpan {
  SleepStageSpan({required this.start, required this.end, required this.stage});

  final DateTime start;
  final DateTime end;
  final SleepStage stage;

  Map<String, dynamic> toJson() => {
        'start': start.toUtc().millisecondsSinceEpoch,
        'end': end.toUtc().millisecondsSinceEpoch,
        'stage': stage.name,
      };

  factory SleepStageSpan.fromJson(Map<String, dynamic> j) => SleepStageSpan(
        start: DateTime.fromMillisecondsSinceEpoch(j['start'] as int, isUtc: true),
        end: DateTime.fromMillisecondsSinceEpoch(j['end'] as int, isUtc: true),
        stage: SleepStage.values.byName(j['stage'] as String),
      );

  Duration get duration => end.difference(start);
}

class HealthSleepRecord {
  HealthSleepRecord({
    required this.sessionStart,
    required this.sessionEnd,
    required this.stages,
    required this.hrAvgBpm,
    required this.hrvAvgMs,
    required this.restingHrBpm,
    required this.sourceApp,
    required this.sourceDevice,
  });

  final DateTime sessionStart;
  final DateTime sessionEnd;
  final List<SleepStageSpan> stages;
  final double? hrAvgBpm;
  final double? hrvAvgMs;
  final double? restingHrBpm;
  final String? sourceApp;
  final String? sourceDevice;

  int get totalMinutes => sessionEnd.difference(sessionStart).inMinutes;

  String? get stagesJson =>
      stages.isEmpty ? null : jsonEncode(stages.map((s) => s.toJson()).toList());

  static List<SleepStageSpan> stagesFromJson(String? raw) {
    if (raw == null || raw.isEmpty) return const [];
    final list = jsonDecode(raw) as List;
    return list
        .map((e) => SleepStageSpan.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
