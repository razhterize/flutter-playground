// ignore_for_file: constant_identifier_names, non_constant_identifier_names
import 'package:quiver/core.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:ww_optimizer/core/types.dart';
import 'package:ww_optimizer/core/wuthering/damage.dart';

part 'stat.g.dart';

typedef StatList = List<StatValue>;

@JsonSerializable()
class StatValue {
  final StatName name;
  final double value;
  final DamageType? appliesOnlyTo;

  const StatValue(this.name, this.value, {this.appliesOnlyTo});

  bool get isPercent => isPercentage(name);

  static bool isPercentage(StatName name) {
    final nonPercentageStats = [StatName.ATK, StatName.FlatATK, StatName.DEF, StatName.HP];
    return !nonPercentageStats.contains(name);
  }

  @override
  String toString() => "${name.toString()} : $value${isPercent ? "%" : ""}";

  factory StatValue.fromJson(JsonType json) => _$StatValueFromJson(json);
  JsonType toJson() => _$StatValueToJson(this);

  @override
  bool operator ==(Object other) => other is StatValue && other.name == name;

  @override
  int get hashCode => hash2(name, value);
}

enum ElementType { None, Glacio, Fusion, Electro, Aero, Spectro, Havoc }

@JsonSerializable()
class StatName {
  const StatName(this.value);
  final int value;

  factory StatName.fromJson(JsonType json) => _$StatNameFromJson(json);
  JsonType toJson() => _$StatNameToJson(this);

  static StatName get ATK => const StatName(1);
  static StatName get DEF => const StatName(2);
  static StatName get HP => const StatName(3);
  static StatName get FlatATK => const StatName(4);
  static StatName get ATKPercent => const StatName(5);
  static StatName get DEFPercent => const StatName(6);
  static StatName get HPPercent => const StatName(7);
  static StatName get CritRate => const StatName(8);
  static StatName get CritDamage => const StatName(9);
  static StatName get EnergyRegen => const StatName(10);
  static StatName get HealingBonus => const StatName(11);
  static StatName get AeroDamage => const StatName(12);
  static StatName get ElectroDamage => const StatName(13);
  static StatName get FusionDamage => const StatName(14);
  static StatName get GlacioDamage => const StatName(15);
  static StatName get HavocDamage => const StatName(16);
  static StatName get SpectroDamage => const StatName(17);
  static StatName get BasicAttackDamage => const StatName(18);
  static StatName get HeavyAttackDamage => const StatName(19);
  static StatName get ResonanceDamage => const StatName(20);
  static StatName get LiberationDamage => const StatName(21);
  static StatName get CoordinatedAttackDamage => const StatName(22);
  static StatName get IntroDamage => const StatName(23);
  static StatName get OutroDamage => const StatName(24);
  static StatName get EchoDamage => const StatName(25);
  static StatName get SpectroFrazzleDamage => const StatName(26);
  static StatName get AeroErosionDamage => const StatName(27);
  static StatName get GlacioChafeDamage => const StatName(28);
  static StatName get ElectroFlareDamage => const StatName(29);
  static StatName get HavocBaneDamage => const StatName(30);
  static StatName get FusionBurstDamage => const StatName(31);
  static StatName get GeneralDamage => const StatName(32);
  static StatName get AeroAmp => const StatName(33);
  static StatName get ElectroAmp => const StatName(34);
  static StatName get FusionAmp => const StatName(35);
  static StatName get GlacioAmp => const StatName(36);
  static StatName get HavocAmp => const StatName(37);
  static StatName get SpectroAmp => const StatName(38);
  static StatName get BasicAttackAmp => const StatName(39);
  static StatName get HeavyAttackAmp => const StatName(40);
  static StatName get ResonanceAmp => const StatName(41);
  static StatName get LiberationAmp => const StatName(42);
  static StatName get CoordinatedAttackAmp => const StatName(43);
  static StatName get IntroAmp => const StatName(44);
  static StatName get OutroAmp => const StatName(45);
  static StatName get EchoAmp => const StatName(46);
  static StatName get SpectroFrazzleAmp => const StatName(47);
  static StatName get AeroErosionAmp => const StatName(48);
  static StatName get ElectroFlareAmp => const StatName(49);
  static StatName get GlacioChafeAmp => const StatName(50);
  static StatName get HavocBaneAmp => const StatName(51);
  static StatName get FusionBurstAmp => const StatName(52);
  static StatName get GeneralAmp => const StatName(53);
  static StatName get AeroRes => const StatName(54);
  static StatName get ElectroRes => const StatName(55);
  static StatName get FusionRes => const StatName(56);
  static StatName get GlacioRes => const StatName(57);
  static StatName get HavocRes => const StatName(58);
  static StatName get SpectroRes => const StatName(59);

  static String name(int idx) => _statNames[idx] ?? "Invalid Index";
  static Map<int, String> get statNames => _statNames;
  static final Map<int, String> _statNames = {
    1: "ATK",
    2: "DEF",
    3: "HP",
    4: "ATK",
    5: "ATK %",
    6: "DEF %",
    7: "HP %",
    8: "Crit. Rate",
    9: "Crit. Damage",
    10: "Energy Regen",
    11: "Healing Bonus",
    12: "Aero Damage",
    13: "Electro Damage",
    14: "Fusion Damage",
    15: "Glacio Damage",
    16: "Havoc Damage",
    17: "Spectro Damage",
    18: "Basic Attack Damage",
    19: "Heavy Attack Damage",
    20: "Resonance Damage",
    21: "Liberation Damage",
    22: "Coordinated Attack Damage",
    23: "Intro Damage",
    24: "Outro Damage",
    25: "Echo Damage",
    26: "Spectro Frazzle Damage",
    27: "Aero Erosion Damage",
    28: "Glacio Chafe Damage",
    29: "Electro Flare Damage",
    30: "Havoc Bane Damage",
    31: "Fusion Burst Damage",
    32: "General Damage",
    33: "Aero Amp",
    34: "Electro Amp",
    35: "Fusion Amp",
    36: "Glacio Amp",
    37: "Havoc Amp",
    38: "Spectro Amp",
    39: "Basic Attack Amp",
    40: "Heavy Attack Amp",
    41: "Resonance Amp",
    42: "Liberation Amp",
    43: "Coordinated Attack Amp",
    44: "Intro Amp",
    45: "Outro Amp",
    46: "Echo Amp",
    47: "Spectro Frazzle Amp",
    48: "Aero Erosion Amp",
    49: "Electro Flare Amp",
    50: "Glacio Chafe Amp",
    51: "Havoc Bane Amp",
    52: "Fusion Burst Amp",
    53: "General Amp",
    54: "Aero Res",
    55: "Electro Res",
    56: "Fusion Res",
    57: "Glacio Res",
    58: "Havoc Res",
    59: "Spectro Res",
  };
}
