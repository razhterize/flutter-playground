import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:sqlite3/sqlite3.dart';
import 'package:sqlite3_flutter_libs/sqlite3_flutter_libs.dart';

import 'package:flutter_playground/common/logger.dart';

part 'struct.g.dart';

class Struct extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get client => text().named('client')();
  TextColumn get data => text()();
  DateTimeColumn get created => dateTime()();
  DateTimeColumn get modified => dateTime()();
}

@DriftDatabase(tables: [Struct])
class StructDatabase extends _$StructDatabase {
  StructDatabase() : super(_initialize());

  @override
  int get schemaVersion => 1;
}

LazyDatabase _initialize() {
  logger.i("Database Initialization started");
  return LazyDatabase(() async {
    Directory appDir = await getApplicationDocumentsDirectory();
    Directory cacheDir = await getApplicationCacheDirectory();

    final dbFile = File(p.join(appDir.path, 'data.sqlite'));

    Platform.isAndroid ? await applyWorkaroundToOpenSqlite3OnOldAndroidVersions() : null;
    sqlite3.tempDirectory = cacheDir.path;
    return NativeDatabase.createInBackground(dbFile);
  });
}
