part of '../wuthering.dart';

@JsonSerializable()
class Weapon {
  final int id;
  final String name;
  final int level;
  final WeaponType type;
  final StatList stats;
  final BuffList buffs;

  Weapon({
    this.id = 0,
    this.name = "",
    this.level = 90,
    this.type = WeaponType.Sword,
    this.stats = const [],
    this.buffs = const [],
  });

  Weapon copyWith({
    int? id,
    String? name,
    int? level,
    WeaponType? type,
    StatList? stats,
    BuffList? buffs,
  }) {
    return Weapon(
      id: id ?? this.id,
      name: name ?? this.name,
      level: level ?? this.level,
      type: type ?? this.type,
      stats: stats ?? this.stats,
      buffs: buffs ?? this.buffs,
    );
  }

  factory Weapon.fromJson(JsonType json) => _$WeaponFromJson(json);
  JsonType toJson() => _$WeaponToJson(this);
}

enum WeaponType { None, Sword, Broadblade, Gauntlet, Rectifier, Pistol }
