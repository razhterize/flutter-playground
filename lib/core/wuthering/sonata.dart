part of '../wuthering.dart';

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
  BuffList getBuffs(List<Echo> echoes) =>
      _metRequirements(echoes) ? _buffs : [];
  StatList getStats(List<Echo> echoes) =>
      _metRequirements(echoes) ? _stats : [];

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
    SonataEffect(
      sonata: .FreezingFrost,
      requiredEchoes: 2,
      stats: [StatValue(name: .GlacioDamage, value: 10)],
    ),
    SonataEffect(
      sonata: .FreezingFrost,
      requiredEchoes: 5,
      buffs: [
        Buff(stats: [StatValue(name: .GlacioDamage, value: 10)], maxStack: 3),
      ],
    ),
  ],
  Sonata.SierraGale: [
    SonataEffect(
      sonata: .SierraGale,
      requiredEchoes: 2,
      stats: [StatValue(name: .AeroDamage, value: 10)],
    ),
    SonataEffect(
      sonata: .SierraGale,
      requiredEchoes: 5,
      buffs: [
        Buff(stats: [StatValue(name: .AeroDamage, value: 30)]),
      ],
    ),
  ],
  Sonata.MoltenRift: [
    SonataEffect(
      sonata: .MoltenRift,
      requiredEchoes: 2,
      stats: [StatValue(name: .FusionDamage, value: 10)],
    ),
    SonataEffect(
      sonata: .MoltenRift,
      buffs: [
        Buff(stats: [StatValue(name: .FusionDamage, value: 30)]),
      ],
    ),
  ],
  Sonata.VoidThunder: [
    SonataEffect(
      sonata: .VoidThunder,
      requiredEchoes: 2,
      stats: [StatValue(name: .ElectroDamage, value: 10)],
    ),
    SonataEffect(
      sonata: .VoidThunder,

      buffs: [
        Buff(stats: [StatValue(name: .ElectroDamage, value: 15)], maxStack: 2),
      ],
    ),
  ],
  Sonata.CelestialLight: [
    SonataEffect(
      sonata: .CelestialLight,
      requiredEchoes: 2,
      stats: [StatValue(name: .SpectroDamage, value: 10)],
    ),
    SonataEffect(
      sonata: .CelestialLight,

      buffs: [
        Buff(stats: [StatValue(name: .SpectroDamage, value: 30)]),
      ],
    ),
  ],
  Sonata.HavocEclipse: [
    SonataEffect(
      sonata: .HavocEclipse,
      requiredEchoes: 2,
      stats: [StatValue(name: .HavocDamage, value: 10)],
    ),
    SonataEffect(
      sonata: .HavocEclipse,
      buffs: [
        Buff(stats: [StatValue(name: .HavocDamage, value: 7.5)], maxStack: 4),
      ],
    ),
  ],
  Sonata.RejuvenatingGlow: [
    SonataEffect(
      sonata: .RejuvenatingGlow,
      requiredEchoes: 2,
      stats: [StatValue(name: .HealingBonus, value: 10)],
    ),
    SonataEffect(
      sonata: .RejuvenatingGlow,
      buffs: [
        Buff(stats: [StatValue(name: .ATKPercent, value: 15)]),
      ],
    ),
  ],
  Sonata.MoonlitClouds: [
    SonataEffect(
      sonata: .MoonlitClouds,
      requiredEchoes: 2,
      stats: [StatValue(name: .EnergyRegen, value: 10)],
    ),
    SonataEffect(
      sonata: .MoonlitClouds,
      buffs: [
        Buff(
          stats: [StatValue(name: .ATKPercent, value: 22.5)],
          target: .Ally,
        ),
      ],
    ),
  ],
  Sonata.LingeringTunes: [
    SonataEffect(
      sonata: .LingeringTunes,
      requiredEchoes: 2,
      stats: [StatValue(name: .ATKPercent, value: 10)],
    ),
    SonataEffect(
      sonata: .LingeringTunes,
      stats: [StatValue(name: .OutroDamage, value: 60)],
      buffs: [
        Buff(stats: [StatValue(name: .ATKPercent, value: 5)], maxStack: 4),
      ],
    ),
  ],
  Sonata.FrostyResolve: [
    SonataEffect(
      sonata: .FrostyResolve,
      requiredEchoes: 2,
      stats: [StatValue(name: .ResonanceDamage, value: 12)],
    ),
    SonataEffect(
      sonata: Sonata.FrostyResolve,
      buffs: [
        Buff(stats: [StatValue(name: .GlacioDamage, value: 22.5)]),
        Buff(
          stats: [StatValue(name: .ResonanceDamage, value: 18)],
          maxStack: 2,
        ),
      ],
    ),
  ],
  Sonata.EternalRadiance: [
    SonataEffect(
      sonata: .EternalRadiance,
      requiredEchoes: 2,
      stats: [StatValue(name: .SpectroDamage, value: 10)],
    ),
    SonataEffect(
      sonata: .EternalRadiance,
      buffs: [
        Buff(stats: [StatValue(name: .CritRate, value: 20)]),
        Buff(stats: [StatValue(name: .SpectroDamage, value: 10)]),
      ],
    ),
  ],
  Sonata.MidnightVeil: [
    SonataEffect(
      sonata: .MidnightVeil,
      requiredEchoes: 2,
      stats: [StatValue(name: .HavocDamage, value: 10)],
    ),
    SonataEffect(
      sonata: .MidnightVeil,
      buffs: [
        Buff(
          stats: [StatValue(name: .HavocDamage, value: 15)],
          target: .Team,
        ),
      ],
    ),
  ],
  Sonata.TidebreakingCourage: [
    SonataEffect(
      sonata: .TidebreakingCourage,
      requiredEchoes: 2,
      stats: [StatValue(name: .EnergyRegen, value: 10)],
    ),
    SonataEffect(
      sonata: .TidebreakingCourage,
      stats: [StatValue(name: .EnergyRegen, value: 10)],
      buffs: [
        Buff(
          stats: [
            StatValue(name: .AeroDamage, value: 30),
            StatValue(name: .ElectroDamage, value: 30),
            StatValue(name: .GlacioDamage, value: 30),
            StatValue(name: .FusionDamage, value: 30),
            StatValue(name: .SpectroDamage, value: 30),
            StatValue(name: .HavocDamage, value: 30),
          ],
        ),
      ],
    ),
  ],
  Sonata.EmpyreanAnthem: [
    SonataEffect(
      sonata: .EmpyreanAnthem,
      requiredEchoes: 2,
      stats: [StatValue(name: .EnergyRegen, value: 10)],
    ),
    SonataEffect(
      sonata: .EmpyreanAnthem,
      stats: [StatValue(name: .CoordinatedAttackDamage, value: 80)],
      buffs: [
        Buff(
          stats: [StatValue(name: .ATKPercent, value: 20)],
          target: .Ally,
        ),
      ],
    ),
  ],
  Sonata.GustsOfWelkin: [
    SonataEffect(
      sonata: .GustsOfWelkin,
      requiredEchoes: 2,
      stats: [StatValue(name: .AeroDamage, value: 10)],
    ),
    SonataEffect(
      sonata: .GustsOfWelkin,
      buffs: [
        Buff(
          stats: [StatValue(name: .AeroDamage, value: 15)],
          target: .Team,
        ),
        Buff(
          stats: [StatValue(name: .AeroDamage, value: 15)],
          target: .Self,
        ),
      ],
    ),
  ],
  Sonata.WindwardPilgrimage: [
    SonataEffect(
      sonata: .WindwardPilgrimage,
      requiredEchoes: 2,
      stats: [StatValue(name: .AeroDamage, value: 10)],
    ),
    SonataEffect(
      sonata: .WindwardPilgrimage,
      buffs: [
        Buff(
          stats: [
            StatValue(name: .CritRate, value: 10),
            StatValue(name: .AeroDamage, value: 30),
          ],
        ),
      ],
    ),
  ],
  Sonata.FlamingClawprint: [
    SonataEffect(
      sonata: .FlamingClawprint,
      requiredEchoes: 2,
      buffs: [
        Buff(stats: [StatValue(name: .FusionDamage, value: 10)]),
      ],
    ),
    SonataEffect(
      sonata: .FlamingClawprint,
      buffs: [
        Buff(
          stats: [StatValue(name: .FusionDamage, value: 15)],
          target: .Team,
        ),
        Buff(
          stats: [StatValue(name: .LiberationDamage, value: 20)],
          target: .Self,
        ),
      ],
    ),
  ],
  Sonata.DreamsOfTheLost: [
    SonataEffect(
      sonata: .DreamsOfTheLost,
      requiredEchoes: 3,
      buffs: [
        Buff(
          stats: [
            StatValue(name: .CritRate, value: 20),
            StatValue(name: .EchoDamage, value: 35),
          ],
        ),
      ],
    ),
  ],
  Sonata.CrownOfValor: [
    SonataEffect(
      sonata: .CrownOfValor,
      requiredEchoes: 3,
      buffs: [
        Buff(
          stats: [
            StatValue(name: .ATKPercent, value: 6),
            StatValue(name: .CritDamage, value: 4),
          ],
          maxStack: 5,
        ),
      ],
    ),
  ],
  Sonata.LawOfHarmony: [
    SonataEffect(
      sonata: .LawOfHarmony,
      requiredEchoes: 3,
      buffs: [
        Buff(stats: [StatValue(name: .HeavyAttackDamage, value: 30)]),
        Buff(stats: [StatValue(name: .EchoDamage, value: 4)], maxStack: 4),
      ],
    ),
  ],
  Sonata.FlamewingShadow: [
    SonataEffect(
      sonata: .FlamewingShadow,
      requiredEchoes: 3,
      buffs: [
        Buff(
          stats: [
            StatValue(
              name: .CritRate,
              value: 20,
              appliesOnlyTo: [.HeavyAttack],
            ),
          ],
        ),
        Buff(
          stats: [
            StatValue(name: .CritRate, value: 20, appliesOnlyTo: [.Echo]),
          ],
        ),
        Buff(stats: [StatValue(name: .FusionDamage, value: 16)]),
      ],
    ),
  ],
  Sonata.ThreadOfSeveredFate: [
    SonataEffect(
      sonata: .ThreadOfSeveredFate,
      requiredEchoes: 3,
      buffs: [
        Buff(
          stats: [
            StatValue(name: .ATKPercent, value: 20),
            StatValue(name: .LiberationDamage, value: 30),
          ],
        ),
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
