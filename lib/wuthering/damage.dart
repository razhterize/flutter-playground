// ignore_for_file: constant_identifier_names

import 'package:json_annotation/json_annotation.dart';
import 'package:ww_optimizer/core/enum_flag.dart';
import 'package:ww_optimizer/core/types.dart';
import 'package:ww_optimizer/wuthering/stat.dart';

part 'damage.g.dart';

@JsonEnum(valueField: "index")
enum DamageType with EnumFlag {
  Raw,
  Healing,
  Spectro,
  Havoc,
  Electro,
  Aero,
  Glacio,
  Fusion,
  BasicAttack,
  HeavyAttack,
  Resonance,
  Liberation,
  SpectroFrazzle,
  AeroErosion,
  HavocBane,
  ElectroFlare,
  GlacioChafe,
  FusionBurst,
  Coordinated,
  Intro,
  Outro,
  Echo,
  TuneBreak,
}

typedef DamageList = List<Damage>;

@JsonSerializable()
class Damage {
  final double multiplier;
  final int hitCount;
  final DamageType damageType;
  final bool isFlat;
  final StatName? source;

  const Damage({
    this.multiplier = 0,
    this.hitCount = 1,
    this.damageType = DamageType.Raw,
    this.isFlat = false,
    this.source = .ATK, // ATK By default
  });

  factory Damage.fromJson(JsonType json) => _$DamageFromJson(json);
  JsonType toJson() => _$DamageToJson(this);
}
