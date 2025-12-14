// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'weapon.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Weapon _$WeaponFromJson(Map<String, dynamic> json) => Weapon(
  id: (json['id'] as num?)?.toInt() ?? 0,
  name: json['name'] as String? ?? "",
  type:
      $enumDecodeNullable(_$WeaponTypeEnumMap, json['type']) ??
      WeaponType.Sword,
  stats:
      (json['stats'] as List<dynamic>?)
          ?.map((e) => StatValue.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  buffs:
      (json['buffs'] as List<dynamic>?)
          ?.map((e) => Buff.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
);

Map<String, dynamic> _$WeaponToJson(Weapon instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'type': _$WeaponTypeEnumMap[instance.type]!,
  'stats': instance.stats,
  'buffs': instance.buffs,
};

const _$WeaponTypeEnumMap = {
  WeaponType.None: 'None',
  WeaponType.Sword: 'Sword',
  WeaponType.Broadblade: 'Broadblade',
  WeaponType.Gauntlet: 'Gauntlet',
  WeaponType.Rectifier: 'Rectifier',
  WeaponType.Pistol: 'Pistol',
};
