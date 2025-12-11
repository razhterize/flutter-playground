// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'echo.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Echo _$EchoFromJson(Map<String, dynamic> json) => Echo(
  name: json['name'] as String? ?? "",
  buffs:
      (json['buffs'] as List<dynamic>?)
          ?.map((e) => Buff.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  cost: (json['cost'] as num?)?.toInt() ?? Echo.Cost1,
  substats:
      (json['substats'] as List<dynamic>?)
          ?.map((e) => StatValue.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  mainStats:
      (json['mainStats'] as List<dynamic>?)
          ?.map((e) => StatValue.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  sonata: $enumDecodeNullable(_$SonataEnumMap, json['sonata']) ?? Sonata.None,
  level: (json['level'] as num?)?.toInt() ?? 25,
);

Map<String, dynamic> _$EchoToJson(Echo instance) => <String, dynamic>{
  'name': instance.name,
  'buffs': instance.buffs,
  'substats': instance.substats,
  'cost': instance.cost,
  'sonata': _$SonataEnumMap[instance.sonata]!,
  'level': instance.level,
  'mainStats': instance.mainStats,
};

const _$SonataEnumMap = {
  Sonata.FreezingFrost: 0,
  Sonata.MoltenRift: 1,
  Sonata.VoidThunder: 2,
  Sonata.SierraGale: 3,
  Sonata.CelestialLight: 4,
  Sonata.HavocEclipse: 5,
  Sonata.RejuvenatingGlow: 6,
  Sonata.MoonlitClouds: 7,
  Sonata.LingeringTunes: 8,
  Sonata.FrostyResolve: 9,
  Sonata.EternalRadiance: 10,
  Sonata.MidnightVeil: 11,
  Sonata.TidebreakingCourage: 12,
  Sonata.EmpyreanAnthem: 13,
  Sonata.GustsOfWelkin: 14,
  Sonata.WindwardPilgrimage: 15,
  Sonata.FlamingClawprint: 16,
  Sonata.DreamsOfTheLost: 17,
  Sonata.CrownOfValor: 18,
  Sonata.LawOfHarmony: 19,
  Sonata.FlamewingShadow: 20,
  Sonata.ThreadOfSeveredFate: 21,
  Sonata.None: 22,
};
