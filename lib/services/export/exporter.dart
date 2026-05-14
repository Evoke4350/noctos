import 'dart:convert';
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../../data/db/database.dart';
import '../../data/db/db_providers.dart';

enum ExportFormat { json, csv }

class ExportResult {
  final String path;
  final int byteSize;
  const ExportResult({required this.path, required this.byteSize});
}

class Exporter {
  Exporter(this._db);
  final NoctosDatabase _db;

  Future<ExportResult> export(ExportFormat format) async {
    final dir = await getApplicationDocumentsDirectory();
    final stamp = DateTime.now()
        .toIso8601String()
        .replaceAll(':', '-')
        .split('.')
        .first;
    final ext = format == ExportFormat.json ? 'json' : 'csv';
    final file = File(p.join(dir.path, 'noctos-export-$stamp.$ext'));

    final diary = await _db.select(_db.sleepDiaryEntries).get();
    final schedule = await _db.select(_db.userSchedules).get();
    final weeks = await _db.select(_db.cbtiWeeks).get();
    final caffeine = await _db.select(_db.caffeineLogs).get();
    final worry = await _db.select(_db.worryJournalEntries).get();

    if (format == ExportFormat.json) {
      final payload = {
        'schema_version': 3,
        'exported_at': DateTime.now().toIso8601String(),
        'sleep_diary_entries': diary.map(_diaryToMap).toList(),
        'user_schedules': schedule.map(_scheduleToMap).toList(),
        'cbti_weeks': weeks.map(_weekToMap).toList(),
        'caffeine_logs': caffeine.map(_caffeineToMap).toList(),
        'worry_journal_entries': worry.map(_worryToMap).toList(),
      };
      const encoder = JsonEncoder.withIndent('  ');
      await file.writeAsString(encoder.convert(payload));
    } else {
      final buf = StringBuffer();
      buf.writeln('# noctos export ${DateTime.now().toIso8601String()}');

      buf.writeln('\n[sleep_diary_entries]');
      buf.writeln(
        _csvHeader(_diaryToMap(diary.isNotEmpty ? diary.first : _emptyDiary())),
      );
      for (final e in diary) {
        buf.writeln(_csvRow(_diaryToMap(e)));
      }

      buf.writeln('\n[user_schedules]');
      buf.writeln(
        _csvHeader(
          _scheduleToMap(
            schedule.isNotEmpty ? schedule.first : _emptySchedule(),
          ),
        ),
      );
      for (final e in schedule) {
        buf.writeln(_csvRow(_scheduleToMap(e)));
      }

      buf.writeln('\n[cbti_weeks]');
      buf.writeln(
        _csvHeader(_weekToMap(weeks.isNotEmpty ? weeks.first : _emptyWeek())),
      );
      for (final e in weeks) {
        buf.writeln(_csvRow(_weekToMap(e)));
      }

      buf.writeln('\n[caffeine_logs]');
      buf.writeln(
        _csvHeader(
          _caffeineToMap(
            caffeine.isNotEmpty ? caffeine.first : _emptyCaffeine(),
          ),
        ),
      );
      for (final e in caffeine) {
        buf.writeln(_csvRow(_caffeineToMap(e)));
      }

      buf.writeln('\n[worry_journal_entries]');
      buf.writeln(
        _csvHeader(_worryToMap(worry.isNotEmpty ? worry.first : _emptyWorry())),
      );
      for (final e in worry) {
        buf.writeln(_csvRow(_worryToMap(e)));
      }

      await file.writeAsString(buf.toString());
    }

    final size = await file.length();
    return ExportResult(path: file.path, byteSize: size);
  }

  Map<String, Object?> _diaryToMap(SleepDiaryEntry e) => {
    'id': e.id,
    'diary_date': e.diaryDate.toIso8601String(),
    'bedtime': e.bedtime.toIso8601String(),
    'lights_out': e.lightsOut.toIso8601String(),
    'sleep_latency_min': e.sleepLatencyMin,
    'awakenings_count': e.awakeningsCount,
    'waso_min': e.wasoMin,
    'wake_time': e.wakeTime.toIso8601String(),
    'out_of_bed_time': e.outOfBedTime.toIso8601String(),
    'quality_rating': e.qualityRating,
    'mood_rating': e.moodRating,
    'adherent_to_prescription': e.adherentToPrescription,
    'notes': e.notes,
    'created_at': e.createdAt.toIso8601String(),
  };

  Map<String, Object?> _scheduleToMap(UserSchedule s) => {
    'id': s.id,
    'fixed_wake_minutes_of_day': s.fixedWakeMinutesOfDay,
    'current_bedtime_minutes_of_day': s.currentBedtimeMinutesOfDay,
    'current_tib_minutes': s.currentTibMinutes,
    'wind_down_minutes': s.windDownMinutes,
    'caffeine_cutoff_offset_min': s.caffeineCutoffOffsetMin,
    'chronotype_score': s.chronotypeScore,
    'chronotype_category': s.chronotypeCategory,
    'insomnia_types': s.insomniaTypes,
    'insomnia_severity': s.insomniaSeverity,
    'notifications_enabled': s.notificationsEnabled,
    'created_at': s.createdAt.toIso8601String(),
    'updated_at': s.updatedAt.toIso8601String(),
  };

  Map<String, Object?> _weekToMap(CbtiWeek w) => {
    'id': w.id,
    'week_index': w.weekIndex,
    'phase_id': w.phaseId,
    'started_on': w.startedOn.toIso8601String(),
    'prescribed_bedtime_minutes_of_day': w.prescribedBedtimeMinutesOfDay,
    'prescribed_wake_minutes_of_day': w.prescribedWakeMinutesOfDay,
    'tib_minutes': w.tibMinutes,
    'efficiency_target': w.efficiencyTarget,
    'rationale': w.rationale,
    'action': w.action,
    'status': w.status,
    'created_at': w.createdAt.toIso8601String(),
  };

  Map<String, Object?> _caffeineToMap(CaffeineLog c) => {
    'id': c.id,
    'consumed_at': c.consumedAt.toIso8601String(),
    'mg': c.mg,
    'source': c.source,
    'created_at': c.createdAt.toIso8601String(),
  };

  Map<String, Object?> _worryToMap(WorryJournalEntry w) => {
    'id': w.id,
    'entered_at': w.enteredAt.toIso8601String(),
    'worry': w.worry,
    'next_action': w.nextAction,
    'resolved': w.resolved,
    'created_at': w.createdAt.toIso8601String(),
  };

  // Placeholder rows just to print headers when a table is empty.
  SleepDiaryEntry _emptyDiary() => SleepDiaryEntry(
    id: 0,
    diaryDate: DateTime.fromMillisecondsSinceEpoch(0),
    bedtime: DateTime.fromMillisecondsSinceEpoch(0),
    lightsOut: DateTime.fromMillisecondsSinceEpoch(0),
    sleepLatencyMin: 0,
    awakeningsCount: 0,
    wasoMin: 0,
    wakeTime: DateTime.fromMillisecondsSinceEpoch(0),
    outOfBedTime: DateTime.fromMillisecondsSinceEpoch(0),
    qualityRating: 0,
    moodRating: 0,
    adherentToPrescription: false,
    notes: null,
    createdAt: DateTime.fromMillisecondsSinceEpoch(0),
  );

  UserSchedule _emptySchedule() => UserSchedule(
    id: 0,
    fixedWakeMinutesOfDay: 0,
    currentBedtimeMinutesOfDay: 0,
    currentTibMinutes: 0,
    windDownMinutes: 0,
    caffeineCutoffOffsetMin: 0,
    chronotypeScore: null,
    chronotypeCategory: null,
    insomniaTypes: null,
    insomniaSeverity: null,
    notificationsEnabled: false,
    createdAt: DateTime.fromMillisecondsSinceEpoch(0),
    updatedAt: DateTime.fromMillisecondsSinceEpoch(0),
  );

  CbtiWeek _emptyWeek() => CbtiWeek(
    id: 0,
    weekIndex: 0,
    phaseId: '',
    startedOn: DateTime.fromMillisecondsSinceEpoch(0),
    prescribedBedtimeMinutesOfDay: 0,
    prescribedWakeMinutesOfDay: 0,
    tibMinutes: 0,
    efficiencyTarget: 0,
    rationale: '',
    action: '',
    status: '',
    createdAt: DateTime.fromMillisecondsSinceEpoch(0),
  );

  CaffeineLog _emptyCaffeine() => CaffeineLog(
    id: 0,
    consumedAt: DateTime.fromMillisecondsSinceEpoch(0),
    mg: 0,
    source: null,
    createdAt: DateTime.fromMillisecondsSinceEpoch(0),
  );

  WorryJournalEntry _emptyWorry() => WorryJournalEntry(
    id: 0,
    enteredAt: DateTime.fromMillisecondsSinceEpoch(0),
    worry: '',
    nextAction: null,
    resolved: false,
    createdAt: DateTime.fromMillisecondsSinceEpoch(0),
  );

  String _csvHeader(Map<String, Object?> row) => row.keys.join(',');

  String _csvRow(Map<String, Object?> row) =>
      row.values.map(_csvCell).join(',');

  String _csvCell(Object? v) {
    if (v == null) return '';
    final s = v.toString();
    if (s.contains(',') || s.contains('"') || s.contains('\n')) {
      return '"${s.replaceAll('"', '""')}"';
    }
    return s;
  }
}

final exporterProvider = Provider<Exporter>((ref) {
  return Exporter(ref.watch(databaseProvider));
});
