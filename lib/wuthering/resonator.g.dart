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
      (json['stats'] as Map<String, dynamic>?)?.map(
        (k, e) =>
            MapEntry($enumDecode(_$StatNameEnumMap, k), (e as num).toDouble()),
      ) ??
      const {},
);

Map<String, dynamic> _$ResonatorToJson(Resonator instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'weaponType': _$WeaponTypeEnumMap[instance.weaponType]!,
  'elementType': _$ElementTypeEnumMap[instance.elementType]!,
  'level': instance.level,
  'skills': instance.skills,
  'buffs': instance.buffs,
  'stats': instance.stats.map((k, e) => MapEntry(_$StatNameEnumMap[k]!, e)),
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

const _$StatNameEnumMap = {
  StatName.None: 0,
  StatName.ATK: 1,
  StatName.DEF: 2,
  StatName.HP: 3,
  StatName.FlatATK: 4,
  StatName.ATKPercent: 5,
  StatName.DEFPercent: 6,
  StatName.HPPercent: 7,
  StatName.CritRate: 8,
  StatName.CritDamage: 9,
  StatName.EnergyRegen: 10,
  StatName.HealingBonus: 11,
  StatName.AeroDamage: 12,
  StatName.ElectroDamage: 13,
  StatName.FusionDamage: 14,
  StatName.GlacioDamage: 15,
  StatName.HavocDamage: 16,
  StatName.SpectroDamage: 17,
  StatName.BasicAttackDamage: 18,
  StatName.HeavyAttackDamage: 19,
  StatName.ResonanceDamage: 20,
  StatName.LiberationDamage: 21,
  StatName.CoordinatedAttackDamage: 22,
  StatName.IntroDamage: 23,
  StatName.OutroDamage: 24,
  StatName.EchoDamage: 25,
  StatName.SpectroFrazzleDamage: 26,
  StatName.AeroErosionDamage: 27,
  StatName.GlacioChafeDamage: 28,
  StatName.ElectroFlareDamage: 29,
  StatName.HavocBaneDamage: 30,
  StatName.FusionBurstDamage: 31,
  StatName.GeneralDamage: 32,
  StatName.AeroAmp: 33,
  StatName.ElectroAmp: 34,
  StatName.FusionAmp: 35,
  StatName.GlacioAmp: 36,
  StatName.HavocAmp: 37,
  StatName.SpectroAmp: 38,
  StatName.BasicAttackAmp: 39,
  StatName.HeavyAttackAmp: 40,
  StatName.ResonanceAmp: 41,
  StatName.LiberationAmp: 42,
  StatName.CoordinatedAttackAmp: 43,
  StatName.IntroAmp: 44,
  StatName.OutroAmp: 45,
  StatName.EchoAmp: 46,
  StatName.SpectroFrazzleAmp: 47,
  StatName.AeroErosionAmp: 48,
  StatName.ElectroFlareAmp: 49,
  StatName.GlacioChafeAmp: 50,
  StatName.HavocBaneAmp: 51,
  StatName.FusionBurstAmp: 52,
  StatName.GeneralAmp: 53,
  StatName.AeroRes: 54,
  StatName.ElectroRes: 55,
  StatName.FusionRes: 56,
  StatName.GlacioRes: 57,
  StatName.HavocRes: 58,
  StatName.SpectroRes: 59,
};
