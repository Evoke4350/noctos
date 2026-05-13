// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $SleepDiaryEntriesTable extends SleepDiaryEntries
    with TableInfo<$SleepDiaryEntriesTable, SleepDiaryEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SleepDiaryEntriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _diaryDateMeta = const VerificationMeta(
    'diaryDate',
  );
  @override
  late final GeneratedColumn<DateTime> diaryDate = GeneratedColumn<DateTime>(
    'diary_date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _bedtimeMeta = const VerificationMeta(
    'bedtime',
  );
  @override
  late final GeneratedColumn<DateTime> bedtime = GeneratedColumn<DateTime>(
    'bedtime',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _lightsOutMeta = const VerificationMeta(
    'lightsOut',
  );
  @override
  late final GeneratedColumn<DateTime> lightsOut = GeneratedColumn<DateTime>(
    'lights_out',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sleepLatencyMinMeta = const VerificationMeta(
    'sleepLatencyMin',
  );
  @override
  late final GeneratedColumn<int> sleepLatencyMin = GeneratedColumn<int>(
    'sleep_latency_min',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _awakeningsCountMeta = const VerificationMeta(
    'awakeningsCount',
  );
  @override
  late final GeneratedColumn<int> awakeningsCount = GeneratedColumn<int>(
    'awakenings_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _wasoMinMeta = const VerificationMeta(
    'wasoMin',
  );
  @override
  late final GeneratedColumn<int> wasoMin = GeneratedColumn<int>(
    'waso_min',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _wakeTimeMeta = const VerificationMeta(
    'wakeTime',
  );
  @override
  late final GeneratedColumn<DateTime> wakeTime = GeneratedColumn<DateTime>(
    'wake_time',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _outOfBedTimeMeta = const VerificationMeta(
    'outOfBedTime',
  );
  @override
  late final GeneratedColumn<DateTime> outOfBedTime = GeneratedColumn<DateTime>(
    'out_of_bed_time',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _qualityRatingMeta = const VerificationMeta(
    'qualityRating',
  );
  @override
  late final GeneratedColumn<int> qualityRating = GeneratedColumn<int>(
    'quality_rating',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(3),
  );
  static const VerificationMeta _moodRatingMeta = const VerificationMeta(
    'moodRating',
  );
  @override
  late final GeneratedColumn<int> moodRating = GeneratedColumn<int>(
    'mood_rating',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(3),
  );
  static const VerificationMeta _adherentToPrescriptionMeta =
      const VerificationMeta('adherentToPrescription');
  @override
  late final GeneratedColumn<bool> adherentToPrescription =
      GeneratedColumn<bool>(
        'adherent_to_prescription',
        aliasedName,
        false,
        type: DriftSqlType.bool,
        requiredDuringInsert: false,
        defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("adherent_to_prescription" IN (0, 1))',
        ),
        defaultValue: const Constant(true),
      );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    diaryDate,
    bedtime,
    lightsOut,
    sleepLatencyMin,
    awakeningsCount,
    wasoMin,
    wakeTime,
    outOfBedTime,
    qualityRating,
    moodRating,
    adherentToPrescription,
    notes,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sleep_diary_entries';
  @override
  VerificationContext validateIntegrity(
    Insertable<SleepDiaryEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('diary_date')) {
      context.handle(
        _diaryDateMeta,
        diaryDate.isAcceptableOrUnknown(data['diary_date']!, _diaryDateMeta),
      );
    } else if (isInserting) {
      context.missing(_diaryDateMeta);
    }
    if (data.containsKey('bedtime')) {
      context.handle(
        _bedtimeMeta,
        bedtime.isAcceptableOrUnknown(data['bedtime']!, _bedtimeMeta),
      );
    } else if (isInserting) {
      context.missing(_bedtimeMeta);
    }
    if (data.containsKey('lights_out')) {
      context.handle(
        _lightsOutMeta,
        lightsOut.isAcceptableOrUnknown(data['lights_out']!, _lightsOutMeta),
      );
    } else if (isInserting) {
      context.missing(_lightsOutMeta);
    }
    if (data.containsKey('sleep_latency_min')) {
      context.handle(
        _sleepLatencyMinMeta,
        sleepLatencyMin.isAcceptableOrUnknown(
          data['sleep_latency_min']!,
          _sleepLatencyMinMeta,
        ),
      );
    }
    if (data.containsKey('awakenings_count')) {
      context.handle(
        _awakeningsCountMeta,
        awakeningsCount.isAcceptableOrUnknown(
          data['awakenings_count']!,
          _awakeningsCountMeta,
        ),
      );
    }
    if (data.containsKey('waso_min')) {
      context.handle(
        _wasoMinMeta,
        wasoMin.isAcceptableOrUnknown(data['waso_min']!, _wasoMinMeta),
      );
    }
    if (data.containsKey('wake_time')) {
      context.handle(
        _wakeTimeMeta,
        wakeTime.isAcceptableOrUnknown(data['wake_time']!, _wakeTimeMeta),
      );
    } else if (isInserting) {
      context.missing(_wakeTimeMeta);
    }
    if (data.containsKey('out_of_bed_time')) {
      context.handle(
        _outOfBedTimeMeta,
        outOfBedTime.isAcceptableOrUnknown(
          data['out_of_bed_time']!,
          _outOfBedTimeMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_outOfBedTimeMeta);
    }
    if (data.containsKey('quality_rating')) {
      context.handle(
        _qualityRatingMeta,
        qualityRating.isAcceptableOrUnknown(
          data['quality_rating']!,
          _qualityRatingMeta,
        ),
      );
    }
    if (data.containsKey('mood_rating')) {
      context.handle(
        _moodRatingMeta,
        moodRating.isAcceptableOrUnknown(data['mood_rating']!, _moodRatingMeta),
      );
    }
    if (data.containsKey('adherent_to_prescription')) {
      context.handle(
        _adherentToPrescriptionMeta,
        adherentToPrescription.isAcceptableOrUnknown(
          data['adherent_to_prescription']!,
          _adherentToPrescriptionMeta,
        ),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SleepDiaryEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SleepDiaryEntry(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      diaryDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}diary_date'],
      )!,
      bedtime: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}bedtime'],
      )!,
      lightsOut: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}lights_out'],
      )!,
      sleepLatencyMin: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sleep_latency_min'],
      )!,
      awakeningsCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}awakenings_count'],
      )!,
      wasoMin: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}waso_min'],
      )!,
      wakeTime: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}wake_time'],
      )!,
      outOfBedTime: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}out_of_bed_time'],
      )!,
      qualityRating: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}quality_rating'],
      )!,
      moodRating: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}mood_rating'],
      )!,
      adherentToPrescription: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}adherent_to_prescription'],
      )!,
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $SleepDiaryEntriesTable createAlias(String alias) {
    return $SleepDiaryEntriesTable(attachedDatabase, alias);
  }
}

class SleepDiaryEntry extends DataClass implements Insertable<SleepDiaryEntry> {
  final int id;
  final DateTime diaryDate;
  final DateTime bedtime;
  final DateTime lightsOut;
  final int sleepLatencyMin;
  final int awakeningsCount;
  final int wasoMin;
  final DateTime wakeTime;
  final DateTime outOfBedTime;
  final int qualityRating;
  final int moodRating;
  final bool adherentToPrescription;
  final String? notes;
  final DateTime createdAt;
  const SleepDiaryEntry({
    required this.id,
    required this.diaryDate,
    required this.bedtime,
    required this.lightsOut,
    required this.sleepLatencyMin,
    required this.awakeningsCount,
    required this.wasoMin,
    required this.wakeTime,
    required this.outOfBedTime,
    required this.qualityRating,
    required this.moodRating,
    required this.adherentToPrescription,
    this.notes,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['diary_date'] = Variable<DateTime>(diaryDate);
    map['bedtime'] = Variable<DateTime>(bedtime);
    map['lights_out'] = Variable<DateTime>(lightsOut);
    map['sleep_latency_min'] = Variable<int>(sleepLatencyMin);
    map['awakenings_count'] = Variable<int>(awakeningsCount);
    map['waso_min'] = Variable<int>(wasoMin);
    map['wake_time'] = Variable<DateTime>(wakeTime);
    map['out_of_bed_time'] = Variable<DateTime>(outOfBedTime);
    map['quality_rating'] = Variable<int>(qualityRating);
    map['mood_rating'] = Variable<int>(moodRating);
    map['adherent_to_prescription'] = Variable<bool>(adherentToPrescription);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  SleepDiaryEntriesCompanion toCompanion(bool nullToAbsent) {
    return SleepDiaryEntriesCompanion(
      id: Value(id),
      diaryDate: Value(diaryDate),
      bedtime: Value(bedtime),
      lightsOut: Value(lightsOut),
      sleepLatencyMin: Value(sleepLatencyMin),
      awakeningsCount: Value(awakeningsCount),
      wasoMin: Value(wasoMin),
      wakeTime: Value(wakeTime),
      outOfBedTime: Value(outOfBedTime),
      qualityRating: Value(qualityRating),
      moodRating: Value(moodRating),
      adherentToPrescription: Value(adherentToPrescription),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      createdAt: Value(createdAt),
    );
  }

  factory SleepDiaryEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SleepDiaryEntry(
      id: serializer.fromJson<int>(json['id']),
      diaryDate: serializer.fromJson<DateTime>(json['diaryDate']),
      bedtime: serializer.fromJson<DateTime>(json['bedtime']),
      lightsOut: serializer.fromJson<DateTime>(json['lightsOut']),
      sleepLatencyMin: serializer.fromJson<int>(json['sleepLatencyMin']),
      awakeningsCount: serializer.fromJson<int>(json['awakeningsCount']),
      wasoMin: serializer.fromJson<int>(json['wasoMin']),
      wakeTime: serializer.fromJson<DateTime>(json['wakeTime']),
      outOfBedTime: serializer.fromJson<DateTime>(json['outOfBedTime']),
      qualityRating: serializer.fromJson<int>(json['qualityRating']),
      moodRating: serializer.fromJson<int>(json['moodRating']),
      adherentToPrescription: serializer.fromJson<bool>(
        json['adherentToPrescription'],
      ),
      notes: serializer.fromJson<String?>(json['notes']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'diaryDate': serializer.toJson<DateTime>(diaryDate),
      'bedtime': serializer.toJson<DateTime>(bedtime),
      'lightsOut': serializer.toJson<DateTime>(lightsOut),
      'sleepLatencyMin': serializer.toJson<int>(sleepLatencyMin),
      'awakeningsCount': serializer.toJson<int>(awakeningsCount),
      'wasoMin': serializer.toJson<int>(wasoMin),
      'wakeTime': serializer.toJson<DateTime>(wakeTime),
      'outOfBedTime': serializer.toJson<DateTime>(outOfBedTime),
      'qualityRating': serializer.toJson<int>(qualityRating),
      'moodRating': serializer.toJson<int>(moodRating),
      'adherentToPrescription': serializer.toJson<bool>(adherentToPrescription),
      'notes': serializer.toJson<String?>(notes),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  SleepDiaryEntry copyWith({
    int? id,
    DateTime? diaryDate,
    DateTime? bedtime,
    DateTime? lightsOut,
    int? sleepLatencyMin,
    int? awakeningsCount,
    int? wasoMin,
    DateTime? wakeTime,
    DateTime? outOfBedTime,
    int? qualityRating,
    int? moodRating,
    bool? adherentToPrescription,
    Value<String?> notes = const Value.absent(),
    DateTime? createdAt,
  }) => SleepDiaryEntry(
    id: id ?? this.id,
    diaryDate: diaryDate ?? this.diaryDate,
    bedtime: bedtime ?? this.bedtime,
    lightsOut: lightsOut ?? this.lightsOut,
    sleepLatencyMin: sleepLatencyMin ?? this.sleepLatencyMin,
    awakeningsCount: awakeningsCount ?? this.awakeningsCount,
    wasoMin: wasoMin ?? this.wasoMin,
    wakeTime: wakeTime ?? this.wakeTime,
    outOfBedTime: outOfBedTime ?? this.outOfBedTime,
    qualityRating: qualityRating ?? this.qualityRating,
    moodRating: moodRating ?? this.moodRating,
    adherentToPrescription:
        adherentToPrescription ?? this.adherentToPrescription,
    notes: notes.present ? notes.value : this.notes,
    createdAt: createdAt ?? this.createdAt,
  );
  SleepDiaryEntry copyWithCompanion(SleepDiaryEntriesCompanion data) {
    return SleepDiaryEntry(
      id: data.id.present ? data.id.value : this.id,
      diaryDate: data.diaryDate.present ? data.diaryDate.value : this.diaryDate,
      bedtime: data.bedtime.present ? data.bedtime.value : this.bedtime,
      lightsOut: data.lightsOut.present ? data.lightsOut.value : this.lightsOut,
      sleepLatencyMin: data.sleepLatencyMin.present
          ? data.sleepLatencyMin.value
          : this.sleepLatencyMin,
      awakeningsCount: data.awakeningsCount.present
          ? data.awakeningsCount.value
          : this.awakeningsCount,
      wasoMin: data.wasoMin.present ? data.wasoMin.value : this.wasoMin,
      wakeTime: data.wakeTime.present ? data.wakeTime.value : this.wakeTime,
      outOfBedTime: data.outOfBedTime.present
          ? data.outOfBedTime.value
          : this.outOfBedTime,
      qualityRating: data.qualityRating.present
          ? data.qualityRating.value
          : this.qualityRating,
      moodRating: data.moodRating.present
          ? data.moodRating.value
          : this.moodRating,
      adherentToPrescription: data.adherentToPrescription.present
          ? data.adherentToPrescription.value
          : this.adherentToPrescription,
      notes: data.notes.present ? data.notes.value : this.notes,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SleepDiaryEntry(')
          ..write('id: $id, ')
          ..write('diaryDate: $diaryDate, ')
          ..write('bedtime: $bedtime, ')
          ..write('lightsOut: $lightsOut, ')
          ..write('sleepLatencyMin: $sleepLatencyMin, ')
          ..write('awakeningsCount: $awakeningsCount, ')
          ..write('wasoMin: $wasoMin, ')
          ..write('wakeTime: $wakeTime, ')
          ..write('outOfBedTime: $outOfBedTime, ')
          ..write('qualityRating: $qualityRating, ')
          ..write('moodRating: $moodRating, ')
          ..write('adherentToPrescription: $adherentToPrescription, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    diaryDate,
    bedtime,
    lightsOut,
    sleepLatencyMin,
    awakeningsCount,
    wasoMin,
    wakeTime,
    outOfBedTime,
    qualityRating,
    moodRating,
    adherentToPrescription,
    notes,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SleepDiaryEntry &&
          other.id == this.id &&
          other.diaryDate == this.diaryDate &&
          other.bedtime == this.bedtime &&
          other.lightsOut == this.lightsOut &&
          other.sleepLatencyMin == this.sleepLatencyMin &&
          other.awakeningsCount == this.awakeningsCount &&
          other.wasoMin == this.wasoMin &&
          other.wakeTime == this.wakeTime &&
          other.outOfBedTime == this.outOfBedTime &&
          other.qualityRating == this.qualityRating &&
          other.moodRating == this.moodRating &&
          other.adherentToPrescription == this.adherentToPrescription &&
          other.notes == this.notes &&
          other.createdAt == this.createdAt);
}

class SleepDiaryEntriesCompanion extends UpdateCompanion<SleepDiaryEntry> {
  final Value<int> id;
  final Value<DateTime> diaryDate;
  final Value<DateTime> bedtime;
  final Value<DateTime> lightsOut;
  final Value<int> sleepLatencyMin;
  final Value<int> awakeningsCount;
  final Value<int> wasoMin;
  final Value<DateTime> wakeTime;
  final Value<DateTime> outOfBedTime;
  final Value<int> qualityRating;
  final Value<int> moodRating;
  final Value<bool> adherentToPrescription;
  final Value<String?> notes;
  final Value<DateTime> createdAt;
  const SleepDiaryEntriesCompanion({
    this.id = const Value.absent(),
    this.diaryDate = const Value.absent(),
    this.bedtime = const Value.absent(),
    this.lightsOut = const Value.absent(),
    this.sleepLatencyMin = const Value.absent(),
    this.awakeningsCount = const Value.absent(),
    this.wasoMin = const Value.absent(),
    this.wakeTime = const Value.absent(),
    this.outOfBedTime = const Value.absent(),
    this.qualityRating = const Value.absent(),
    this.moodRating = const Value.absent(),
    this.adherentToPrescription = const Value.absent(),
    this.notes = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  SleepDiaryEntriesCompanion.insert({
    this.id = const Value.absent(),
    required DateTime diaryDate,
    required DateTime bedtime,
    required DateTime lightsOut,
    this.sleepLatencyMin = const Value.absent(),
    this.awakeningsCount = const Value.absent(),
    this.wasoMin = const Value.absent(),
    required DateTime wakeTime,
    required DateTime outOfBedTime,
    this.qualityRating = const Value.absent(),
    this.moodRating = const Value.absent(),
    this.adherentToPrescription = const Value.absent(),
    this.notes = const Value.absent(),
    this.createdAt = const Value.absent(),
  }) : diaryDate = Value(diaryDate),
       bedtime = Value(bedtime),
       lightsOut = Value(lightsOut),
       wakeTime = Value(wakeTime),
       outOfBedTime = Value(outOfBedTime);
  static Insertable<SleepDiaryEntry> custom({
    Expression<int>? id,
    Expression<DateTime>? diaryDate,
    Expression<DateTime>? bedtime,
    Expression<DateTime>? lightsOut,
    Expression<int>? sleepLatencyMin,
    Expression<int>? awakeningsCount,
    Expression<int>? wasoMin,
    Expression<DateTime>? wakeTime,
    Expression<DateTime>? outOfBedTime,
    Expression<int>? qualityRating,
    Expression<int>? moodRating,
    Expression<bool>? adherentToPrescription,
    Expression<String>? notes,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (diaryDate != null) 'diary_date': diaryDate,
      if (bedtime != null) 'bedtime': bedtime,
      if (lightsOut != null) 'lights_out': lightsOut,
      if (sleepLatencyMin != null) 'sleep_latency_min': sleepLatencyMin,
      if (awakeningsCount != null) 'awakenings_count': awakeningsCount,
      if (wasoMin != null) 'waso_min': wasoMin,
      if (wakeTime != null) 'wake_time': wakeTime,
      if (outOfBedTime != null) 'out_of_bed_time': outOfBedTime,
      if (qualityRating != null) 'quality_rating': qualityRating,
      if (moodRating != null) 'mood_rating': moodRating,
      if (adherentToPrescription != null)
        'adherent_to_prescription': adherentToPrescription,
      if (notes != null) 'notes': notes,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  SleepDiaryEntriesCompanion copyWith({
    Value<int>? id,
    Value<DateTime>? diaryDate,
    Value<DateTime>? bedtime,
    Value<DateTime>? lightsOut,
    Value<int>? sleepLatencyMin,
    Value<int>? awakeningsCount,
    Value<int>? wasoMin,
    Value<DateTime>? wakeTime,
    Value<DateTime>? outOfBedTime,
    Value<int>? qualityRating,
    Value<int>? moodRating,
    Value<bool>? adherentToPrescription,
    Value<String?>? notes,
    Value<DateTime>? createdAt,
  }) {
    return SleepDiaryEntriesCompanion(
      id: id ?? this.id,
      diaryDate: diaryDate ?? this.diaryDate,
      bedtime: bedtime ?? this.bedtime,
      lightsOut: lightsOut ?? this.lightsOut,
      sleepLatencyMin: sleepLatencyMin ?? this.sleepLatencyMin,
      awakeningsCount: awakeningsCount ?? this.awakeningsCount,
      wasoMin: wasoMin ?? this.wasoMin,
      wakeTime: wakeTime ?? this.wakeTime,
      outOfBedTime: outOfBedTime ?? this.outOfBedTime,
      qualityRating: qualityRating ?? this.qualityRating,
      moodRating: moodRating ?? this.moodRating,
      adherentToPrescription:
          adherentToPrescription ?? this.adherentToPrescription,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (diaryDate.present) {
      map['diary_date'] = Variable<DateTime>(diaryDate.value);
    }
    if (bedtime.present) {
      map['bedtime'] = Variable<DateTime>(bedtime.value);
    }
    if (lightsOut.present) {
      map['lights_out'] = Variable<DateTime>(lightsOut.value);
    }
    if (sleepLatencyMin.present) {
      map['sleep_latency_min'] = Variable<int>(sleepLatencyMin.value);
    }
    if (awakeningsCount.present) {
      map['awakenings_count'] = Variable<int>(awakeningsCount.value);
    }
    if (wasoMin.present) {
      map['waso_min'] = Variable<int>(wasoMin.value);
    }
    if (wakeTime.present) {
      map['wake_time'] = Variable<DateTime>(wakeTime.value);
    }
    if (outOfBedTime.present) {
      map['out_of_bed_time'] = Variable<DateTime>(outOfBedTime.value);
    }
    if (qualityRating.present) {
      map['quality_rating'] = Variable<int>(qualityRating.value);
    }
    if (moodRating.present) {
      map['mood_rating'] = Variable<int>(moodRating.value);
    }
    if (adherentToPrescription.present) {
      map['adherent_to_prescription'] = Variable<bool>(
        adherentToPrescription.value,
      );
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SleepDiaryEntriesCompanion(')
          ..write('id: $id, ')
          ..write('diaryDate: $diaryDate, ')
          ..write('bedtime: $bedtime, ')
          ..write('lightsOut: $lightsOut, ')
          ..write('sleepLatencyMin: $sleepLatencyMin, ')
          ..write('awakeningsCount: $awakeningsCount, ')
          ..write('wasoMin: $wasoMin, ')
          ..write('wakeTime: $wakeTime, ')
          ..write('outOfBedTime: $outOfBedTime, ')
          ..write('qualityRating: $qualityRating, ')
          ..write('moodRating: $moodRating, ')
          ..write('adherentToPrescription: $adherentToPrescription, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $UserSchedulesTable extends UserSchedules
    with TableInfo<$UserSchedulesTable, UserSchedule> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UserSchedulesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _fixedWakeMinutesOfDayMeta =
      const VerificationMeta('fixedWakeMinutesOfDay');
  @override
  late final GeneratedColumn<int> fixedWakeMinutesOfDay = GeneratedColumn<int>(
    'fixed_wake_minutes_of_day',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _currentBedtimeMinutesOfDayMeta =
      const VerificationMeta('currentBedtimeMinutesOfDay');
  @override
  late final GeneratedColumn<int> currentBedtimeMinutesOfDay =
      GeneratedColumn<int>(
        'current_bedtime_minutes_of_day',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _currentTibMinutesMeta = const VerificationMeta(
    'currentTibMinutes',
  );
  @override
  late final GeneratedColumn<int> currentTibMinutes = GeneratedColumn<int>(
    'current_tib_minutes',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(450),
  );
  static const VerificationMeta _windDownMinutesMeta = const VerificationMeta(
    'windDownMinutes',
  );
  @override
  late final GeneratedColumn<int> windDownMinutes = GeneratedColumn<int>(
    'wind_down_minutes',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(30),
  );
  static const VerificationMeta _caffeineCutoffOffsetMinMeta =
      const VerificationMeta('caffeineCutoffOffsetMin');
  @override
  late final GeneratedColumn<int> caffeineCutoffOffsetMin =
      GeneratedColumn<int>(
        'caffeine_cutoff_offset_min',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: false,
        defaultValue: const Constant(600),
      );
  static const VerificationMeta _chronotypeScoreMeta = const VerificationMeta(
    'chronotypeScore',
  );
  @override
  late final GeneratedColumn<int> chronotypeScore = GeneratedColumn<int>(
    'chronotype_score',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _chronotypeCategoryMeta =
      const VerificationMeta('chronotypeCategory');
  @override
  late final GeneratedColumn<String> chronotypeCategory =
      GeneratedColumn<String>(
        'chronotype_category',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _insomniaTypesMeta = const VerificationMeta(
    'insomniaTypes',
  );
  @override
  late final GeneratedColumn<String> insomniaTypes = GeneratedColumn<String>(
    'insomnia_types',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _insomniaSeverityMeta = const VerificationMeta(
    'insomniaSeverity',
  );
  @override
  late final GeneratedColumn<int> insomniaSeverity = GeneratedColumn<int>(
    'insomnia_severity',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _notificationsEnabledMeta =
      const VerificationMeta('notificationsEnabled');
  @override
  late final GeneratedColumn<bool> notificationsEnabled = GeneratedColumn<bool>(
    'notifications_enabled',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("notifications_enabled" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    fixedWakeMinutesOfDay,
    currentBedtimeMinutesOfDay,
    currentTibMinutes,
    windDownMinutes,
    caffeineCutoffOffsetMin,
    chronotypeScore,
    chronotypeCategory,
    insomniaTypes,
    insomniaSeverity,
    notificationsEnabled,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'user_schedules';
  @override
  VerificationContext validateIntegrity(
    Insertable<UserSchedule> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('fixed_wake_minutes_of_day')) {
      context.handle(
        _fixedWakeMinutesOfDayMeta,
        fixedWakeMinutesOfDay.isAcceptableOrUnknown(
          data['fixed_wake_minutes_of_day']!,
          _fixedWakeMinutesOfDayMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_fixedWakeMinutesOfDayMeta);
    }
    if (data.containsKey('current_bedtime_minutes_of_day')) {
      context.handle(
        _currentBedtimeMinutesOfDayMeta,
        currentBedtimeMinutesOfDay.isAcceptableOrUnknown(
          data['current_bedtime_minutes_of_day']!,
          _currentBedtimeMinutesOfDayMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_currentBedtimeMinutesOfDayMeta);
    }
    if (data.containsKey('current_tib_minutes')) {
      context.handle(
        _currentTibMinutesMeta,
        currentTibMinutes.isAcceptableOrUnknown(
          data['current_tib_minutes']!,
          _currentTibMinutesMeta,
        ),
      );
    }
    if (data.containsKey('wind_down_minutes')) {
      context.handle(
        _windDownMinutesMeta,
        windDownMinutes.isAcceptableOrUnknown(
          data['wind_down_minutes']!,
          _windDownMinutesMeta,
        ),
      );
    }
    if (data.containsKey('caffeine_cutoff_offset_min')) {
      context.handle(
        _caffeineCutoffOffsetMinMeta,
        caffeineCutoffOffsetMin.isAcceptableOrUnknown(
          data['caffeine_cutoff_offset_min']!,
          _caffeineCutoffOffsetMinMeta,
        ),
      );
    }
    if (data.containsKey('chronotype_score')) {
      context.handle(
        _chronotypeScoreMeta,
        chronotypeScore.isAcceptableOrUnknown(
          data['chronotype_score']!,
          _chronotypeScoreMeta,
        ),
      );
    }
    if (data.containsKey('chronotype_category')) {
      context.handle(
        _chronotypeCategoryMeta,
        chronotypeCategory.isAcceptableOrUnknown(
          data['chronotype_category']!,
          _chronotypeCategoryMeta,
        ),
      );
    }
    if (data.containsKey('insomnia_types')) {
      context.handle(
        _insomniaTypesMeta,
        insomniaTypes.isAcceptableOrUnknown(
          data['insomnia_types']!,
          _insomniaTypesMeta,
        ),
      );
    }
    if (data.containsKey('insomnia_severity')) {
      context.handle(
        _insomniaSeverityMeta,
        insomniaSeverity.isAcceptableOrUnknown(
          data['insomnia_severity']!,
          _insomniaSeverityMeta,
        ),
      );
    }
    if (data.containsKey('notifications_enabled')) {
      context.handle(
        _notificationsEnabledMeta,
        notificationsEnabled.isAcceptableOrUnknown(
          data['notifications_enabled']!,
          _notificationsEnabledMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  UserSchedule map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return UserSchedule(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      fixedWakeMinutesOfDay: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}fixed_wake_minutes_of_day'],
      )!,
      currentBedtimeMinutesOfDay: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}current_bedtime_minutes_of_day'],
      )!,
      currentTibMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}current_tib_minutes'],
      )!,
      windDownMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}wind_down_minutes'],
      )!,
      caffeineCutoffOffsetMin: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}caffeine_cutoff_offset_min'],
      )!,
      chronotypeScore: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}chronotype_score'],
      ),
      chronotypeCategory: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}chronotype_category'],
      ),
      insomniaTypes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}insomnia_types'],
      ),
      insomniaSeverity: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}insomnia_severity'],
      ),
      notificationsEnabled: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}notifications_enabled'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $UserSchedulesTable createAlias(String alias) {
    return $UserSchedulesTable(attachedDatabase, alias);
  }
}

class UserSchedule extends DataClass implements Insertable<UserSchedule> {
  final int id;
  final int fixedWakeMinutesOfDay;
  final int currentBedtimeMinutesOfDay;
  final int currentTibMinutes;
  final int windDownMinutes;
  final int caffeineCutoffOffsetMin;
  final int? chronotypeScore;
  final String? chronotypeCategory;
  final String? insomniaTypes;
  final int? insomniaSeverity;
  final bool notificationsEnabled;
  final DateTime createdAt;
  final DateTime updatedAt;
  const UserSchedule({
    required this.id,
    required this.fixedWakeMinutesOfDay,
    required this.currentBedtimeMinutesOfDay,
    required this.currentTibMinutes,
    required this.windDownMinutes,
    required this.caffeineCutoffOffsetMin,
    this.chronotypeScore,
    this.chronotypeCategory,
    this.insomniaTypes,
    this.insomniaSeverity,
    required this.notificationsEnabled,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['fixed_wake_minutes_of_day'] = Variable<int>(fixedWakeMinutesOfDay);
    map['current_bedtime_minutes_of_day'] = Variable<int>(
      currentBedtimeMinutesOfDay,
    );
    map['current_tib_minutes'] = Variable<int>(currentTibMinutes);
    map['wind_down_minutes'] = Variable<int>(windDownMinutes);
    map['caffeine_cutoff_offset_min'] = Variable<int>(caffeineCutoffOffsetMin);
    if (!nullToAbsent || chronotypeScore != null) {
      map['chronotype_score'] = Variable<int>(chronotypeScore);
    }
    if (!nullToAbsent || chronotypeCategory != null) {
      map['chronotype_category'] = Variable<String>(chronotypeCategory);
    }
    if (!nullToAbsent || insomniaTypes != null) {
      map['insomnia_types'] = Variable<String>(insomniaTypes);
    }
    if (!nullToAbsent || insomniaSeverity != null) {
      map['insomnia_severity'] = Variable<int>(insomniaSeverity);
    }
    map['notifications_enabled'] = Variable<bool>(notificationsEnabled);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  UserSchedulesCompanion toCompanion(bool nullToAbsent) {
    return UserSchedulesCompanion(
      id: Value(id),
      fixedWakeMinutesOfDay: Value(fixedWakeMinutesOfDay),
      currentBedtimeMinutesOfDay: Value(currentBedtimeMinutesOfDay),
      currentTibMinutes: Value(currentTibMinutes),
      windDownMinutes: Value(windDownMinutes),
      caffeineCutoffOffsetMin: Value(caffeineCutoffOffsetMin),
      chronotypeScore: chronotypeScore == null && nullToAbsent
          ? const Value.absent()
          : Value(chronotypeScore),
      chronotypeCategory: chronotypeCategory == null && nullToAbsent
          ? const Value.absent()
          : Value(chronotypeCategory),
      insomniaTypes: insomniaTypes == null && nullToAbsent
          ? const Value.absent()
          : Value(insomniaTypes),
      insomniaSeverity: insomniaSeverity == null && nullToAbsent
          ? const Value.absent()
          : Value(insomniaSeverity),
      notificationsEnabled: Value(notificationsEnabled),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory UserSchedule.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return UserSchedule(
      id: serializer.fromJson<int>(json['id']),
      fixedWakeMinutesOfDay: serializer.fromJson<int>(
        json['fixedWakeMinutesOfDay'],
      ),
      currentBedtimeMinutesOfDay: serializer.fromJson<int>(
        json['currentBedtimeMinutesOfDay'],
      ),
      currentTibMinutes: serializer.fromJson<int>(json['currentTibMinutes']),
      windDownMinutes: serializer.fromJson<int>(json['windDownMinutes']),
      caffeineCutoffOffsetMin: serializer.fromJson<int>(
        json['caffeineCutoffOffsetMin'],
      ),
      chronotypeScore: serializer.fromJson<int?>(json['chronotypeScore']),
      chronotypeCategory: serializer.fromJson<String?>(
        json['chronotypeCategory'],
      ),
      insomniaTypes: serializer.fromJson<String?>(json['insomniaTypes']),
      insomniaSeverity: serializer.fromJson<int?>(json['insomniaSeverity']),
      notificationsEnabled: serializer.fromJson<bool>(
        json['notificationsEnabled'],
      ),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'fixedWakeMinutesOfDay': serializer.toJson<int>(fixedWakeMinutesOfDay),
      'currentBedtimeMinutesOfDay': serializer.toJson<int>(
        currentBedtimeMinutesOfDay,
      ),
      'currentTibMinutes': serializer.toJson<int>(currentTibMinutes),
      'windDownMinutes': serializer.toJson<int>(windDownMinutes),
      'caffeineCutoffOffsetMin': serializer.toJson<int>(
        caffeineCutoffOffsetMin,
      ),
      'chronotypeScore': serializer.toJson<int?>(chronotypeScore),
      'chronotypeCategory': serializer.toJson<String?>(chronotypeCategory),
      'insomniaTypes': serializer.toJson<String?>(insomniaTypes),
      'insomniaSeverity': serializer.toJson<int?>(insomniaSeverity),
      'notificationsEnabled': serializer.toJson<bool>(notificationsEnabled),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  UserSchedule copyWith({
    int? id,
    int? fixedWakeMinutesOfDay,
    int? currentBedtimeMinutesOfDay,
    int? currentTibMinutes,
    int? windDownMinutes,
    int? caffeineCutoffOffsetMin,
    Value<int?> chronotypeScore = const Value.absent(),
    Value<String?> chronotypeCategory = const Value.absent(),
    Value<String?> insomniaTypes = const Value.absent(),
    Value<int?> insomniaSeverity = const Value.absent(),
    bool? notificationsEnabled,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => UserSchedule(
    id: id ?? this.id,
    fixedWakeMinutesOfDay: fixedWakeMinutesOfDay ?? this.fixedWakeMinutesOfDay,
    currentBedtimeMinutesOfDay:
        currentBedtimeMinutesOfDay ?? this.currentBedtimeMinutesOfDay,
    currentTibMinutes: currentTibMinutes ?? this.currentTibMinutes,
    windDownMinutes: windDownMinutes ?? this.windDownMinutes,
    caffeineCutoffOffsetMin:
        caffeineCutoffOffsetMin ?? this.caffeineCutoffOffsetMin,
    chronotypeScore: chronotypeScore.present
        ? chronotypeScore.value
        : this.chronotypeScore,
    chronotypeCategory: chronotypeCategory.present
        ? chronotypeCategory.value
        : this.chronotypeCategory,
    insomniaTypes: insomniaTypes.present
        ? insomniaTypes.value
        : this.insomniaTypes,
    insomniaSeverity: insomniaSeverity.present
        ? insomniaSeverity.value
        : this.insomniaSeverity,
    notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  UserSchedule copyWithCompanion(UserSchedulesCompanion data) {
    return UserSchedule(
      id: data.id.present ? data.id.value : this.id,
      fixedWakeMinutesOfDay: data.fixedWakeMinutesOfDay.present
          ? data.fixedWakeMinutesOfDay.value
          : this.fixedWakeMinutesOfDay,
      currentBedtimeMinutesOfDay: data.currentBedtimeMinutesOfDay.present
          ? data.currentBedtimeMinutesOfDay.value
          : this.currentBedtimeMinutesOfDay,
      currentTibMinutes: data.currentTibMinutes.present
          ? data.currentTibMinutes.value
          : this.currentTibMinutes,
      windDownMinutes: data.windDownMinutes.present
          ? data.windDownMinutes.value
          : this.windDownMinutes,
      caffeineCutoffOffsetMin: data.caffeineCutoffOffsetMin.present
          ? data.caffeineCutoffOffsetMin.value
          : this.caffeineCutoffOffsetMin,
      chronotypeScore: data.chronotypeScore.present
          ? data.chronotypeScore.value
          : this.chronotypeScore,
      chronotypeCategory: data.chronotypeCategory.present
          ? data.chronotypeCategory.value
          : this.chronotypeCategory,
      insomniaTypes: data.insomniaTypes.present
          ? data.insomniaTypes.value
          : this.insomniaTypes,
      insomniaSeverity: data.insomniaSeverity.present
          ? data.insomniaSeverity.value
          : this.insomniaSeverity,
      notificationsEnabled: data.notificationsEnabled.present
          ? data.notificationsEnabled.value
          : this.notificationsEnabled,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('UserSchedule(')
          ..write('id: $id, ')
          ..write('fixedWakeMinutesOfDay: $fixedWakeMinutesOfDay, ')
          ..write('currentBedtimeMinutesOfDay: $currentBedtimeMinutesOfDay, ')
          ..write('currentTibMinutes: $currentTibMinutes, ')
          ..write('windDownMinutes: $windDownMinutes, ')
          ..write('caffeineCutoffOffsetMin: $caffeineCutoffOffsetMin, ')
          ..write('chronotypeScore: $chronotypeScore, ')
          ..write('chronotypeCategory: $chronotypeCategory, ')
          ..write('insomniaTypes: $insomniaTypes, ')
          ..write('insomniaSeverity: $insomniaSeverity, ')
          ..write('notificationsEnabled: $notificationsEnabled, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    fixedWakeMinutesOfDay,
    currentBedtimeMinutesOfDay,
    currentTibMinutes,
    windDownMinutes,
    caffeineCutoffOffsetMin,
    chronotypeScore,
    chronotypeCategory,
    insomniaTypes,
    insomniaSeverity,
    notificationsEnabled,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UserSchedule &&
          other.id == this.id &&
          other.fixedWakeMinutesOfDay == this.fixedWakeMinutesOfDay &&
          other.currentBedtimeMinutesOfDay == this.currentBedtimeMinutesOfDay &&
          other.currentTibMinutes == this.currentTibMinutes &&
          other.windDownMinutes == this.windDownMinutes &&
          other.caffeineCutoffOffsetMin == this.caffeineCutoffOffsetMin &&
          other.chronotypeScore == this.chronotypeScore &&
          other.chronotypeCategory == this.chronotypeCategory &&
          other.insomniaTypes == this.insomniaTypes &&
          other.insomniaSeverity == this.insomniaSeverity &&
          other.notificationsEnabled == this.notificationsEnabled &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class UserSchedulesCompanion extends UpdateCompanion<UserSchedule> {
  final Value<int> id;
  final Value<int> fixedWakeMinutesOfDay;
  final Value<int> currentBedtimeMinutesOfDay;
  final Value<int> currentTibMinutes;
  final Value<int> windDownMinutes;
  final Value<int> caffeineCutoffOffsetMin;
  final Value<int?> chronotypeScore;
  final Value<String?> chronotypeCategory;
  final Value<String?> insomniaTypes;
  final Value<int?> insomniaSeverity;
  final Value<bool> notificationsEnabled;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const UserSchedulesCompanion({
    this.id = const Value.absent(),
    this.fixedWakeMinutesOfDay = const Value.absent(),
    this.currentBedtimeMinutesOfDay = const Value.absent(),
    this.currentTibMinutes = const Value.absent(),
    this.windDownMinutes = const Value.absent(),
    this.caffeineCutoffOffsetMin = const Value.absent(),
    this.chronotypeScore = const Value.absent(),
    this.chronotypeCategory = const Value.absent(),
    this.insomniaTypes = const Value.absent(),
    this.insomniaSeverity = const Value.absent(),
    this.notificationsEnabled = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  UserSchedulesCompanion.insert({
    this.id = const Value.absent(),
    required int fixedWakeMinutesOfDay,
    required int currentBedtimeMinutesOfDay,
    this.currentTibMinutes = const Value.absent(),
    this.windDownMinutes = const Value.absent(),
    this.caffeineCutoffOffsetMin = const Value.absent(),
    this.chronotypeScore = const Value.absent(),
    this.chronotypeCategory = const Value.absent(),
    this.insomniaTypes = const Value.absent(),
    this.insomniaSeverity = const Value.absent(),
    this.notificationsEnabled = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  }) : fixedWakeMinutesOfDay = Value(fixedWakeMinutesOfDay),
       currentBedtimeMinutesOfDay = Value(currentBedtimeMinutesOfDay);
  static Insertable<UserSchedule> custom({
    Expression<int>? id,
    Expression<int>? fixedWakeMinutesOfDay,
    Expression<int>? currentBedtimeMinutesOfDay,
    Expression<int>? currentTibMinutes,
    Expression<int>? windDownMinutes,
    Expression<int>? caffeineCutoffOffsetMin,
    Expression<int>? chronotypeScore,
    Expression<String>? chronotypeCategory,
    Expression<String>? insomniaTypes,
    Expression<int>? insomniaSeverity,
    Expression<bool>? notificationsEnabled,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (fixedWakeMinutesOfDay != null)
        'fixed_wake_minutes_of_day': fixedWakeMinutesOfDay,
      if (currentBedtimeMinutesOfDay != null)
        'current_bedtime_minutes_of_day': currentBedtimeMinutesOfDay,
      if (currentTibMinutes != null) 'current_tib_minutes': currentTibMinutes,
      if (windDownMinutes != null) 'wind_down_minutes': windDownMinutes,
      if (caffeineCutoffOffsetMin != null)
        'caffeine_cutoff_offset_min': caffeineCutoffOffsetMin,
      if (chronotypeScore != null) 'chronotype_score': chronotypeScore,
      if (chronotypeCategory != null) 'chronotype_category': chronotypeCategory,
      if (insomniaTypes != null) 'insomnia_types': insomniaTypes,
      if (insomniaSeverity != null) 'insomnia_severity': insomniaSeverity,
      if (notificationsEnabled != null)
        'notifications_enabled': notificationsEnabled,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  UserSchedulesCompanion copyWith({
    Value<int>? id,
    Value<int>? fixedWakeMinutesOfDay,
    Value<int>? currentBedtimeMinutesOfDay,
    Value<int>? currentTibMinutes,
    Value<int>? windDownMinutes,
    Value<int>? caffeineCutoffOffsetMin,
    Value<int?>? chronotypeScore,
    Value<String?>? chronotypeCategory,
    Value<String?>? insomniaTypes,
    Value<int?>? insomniaSeverity,
    Value<bool>? notificationsEnabled,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
  }) {
    return UserSchedulesCompanion(
      id: id ?? this.id,
      fixedWakeMinutesOfDay:
          fixedWakeMinutesOfDay ?? this.fixedWakeMinutesOfDay,
      currentBedtimeMinutesOfDay:
          currentBedtimeMinutesOfDay ?? this.currentBedtimeMinutesOfDay,
      currentTibMinutes: currentTibMinutes ?? this.currentTibMinutes,
      windDownMinutes: windDownMinutes ?? this.windDownMinutes,
      caffeineCutoffOffsetMin:
          caffeineCutoffOffsetMin ?? this.caffeineCutoffOffsetMin,
      chronotypeScore: chronotypeScore ?? this.chronotypeScore,
      chronotypeCategory: chronotypeCategory ?? this.chronotypeCategory,
      insomniaTypes: insomniaTypes ?? this.insomniaTypes,
      insomniaSeverity: insomniaSeverity ?? this.insomniaSeverity,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (fixedWakeMinutesOfDay.present) {
      map['fixed_wake_minutes_of_day'] = Variable<int>(
        fixedWakeMinutesOfDay.value,
      );
    }
    if (currentBedtimeMinutesOfDay.present) {
      map['current_bedtime_minutes_of_day'] = Variable<int>(
        currentBedtimeMinutesOfDay.value,
      );
    }
    if (currentTibMinutes.present) {
      map['current_tib_minutes'] = Variable<int>(currentTibMinutes.value);
    }
    if (windDownMinutes.present) {
      map['wind_down_minutes'] = Variable<int>(windDownMinutes.value);
    }
    if (caffeineCutoffOffsetMin.present) {
      map['caffeine_cutoff_offset_min'] = Variable<int>(
        caffeineCutoffOffsetMin.value,
      );
    }
    if (chronotypeScore.present) {
      map['chronotype_score'] = Variable<int>(chronotypeScore.value);
    }
    if (chronotypeCategory.present) {
      map['chronotype_category'] = Variable<String>(chronotypeCategory.value);
    }
    if (insomniaTypes.present) {
      map['insomnia_types'] = Variable<String>(insomniaTypes.value);
    }
    if (insomniaSeverity.present) {
      map['insomnia_severity'] = Variable<int>(insomniaSeverity.value);
    }
    if (notificationsEnabled.present) {
      map['notifications_enabled'] = Variable<bool>(notificationsEnabled.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UserSchedulesCompanion(')
          ..write('id: $id, ')
          ..write('fixedWakeMinutesOfDay: $fixedWakeMinutesOfDay, ')
          ..write('currentBedtimeMinutesOfDay: $currentBedtimeMinutesOfDay, ')
          ..write('currentTibMinutes: $currentTibMinutes, ')
          ..write('windDownMinutes: $windDownMinutes, ')
          ..write('caffeineCutoffOffsetMin: $caffeineCutoffOffsetMin, ')
          ..write('chronotypeScore: $chronotypeScore, ')
          ..write('chronotypeCategory: $chronotypeCategory, ')
          ..write('insomniaTypes: $insomniaTypes, ')
          ..write('insomniaSeverity: $insomniaSeverity, ')
          ..write('notificationsEnabled: $notificationsEnabled, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $CbtiWeeksTable extends CbtiWeeks
    with TableInfo<$CbtiWeeksTable, CbtiWeek> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CbtiWeeksTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _weekIndexMeta = const VerificationMeta(
    'weekIndex',
  );
  @override
  late final GeneratedColumn<int> weekIndex = GeneratedColumn<int>(
    'week_index',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _phaseIdMeta = const VerificationMeta(
    'phaseId',
  );
  @override
  late final GeneratedColumn<String> phaseId = GeneratedColumn<String>(
    'phase_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _startedOnMeta = const VerificationMeta(
    'startedOn',
  );
  @override
  late final GeneratedColumn<DateTime> startedOn = GeneratedColumn<DateTime>(
    'started_on',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _prescribedBedtimeMinutesOfDayMeta =
      const VerificationMeta('prescribedBedtimeMinutesOfDay');
  @override
  late final GeneratedColumn<int> prescribedBedtimeMinutesOfDay =
      GeneratedColumn<int>(
        'prescribed_bedtime_minutes_of_day',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _prescribedWakeMinutesOfDayMeta =
      const VerificationMeta('prescribedWakeMinutesOfDay');
  @override
  late final GeneratedColumn<int> prescribedWakeMinutesOfDay =
      GeneratedColumn<int>(
        'prescribed_wake_minutes_of_day',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _tibMinutesMeta = const VerificationMeta(
    'tibMinutes',
  );
  @override
  late final GeneratedColumn<int> tibMinutes = GeneratedColumn<int>(
    'tib_minutes',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _efficiencyTargetMeta = const VerificationMeta(
    'efficiencyTarget',
  );
  @override
  late final GeneratedColumn<double> efficiencyTarget = GeneratedColumn<double>(
    'efficiency_target',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0.85),
  );
  static const VerificationMeta _rationaleMeta = const VerificationMeta(
    'rationale',
  );
  @override
  late final GeneratedColumn<String> rationale = GeneratedColumn<String>(
    'rationale',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _actionMeta = const VerificationMeta('action');
  @override
  late final GeneratedColumn<String> action = GeneratedColumn<String>(
    'action',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('active'),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    weekIndex,
    phaseId,
    startedOn,
    prescribedBedtimeMinutesOfDay,
    prescribedWakeMinutesOfDay,
    tibMinutes,
    efficiencyTarget,
    rationale,
    action,
    status,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'cbti_weeks';
  @override
  VerificationContext validateIntegrity(
    Insertable<CbtiWeek> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('week_index')) {
      context.handle(
        _weekIndexMeta,
        weekIndex.isAcceptableOrUnknown(data['week_index']!, _weekIndexMeta),
      );
    } else if (isInserting) {
      context.missing(_weekIndexMeta);
    }
    if (data.containsKey('phase_id')) {
      context.handle(
        _phaseIdMeta,
        phaseId.isAcceptableOrUnknown(data['phase_id']!, _phaseIdMeta),
      );
    } else if (isInserting) {
      context.missing(_phaseIdMeta);
    }
    if (data.containsKey('started_on')) {
      context.handle(
        _startedOnMeta,
        startedOn.isAcceptableOrUnknown(data['started_on']!, _startedOnMeta),
      );
    } else if (isInserting) {
      context.missing(_startedOnMeta);
    }
    if (data.containsKey('prescribed_bedtime_minutes_of_day')) {
      context.handle(
        _prescribedBedtimeMinutesOfDayMeta,
        prescribedBedtimeMinutesOfDay.isAcceptableOrUnknown(
          data['prescribed_bedtime_minutes_of_day']!,
          _prescribedBedtimeMinutesOfDayMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_prescribedBedtimeMinutesOfDayMeta);
    }
    if (data.containsKey('prescribed_wake_minutes_of_day')) {
      context.handle(
        _prescribedWakeMinutesOfDayMeta,
        prescribedWakeMinutesOfDay.isAcceptableOrUnknown(
          data['prescribed_wake_minutes_of_day']!,
          _prescribedWakeMinutesOfDayMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_prescribedWakeMinutesOfDayMeta);
    }
    if (data.containsKey('tib_minutes')) {
      context.handle(
        _tibMinutesMeta,
        tibMinutes.isAcceptableOrUnknown(data['tib_minutes']!, _tibMinutesMeta),
      );
    } else if (isInserting) {
      context.missing(_tibMinutesMeta);
    }
    if (data.containsKey('efficiency_target')) {
      context.handle(
        _efficiencyTargetMeta,
        efficiencyTarget.isAcceptableOrUnknown(
          data['efficiency_target']!,
          _efficiencyTargetMeta,
        ),
      );
    }
    if (data.containsKey('rationale')) {
      context.handle(
        _rationaleMeta,
        rationale.isAcceptableOrUnknown(data['rationale']!, _rationaleMeta),
      );
    } else if (isInserting) {
      context.missing(_rationaleMeta);
    }
    if (data.containsKey('action')) {
      context.handle(
        _actionMeta,
        action.isAcceptableOrUnknown(data['action']!, _actionMeta),
      );
    } else if (isInserting) {
      context.missing(_actionMeta);
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CbtiWeek map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CbtiWeek(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      weekIndex: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}week_index'],
      )!,
      phaseId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}phase_id'],
      )!,
      startedOn: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}started_on'],
      )!,
      prescribedBedtimeMinutesOfDay: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}prescribed_bedtime_minutes_of_day'],
      )!,
      prescribedWakeMinutesOfDay: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}prescribed_wake_minutes_of_day'],
      )!,
      tibMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}tib_minutes'],
      )!,
      efficiencyTarget: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}efficiency_target'],
      )!,
      rationale: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}rationale'],
      )!,
      action: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}action'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $CbtiWeeksTable createAlias(String alias) {
    return $CbtiWeeksTable(attachedDatabase, alias);
  }
}

class CbtiWeek extends DataClass implements Insertable<CbtiWeek> {
  final int id;
  final int weekIndex;
  final String phaseId;
  final DateTime startedOn;
  final int prescribedBedtimeMinutesOfDay;
  final int prescribedWakeMinutesOfDay;
  final int tibMinutes;
  final double efficiencyTarget;
  final String rationale;
  final String action;
  final String status;
  final DateTime createdAt;
  const CbtiWeek({
    required this.id,
    required this.weekIndex,
    required this.phaseId,
    required this.startedOn,
    required this.prescribedBedtimeMinutesOfDay,
    required this.prescribedWakeMinutesOfDay,
    required this.tibMinutes,
    required this.efficiencyTarget,
    required this.rationale,
    required this.action,
    required this.status,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['week_index'] = Variable<int>(weekIndex);
    map['phase_id'] = Variable<String>(phaseId);
    map['started_on'] = Variable<DateTime>(startedOn);
    map['prescribed_bedtime_minutes_of_day'] = Variable<int>(
      prescribedBedtimeMinutesOfDay,
    );
    map['prescribed_wake_minutes_of_day'] = Variable<int>(
      prescribedWakeMinutesOfDay,
    );
    map['tib_minutes'] = Variable<int>(tibMinutes);
    map['efficiency_target'] = Variable<double>(efficiencyTarget);
    map['rationale'] = Variable<String>(rationale);
    map['action'] = Variable<String>(action);
    map['status'] = Variable<String>(status);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  CbtiWeeksCompanion toCompanion(bool nullToAbsent) {
    return CbtiWeeksCompanion(
      id: Value(id),
      weekIndex: Value(weekIndex),
      phaseId: Value(phaseId),
      startedOn: Value(startedOn),
      prescribedBedtimeMinutesOfDay: Value(prescribedBedtimeMinutesOfDay),
      prescribedWakeMinutesOfDay: Value(prescribedWakeMinutesOfDay),
      tibMinutes: Value(tibMinutes),
      efficiencyTarget: Value(efficiencyTarget),
      rationale: Value(rationale),
      action: Value(action),
      status: Value(status),
      createdAt: Value(createdAt),
    );
  }

  factory CbtiWeek.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CbtiWeek(
      id: serializer.fromJson<int>(json['id']),
      weekIndex: serializer.fromJson<int>(json['weekIndex']),
      phaseId: serializer.fromJson<String>(json['phaseId']),
      startedOn: serializer.fromJson<DateTime>(json['startedOn']),
      prescribedBedtimeMinutesOfDay: serializer.fromJson<int>(
        json['prescribedBedtimeMinutesOfDay'],
      ),
      prescribedWakeMinutesOfDay: serializer.fromJson<int>(
        json['prescribedWakeMinutesOfDay'],
      ),
      tibMinutes: serializer.fromJson<int>(json['tibMinutes']),
      efficiencyTarget: serializer.fromJson<double>(json['efficiencyTarget']),
      rationale: serializer.fromJson<String>(json['rationale']),
      action: serializer.fromJson<String>(json['action']),
      status: serializer.fromJson<String>(json['status']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'weekIndex': serializer.toJson<int>(weekIndex),
      'phaseId': serializer.toJson<String>(phaseId),
      'startedOn': serializer.toJson<DateTime>(startedOn),
      'prescribedBedtimeMinutesOfDay': serializer.toJson<int>(
        prescribedBedtimeMinutesOfDay,
      ),
      'prescribedWakeMinutesOfDay': serializer.toJson<int>(
        prescribedWakeMinutesOfDay,
      ),
      'tibMinutes': serializer.toJson<int>(tibMinutes),
      'efficiencyTarget': serializer.toJson<double>(efficiencyTarget),
      'rationale': serializer.toJson<String>(rationale),
      'action': serializer.toJson<String>(action),
      'status': serializer.toJson<String>(status),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  CbtiWeek copyWith({
    int? id,
    int? weekIndex,
    String? phaseId,
    DateTime? startedOn,
    int? prescribedBedtimeMinutesOfDay,
    int? prescribedWakeMinutesOfDay,
    int? tibMinutes,
    double? efficiencyTarget,
    String? rationale,
    String? action,
    String? status,
    DateTime? createdAt,
  }) => CbtiWeek(
    id: id ?? this.id,
    weekIndex: weekIndex ?? this.weekIndex,
    phaseId: phaseId ?? this.phaseId,
    startedOn: startedOn ?? this.startedOn,
    prescribedBedtimeMinutesOfDay:
        prescribedBedtimeMinutesOfDay ?? this.prescribedBedtimeMinutesOfDay,
    prescribedWakeMinutesOfDay:
        prescribedWakeMinutesOfDay ?? this.prescribedWakeMinutesOfDay,
    tibMinutes: tibMinutes ?? this.tibMinutes,
    efficiencyTarget: efficiencyTarget ?? this.efficiencyTarget,
    rationale: rationale ?? this.rationale,
    action: action ?? this.action,
    status: status ?? this.status,
    createdAt: createdAt ?? this.createdAt,
  );
  CbtiWeek copyWithCompanion(CbtiWeeksCompanion data) {
    return CbtiWeek(
      id: data.id.present ? data.id.value : this.id,
      weekIndex: data.weekIndex.present ? data.weekIndex.value : this.weekIndex,
      phaseId: data.phaseId.present ? data.phaseId.value : this.phaseId,
      startedOn: data.startedOn.present ? data.startedOn.value : this.startedOn,
      prescribedBedtimeMinutesOfDay: data.prescribedBedtimeMinutesOfDay.present
          ? data.prescribedBedtimeMinutesOfDay.value
          : this.prescribedBedtimeMinutesOfDay,
      prescribedWakeMinutesOfDay: data.prescribedWakeMinutesOfDay.present
          ? data.prescribedWakeMinutesOfDay.value
          : this.prescribedWakeMinutesOfDay,
      tibMinutes: data.tibMinutes.present
          ? data.tibMinutes.value
          : this.tibMinutes,
      efficiencyTarget: data.efficiencyTarget.present
          ? data.efficiencyTarget.value
          : this.efficiencyTarget,
      rationale: data.rationale.present ? data.rationale.value : this.rationale,
      action: data.action.present ? data.action.value : this.action,
      status: data.status.present ? data.status.value : this.status,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CbtiWeek(')
          ..write('id: $id, ')
          ..write('weekIndex: $weekIndex, ')
          ..write('phaseId: $phaseId, ')
          ..write('startedOn: $startedOn, ')
          ..write(
            'prescribedBedtimeMinutesOfDay: $prescribedBedtimeMinutesOfDay, ',
          )
          ..write('prescribedWakeMinutesOfDay: $prescribedWakeMinutesOfDay, ')
          ..write('tibMinutes: $tibMinutes, ')
          ..write('efficiencyTarget: $efficiencyTarget, ')
          ..write('rationale: $rationale, ')
          ..write('action: $action, ')
          ..write('status: $status, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    weekIndex,
    phaseId,
    startedOn,
    prescribedBedtimeMinutesOfDay,
    prescribedWakeMinutesOfDay,
    tibMinutes,
    efficiencyTarget,
    rationale,
    action,
    status,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CbtiWeek &&
          other.id == this.id &&
          other.weekIndex == this.weekIndex &&
          other.phaseId == this.phaseId &&
          other.startedOn == this.startedOn &&
          other.prescribedBedtimeMinutesOfDay ==
              this.prescribedBedtimeMinutesOfDay &&
          other.prescribedWakeMinutesOfDay == this.prescribedWakeMinutesOfDay &&
          other.tibMinutes == this.tibMinutes &&
          other.efficiencyTarget == this.efficiencyTarget &&
          other.rationale == this.rationale &&
          other.action == this.action &&
          other.status == this.status &&
          other.createdAt == this.createdAt);
}

class CbtiWeeksCompanion extends UpdateCompanion<CbtiWeek> {
  final Value<int> id;
  final Value<int> weekIndex;
  final Value<String> phaseId;
  final Value<DateTime> startedOn;
  final Value<int> prescribedBedtimeMinutesOfDay;
  final Value<int> prescribedWakeMinutesOfDay;
  final Value<int> tibMinutes;
  final Value<double> efficiencyTarget;
  final Value<String> rationale;
  final Value<String> action;
  final Value<String> status;
  final Value<DateTime> createdAt;
  const CbtiWeeksCompanion({
    this.id = const Value.absent(),
    this.weekIndex = const Value.absent(),
    this.phaseId = const Value.absent(),
    this.startedOn = const Value.absent(),
    this.prescribedBedtimeMinutesOfDay = const Value.absent(),
    this.prescribedWakeMinutesOfDay = const Value.absent(),
    this.tibMinutes = const Value.absent(),
    this.efficiencyTarget = const Value.absent(),
    this.rationale = const Value.absent(),
    this.action = const Value.absent(),
    this.status = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  CbtiWeeksCompanion.insert({
    this.id = const Value.absent(),
    required int weekIndex,
    required String phaseId,
    required DateTime startedOn,
    required int prescribedBedtimeMinutesOfDay,
    required int prescribedWakeMinutesOfDay,
    required int tibMinutes,
    this.efficiencyTarget = const Value.absent(),
    required String rationale,
    required String action,
    this.status = const Value.absent(),
    this.createdAt = const Value.absent(),
  }) : weekIndex = Value(weekIndex),
       phaseId = Value(phaseId),
       startedOn = Value(startedOn),
       prescribedBedtimeMinutesOfDay = Value(prescribedBedtimeMinutesOfDay),
       prescribedWakeMinutesOfDay = Value(prescribedWakeMinutesOfDay),
       tibMinutes = Value(tibMinutes),
       rationale = Value(rationale),
       action = Value(action);
  static Insertable<CbtiWeek> custom({
    Expression<int>? id,
    Expression<int>? weekIndex,
    Expression<String>? phaseId,
    Expression<DateTime>? startedOn,
    Expression<int>? prescribedBedtimeMinutesOfDay,
    Expression<int>? prescribedWakeMinutesOfDay,
    Expression<int>? tibMinutes,
    Expression<double>? efficiencyTarget,
    Expression<String>? rationale,
    Expression<String>? action,
    Expression<String>? status,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (weekIndex != null) 'week_index': weekIndex,
      if (phaseId != null) 'phase_id': phaseId,
      if (startedOn != null) 'started_on': startedOn,
      if (prescribedBedtimeMinutesOfDay != null)
        'prescribed_bedtime_minutes_of_day': prescribedBedtimeMinutesOfDay,
      if (prescribedWakeMinutesOfDay != null)
        'prescribed_wake_minutes_of_day': prescribedWakeMinutesOfDay,
      if (tibMinutes != null) 'tib_minutes': tibMinutes,
      if (efficiencyTarget != null) 'efficiency_target': efficiencyTarget,
      if (rationale != null) 'rationale': rationale,
      if (action != null) 'action': action,
      if (status != null) 'status': status,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  CbtiWeeksCompanion copyWith({
    Value<int>? id,
    Value<int>? weekIndex,
    Value<String>? phaseId,
    Value<DateTime>? startedOn,
    Value<int>? prescribedBedtimeMinutesOfDay,
    Value<int>? prescribedWakeMinutesOfDay,
    Value<int>? tibMinutes,
    Value<double>? efficiencyTarget,
    Value<String>? rationale,
    Value<String>? action,
    Value<String>? status,
    Value<DateTime>? createdAt,
  }) {
    return CbtiWeeksCompanion(
      id: id ?? this.id,
      weekIndex: weekIndex ?? this.weekIndex,
      phaseId: phaseId ?? this.phaseId,
      startedOn: startedOn ?? this.startedOn,
      prescribedBedtimeMinutesOfDay:
          prescribedBedtimeMinutesOfDay ?? this.prescribedBedtimeMinutesOfDay,
      prescribedWakeMinutesOfDay:
          prescribedWakeMinutesOfDay ?? this.prescribedWakeMinutesOfDay,
      tibMinutes: tibMinutes ?? this.tibMinutes,
      efficiencyTarget: efficiencyTarget ?? this.efficiencyTarget,
      rationale: rationale ?? this.rationale,
      action: action ?? this.action,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (weekIndex.present) {
      map['week_index'] = Variable<int>(weekIndex.value);
    }
    if (phaseId.present) {
      map['phase_id'] = Variable<String>(phaseId.value);
    }
    if (startedOn.present) {
      map['started_on'] = Variable<DateTime>(startedOn.value);
    }
    if (prescribedBedtimeMinutesOfDay.present) {
      map['prescribed_bedtime_minutes_of_day'] = Variable<int>(
        prescribedBedtimeMinutesOfDay.value,
      );
    }
    if (prescribedWakeMinutesOfDay.present) {
      map['prescribed_wake_minutes_of_day'] = Variable<int>(
        prescribedWakeMinutesOfDay.value,
      );
    }
    if (tibMinutes.present) {
      map['tib_minutes'] = Variable<int>(tibMinutes.value);
    }
    if (efficiencyTarget.present) {
      map['efficiency_target'] = Variable<double>(efficiencyTarget.value);
    }
    if (rationale.present) {
      map['rationale'] = Variable<String>(rationale.value);
    }
    if (action.present) {
      map['action'] = Variable<String>(action.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CbtiWeeksCompanion(')
          ..write('id: $id, ')
          ..write('weekIndex: $weekIndex, ')
          ..write('phaseId: $phaseId, ')
          ..write('startedOn: $startedOn, ')
          ..write(
            'prescribedBedtimeMinutesOfDay: $prescribedBedtimeMinutesOfDay, ',
          )
          ..write('prescribedWakeMinutesOfDay: $prescribedWakeMinutesOfDay, ')
          ..write('tibMinutes: $tibMinutes, ')
          ..write('efficiencyTarget: $efficiencyTarget, ')
          ..write('rationale: $rationale, ')
          ..write('action: $action, ')
          ..write('status: $status, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $CaffeineLogsTable extends CaffeineLogs
    with TableInfo<$CaffeineLogsTable, CaffeineLog> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CaffeineLogsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _consumedAtMeta = const VerificationMeta(
    'consumedAt',
  );
  @override
  late final GeneratedColumn<DateTime> consumedAt = GeneratedColumn<DateTime>(
    'consumed_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _mgMeta = const VerificationMeta('mg');
  @override
  late final GeneratedColumn<int> mg = GeneratedColumn<int>(
    'mg',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sourceMeta = const VerificationMeta('source');
  @override
  late final GeneratedColumn<String> source = GeneratedColumn<String>(
    'source',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [id, consumedAt, mg, source, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'caffeine_logs';
  @override
  VerificationContext validateIntegrity(
    Insertable<CaffeineLog> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('consumed_at')) {
      context.handle(
        _consumedAtMeta,
        consumedAt.isAcceptableOrUnknown(data['consumed_at']!, _consumedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_consumedAtMeta);
    }
    if (data.containsKey('mg')) {
      context.handle(_mgMeta, mg.isAcceptableOrUnknown(data['mg']!, _mgMeta));
    } else if (isInserting) {
      context.missing(_mgMeta);
    }
    if (data.containsKey('source')) {
      context.handle(
        _sourceMeta,
        source.isAcceptableOrUnknown(data['source']!, _sourceMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CaffeineLog map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CaffeineLog(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      consumedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}consumed_at'],
      )!,
      mg: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}mg'],
      )!,
      source: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $CaffeineLogsTable createAlias(String alias) {
    return $CaffeineLogsTable(attachedDatabase, alias);
  }
}

class CaffeineLog extends DataClass implements Insertable<CaffeineLog> {
  final int id;
  final DateTime consumedAt;
  final int mg;
  final String? source;
  final DateTime createdAt;
  const CaffeineLog({
    required this.id,
    required this.consumedAt,
    required this.mg,
    this.source,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['consumed_at'] = Variable<DateTime>(consumedAt);
    map['mg'] = Variable<int>(mg);
    if (!nullToAbsent || source != null) {
      map['source'] = Variable<String>(source);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  CaffeineLogsCompanion toCompanion(bool nullToAbsent) {
    return CaffeineLogsCompanion(
      id: Value(id),
      consumedAt: Value(consumedAt),
      mg: Value(mg),
      source: source == null && nullToAbsent
          ? const Value.absent()
          : Value(source),
      createdAt: Value(createdAt),
    );
  }

  factory CaffeineLog.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CaffeineLog(
      id: serializer.fromJson<int>(json['id']),
      consumedAt: serializer.fromJson<DateTime>(json['consumedAt']),
      mg: serializer.fromJson<int>(json['mg']),
      source: serializer.fromJson<String?>(json['source']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'consumedAt': serializer.toJson<DateTime>(consumedAt),
      'mg': serializer.toJson<int>(mg),
      'source': serializer.toJson<String?>(source),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  CaffeineLog copyWith({
    int? id,
    DateTime? consumedAt,
    int? mg,
    Value<String?> source = const Value.absent(),
    DateTime? createdAt,
  }) => CaffeineLog(
    id: id ?? this.id,
    consumedAt: consumedAt ?? this.consumedAt,
    mg: mg ?? this.mg,
    source: source.present ? source.value : this.source,
    createdAt: createdAt ?? this.createdAt,
  );
  CaffeineLog copyWithCompanion(CaffeineLogsCompanion data) {
    return CaffeineLog(
      id: data.id.present ? data.id.value : this.id,
      consumedAt: data.consumedAt.present
          ? data.consumedAt.value
          : this.consumedAt,
      mg: data.mg.present ? data.mg.value : this.mg,
      source: data.source.present ? data.source.value : this.source,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CaffeineLog(')
          ..write('id: $id, ')
          ..write('consumedAt: $consumedAt, ')
          ..write('mg: $mg, ')
          ..write('source: $source, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, consumedAt, mg, source, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CaffeineLog &&
          other.id == this.id &&
          other.consumedAt == this.consumedAt &&
          other.mg == this.mg &&
          other.source == this.source &&
          other.createdAt == this.createdAt);
}

class CaffeineLogsCompanion extends UpdateCompanion<CaffeineLog> {
  final Value<int> id;
  final Value<DateTime> consumedAt;
  final Value<int> mg;
  final Value<String?> source;
  final Value<DateTime> createdAt;
  const CaffeineLogsCompanion({
    this.id = const Value.absent(),
    this.consumedAt = const Value.absent(),
    this.mg = const Value.absent(),
    this.source = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  CaffeineLogsCompanion.insert({
    this.id = const Value.absent(),
    required DateTime consumedAt,
    required int mg,
    this.source = const Value.absent(),
    this.createdAt = const Value.absent(),
  }) : consumedAt = Value(consumedAt),
       mg = Value(mg);
  static Insertable<CaffeineLog> custom({
    Expression<int>? id,
    Expression<DateTime>? consumedAt,
    Expression<int>? mg,
    Expression<String>? source,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (consumedAt != null) 'consumed_at': consumedAt,
      if (mg != null) 'mg': mg,
      if (source != null) 'source': source,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  CaffeineLogsCompanion copyWith({
    Value<int>? id,
    Value<DateTime>? consumedAt,
    Value<int>? mg,
    Value<String?>? source,
    Value<DateTime>? createdAt,
  }) {
    return CaffeineLogsCompanion(
      id: id ?? this.id,
      consumedAt: consumedAt ?? this.consumedAt,
      mg: mg ?? this.mg,
      source: source ?? this.source,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (consumedAt.present) {
      map['consumed_at'] = Variable<DateTime>(consumedAt.value);
    }
    if (mg.present) {
      map['mg'] = Variable<int>(mg.value);
    }
    if (source.present) {
      map['source'] = Variable<String>(source.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CaffeineLogsCompanion(')
          ..write('id: $id, ')
          ..write('consumedAt: $consumedAt, ')
          ..write('mg: $mg, ')
          ..write('source: $source, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $WorryJournalEntriesTable extends WorryJournalEntries
    with TableInfo<$WorryJournalEntriesTable, WorryJournalEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WorryJournalEntriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _enteredAtMeta = const VerificationMeta(
    'enteredAt',
  );
  @override
  late final GeneratedColumn<DateTime> enteredAt = GeneratedColumn<DateTime>(
    'entered_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _worryMeta = const VerificationMeta('worry');
  @override
  late final GeneratedColumn<String> worry = GeneratedColumn<String>(
    'worry',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nextActionMeta = const VerificationMeta(
    'nextAction',
  );
  @override
  late final GeneratedColumn<String> nextAction = GeneratedColumn<String>(
    'next_action',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _resolvedMeta = const VerificationMeta(
    'resolved',
  );
  @override
  late final GeneratedColumn<bool> resolved = GeneratedColumn<bool>(
    'resolved',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("resolved" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    enteredAt,
    worry,
    nextAction,
    resolved,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'worry_journal_entries';
  @override
  VerificationContext validateIntegrity(
    Insertable<WorryJournalEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('entered_at')) {
      context.handle(
        _enteredAtMeta,
        enteredAt.isAcceptableOrUnknown(data['entered_at']!, _enteredAtMeta),
      );
    } else if (isInserting) {
      context.missing(_enteredAtMeta);
    }
    if (data.containsKey('worry')) {
      context.handle(
        _worryMeta,
        worry.isAcceptableOrUnknown(data['worry']!, _worryMeta),
      );
    } else if (isInserting) {
      context.missing(_worryMeta);
    }
    if (data.containsKey('next_action')) {
      context.handle(
        _nextActionMeta,
        nextAction.isAcceptableOrUnknown(data['next_action']!, _nextActionMeta),
      );
    }
    if (data.containsKey('resolved')) {
      context.handle(
        _resolvedMeta,
        resolved.isAcceptableOrUnknown(data['resolved']!, _resolvedMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  WorryJournalEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return WorryJournalEntry(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      enteredAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}entered_at'],
      )!,
      worry: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}worry'],
      )!,
      nextAction: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}next_action'],
      ),
      resolved: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}resolved'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $WorryJournalEntriesTable createAlias(String alias) {
    return $WorryJournalEntriesTable(attachedDatabase, alias);
  }
}

class WorryJournalEntry extends DataClass
    implements Insertable<WorryJournalEntry> {
  final int id;
  final DateTime enteredAt;
  final String worry;
  final String? nextAction;
  final bool resolved;
  final DateTime createdAt;
  const WorryJournalEntry({
    required this.id,
    required this.enteredAt,
    required this.worry,
    this.nextAction,
    required this.resolved,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['entered_at'] = Variable<DateTime>(enteredAt);
    map['worry'] = Variable<String>(worry);
    if (!nullToAbsent || nextAction != null) {
      map['next_action'] = Variable<String>(nextAction);
    }
    map['resolved'] = Variable<bool>(resolved);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  WorryJournalEntriesCompanion toCompanion(bool nullToAbsent) {
    return WorryJournalEntriesCompanion(
      id: Value(id),
      enteredAt: Value(enteredAt),
      worry: Value(worry),
      nextAction: nextAction == null && nullToAbsent
          ? const Value.absent()
          : Value(nextAction),
      resolved: Value(resolved),
      createdAt: Value(createdAt),
    );
  }

  factory WorryJournalEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return WorryJournalEntry(
      id: serializer.fromJson<int>(json['id']),
      enteredAt: serializer.fromJson<DateTime>(json['enteredAt']),
      worry: serializer.fromJson<String>(json['worry']),
      nextAction: serializer.fromJson<String?>(json['nextAction']),
      resolved: serializer.fromJson<bool>(json['resolved']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'enteredAt': serializer.toJson<DateTime>(enteredAt),
      'worry': serializer.toJson<String>(worry),
      'nextAction': serializer.toJson<String?>(nextAction),
      'resolved': serializer.toJson<bool>(resolved),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  WorryJournalEntry copyWith({
    int? id,
    DateTime? enteredAt,
    String? worry,
    Value<String?> nextAction = const Value.absent(),
    bool? resolved,
    DateTime? createdAt,
  }) => WorryJournalEntry(
    id: id ?? this.id,
    enteredAt: enteredAt ?? this.enteredAt,
    worry: worry ?? this.worry,
    nextAction: nextAction.present ? nextAction.value : this.nextAction,
    resolved: resolved ?? this.resolved,
    createdAt: createdAt ?? this.createdAt,
  );
  WorryJournalEntry copyWithCompanion(WorryJournalEntriesCompanion data) {
    return WorryJournalEntry(
      id: data.id.present ? data.id.value : this.id,
      enteredAt: data.enteredAt.present ? data.enteredAt.value : this.enteredAt,
      worry: data.worry.present ? data.worry.value : this.worry,
      nextAction: data.nextAction.present
          ? data.nextAction.value
          : this.nextAction,
      resolved: data.resolved.present ? data.resolved.value : this.resolved,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('WorryJournalEntry(')
          ..write('id: $id, ')
          ..write('enteredAt: $enteredAt, ')
          ..write('worry: $worry, ')
          ..write('nextAction: $nextAction, ')
          ..write('resolved: $resolved, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, enteredAt, worry, nextAction, resolved, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is WorryJournalEntry &&
          other.id == this.id &&
          other.enteredAt == this.enteredAt &&
          other.worry == this.worry &&
          other.nextAction == this.nextAction &&
          other.resolved == this.resolved &&
          other.createdAt == this.createdAt);
}

class WorryJournalEntriesCompanion extends UpdateCompanion<WorryJournalEntry> {
  final Value<int> id;
  final Value<DateTime> enteredAt;
  final Value<String> worry;
  final Value<String?> nextAction;
  final Value<bool> resolved;
  final Value<DateTime> createdAt;
  const WorryJournalEntriesCompanion({
    this.id = const Value.absent(),
    this.enteredAt = const Value.absent(),
    this.worry = const Value.absent(),
    this.nextAction = const Value.absent(),
    this.resolved = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  WorryJournalEntriesCompanion.insert({
    this.id = const Value.absent(),
    required DateTime enteredAt,
    required String worry,
    this.nextAction = const Value.absent(),
    this.resolved = const Value.absent(),
    this.createdAt = const Value.absent(),
  }) : enteredAt = Value(enteredAt),
       worry = Value(worry);
  static Insertable<WorryJournalEntry> custom({
    Expression<int>? id,
    Expression<DateTime>? enteredAt,
    Expression<String>? worry,
    Expression<String>? nextAction,
    Expression<bool>? resolved,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (enteredAt != null) 'entered_at': enteredAt,
      if (worry != null) 'worry': worry,
      if (nextAction != null) 'next_action': nextAction,
      if (resolved != null) 'resolved': resolved,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  WorryJournalEntriesCompanion copyWith({
    Value<int>? id,
    Value<DateTime>? enteredAt,
    Value<String>? worry,
    Value<String?>? nextAction,
    Value<bool>? resolved,
    Value<DateTime>? createdAt,
  }) {
    return WorryJournalEntriesCompanion(
      id: id ?? this.id,
      enteredAt: enteredAt ?? this.enteredAt,
      worry: worry ?? this.worry,
      nextAction: nextAction ?? this.nextAction,
      resolved: resolved ?? this.resolved,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (enteredAt.present) {
      map['entered_at'] = Variable<DateTime>(enteredAt.value);
    }
    if (worry.present) {
      map['worry'] = Variable<String>(worry.value);
    }
    if (nextAction.present) {
      map['next_action'] = Variable<String>(nextAction.value);
    }
    if (resolved.present) {
      map['resolved'] = Variable<bool>(resolved.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WorryJournalEntriesCompanion(')
          ..write('id: $id, ')
          ..write('enteredAt: $enteredAt, ')
          ..write('worry: $worry, ')
          ..write('nextAction: $nextAction, ')
          ..write('resolved: $resolved, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

abstract class _$NoctosDatabase extends GeneratedDatabase {
  _$NoctosDatabase(QueryExecutor e) : super(e);
  $NoctosDatabaseManager get managers => $NoctosDatabaseManager(this);
  late final $SleepDiaryEntriesTable sleepDiaryEntries =
      $SleepDiaryEntriesTable(this);
  late final $UserSchedulesTable userSchedules = $UserSchedulesTable(this);
  late final $CbtiWeeksTable cbtiWeeks = $CbtiWeeksTable(this);
  late final $CaffeineLogsTable caffeineLogs = $CaffeineLogsTable(this);
  late final $WorryJournalEntriesTable worryJournalEntries =
      $WorryJournalEntriesTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    sleepDiaryEntries,
    userSchedules,
    cbtiWeeks,
    caffeineLogs,
    worryJournalEntries,
  ];
}

typedef $$SleepDiaryEntriesTableCreateCompanionBuilder =
    SleepDiaryEntriesCompanion Function({
      Value<int> id,
      required DateTime diaryDate,
      required DateTime bedtime,
      required DateTime lightsOut,
      Value<int> sleepLatencyMin,
      Value<int> awakeningsCount,
      Value<int> wasoMin,
      required DateTime wakeTime,
      required DateTime outOfBedTime,
      Value<int> qualityRating,
      Value<int> moodRating,
      Value<bool> adherentToPrescription,
      Value<String?> notes,
      Value<DateTime> createdAt,
    });
typedef $$SleepDiaryEntriesTableUpdateCompanionBuilder =
    SleepDiaryEntriesCompanion Function({
      Value<int> id,
      Value<DateTime> diaryDate,
      Value<DateTime> bedtime,
      Value<DateTime> lightsOut,
      Value<int> sleepLatencyMin,
      Value<int> awakeningsCount,
      Value<int> wasoMin,
      Value<DateTime> wakeTime,
      Value<DateTime> outOfBedTime,
      Value<int> qualityRating,
      Value<int> moodRating,
      Value<bool> adherentToPrescription,
      Value<String?> notes,
      Value<DateTime> createdAt,
    });

class $$SleepDiaryEntriesTableFilterComposer
    extends Composer<_$NoctosDatabase, $SleepDiaryEntriesTable> {
  $$SleepDiaryEntriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get diaryDate => $composableBuilder(
    column: $table.diaryDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get bedtime => $composableBuilder(
    column: $table.bedtime,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lightsOut => $composableBuilder(
    column: $table.lightsOut,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sleepLatencyMin => $composableBuilder(
    column: $table.sleepLatencyMin,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get awakeningsCount => $composableBuilder(
    column: $table.awakeningsCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get wasoMin => $composableBuilder(
    column: $table.wasoMin,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get wakeTime => $composableBuilder(
    column: $table.wakeTime,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get outOfBedTime => $composableBuilder(
    column: $table.outOfBedTime,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get qualityRating => $composableBuilder(
    column: $table.qualityRating,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get moodRating => $composableBuilder(
    column: $table.moodRating,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get adherentToPrescription => $composableBuilder(
    column: $table.adherentToPrescription,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SleepDiaryEntriesTableOrderingComposer
    extends Composer<_$NoctosDatabase, $SleepDiaryEntriesTable> {
  $$SleepDiaryEntriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get diaryDate => $composableBuilder(
    column: $table.diaryDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get bedtime => $composableBuilder(
    column: $table.bedtime,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lightsOut => $composableBuilder(
    column: $table.lightsOut,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sleepLatencyMin => $composableBuilder(
    column: $table.sleepLatencyMin,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get awakeningsCount => $composableBuilder(
    column: $table.awakeningsCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get wasoMin => $composableBuilder(
    column: $table.wasoMin,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get wakeTime => $composableBuilder(
    column: $table.wakeTime,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get outOfBedTime => $composableBuilder(
    column: $table.outOfBedTime,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get qualityRating => $composableBuilder(
    column: $table.qualityRating,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get moodRating => $composableBuilder(
    column: $table.moodRating,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get adherentToPrescription => $composableBuilder(
    column: $table.adherentToPrescription,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SleepDiaryEntriesTableAnnotationComposer
    extends Composer<_$NoctosDatabase, $SleepDiaryEntriesTable> {
  $$SleepDiaryEntriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get diaryDate =>
      $composableBuilder(column: $table.diaryDate, builder: (column) => column);

  GeneratedColumn<DateTime> get bedtime =>
      $composableBuilder(column: $table.bedtime, builder: (column) => column);

  GeneratedColumn<DateTime> get lightsOut =>
      $composableBuilder(column: $table.lightsOut, builder: (column) => column);

  GeneratedColumn<int> get sleepLatencyMin => $composableBuilder(
    column: $table.sleepLatencyMin,
    builder: (column) => column,
  );

  GeneratedColumn<int> get awakeningsCount => $composableBuilder(
    column: $table.awakeningsCount,
    builder: (column) => column,
  );

  GeneratedColumn<int> get wasoMin =>
      $composableBuilder(column: $table.wasoMin, builder: (column) => column);

  GeneratedColumn<DateTime> get wakeTime =>
      $composableBuilder(column: $table.wakeTime, builder: (column) => column);

  GeneratedColumn<DateTime> get outOfBedTime => $composableBuilder(
    column: $table.outOfBedTime,
    builder: (column) => column,
  );

  GeneratedColumn<int> get qualityRating => $composableBuilder(
    column: $table.qualityRating,
    builder: (column) => column,
  );

  GeneratedColumn<int> get moodRating => $composableBuilder(
    column: $table.moodRating,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get adherentToPrescription => $composableBuilder(
    column: $table.adherentToPrescription,
    builder: (column) => column,
  );

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$SleepDiaryEntriesTableTableManager
    extends
        RootTableManager<
          _$NoctosDatabase,
          $SleepDiaryEntriesTable,
          SleepDiaryEntry,
          $$SleepDiaryEntriesTableFilterComposer,
          $$SleepDiaryEntriesTableOrderingComposer,
          $$SleepDiaryEntriesTableAnnotationComposer,
          $$SleepDiaryEntriesTableCreateCompanionBuilder,
          $$SleepDiaryEntriesTableUpdateCompanionBuilder,
          (
            SleepDiaryEntry,
            BaseReferences<
              _$NoctosDatabase,
              $SleepDiaryEntriesTable,
              SleepDiaryEntry
            >,
          ),
          SleepDiaryEntry,
          PrefetchHooks Function()
        > {
  $$SleepDiaryEntriesTableTableManager(
    _$NoctosDatabase db,
    $SleepDiaryEntriesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SleepDiaryEntriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SleepDiaryEntriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SleepDiaryEntriesTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<DateTime> diaryDate = const Value.absent(),
                Value<DateTime> bedtime = const Value.absent(),
                Value<DateTime> lightsOut = const Value.absent(),
                Value<int> sleepLatencyMin = const Value.absent(),
                Value<int> awakeningsCount = const Value.absent(),
                Value<int> wasoMin = const Value.absent(),
                Value<DateTime> wakeTime = const Value.absent(),
                Value<DateTime> outOfBedTime = const Value.absent(),
                Value<int> qualityRating = const Value.absent(),
                Value<int> moodRating = const Value.absent(),
                Value<bool> adherentToPrescription = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => SleepDiaryEntriesCompanion(
                id: id,
                diaryDate: diaryDate,
                bedtime: bedtime,
                lightsOut: lightsOut,
                sleepLatencyMin: sleepLatencyMin,
                awakeningsCount: awakeningsCount,
                wasoMin: wasoMin,
                wakeTime: wakeTime,
                outOfBedTime: outOfBedTime,
                qualityRating: qualityRating,
                moodRating: moodRating,
                adherentToPrescription: adherentToPrescription,
                notes: notes,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required DateTime diaryDate,
                required DateTime bedtime,
                required DateTime lightsOut,
                Value<int> sleepLatencyMin = const Value.absent(),
                Value<int> awakeningsCount = const Value.absent(),
                Value<int> wasoMin = const Value.absent(),
                required DateTime wakeTime,
                required DateTime outOfBedTime,
                Value<int> qualityRating = const Value.absent(),
                Value<int> moodRating = const Value.absent(),
                Value<bool> adherentToPrescription = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => SleepDiaryEntriesCompanion.insert(
                id: id,
                diaryDate: diaryDate,
                bedtime: bedtime,
                lightsOut: lightsOut,
                sleepLatencyMin: sleepLatencyMin,
                awakeningsCount: awakeningsCount,
                wasoMin: wasoMin,
                wakeTime: wakeTime,
                outOfBedTime: outOfBedTime,
                qualityRating: qualityRating,
                moodRating: moodRating,
                adherentToPrescription: adherentToPrescription,
                notes: notes,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SleepDiaryEntriesTableProcessedTableManager =
    ProcessedTableManager<
      _$NoctosDatabase,
      $SleepDiaryEntriesTable,
      SleepDiaryEntry,
      $$SleepDiaryEntriesTableFilterComposer,
      $$SleepDiaryEntriesTableOrderingComposer,
      $$SleepDiaryEntriesTableAnnotationComposer,
      $$SleepDiaryEntriesTableCreateCompanionBuilder,
      $$SleepDiaryEntriesTableUpdateCompanionBuilder,
      (
        SleepDiaryEntry,
        BaseReferences<
          _$NoctosDatabase,
          $SleepDiaryEntriesTable,
          SleepDiaryEntry
        >,
      ),
      SleepDiaryEntry,
      PrefetchHooks Function()
    >;
typedef $$UserSchedulesTableCreateCompanionBuilder =
    UserSchedulesCompanion Function({
      Value<int> id,
      required int fixedWakeMinutesOfDay,
      required int currentBedtimeMinutesOfDay,
      Value<int> currentTibMinutes,
      Value<int> windDownMinutes,
      Value<int> caffeineCutoffOffsetMin,
      Value<int?> chronotypeScore,
      Value<String?> chronotypeCategory,
      Value<String?> insomniaTypes,
      Value<int?> insomniaSeverity,
      Value<bool> notificationsEnabled,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });
typedef $$UserSchedulesTableUpdateCompanionBuilder =
    UserSchedulesCompanion Function({
      Value<int> id,
      Value<int> fixedWakeMinutesOfDay,
      Value<int> currentBedtimeMinutesOfDay,
      Value<int> currentTibMinutes,
      Value<int> windDownMinutes,
      Value<int> caffeineCutoffOffsetMin,
      Value<int?> chronotypeScore,
      Value<String?> chronotypeCategory,
      Value<String?> insomniaTypes,
      Value<int?> insomniaSeverity,
      Value<bool> notificationsEnabled,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });

class $$UserSchedulesTableFilterComposer
    extends Composer<_$NoctosDatabase, $UserSchedulesTable> {
  $$UserSchedulesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get fixedWakeMinutesOfDay => $composableBuilder(
    column: $table.fixedWakeMinutesOfDay,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get currentBedtimeMinutesOfDay => $composableBuilder(
    column: $table.currentBedtimeMinutesOfDay,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get currentTibMinutes => $composableBuilder(
    column: $table.currentTibMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get windDownMinutes => $composableBuilder(
    column: $table.windDownMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get caffeineCutoffOffsetMin => $composableBuilder(
    column: $table.caffeineCutoffOffsetMin,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get chronotypeScore => $composableBuilder(
    column: $table.chronotypeScore,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get chronotypeCategory => $composableBuilder(
    column: $table.chronotypeCategory,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get insomniaTypes => $composableBuilder(
    column: $table.insomniaTypes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get insomniaSeverity => $composableBuilder(
    column: $table.insomniaSeverity,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get notificationsEnabled => $composableBuilder(
    column: $table.notificationsEnabled,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$UserSchedulesTableOrderingComposer
    extends Composer<_$NoctosDatabase, $UserSchedulesTable> {
  $$UserSchedulesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get fixedWakeMinutesOfDay => $composableBuilder(
    column: $table.fixedWakeMinutesOfDay,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get currentBedtimeMinutesOfDay => $composableBuilder(
    column: $table.currentBedtimeMinutesOfDay,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get currentTibMinutes => $composableBuilder(
    column: $table.currentTibMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get windDownMinutes => $composableBuilder(
    column: $table.windDownMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get caffeineCutoffOffsetMin => $composableBuilder(
    column: $table.caffeineCutoffOffsetMin,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get chronotypeScore => $composableBuilder(
    column: $table.chronotypeScore,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get chronotypeCategory => $composableBuilder(
    column: $table.chronotypeCategory,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get insomniaTypes => $composableBuilder(
    column: $table.insomniaTypes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get insomniaSeverity => $composableBuilder(
    column: $table.insomniaSeverity,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get notificationsEnabled => $composableBuilder(
    column: $table.notificationsEnabled,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$UserSchedulesTableAnnotationComposer
    extends Composer<_$NoctosDatabase, $UserSchedulesTable> {
  $$UserSchedulesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get fixedWakeMinutesOfDay => $composableBuilder(
    column: $table.fixedWakeMinutesOfDay,
    builder: (column) => column,
  );

  GeneratedColumn<int> get currentBedtimeMinutesOfDay => $composableBuilder(
    column: $table.currentBedtimeMinutesOfDay,
    builder: (column) => column,
  );

  GeneratedColumn<int> get currentTibMinutes => $composableBuilder(
    column: $table.currentTibMinutes,
    builder: (column) => column,
  );

  GeneratedColumn<int> get windDownMinutes => $composableBuilder(
    column: $table.windDownMinutes,
    builder: (column) => column,
  );

  GeneratedColumn<int> get caffeineCutoffOffsetMin => $composableBuilder(
    column: $table.caffeineCutoffOffsetMin,
    builder: (column) => column,
  );

  GeneratedColumn<int> get chronotypeScore => $composableBuilder(
    column: $table.chronotypeScore,
    builder: (column) => column,
  );

  GeneratedColumn<String> get chronotypeCategory => $composableBuilder(
    column: $table.chronotypeCategory,
    builder: (column) => column,
  );

  GeneratedColumn<String> get insomniaTypes => $composableBuilder(
    column: $table.insomniaTypes,
    builder: (column) => column,
  );

  GeneratedColumn<int> get insomniaSeverity => $composableBuilder(
    column: $table.insomniaSeverity,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get notificationsEnabled => $composableBuilder(
    column: $table.notificationsEnabled,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$UserSchedulesTableTableManager
    extends
        RootTableManager<
          _$NoctosDatabase,
          $UserSchedulesTable,
          UserSchedule,
          $$UserSchedulesTableFilterComposer,
          $$UserSchedulesTableOrderingComposer,
          $$UserSchedulesTableAnnotationComposer,
          $$UserSchedulesTableCreateCompanionBuilder,
          $$UserSchedulesTableUpdateCompanionBuilder,
          (
            UserSchedule,
            BaseReferences<_$NoctosDatabase, $UserSchedulesTable, UserSchedule>,
          ),
          UserSchedule,
          PrefetchHooks Function()
        > {
  $$UserSchedulesTableTableManager(
    _$NoctosDatabase db,
    $UserSchedulesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UserSchedulesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$UserSchedulesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$UserSchedulesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> fixedWakeMinutesOfDay = const Value.absent(),
                Value<int> currentBedtimeMinutesOfDay = const Value.absent(),
                Value<int> currentTibMinutes = const Value.absent(),
                Value<int> windDownMinutes = const Value.absent(),
                Value<int> caffeineCutoffOffsetMin = const Value.absent(),
                Value<int?> chronotypeScore = const Value.absent(),
                Value<String?> chronotypeCategory = const Value.absent(),
                Value<String?> insomniaTypes = const Value.absent(),
                Value<int?> insomniaSeverity = const Value.absent(),
                Value<bool> notificationsEnabled = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => UserSchedulesCompanion(
                id: id,
                fixedWakeMinutesOfDay: fixedWakeMinutesOfDay,
                currentBedtimeMinutesOfDay: currentBedtimeMinutesOfDay,
                currentTibMinutes: currentTibMinutes,
                windDownMinutes: windDownMinutes,
                caffeineCutoffOffsetMin: caffeineCutoffOffsetMin,
                chronotypeScore: chronotypeScore,
                chronotypeCategory: chronotypeCategory,
                insomniaTypes: insomniaTypes,
                insomniaSeverity: insomniaSeverity,
                notificationsEnabled: notificationsEnabled,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int fixedWakeMinutesOfDay,
                required int currentBedtimeMinutesOfDay,
                Value<int> currentTibMinutes = const Value.absent(),
                Value<int> windDownMinutes = const Value.absent(),
                Value<int> caffeineCutoffOffsetMin = const Value.absent(),
                Value<int?> chronotypeScore = const Value.absent(),
                Value<String?> chronotypeCategory = const Value.absent(),
                Value<String?> insomniaTypes = const Value.absent(),
                Value<int?> insomniaSeverity = const Value.absent(),
                Value<bool> notificationsEnabled = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => UserSchedulesCompanion.insert(
                id: id,
                fixedWakeMinutesOfDay: fixedWakeMinutesOfDay,
                currentBedtimeMinutesOfDay: currentBedtimeMinutesOfDay,
                currentTibMinutes: currentTibMinutes,
                windDownMinutes: windDownMinutes,
                caffeineCutoffOffsetMin: caffeineCutoffOffsetMin,
                chronotypeScore: chronotypeScore,
                chronotypeCategory: chronotypeCategory,
                insomniaTypes: insomniaTypes,
                insomniaSeverity: insomniaSeverity,
                notificationsEnabled: notificationsEnabled,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$UserSchedulesTableProcessedTableManager =
    ProcessedTableManager<
      _$NoctosDatabase,
      $UserSchedulesTable,
      UserSchedule,
      $$UserSchedulesTableFilterComposer,
      $$UserSchedulesTableOrderingComposer,
      $$UserSchedulesTableAnnotationComposer,
      $$UserSchedulesTableCreateCompanionBuilder,
      $$UserSchedulesTableUpdateCompanionBuilder,
      (
        UserSchedule,
        BaseReferences<_$NoctosDatabase, $UserSchedulesTable, UserSchedule>,
      ),
      UserSchedule,
      PrefetchHooks Function()
    >;
typedef $$CbtiWeeksTableCreateCompanionBuilder =
    CbtiWeeksCompanion Function({
      Value<int> id,
      required int weekIndex,
      required String phaseId,
      required DateTime startedOn,
      required int prescribedBedtimeMinutesOfDay,
      required int prescribedWakeMinutesOfDay,
      required int tibMinutes,
      Value<double> efficiencyTarget,
      required String rationale,
      required String action,
      Value<String> status,
      Value<DateTime> createdAt,
    });
typedef $$CbtiWeeksTableUpdateCompanionBuilder =
    CbtiWeeksCompanion Function({
      Value<int> id,
      Value<int> weekIndex,
      Value<String> phaseId,
      Value<DateTime> startedOn,
      Value<int> prescribedBedtimeMinutesOfDay,
      Value<int> prescribedWakeMinutesOfDay,
      Value<int> tibMinutes,
      Value<double> efficiencyTarget,
      Value<String> rationale,
      Value<String> action,
      Value<String> status,
      Value<DateTime> createdAt,
    });

class $$CbtiWeeksTableFilterComposer
    extends Composer<_$NoctosDatabase, $CbtiWeeksTable> {
  $$CbtiWeeksTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get weekIndex => $composableBuilder(
    column: $table.weekIndex,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get phaseId => $composableBuilder(
    column: $table.phaseId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get startedOn => $composableBuilder(
    column: $table.startedOn,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get prescribedBedtimeMinutesOfDay => $composableBuilder(
    column: $table.prescribedBedtimeMinutesOfDay,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get prescribedWakeMinutesOfDay => $composableBuilder(
    column: $table.prescribedWakeMinutesOfDay,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get tibMinutes => $composableBuilder(
    column: $table.tibMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get efficiencyTarget => $composableBuilder(
    column: $table.efficiencyTarget,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get rationale => $composableBuilder(
    column: $table.rationale,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get action => $composableBuilder(
    column: $table.action,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$CbtiWeeksTableOrderingComposer
    extends Composer<_$NoctosDatabase, $CbtiWeeksTable> {
  $$CbtiWeeksTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get weekIndex => $composableBuilder(
    column: $table.weekIndex,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get phaseId => $composableBuilder(
    column: $table.phaseId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get startedOn => $composableBuilder(
    column: $table.startedOn,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get prescribedBedtimeMinutesOfDay => $composableBuilder(
    column: $table.prescribedBedtimeMinutesOfDay,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get prescribedWakeMinutesOfDay => $composableBuilder(
    column: $table.prescribedWakeMinutesOfDay,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get tibMinutes => $composableBuilder(
    column: $table.tibMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get efficiencyTarget => $composableBuilder(
    column: $table.efficiencyTarget,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get rationale => $composableBuilder(
    column: $table.rationale,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get action => $composableBuilder(
    column: $table.action,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CbtiWeeksTableAnnotationComposer
    extends Composer<_$NoctosDatabase, $CbtiWeeksTable> {
  $$CbtiWeeksTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get weekIndex =>
      $composableBuilder(column: $table.weekIndex, builder: (column) => column);

  GeneratedColumn<String> get phaseId =>
      $composableBuilder(column: $table.phaseId, builder: (column) => column);

  GeneratedColumn<DateTime> get startedOn =>
      $composableBuilder(column: $table.startedOn, builder: (column) => column);

  GeneratedColumn<int> get prescribedBedtimeMinutesOfDay => $composableBuilder(
    column: $table.prescribedBedtimeMinutesOfDay,
    builder: (column) => column,
  );

  GeneratedColumn<int> get prescribedWakeMinutesOfDay => $composableBuilder(
    column: $table.prescribedWakeMinutesOfDay,
    builder: (column) => column,
  );

  GeneratedColumn<int> get tibMinutes => $composableBuilder(
    column: $table.tibMinutes,
    builder: (column) => column,
  );

  GeneratedColumn<double> get efficiencyTarget => $composableBuilder(
    column: $table.efficiencyTarget,
    builder: (column) => column,
  );

  GeneratedColumn<String> get rationale =>
      $composableBuilder(column: $table.rationale, builder: (column) => column);

  GeneratedColumn<String> get action =>
      $composableBuilder(column: $table.action, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$CbtiWeeksTableTableManager
    extends
        RootTableManager<
          _$NoctosDatabase,
          $CbtiWeeksTable,
          CbtiWeek,
          $$CbtiWeeksTableFilterComposer,
          $$CbtiWeeksTableOrderingComposer,
          $$CbtiWeeksTableAnnotationComposer,
          $$CbtiWeeksTableCreateCompanionBuilder,
          $$CbtiWeeksTableUpdateCompanionBuilder,
          (
            CbtiWeek,
            BaseReferences<_$NoctosDatabase, $CbtiWeeksTable, CbtiWeek>,
          ),
          CbtiWeek,
          PrefetchHooks Function()
        > {
  $$CbtiWeeksTableTableManager(_$NoctosDatabase db, $CbtiWeeksTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CbtiWeeksTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CbtiWeeksTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CbtiWeeksTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> weekIndex = const Value.absent(),
                Value<String> phaseId = const Value.absent(),
                Value<DateTime> startedOn = const Value.absent(),
                Value<int> prescribedBedtimeMinutesOfDay = const Value.absent(),
                Value<int> prescribedWakeMinutesOfDay = const Value.absent(),
                Value<int> tibMinutes = const Value.absent(),
                Value<double> efficiencyTarget = const Value.absent(),
                Value<String> rationale = const Value.absent(),
                Value<String> action = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => CbtiWeeksCompanion(
                id: id,
                weekIndex: weekIndex,
                phaseId: phaseId,
                startedOn: startedOn,
                prescribedBedtimeMinutesOfDay: prescribedBedtimeMinutesOfDay,
                prescribedWakeMinutesOfDay: prescribedWakeMinutesOfDay,
                tibMinutes: tibMinutes,
                efficiencyTarget: efficiencyTarget,
                rationale: rationale,
                action: action,
                status: status,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int weekIndex,
                required String phaseId,
                required DateTime startedOn,
                required int prescribedBedtimeMinutesOfDay,
                required int prescribedWakeMinutesOfDay,
                required int tibMinutes,
                Value<double> efficiencyTarget = const Value.absent(),
                required String rationale,
                required String action,
                Value<String> status = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => CbtiWeeksCompanion.insert(
                id: id,
                weekIndex: weekIndex,
                phaseId: phaseId,
                startedOn: startedOn,
                prescribedBedtimeMinutesOfDay: prescribedBedtimeMinutesOfDay,
                prescribedWakeMinutesOfDay: prescribedWakeMinutesOfDay,
                tibMinutes: tibMinutes,
                efficiencyTarget: efficiencyTarget,
                rationale: rationale,
                action: action,
                status: status,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CbtiWeeksTableProcessedTableManager =
    ProcessedTableManager<
      _$NoctosDatabase,
      $CbtiWeeksTable,
      CbtiWeek,
      $$CbtiWeeksTableFilterComposer,
      $$CbtiWeeksTableOrderingComposer,
      $$CbtiWeeksTableAnnotationComposer,
      $$CbtiWeeksTableCreateCompanionBuilder,
      $$CbtiWeeksTableUpdateCompanionBuilder,
      (CbtiWeek, BaseReferences<_$NoctosDatabase, $CbtiWeeksTable, CbtiWeek>),
      CbtiWeek,
      PrefetchHooks Function()
    >;
typedef $$CaffeineLogsTableCreateCompanionBuilder =
    CaffeineLogsCompanion Function({
      Value<int> id,
      required DateTime consumedAt,
      required int mg,
      Value<String?> source,
      Value<DateTime> createdAt,
    });
typedef $$CaffeineLogsTableUpdateCompanionBuilder =
    CaffeineLogsCompanion Function({
      Value<int> id,
      Value<DateTime> consumedAt,
      Value<int> mg,
      Value<String?> source,
      Value<DateTime> createdAt,
    });

class $$CaffeineLogsTableFilterComposer
    extends Composer<_$NoctosDatabase, $CaffeineLogsTable> {
  $$CaffeineLogsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get consumedAt => $composableBuilder(
    column: $table.consumedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get mg => $composableBuilder(
    column: $table.mg,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$CaffeineLogsTableOrderingComposer
    extends Composer<_$NoctosDatabase, $CaffeineLogsTable> {
  $$CaffeineLogsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get consumedAt => $composableBuilder(
    column: $table.consumedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get mg => $composableBuilder(
    column: $table.mg,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CaffeineLogsTableAnnotationComposer
    extends Composer<_$NoctosDatabase, $CaffeineLogsTable> {
  $$CaffeineLogsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get consumedAt => $composableBuilder(
    column: $table.consumedAt,
    builder: (column) => column,
  );

  GeneratedColumn<int> get mg =>
      $composableBuilder(column: $table.mg, builder: (column) => column);

  GeneratedColumn<String> get source =>
      $composableBuilder(column: $table.source, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$CaffeineLogsTableTableManager
    extends
        RootTableManager<
          _$NoctosDatabase,
          $CaffeineLogsTable,
          CaffeineLog,
          $$CaffeineLogsTableFilterComposer,
          $$CaffeineLogsTableOrderingComposer,
          $$CaffeineLogsTableAnnotationComposer,
          $$CaffeineLogsTableCreateCompanionBuilder,
          $$CaffeineLogsTableUpdateCompanionBuilder,
          (
            CaffeineLog,
            BaseReferences<_$NoctosDatabase, $CaffeineLogsTable, CaffeineLog>,
          ),
          CaffeineLog,
          PrefetchHooks Function()
        > {
  $$CaffeineLogsTableTableManager(_$NoctosDatabase db, $CaffeineLogsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CaffeineLogsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CaffeineLogsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CaffeineLogsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<DateTime> consumedAt = const Value.absent(),
                Value<int> mg = const Value.absent(),
                Value<String?> source = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => CaffeineLogsCompanion(
                id: id,
                consumedAt: consumedAt,
                mg: mg,
                source: source,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required DateTime consumedAt,
                required int mg,
                Value<String?> source = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => CaffeineLogsCompanion.insert(
                id: id,
                consumedAt: consumedAt,
                mg: mg,
                source: source,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CaffeineLogsTableProcessedTableManager =
    ProcessedTableManager<
      _$NoctosDatabase,
      $CaffeineLogsTable,
      CaffeineLog,
      $$CaffeineLogsTableFilterComposer,
      $$CaffeineLogsTableOrderingComposer,
      $$CaffeineLogsTableAnnotationComposer,
      $$CaffeineLogsTableCreateCompanionBuilder,
      $$CaffeineLogsTableUpdateCompanionBuilder,
      (
        CaffeineLog,
        BaseReferences<_$NoctosDatabase, $CaffeineLogsTable, CaffeineLog>,
      ),
      CaffeineLog,
      PrefetchHooks Function()
    >;
typedef $$WorryJournalEntriesTableCreateCompanionBuilder =
    WorryJournalEntriesCompanion Function({
      Value<int> id,
      required DateTime enteredAt,
      required String worry,
      Value<String?> nextAction,
      Value<bool> resolved,
      Value<DateTime> createdAt,
    });
typedef $$WorryJournalEntriesTableUpdateCompanionBuilder =
    WorryJournalEntriesCompanion Function({
      Value<int> id,
      Value<DateTime> enteredAt,
      Value<String> worry,
      Value<String?> nextAction,
      Value<bool> resolved,
      Value<DateTime> createdAt,
    });

class $$WorryJournalEntriesTableFilterComposer
    extends Composer<_$NoctosDatabase, $WorryJournalEntriesTable> {
  $$WorryJournalEntriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get enteredAt => $composableBuilder(
    column: $table.enteredAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get worry => $composableBuilder(
    column: $table.worry,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nextAction => $composableBuilder(
    column: $table.nextAction,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get resolved => $composableBuilder(
    column: $table.resolved,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$WorryJournalEntriesTableOrderingComposer
    extends Composer<_$NoctosDatabase, $WorryJournalEntriesTable> {
  $$WorryJournalEntriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get enteredAt => $composableBuilder(
    column: $table.enteredAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get worry => $composableBuilder(
    column: $table.worry,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nextAction => $composableBuilder(
    column: $table.nextAction,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get resolved => $composableBuilder(
    column: $table.resolved,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$WorryJournalEntriesTableAnnotationComposer
    extends Composer<_$NoctosDatabase, $WorryJournalEntriesTable> {
  $$WorryJournalEntriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get enteredAt =>
      $composableBuilder(column: $table.enteredAt, builder: (column) => column);

  GeneratedColumn<String> get worry =>
      $composableBuilder(column: $table.worry, builder: (column) => column);

  GeneratedColumn<String> get nextAction => $composableBuilder(
    column: $table.nextAction,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get resolved =>
      $composableBuilder(column: $table.resolved, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$WorryJournalEntriesTableTableManager
    extends
        RootTableManager<
          _$NoctosDatabase,
          $WorryJournalEntriesTable,
          WorryJournalEntry,
          $$WorryJournalEntriesTableFilterComposer,
          $$WorryJournalEntriesTableOrderingComposer,
          $$WorryJournalEntriesTableAnnotationComposer,
          $$WorryJournalEntriesTableCreateCompanionBuilder,
          $$WorryJournalEntriesTableUpdateCompanionBuilder,
          (
            WorryJournalEntry,
            BaseReferences<
              _$NoctosDatabase,
              $WorryJournalEntriesTable,
              WorryJournalEntry
            >,
          ),
          WorryJournalEntry,
          PrefetchHooks Function()
        > {
  $$WorryJournalEntriesTableTableManager(
    _$NoctosDatabase db,
    $WorryJournalEntriesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$WorryJournalEntriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$WorryJournalEntriesTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$WorryJournalEntriesTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<DateTime> enteredAt = const Value.absent(),
                Value<String> worry = const Value.absent(),
                Value<String?> nextAction = const Value.absent(),
                Value<bool> resolved = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => WorryJournalEntriesCompanion(
                id: id,
                enteredAt: enteredAt,
                worry: worry,
                nextAction: nextAction,
                resolved: resolved,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required DateTime enteredAt,
                required String worry,
                Value<String?> nextAction = const Value.absent(),
                Value<bool> resolved = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => WorryJournalEntriesCompanion.insert(
                id: id,
                enteredAt: enteredAt,
                worry: worry,
                nextAction: nextAction,
                resolved: resolved,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$WorryJournalEntriesTableProcessedTableManager =
    ProcessedTableManager<
      _$NoctosDatabase,
      $WorryJournalEntriesTable,
      WorryJournalEntry,
      $$WorryJournalEntriesTableFilterComposer,
      $$WorryJournalEntriesTableOrderingComposer,
      $$WorryJournalEntriesTableAnnotationComposer,
      $$WorryJournalEntriesTableCreateCompanionBuilder,
      $$WorryJournalEntriesTableUpdateCompanionBuilder,
      (
        WorryJournalEntry,
        BaseReferences<
          _$NoctosDatabase,
          $WorryJournalEntriesTable,
          WorryJournalEntry
        >,
      ),
      WorryJournalEntry,
      PrefetchHooks Function()
    >;

class $NoctosDatabaseManager {
  final _$NoctosDatabase _db;
  $NoctosDatabaseManager(this._db);
  $$SleepDiaryEntriesTableTableManager get sleepDiaryEntries =>
      $$SleepDiaryEntriesTableTableManager(_db, _db.sleepDiaryEntries);
  $$UserSchedulesTableTableManager get userSchedules =>
      $$UserSchedulesTableTableManager(_db, _db.userSchedules);
  $$CbtiWeeksTableTableManager get cbtiWeeks =>
      $$CbtiWeeksTableTableManager(_db, _db.cbtiWeeks);
  $$CaffeineLogsTableTableManager get caffeineLogs =>
      $$CaffeineLogsTableTableManager(_db, _db.caffeineLogs);
  $$WorryJournalEntriesTableTableManager get worryJournalEntries =>
      $$WorryJournalEntriesTableTableManager(_db, _db.worryJournalEntries);
}
