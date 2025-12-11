// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sonata.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SonataEffect _$SonataEffectFromJson(Map<String, dynamic> json) => SonataEffect(
  sonata: $enumDecodeNullable(_$SonataEnumMap, json['sonata']) ?? Sonata.None,
  requiredEchoes: (json['requiredEchoes'] as num?)?.toInt() ?? 5,
);

Map<String, dynamic> _$SonataEffectToJson(SonataEffect instance) =>
    <String, dynamic>{
      'sonata': _$SonataEnumMap[instance.sonata]!,
      'requiredEchoes': instance.requiredEchoes,
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
