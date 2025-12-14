// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'resonator.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Resonator _$ResonatorFromJson(Map<String, dynamic> json) => Resonator(
  name: json['name'] as String? ?? "",
  id: (json['id'] as num?)?.toInt() ?? 0,
  weaponType:
      $enumDecodeNullable(_$WeaponTypeEnumMap, json['weaponType']) ??
      WeaponType.None,
  elementType:
      $enumDecodeNullable(_$ElementTypeEnumMap, json['elementType']) ??
      ElementType.None,
  level: (json['level'] as num?)?.toInt() ?? 90,
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
  'id': instance.id,
  'name': instance.name,
  'weaponType': _$WeaponTypeEnumMap[instance.weaponType]!,
  'elementType': _$ElementTypeEnumMap[instance.elementType]!,
  'level': instance.level,
  'skills': instance.skills,
  'buffs': instance.buffs,
  'stats': instance.stats,
};

const _$WeaponTypeEnumMap = {
  WeaponType.None: 'None',
  WeaponType.Sword: 'Sword',
  WeaponType.Broadblade: 'Broadblade',
  WeaponType.Gauntlet: 'Gauntlet',
  WeaponType.Rectifier: 'Rectifier',
  WeaponType.Pistol: 'Pistol',
};

const _$ElementTypeEnumMap = {
  ElementType.None: 'None',
  ElementType.Glacio: 'Glacio',
  ElementType.Fusion: 'Fusion',
  ElementType.Electro: 'Electro',
  ElementType.Aero: 'Aero',
  ElementType.Spectro: 'Spectro',
  ElementType.Havoc: 'Havoc',
};
