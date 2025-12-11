import 'package:json_annotation/json_annotation.dart';
import 'package:ww_optimizer/core/types.dart';
import 'package:ww_optimizer/core/wuthering/buff.dart';
import 'package:ww_optimizer/core/wuthering/attack.dart';
import 'package:ww_optimizer/core/wuthering/stat.dart';
import 'package:ww_optimizer/core/wuthering/weapon.dart';

part 'resonator.g.dart';

@JsonSerializable()
class Resonator {
  final String name;
  final WeaponType weaponType;
  final ElementType elementType;
  List<Skill> skills;
  BuffList buffs;
  StatList stats;
  Resonator({
    this.name = "",
    this.weaponType = WeaponType.None,
    this.elementType = ElementType.None,
    this.skills = const [],
    this.buffs = const [],
    this.stats = const [],
  });
  factory Resonator.fromJson(JsonType json) => _$ResonatorFromJson(json);
  JsonType toJson() => _$ResonatorToJson(this);
}
