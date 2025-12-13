import 'dart:convert';
import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ww_optimizer/core/types.dart';
import 'package:ww_optimizer/paths.dart';
import 'package:ww_optimizer/repository/saved_repository.dart';

class SavedDataCubit extends Cubit<SavedState> {
  SavedDataCubit() : super(const SavedState()) {
    loadData();
  }

  SavedRepository _savedRepository = SavedRepository();

  void loadData([String? path]) {
    emit(state.copyWith(true));
    _savedRepository.loadData(path);
    emit(state.copyWith(false, _savedRepository.savedData));
  }

  void saveData() => _savedRepository.saveData();
}

class SavedState extends Equatable {
  final JsonType rawData;
  final bool processing;
  const SavedState([this.processing = false, this.rawData = const {}]);

  List<JsonType> get resonators => _getFields("resonators");
  List<JsonType> get echoes => _getFields("echoes");
  List<JsonType> get weapons => _getFields("weapons");

  List<JsonType> _getFields(String key) {
    if (rawData.containsKey(key) && rawData[key].isNotEmpty) {
      final jsonList = (rawData[key] as List)
          .map((resonatorEntry) => JsonType.from(resonatorEntry))
          .toList();
      return jsonList;
    }
    return <JsonType>[];
  }

  SavedState copyWith([bool? processing, JsonType? rawData]) {
    return SavedState(processing ?? this.processing, rawData ?? this.rawData);
  }

  @override
  List<Object?> get props => [processing, rawData];
}
