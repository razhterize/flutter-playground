// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'damage.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Damage _$DamageFromJson(Map<String, dynamic> json) => Damage(
  multiplier: (json['multiplier'] as num?)?.toDouble() ?? 0,
  hitCount: (json['hitCount'] as num?)?.toInt() ?? 1,
  damageType:
      $enumDecodeNullable(_$DamageTypeEnumMap, json['damageType']) ??
      DamageType.Raw,
  isFlat: json['isFlat'] as bool? ?? false,
  source: json['source'] == null
      ? StatName.ATK
      : StatName.fromJson(json['source'] as Map<String, dynamic>),
);

Map<String, dynamic> _$DamageToJson(Damage instance) => <String, dynamic>{
  'multiplier': instance.multiplier,
  'hitCount': instance.hitCount,
  'damageType': _$DamageTypeEnumMap[instance.damageType]!,
  'isFlat': instance.isFlat,
  'source': instance.source,
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
