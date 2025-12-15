import 'dart:developer';
import 'dart:io';
import 'dart:convert';
import 'package:ww_optimizer/core/types.dart';
import 'package:ww_optimizer/wuthering/echo.dart';
import 'package:ww_optimizer/wuthering/stat.dart';
import 'package:ww_optimizer/wuthering/weapon.dart';
import 'package:ww_optimizer/wuthering/resonator.dart';
import 'package:ww_optimizer/logger.dart';
import 'package:ww_optimizer/paths.dart';

class SavedRepository {
  SavedRepository({String? path}) {
    _log.debug("Init");
    path ??= assetDir.join("data.json");
    _savedFile = File(path);
    if (!_savedFile.existsSync()) _savedFile.createSync();
  }
  final _log = Logger("SavedRepo");
  JsonType _savedData = {};
  late File _savedFile;

  JsonType get savedData => _savedData;

  set echoes(List<JsonType> jsonEchoes) => _savedData["echoes"] = jsonEchoes;
  set resonators(List<JsonType> jsonResonator) =>
      _savedData["resonators"] = jsonResonator;
  set weapons(List<JsonType> jsonWeapons) =>
      _savedData["weapons"] = jsonWeapons;

  void loadData([String? path]) {
    path ??= assetDir.join("data.json");
    _savedFile = File(path);
    if (!_savedFile.existsSync()) _savedFile.createSync();
    if (_savedFile.readAsStringSync().isEmpty) {
      _savedFile.writeAsStringSync(
        jsonEncode({"resonators": [], "echoes": [], "weapons": []}),
      );
    }
    _savedData = jsonDecode(_savedFile.readAsStringSync());
    // Check required keys
    const keys = ["resonators", "weapons"];
    for (var k in keys) {
      if (!_savedData.containsKey(k) || (_savedData[k] as List).isEmpty) {
        _writeDefaultValues();
        saveData();
      }
    }
  }

  void saveData() {
    String _json = jsonEncode(_savedData);
    _savedFile.writeAsString(_json);
  }

  void _writeDefaultValues() {
    try {
      // Resonator first
      Directory(
        assetDir.join("resonators"),
      ).listSync().whereType<File>().forEach((f) {
        _log.debug("Reading ${f.path}");
        final _json = jsonDecode(f.readAsStringSync());
        Resonator newResonator = Resonator(
          name: _json['name'],
          elementType: ElementType.values.firstWhere(
            (e) => e.name == _json["element"],
          ),
          weaponType: WeaponType.values.firstWhere(
            (w) => w.name == _json["weaponType"],
          ),
        );
        (_savedData["resonators"] as List).add(newResonator.toJson());
      });

      // Then Weapon
      Directory(assetDir.join("weapons")).listSync().whereType<File>().forEach((
        f,
      ) {
        _log.debug("Reading ${f.path}");
        final _json = jsonDecode(f.readAsStringSync());
        Weapon newWeapon = Weapon(
          name: _json['name'],
          type: WeaponType.values.firstWhere((w) => w.name == _json['type']),
        );
        (_savedData["weapons"] as List).add(newWeapon.toJson());
      });
      saveData();
    } catch (e) {
      _log.error(e.toString(), st: .current);
    }
  }
}
