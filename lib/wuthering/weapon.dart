import 'package:json_annotation/json_annotation.dart';
import 'package:ww_optimizer/core/types.dart';
import 'package:ww_optimizer/wuthering/buff.dart';
import 'package:ww_optimizer/wuthering/stat.dart';

part 'weapon.g.dart';

@JsonSerializable()
class Weapon {
  int id;
  final String name;
  final WeaponType type;
  StatList stats;
  BuffList buffs;

  Weapon({
    this.id = 0,
    this.name = "",
    this.type = WeaponType.Sword,
    this.stats = const [],
    this.buffs = const [],
  });
  factory Weapon.fromJson(JsonType json) => _$WeaponFromJson(json);
  JsonType toJson() => _$WeaponToJson(this);
}

enum WeaponType { None, Sword, Broadblade, Gauntlet, Rectifier, Pistol }
