// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'attack.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Attack _$AttackFromJson(Map<String, dynamic> json) => Attack(
  name: json['name'] as String? ?? "",
  damages:
      (json['damages'] as List<dynamic>?)
          ?.map((e) => Damage.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  damageType: $enumDecodeNullable(_$DamageTypeEnumMap, json['damageType']),
);

Map<String, dynamic> _$AttackToJson(Attack instance) => <String, dynamic>{
  'name': instance.name,
  'damages': instance.damages,
  'damageType': _$DamageTypeEnumMap[instance.damageType],
};

const _$DamageTypeEnumMap = {
  DamageType.Raw: 0,
  DamageType.Healing: 1,
  DamageType.Spectro: 2,
  DamageType.Havoc: 3,
  DamageType.Electro: 4,
  DamageType.Aero: 5,
  DamageType.Glacio: 6,
  DamageType.Fusion: 7,
  DamageType.BasicAttack: 8,
  DamageType.HeavyAttack: 9,
  DamageType.Resonance: 10,
  DamageType.Liberation: 11,
  DamageType.SpectroFrazzle: 12,
  DamageType.AeroErosion: 13,
  DamageType.HavocBane: 14,
  DamageType.ElectroFlare: 15,
  DamageType.GlacioChafe: 16,
  DamageType.FusionBurst: 17,
  DamageType.Coordinated: 18,
  DamageType.Intro: 19,
  DamageType.Outro: 20,
  DamageType.Echo: 21,
  DamageType.TuneBreak: 22,
};

Skill _$SkillFromJson(Map<String, dynamic> json) => Skill(
  name: json['name'] as String? ?? "",
  description: json['description'] as String? ?? "",
  attacks:
      (json['attacks'] as List<dynamic>?)
          ?.map((e) => Attack.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
);

Map<String, dynamic> _$SkillToJson(Skill instance) => <String, dynamic>{
  'name': instance.name,
  'description': instance.description,
  'attacks': instance.attacks,
};
