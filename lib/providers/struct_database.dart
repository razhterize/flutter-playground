import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:isar/isar.dart';
import 'package:flutter_playground/models/struct_model.dart';

class StructProvider {
  final Isar isar;
  final Directory dataDir;
  late final IsarCollection<Struct> accessor;

  StructProvider._created({required this.isar, required this.dataDir}) {
    accessor = isar.structs;
  }

  static Future<StructProvider> init() async {
    final directory = await getApplicationSupportDirectory();
    final isar = await Isar.open([StructSchema], directory: directory.path);
    var instance = StructProvider._created(isar: isar, dataDir: directory);
    return instance;
  }

  Future<List<Struct>> get all async => _fetchAllStructs();

  Future<Struct?> get first async => await accessor.where().findFirst();

  Future<Struct?> get last async => await accessor.where(sort: Sort.desc).findFirst();

  Future<Struct?> add(Struct struct) async => await _addStruct(struct);
  Future<bool> delete(Struct struct) async => await _deleteStruct(struct);
  Future<Struct?> edit(Struct struct) async => await _editStruct(struct);

  Future<List<Struct>> _fetchAllStructs() async => await accessor.where().findAll();

  Future<Struct?> _addStruct(Struct struct) async {
    await isar.writeTxn(() async {
      await accessor.put(struct);
    });
    return await accessor.get(struct.id);
  }

  Future<Struct?> _editStruct(Struct struct) async {
    Struct? currentStruct = await accessor.get(struct.id);
    if (currentStruct != null) {
      await isar.writeTxn(() async {
        await accessor.put(struct);
      });
      return await accessor.get(struct.id);
    }
    return null;
  }

  Future<bool> _deleteStruct(Struct struct) async {
    Struct? currentStruct = await accessor.get(struct.id);
    if (currentStruct != null) {
      return await accessor.delete(struct.id);
    }
    return false;
  }
}
