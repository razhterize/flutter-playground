// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'resonator.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Resonator _$ResonatorFromJson(Map<String, dynamic> json) => Resonator(
  name: json['name'] as String? ?? "",
  weaponType:
      $enumDecodeNullable(_$WeaponTypeEnumMap, json['weaponType']) ??
      WeaponType.Sword,
  skills:
      (json['skills'] as List<dynamic>?)
          ?.map((e) => Skill.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  buffs:
      (json['buffs'] as List<dynamic>?)
          ?.map((e) => Buff.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  stats:
      (json['stats'] as List<dynamic>?)
          ?.map((e) => StatValue.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
);

Map<String, dynamic> _$ResonatorToJson(Resonator instance) => <String, dynamic>{
  'name': instance.name,
  'weaponType': _$WeaponTypeEnumMap[instance.weaponType]!,
  'skills': instance.skills,
  'buffs': instance.buffs,
  'stats': instance.stats,
};

const _$WeaponTypeEnumMap = {
  WeaponType.Sword: 'Sword',
  WeaponType.Broadblade: 'Broadblade',
  WeaponType.Gaunlet: 'Gaunlet',
  WeaponType.Rectifier: 'Rectifier',
  WeaponType.Pistol: 'Pistol',
};
