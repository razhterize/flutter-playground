// ignore_for_file: constant_identifier_names, non_constant_identifier_names
import 'package:quiver/core.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:ww_optimizer/core/types.dart';
import 'package:ww_optimizer/wuthering/damage.dart';

part 'stat.g.dart';

typedef StatList = List<StatValue>;
typedef StatMap = Map<int, double>;

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

  static final List<StatName> values = List.generate(
    58,
    (index) => StatName(index + 1),
    growable: false,
  );

  static String name(StatName statName) =>
      _statNames[statName] ?? "Invalid Index";
  static Map<StatName, String> get statNames => _statNames;
  static final Map<StatName, String> _statNames = const {
    StatName(1): "ATK (Raw)", // Raw Resoantor/Weapon attack
    StatName(2): "DEF",
    StatName(3): "HP",
    StatName(4): "ATK (Flat)", // Flat ATK From Tuning
    StatName(5): "ATK %",
    StatName(6): "DEF %",
    StatName(7): "HP %",
    StatName(8): "Crit. Rate",
    StatName(9): "Crit. Damage",
    StatName(10): "Energy Regen",
    StatName(11): "Healing Bonus",
    StatName(12): "Aero Damage",
    StatName(13): "Electro Damage",
    StatName(14): "Fusion Damage",
    StatName(15): "Glacio Damage",
    StatName(16): "Havoc Damage",
    StatName(17): "Spectro Damage",
    StatName(18): "Basic Attack Damage",
    StatName(19): "Heavy Attack Damage",
    StatName(20): "Resonance Damage",
    StatName(21): "Liberation Damage",
    StatName(22): "Coordinated Attack Damage",
    StatName(23): "Intro Damage",
    StatName(24): "Outro Damage",
    StatName(25): "Echo Damage",
    StatName(26): "Spectro Frazzle Damage",
    StatName(27): "Aero Erosion Damage",
    StatName(28): "Glacio Chafe Damage",
    StatName(29): "Electro Flare Damage",
    StatName(30): "Havoc Bane Damage",
    StatName(31): "Fusion Burst Damage",
    StatName(32): "General Damage",
    StatName(33): "Aero Amp",
    StatName(34): "Electro Amp",
    StatName(35): "Fusion Amp",
    StatName(36): "Glacio Amp",
    StatName(37): "Havoc Amp",
    StatName(38): "Spectro Amp",
    StatName(39): "Basic Attack Amp",
    StatName(40): "Heavy Attack Amp",
    StatName(41): "Resonance Amp",
    StatName(42): "Liberation Amp",
    StatName(43): "Coordinated Attack Amp",
    StatName(44): "Intro Amp",
    StatName(45): "Outro Amp",
    StatName(46): "Echo Amp",
    StatName(47): "Spectro Frazzle Amp",
    StatName(48): "Aero Erosion Amp",
    StatName(49): "Electro Flare Amp",
    StatName(50): "Glacio Chafe Amp",
    StatName(51): "Havoc Bane Amp",
    StatName(52): "Fusion Burst Amp",
    StatName(53): "General Amp",
    StatName(54): "Aero Res",
    StatName(55): "Electro Res",
    StatName(56): "Fusion Res",
    StatName(57): "Glacio Res",
    StatName(58): "Havoc Res",
    StatName(59): "Spectro Res",
  };

  static StatName strToName(String strName) =>
      _strToStaName[strName] ?? StatName(0);

  static final Map<String, StatName> _strToStaName = Map.fromEntries(
    _statNames.map((k, v) {
      return MapEntry(v, k);
    }).entries,
  );
}
