import 'dart:convert';
import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ww_optimizer/core/types.dart';
import 'package:ww_optimizer/paths.dart';

class SavedDataCubit extends Cubit<JsonType> {
  SavedDataCubit() : super({}) {
    if (!_dataFile.existsSync()) {
      _dataFile.createSync();
      _dataFile.writeAsStringSync(jsonEncode({} as Map));
    }
    loadData();
  }

  File _dataFile = File("${getRootDir()}/data.json");

  void loadData([String? path]) {
    if (path != null) {
      assert(path.endsWith(".json"));
      _dataFile = File(path);
      emit(jsonDecode(_dataFile.readAsStringSync()));
    }
  }

  void saveData() => _dataFile.writeAsStringSync(jsonEncode(state), flush: true);
}
