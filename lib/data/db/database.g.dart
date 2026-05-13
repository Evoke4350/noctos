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

abstract class _$NoctosDatabase extends GeneratedDatabase {
  _$NoctosDatabase(QueryExecutor e) : super(e);
  $NoctosDatabaseManager get managers => $NoctosDatabaseManager(this);
  late final $SleepDiaryEntriesTable sleepDiaryEntries =
      $SleepDiaryEntriesTable(this);
  late final $UserSchedulesTable userSchedules = $UserSchedulesTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    sleepDiaryEntries,
    userSchedules,
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

class $NoctosDatabaseManager {
  final _$NoctosDatabase _db;
  $NoctosDatabaseManager(this._db);
  $$SleepDiaryEntriesTableTableManager get sleepDiaryEntries =>
      $$SleepDiaryEntriesTableTableManager(_db, _db.sleepDiaryEntries);
  $$UserSchedulesTableTableManager get userSchedules =>
      $$UserSchedulesTableTableManager(_db, _db.userSchedules);
}
