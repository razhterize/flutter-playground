part of '../wuthering.dart';

@JsonSerializable()
class Weapon {
  final int id;
  final String name;
  final WeaponType type;
  final StatList stats;
  final BuffList buffs;

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
