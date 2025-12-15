import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ww_optimizer/core/types.dart';
import 'package:ww_optimizer/repository/saved_repository.dart';
import 'package:ww_optimizer/wuthering/echo.dart';
import 'package:ww_optimizer/wuthering/resonator.dart';
import 'package:ww_optimizer/wuthering/weapon.dart';

class SavedDataCubit extends Cubit<SavedState> {
  SavedDataCubit() : super(const SavedState()) {
    loadData();

    // only save every second
    _saveTimer = Timer.periodic(Duration(seconds: 1), (_) => saveData());
  }

  final _savedRepository = SavedRepository();
  late final Timer _saveTimer;
  bool _saveFlag = false;

  void loadData([String? path]) {
    emit(state.copyWith(true));
    _savedRepository.loadData(path);
    emit(state.copyWith(false, _savedRepository.savedData));
  }

  void saveEcho(List<Echo> echoList) {
    _savedRepository.echoes = echoList.map((e) => e.toJson()).toList();
    _saveFlag = true;
  }

  void saveWeapons(List<Weapon> weaponList) {
    _savedRepository.weapons = weaponList.map((w) => w.toJson()).toList();
    _saveFlag = true;
  }

  void saveResonator(List<Resonator> resonatorList) {
    _savedRepository.resonators = resonatorList.map((r) => r.toJson()).toList();
    _saveFlag = true;
  }

  void saveData() {
    if (_saveFlag) {
      _savedRepository.saveData();
      _saveFlag = false;
    }
  }

  @override
  Future<void> close() {
    _saveTimer.cancel();
    return super.close();
  }
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
