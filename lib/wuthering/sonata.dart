// ignore_for_file: constant_identifier_names
import 'package:json_annotation/json_annotation.dart';
import 'package:ww_optimizer/core/enum_flag.dart';
import 'package:ww_optimizer/core/types.dart';
import 'package:ww_optimizer/wuthering/buff.dart';
import 'package:ww_optimizer/wuthering/echo.dart';
import 'package:ww_optimizer/wuthering/stat.dart';

part 'sonata.g.dart';

Map<Sonata, String> sonataNames = {
  Sonata.FreezingFrost: "Freezing Frost",
  Sonata.MoltenRift: "Molten Rift",
  Sonata.VoidThunder: "Void Thunder",
  Sonata.SierraGale: "Sierra Gale",
  Sonata.CelestialLight: "Celestial Light",
  Sonata.HavocEclipse: "Havoc Eclipse",
  Sonata.RejuvenatingGlow: "Resjuvenating Glow",
  Sonata.MoonlitClouds: "Moonlit Clouds",
  Sonata.LingeringTunes: "Lingering Tunes",
  Sonata.FrostyResolve: "Frosty Resolve",
  Sonata.EternalRadiance: "Eternal Radiance",
  Sonata.MidnightVeil: "Midnight Veil",
  Sonata.TidebreakingCourage: "Tidebreaking Courage",
  Sonata.EmpyreanAnthem: "Empyrean Anthem",
  Sonata.GustsOfWelkin: "Gusts of Welkin",
  Sonata.WindwardPilgrimage: "Windward Pilgrimage",
  Sonata.FlamingClawprint: "Flaming Clawprint",
  Sonata.DreamsOfTheLost: "Dreams of the Lost",
  Sonata.CrownOfValor: "Crown of Valor",
  Sonata.LawOfHarmony: "Law of Harmony",
  Sonata.FlamewingShadow: "Flamewing's Shadow",
  Sonata.ThreadOfSeveredFate: "Thread of Severed Fate",
};

@JsonSerializable()
class SonataEffect {
  final Sonata sonata;
  final int requiredEchoes;
  StatList _stats;
  BuffList _buffs;

  SonataEffect({
    this.sonata = Sonata.None,
    this.requiredEchoes = 5,
    StatList stats = const [],
    BuffList buffs = const [],
  }) : _buffs = buffs,
       _stats = stats;

  String get name => sonataNames[sonata] ?? "Unknown Sonata";
  BuffList getBuffs(List<Echo> echoes) => _metRequirements(echoes) ? _buffs : [];
  StatList getStats(List<Echo> echoes) => _metRequirements(echoes) ? _stats : [];

  bool _metRequirements(List<Echo> echoes) {
    int numberMatch = 0;
    for (Echo e in echoes) {
      numberMatch += (e.sonata == sonata) ? 1 : 0;
    }
    return numberMatch >= requiredEchoes;
  }

  factory SonataEffect.fromJson(JsonType json) => _$SonataEffectFromJson(json);
  JsonType toJson() => _$SonataEffectToJson(this);
}

Map<Sonata, List<SonataEffect>> presetSonataEffects = {
  Sonata.FreezingFrost: [
    SonataEffect(sonata: .FreezingFrost, requiredEchoes: 2, stats: [StatValue(.GlacioDamage, 10)]),
    SonataEffect(
      sonata: .FreezingFrost,
      requiredEchoes: 5,
      buffs: [
        Buff(stats: [StatValue(.GlacioDamage, 10)], maxStack: 3),
      ],
    ),
  ],
  Sonata.SierraGale: [
    SonataEffect(sonata: .SierraGale, requiredEchoes: 2, stats: [StatValue(.AeroDamage, 10)]),
    SonataEffect(
      sonata: .SierraGale,
      requiredEchoes: 5,
      buffs: [
        Buff(stats: [StatValue(.AeroDamage, 30)]),
      ],
    ),
  ],
  Sonata.MoltenRift: [
    SonataEffect(sonata: .MoltenRift, requiredEchoes: 2, stats: [StatValue(.FusionDamage, 10)]),
    SonataEffect(
      sonata: .MoltenRift,
      buffs: [
        Buff(stats: [StatValue(.FusionDamage, 30)]),
      ],
    ),
  ],
  Sonata.VoidThunder: [
    SonataEffect(sonata: .VoidThunder, requiredEchoes: 2, stats: [StatValue(.ElectroDamage, 10)]),
    SonataEffect(
      sonata: .VoidThunder,

      buffs: [
        Buff(stats: [StatValue(.ElectroDamage, 15)], maxStack: 2),
      ],
    ),
  ],
  Sonata.CelestialLight: [
    SonataEffect(
      sonata: .CelestialLight,
      requiredEchoes: 2,
      stats: [StatValue(.SpectroDamage, 10)],
    ),
    SonataEffect(
      sonata: .CelestialLight,

      buffs: [
        Buff(stats: [StatValue(StatName.SpectroDamage, 30)]),
      ],
    ),
  ],
  Sonata.HavocEclipse: [
    SonataEffect(sonata: .HavocEclipse, requiredEchoes: 2, stats: [StatValue(.HavocDamage, 10)]),
    SonataEffect(
      sonata: .HavocEclipse,
      buffs: [
        Buff(stats: [StatValue(.HavocDamage, 7.5)], maxStack: 4),
      ],
    ),
  ],
  Sonata.RejuvenatingGlow: [
    SonataEffect(
      sonata: .RejuvenatingGlow,
      requiredEchoes: 2,
      stats: [StatValue(.HealingBonus, 10)],
    ),
    SonataEffect(
      sonata: .RejuvenatingGlow,
      buffs: [
        Buff(stats: [StatValue(.ATKPercent, 15)]),
      ],
    ),
  ],
  Sonata.MoonlitClouds: [
    SonataEffect(sonata: .MoonlitClouds, requiredEchoes: 2, stats: [StatValue(.EnergyRegen, 10)]),
    SonataEffect(
      sonata: .MoonlitClouds,
      buffs: [
        Buff(stats: [StatValue(.ATKPercent, 22.5)], target: .Ally),
      ],
    ),
  ],
  Sonata.LingeringTunes: [
    SonataEffect(sonata: .LingeringTunes, requiredEchoes: 2, stats: [StatValue(.ATKPercent, 10)]),
    SonataEffect(
      sonata: .LingeringTunes,
      stats: [StatValue(.OutroDamage, 60)],
      buffs: [
        Buff(stats: [StatValue(StatName.ATKPercent, 5)], maxStack: 4),
      ],
    ),
  ],
  // TODO: Finish sonata
  Sonata.FrostyResolve: [
    SonataEffect(
      sonata: .FrostyResolve,
      requiredEchoes: 2,
      stats: [StatValue(.ResonanceDamage, 12)],
    ),
    SonataEffect(
      sonata: Sonata.FrostyResolve,
      buffs: [
        Buff(stats: [StatValue(.GlacioDamage, 22.5)]),
        Buff(stats: [StatValue(.ResonanceDamage, 18)], maxStack: 2),
      ],
    ),
  ],
  Sonata.EternalRadiance: [
    SonataEffect(
      sonata: .EternalRadiance,
      requiredEchoes: 2,
      stats: [StatValue(.SpectroDamage, 10)],
    ),
    SonataEffect(
      sonata: .EternalRadiance,
      buffs: [
        Buff(stats: [StatValue(StatName.CritRate, 20)]),
        Buff(stats: [StatValue(.SpectroDamage, 10)]),
      ],
    ),
  ],
  Sonata.MidnightVeil: [
    SonataEffect(sonata: .MidnightVeil, requiredEchoes: 2, stats: [StatValue(.HavocDamage, 10)]),
    SonataEffect(
      sonata: .MidnightVeil,
      buffs: [
        Buff(stats: [StatValue(.HavocDamage, 15)], target: .Team),
      ],
    ),
  ],
  Sonata.TidebreakingCourage: [
    SonataEffect(
      sonata: .TidebreakingCourage,
      requiredEchoes: 2,
      stats: [StatValue(.EnergyRegen, 10)],
    ),
    SonataEffect(
      sonata: .TidebreakingCourage,
      stats: [StatValue(.EnergyRegen, 10)],
      //   TODO: Figure out something with conditional buff
      buffs: [
        Buff(
          stats: [
            StatValue(.AeroDamage, 30),
            StatValue(.ElectroDamage, 30),
            StatValue(.GlacioDamage, 30),
            StatValue(.FusionDamage, 30),
            StatValue(.SpectroDamage, 30),
            StatValue(.HavocDamage, 30),
          ],
        ),
      ],
    ),
  ],
  Sonata.EmpyreanAnthem: [
    SonataEffect(sonata: .EmpyreanAnthem, requiredEchoes: 2, stats: [StatValue(.EnergyRegen, 10)]),
    SonataEffect(
      sonata: .EmpyreanAnthem,
      stats: [StatValue(.CoordinatedAttackDamage, 80)],
      buffs: [
        Buff(stats: [StatValue(.ATKPercent, 20)], target: .Ally),
      ],
    ),
  ],
  Sonata.GustsOfWelkin: [
    SonataEffect(sonata: .GustsOfWelkin, requiredEchoes: 2, stats: [StatValue(.AeroDamage, 10)]),
    SonataEffect(
      sonata: .GustsOfWelkin,
      buffs: [
        Buff(stats: [StatValue(.AeroDamage, 15)], target: .Team),
        Buff(stats: [StatValue(.AeroDamage, 15)], target: .Self),
      ],
    ),
  ],
  Sonata.WindwardPilgrimage: [
    SonataEffect(
      sonata: .WindwardPilgrimage,
      requiredEchoes: 2,
      stats: [StatValue(.AeroDamage, 10)],
    ),
    SonataEffect(
      sonata: .WindwardPilgrimage,
      buffs: [
        Buff(stats: [StatValue(.CritRate, 10), StatValue(.AeroDamage, 30)]),
      ],
    ),
  ],
  Sonata.FlamingClawprint: [
    SonataEffect(
      sonata: .FlamingClawprint,
      requiredEchoes: 2,
      buffs: [
        Buff(stats: [StatValue(.FusionDamage, 10)]),
      ],
    ),
    SonataEffect(
      sonata: .FlamingClawprint,
      buffs: [
        Buff(stats: [StatValue(.FusionDamage, 15)], target: .Team),
        Buff(stats: [StatValue(.LiberationDamage, 20)], target: .Self),
      ],
    ),
  ],
  Sonata.DreamsOfTheLost: [
    SonataEffect(
      sonata: .DreamsOfTheLost,
      requiredEchoes: 3,
      buffs: [
        Buff(stats: [StatValue(.CritRate, 20), StatValue(.EchoDamage, 35)]),
      ],
    ),
  ],
  Sonata.CrownOfValor: [
    SonataEffect(
      sonata: .CrownOfValor,
      requiredEchoes: 3,
      buffs: [
        Buff(stats: [StatValue(.ATKPercent, 6), StatValue(.CritDamage, 4)], maxStack: 5),
      ],
    ),
  ],
  Sonata.LawOfHarmony: [
    SonataEffect(
      sonata: .LawOfHarmony,
      requiredEchoes: 3,
      buffs: [
        Buff(stats: [StatValue(.HeavyAttackDamage, 30)]),
        Buff(stats: [StatValue(.EchoDamage, 4)], maxStack: 4),
      ],
    ),
  ],
  Sonata.FlamewingShadow: [
    SonataEffect(
      sonata: .FlamewingShadow,
      requiredEchoes: 3,
      buffs: [
        Buff(stats: [StatValue(.CritRate, 20, appliesOnlyTo: [.HeavyAttack])]),
        Buff(stats: [StatValue(.CritRate, 20, appliesOnlyTo: [.Echo])]),
        Buff(stats: [StatValue(.FusionDamage, 16)]),
      ],
    ),
  ],
  Sonata.ThreadOfSeveredFate: [
    SonataEffect(
      sonata: .ThreadOfSeveredFate,
      requiredEchoes: 3,
      buffs: [
        Buff(stats: [StatValue(.ATKPercent, 20), StatValue(.LiberationDamage, 30)]),
      ],
    ),
  ],
};

@JsonEnum(valueField: "index")
enum Sonata with EnumFlag {
  FreezingFrost,
  MoltenRift,
  VoidThunder,
  SierraGale,
  CelestialLight,
  HavocEclipse,
  RejuvenatingGlow,
  MoonlitClouds,
  LingeringTunes,
  FrostyResolve,
  EternalRadiance,
  MidnightVeil,
  TidebreakingCourage,
  EmpyreanAnthem,
  GustsOfWelkin,
  WindwardPilgrimage,
  FlamingClawprint,
  DreamsOfTheLost,
  CrownOfValor,
  LawOfHarmony,
  FlamewingShadow,
  ThreadOfSeveredFate,
  None,
}
