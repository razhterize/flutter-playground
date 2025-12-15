import 'package:json_annotation/json_annotation.dart';
import 'package:ww_optimizer/core/types.dart';
import 'package:ww_optimizer/wuthering/buff.dart';
import 'package:ww_optimizer/wuthering/attack.dart';
import 'package:ww_optimizer/wuthering/stat.dart';
import 'package:ww_optimizer/wuthering/weapon.dart';

part 'resonator.g.dart';

@JsonSerializable()
class Resonator {
  int id;
  final String name;
  final WeaponType weaponType;
  final ElementType elementType;
  int level;
  List<Skill> skills;
  BuffList buffs;
  @JsonKey(fromJson: _statMapFromJson, toJson: _statMapToJson)
  StatMap stats;
  Resonator({
    this.name = "",
    this.id = 0,
    this.weaponType = WeaponType.None,
    this.elementType = ElementType.None,
    this.level = 90,
    this.skills = const [],
    this.buffs = const [],
    this.stats = const {},
  });
  factory Resonator.fromJson(JsonType json) => _$ResonatorFromJson(json);
  JsonType toJson() => _$ResonatorToJson(this);
}

StatMap _statMapFromJson(JsonType json) {
  StatMap statMap = {};
  for (var entry in json.entries) {
    var key = StatName.values
        .where((statIdx) => "${statIdx.index}" == entry.key)
        .first;
    statMap.update(
      key,
      (v) => entry.value is double
          ? entry.value
          : double.tryParse(entry.value) ?? 0,
      ifAbsent: () => entry.value is double
          ? entry.value
          : double.tryParse(entry.value) ?? 0,
    );
  }
  return statMap;
}

JsonType _statMapToJson(StatMap statMap) {
  JsonType _json = {};
  for (var entry in statMap.entries) {
    _json.update(
      '${entry.key.index}',
      (v) => entry.value,
      ifAbsent: () => entry.value,
    );
  }
  return _json;
}
