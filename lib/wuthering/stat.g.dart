// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stat.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StatValue _$StatValueFromJson(Map<String, dynamic> json) => StatValue(
  StatName.fromJson(json['name'] as Map<String, dynamic>),
  (json['value'] as num).toDouble(),
  appliesOnlyTo: $enumDecodeNullable(
    _$DamageTypeEnumMap,
    json['appliesOnlyTo'],
  ),
);

Map<String, dynamic> _$StatValueToJson(StatValue instance) => <String, dynamic>{
  'name': instance.name,
  'value': instance.value,
  'appliesOnlyTo': _$DamageTypeEnumMap[instance.appliesOnlyTo],
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

StatName _$StatNameFromJson(Map<String, dynamic> json) =>
    StatName((json['value'] as num).toInt());

Map<String, dynamic> _$StatNameToJson(StatName instance) => <String, dynamic>{
  'value': instance.value,
};
