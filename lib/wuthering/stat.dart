// ignore_for_file: constant_identifier_names, non_constant_identifier_names
import 'package:quiver/core.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:ww_optimizer/core/types.dart';
import 'package:ww_optimizer/wuthering/damage.dart';

part 'stat.g.dart';

typedef StatList = List<StatValue>;
typedef StatMap = Map<StatName, double>;

@JsonSerializable()
class StatValue {
  final StatName name;
  final double value;
  final DamageType? appliesOnlyTo;

  const StatValue(this.name, this.value, {this.appliesOnlyTo});

  StatValue copyWith({StatName? name, double? value}) =>
      StatValue(name ?? this.name, value ?? this.value);

  bool get isPercent => isPercentage(name);

  static bool isPercentage(StatName name) {
    final nonPercentageStats = [
      StatName.ATK,
      StatName.FlatATK,
      StatName.DEF,
      StatName.HP,
    ];
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

@JsonEnum(valueField: "index")
enum StatName {
  None,
  // Base Stats
  ATK,
  DEF,
  HP,

  // Percentage/Flat Stats
  FlatATK,
  ATKPercent,
  DEFPercent,
  HPPercent,

  // Damage Modifiers
  CritRate,
  CritDamage,
  EnergyRegen,
  HealingBonus,

  // Element Damage %
  AeroDamage,
  ElectroDamage,
  FusionDamage,
  GlacioDamage,
  HavocDamage,
  SpectroDamage,

  // Skill Damage %
  BasicAttackDamage,
  HeavyAttackDamage,
  ResonanceDamage,
  LiberationDamage,
  CoordinatedAttackDamage,
  IntroDamage,
  OutroDamage,
  EchoDamage,

  // Status/Dot Damage %
  SpectroFrazzleDamage,
  AeroErosionDamage,
  GlacioChafeDamage,
  ElectroFlareDamage,
  HavocBaneDamage,
  FusionBurstDamage,
  GeneralDamage, // Often All Damage %
  // Element Amplification (Amp is often a specific damage multiplier/modifier)
  AeroAmp,
  ElectroAmp,
  FusionAmp,
  GlacioAmp,
  HavocAmp,
  SpectroAmp,

  // Skill Amplification
  BasicAttackAmp,
  HeavyAttackAmp,
  ResonanceAmp,
  LiberationAmp,
  CoordinatedAttackAmp,
  IntroAmp,
  OutroAmp,
  EchoAmp,

  // Status/Dot Amplification
  SpectroFrazzleAmp,
  AeroErosionAmp,
  ElectroFlareAmp,
  GlacioChafeAmp,
  HavocBaneAmp,
  FusionBurstAmp,
  GeneralAmp,

  // Resistances
  AeroRes,
  ElectroRes,
  FusionRes,
  GlacioRes,
  HavocRes,
  SpectroRes,
}

const Map<StatName, String> strStatNames = {
  // Base Stats
  StatName.ATK: "ATK (Raw)", // Raw Resoantor/Weapon attack
  StatName.DEF: "DEF",
  StatName.HP: "HP",

  // Percentage/Flat Stats
  StatName.FlatATK: "ATK (Flat)", // Flat ATK From Tuning
  StatName.ATKPercent: "ATK %",
  StatName.DEFPercent: "DEF %",
  StatName.HPPercent: "HP %",

  // Damage Modifiers
  StatName.CritRate: "Crit. Rate",
  StatName.CritDamage: "Crit. Damage",
  StatName.EnergyRegen: "Energy Regen",
  StatName.HealingBonus: "Healing Bonus",

  // Element Damage %
  StatName.AeroDamage: "Aero Damage",
  StatName.ElectroDamage: "Electro Damage",
  StatName.FusionDamage: "Fusion Damage",
  StatName.GlacioDamage: "Glacio Damage",
  StatName.HavocDamage: "Havoc Damage",
  StatName.SpectroDamage: "Spectro Damage",

  // Skill Damage %
  StatName.BasicAttackDamage: "Basic Attack Damage",
  StatName.HeavyAttackDamage: "Heavy Attack Damage",
  StatName.ResonanceDamage: "Resonance Damage",
  StatName.LiberationDamage: "Liberation Damage",
  StatName.CoordinatedAttackDamage: "Coordinated Attack Damage",
  StatName.IntroDamage: "Intro Damage",
  StatName.OutroDamage: "Outro Damage",
  StatName.EchoDamage: "Echo Damage",

  // Status/Dot Damage %
  StatName.SpectroFrazzleDamage: "Spectro Frazzle Damage",
  StatName.AeroErosionDamage: "Aero Erosion Damage",
  StatName.GlacioChafeDamage: "Glacio Chafe Damage",
  StatName.ElectroFlareDamage: "Electro Flare Damage",
  StatName.HavocBaneDamage: "Havoc Bane Damage",
  StatName.FusionBurstDamage: "Fusion Burst Damage",
  StatName.GeneralDamage: "General Damage", // Often All Damage %
  // Element Amplification (Amp is often a specific damage multiplier/modifier)
  StatName.AeroAmp: "Aero Amp",
  StatName.ElectroAmp: "Electro Amp",
  StatName.FusionAmp: "Fusion Amp",
  StatName.GlacioAmp: "Glacio Amp",
  StatName.HavocAmp: "Havoc Amp",
  StatName.SpectroAmp: "Spectro Amp",

  // Skill Amplification
  StatName.BasicAttackAmp: "Basic Attack Amp",
  StatName.HeavyAttackAmp: "Heavy Attack Amp",
  StatName.ResonanceAmp: "Resonance Amp",
  StatName.LiberationAmp: "Liberation Amp",
  StatName.CoordinatedAttackAmp: "Coordinated Attack Amp",
  StatName.IntroAmp: "Intro Amp",
  StatName.OutroAmp: "Outro Amp",
  StatName.EchoAmp: "Echo Amp",

  // Status/Dot Amplification
  StatName.SpectroFrazzleAmp: "Spectro Frazzle Amp",
  StatName.AeroErosionAmp: "Aero Erosion Amp",
  StatName.ElectroFlareAmp: "Electro Flare Amp",
  StatName.GlacioChafeAmp: "Glacio Chafe Amp",
  StatName.HavocBaneAmp: "Havoc Bane Amp",
  StatName.FusionBurstAmp: "Fusion Burst Amp",
  StatName.GeneralAmp: "General Amp",

  // Resistances
  StatName.AeroRes: "Aero Res",
  StatName.ElectroRes: "Electro Res",
  StatName.FusionRes: "Fusion Res",
  StatName.GlacioRes: "Glacio Res",
  StatName.HavocRes: "Havoc Res",
  StatName.SpectroRes: "Spectro Res",
};
