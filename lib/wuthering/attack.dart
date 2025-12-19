import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:ww_optimizer/wuthering/damage.dart';
import 'package:ww_optimizer/core/types.dart';

part 'attack.g.dart';

@JsonSerializable()
class Attack extends Equatable {
  final String name;
  final List<Damage> damages;
  final List<DamageType> damageType;

  const Attack({this.name = "", this.damages = const [], this.damageType = const []});

  Attack copyWith({
    String? name,
    List<Damage>? damages,
    List<DamageType>? damageType,
  }) {
    return Attack(
      name: name ?? this.name,
      damages: damages ?? this.damages,
      damageType: damageType ?? this.damageType,
    );
  }

  factory Attack.fromJson(JsonType json) => _$AttackFromJson(json);
  JsonType toJson() => _$AttackToJson(this);

  @override
  List<Object?> get props => [name, damages, damageType];
}

@JsonSerializable()
class Skill extends Equatable {
  final String name;
  final String description;
  List<Attack> attacks;

  Skill({this.name = "", this.description = "", this.attacks = const []});

  Skill copyWith({String? name, String? description, List<Attack>? attacks}) {
    return Skill(
      name: name ?? this.name,
      description: description ?? this.description,
      attacks: attacks ?? this.attacks,
    );
  }

  factory Skill.fromJson(JsonType json) => _$SkillFromJson(json);
  JsonType toJson() => _$SkillToJson(this);

  @override
  List<Object?> get props => [name, description, attacks];
}
