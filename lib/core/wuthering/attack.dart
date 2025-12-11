import 'package:json_annotation/json_annotation.dart';
import 'package:ww_optimizer/core/wuthering/buff.dart';
import 'package:ww_optimizer/core/wuthering/stat.dart';
import 'package:ww_optimizer/core/wuthering/damage.dart';
import 'package:ww_optimizer/core/types.dart';

part 'attack.g.dart';

@JsonSerializable()
class Attack {
  final String name;
  DamageList damages;
  DamageType? damageType;

  Attack({this.name = "", this.damages = const [], this.damageType});
  factory Attack.fromJson(JsonType json) => _$AttackFromJson(json);
  JsonType toJson() => _$AttackToJson(this);
}

@JsonSerializable()
class Skill {
  final String name;
  final String description;
  List<Attack> attacks;

  Skill({this.name = "", this.description = "", this.attacks = const []});

  factory Skill.fromJson(JsonType json) => _$SkillFromJson(json);
  JsonType toJson() => _$SkillToJson(this);
}
