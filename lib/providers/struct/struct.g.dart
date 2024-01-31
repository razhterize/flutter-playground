// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'struct.dart';

// ignore_for_file: type=lint
class $StructTable extends Struct with TableInfo<$StructTable, StructData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $StructTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _clientMeta = const VerificationMeta('client');
  @override
  late final GeneratedColumn<String> client = GeneratedColumn<String>(
      'client', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _dataMeta = const VerificationMeta('data');
  @override
  late final GeneratedColumn<String> data = GeneratedColumn<String>(
      'data', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _createdMeta =
      const VerificationMeta('created');
  @override
  late final GeneratedColumn<DateTime> created = GeneratedColumn<DateTime>(
      'created', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _modifiedMeta =
      const VerificationMeta('modified');
  @override
  late final GeneratedColumn<DateTime> modified = GeneratedColumn<DateTime>(
      'modified', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [id, client, data, created, modified];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'struct';
  @override
  VerificationContext validateIntegrity(Insertable<StructData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('client')) {
      context.handle(_clientMeta,
          client.isAcceptableOrUnknown(data['client']!, _clientMeta));
    } else if (isInserting) {
      context.missing(_clientMeta);
    }
    if (data.containsKey('data')) {
      context.handle(
          _dataMeta, this.data.isAcceptableOrUnknown(data['data']!, _dataMeta));
    } else if (isInserting) {
      context.missing(_dataMeta);
    }
    if (data.containsKey('created')) {
      context.handle(_createdMeta,
          created.isAcceptableOrUnknown(data['created']!, _createdMeta));
    } else if (isInserting) {
      context.missing(_createdMeta);
    }
    if (data.containsKey('modified')) {
      context.handle(_modifiedMeta,
          modified.isAcceptableOrUnknown(data['modified']!, _modifiedMeta));
    } else if (isInserting) {
      context.missing(_modifiedMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  StructData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return StructData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      client: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}client'])!,
      data: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}data'])!,
      created: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created'])!,
      modified: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}modified'])!,
    );
  }

  @override
  $StructTable createAlias(String alias) {
    return $StructTable(attachedDatabase, alias);
  }
}

class StructData extends DataClass implements Insertable<StructData> {
  final int id;
  final String client;
  final String data;
  final DateTime created;
  final DateTime modified;
  const StructData(
      {required this.id,
      required this.client,
      required this.data,
      required this.created,
      required this.modified});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['client'] = Variable<String>(client);
    map['data'] = Variable<String>(data);
    map['created'] = Variable<DateTime>(created);
    map['modified'] = Variable<DateTime>(modified);
    return map;
  }

  StructCompanion toCompanion(bool nullToAbsent) {
    return StructCompanion(
      id: Value(id),
      client: Value(client),
      data: Value(data),
      created: Value(created),
      modified: Value(modified),
    );
  }

  factory StructData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return StructData(
      id: serializer.fromJson<int>(json['id']),
      client: serializer.fromJson<String>(json['client']),
      data: serializer.fromJson<String>(json['data']),
      created: serializer.fromJson<DateTime>(json['created']),
      modified: serializer.fromJson<DateTime>(json['modified']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'client': serializer.toJson<String>(client),
      'data': serializer.toJson<String>(data),
      'created': serializer.toJson<DateTime>(created),
      'modified': serializer.toJson<DateTime>(modified),
    };
  }

  StructData copyWith(
          {int? id,
          String? client,
          String? data,
          DateTime? created,
          DateTime? modified}) =>
      StructData(
        id: id ?? this.id,
        client: client ?? this.client,
        data: data ?? this.data,
        created: created ?? this.created,
        modified: modified ?? this.modified,
      );
  @override
  String toString() {
    return (StringBuffer('StructData(')
          ..write('id: $id, ')
          ..write('client: $client, ')
          ..write('data: $data, ')
          ..write('created: $created, ')
          ..write('modified: $modified')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, client, data, created, modified);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is StructData &&
          other.id == this.id &&
          other.client == this.client &&
          other.data == this.data &&
          other.created == this.created &&
          other.modified == this.modified);
}

class StructCompanion extends UpdateCompanion<StructData> {
  final Value<int> id;
  final Value<String> client;
  final Value<String> data;
  final Value<DateTime> created;
  final Value<DateTime> modified;
  const StructCompanion({
    this.id = const Value.absent(),
    this.client = const Value.absent(),
    this.data = const Value.absent(),
    this.created = const Value.absent(),
    this.modified = const Value.absent(),
  });
  StructCompanion.insert({
    this.id = const Value.absent(),
    required String client,
    required String data,
    required DateTime created,
    required DateTime modified,
  })  : client = Value(client),
        data = Value(data),
        created = Value(created),
        modified = Value(modified);
  static Insertable<StructData> custom({
    Expression<int>? id,
    Expression<String>? client,
    Expression<String>? data,
    Expression<DateTime>? created,
    Expression<DateTime>? modified,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (client != null) 'client': client,
      if (data != null) 'data': data,
      if (created != null) 'created': created,
      if (modified != null) 'modified': modified,
    });
  }

  StructCompanion copyWith(
      {Value<int>? id,
      Value<String>? client,
      Value<String>? data,
      Value<DateTime>? created,
      Value<DateTime>? modified}) {
    return StructCompanion(
      id: id ?? this.id,
      client: client ?? this.client,
      data: data ?? this.data,
      created: created ?? this.created,
      modified: modified ?? this.modified,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (client.present) {
      map['client'] = Variable<String>(client.value);
    }
    if (data.present) {
      map['data'] = Variable<String>(data.value);
    }
    if (created.present) {
      map['created'] = Variable<DateTime>(created.value);
    }
    if (modified.present) {
      map['modified'] = Variable<DateTime>(modified.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('StructCompanion(')
          ..write('id: $id, ')
          ..write('client: $client, ')
          ..write('data: $data, ')
          ..write('created: $created, ')
          ..write('modified: $modified')
          ..write(')'))
        .toString();
  }
}

abstract class _$StructDatabase extends GeneratedDatabase {
  _$StructDatabase(QueryExecutor e) : super(e);
  late final $StructTable struct = $StructTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [struct];
}
