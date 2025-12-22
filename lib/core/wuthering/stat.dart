part of '../wuthering.dart';

typedef StatList = List<StatValue>;
typedef StatMap = Map<StatName, double>;

@JsonSerializable()
class StatValue extends Equatable {
  final StatName name;
  final double value;
  final List<DamageType> appliesOnlyTo;

  const StatValue({
    this.name = .ATK,
    this.value = 0,
    this.appliesOnlyTo = const [],
  });

  StatValue copyWith({
    StatName? name,
    double? value,
    List<DamageType>? appliesOnlyTo,
  }) => StatValue(
    name: name ?? this.name,
    value: value ?? this.value,
    appliesOnlyTo: appliesOnlyTo ?? this.appliesOnlyTo,
  );

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
  String toString() {
    return "${StatName.strNames[name]}:  $value${isPercent ? '%' : ''}";
  }

  factory StatValue.fromJson(JsonType json) => _$StatValueFromJson(json);
  JsonType toJson() => _$StatValueToJson(this);

  @override
  bool operator ==(Object other) => other is StatValue && other.name == name;

  @override
  int get hashCode => hash2(name, value);

  @override
  List<Object?> get props => [name, value, appliesOnlyTo];
}

mixin HasStats {
  late final StatList _stats;
  bool Function()? statCondition;
  StatList get stats => statCondition != null
      ? statCondition!()
            ? _stats
            : []
      : _stats;
}

enum ElementType { None, Glacio, Fusion, Electro, Aero, Spectro, Havoc }

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
  SpectroRes;

  static Map<StatName, String> strNames = const {
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
}

extension StatMapValues on StatMap {
  List<StatValue> get values => entries.map((e) => e.toStatValue()).toList();

  static StatMap fromJson(JsonType json) {
    StatMap statMap = {};
    for (var entry in json.entries) {
      var keyIndex = StatName.values.indexWhere(
        (statName) => statName.name == entry.key,
      );
      statMap.update(
        StatName.values[keyIndex],
        (v) => entry.value is double
            ? entry.value
            : double.tryParse(entry.value) ?? 0,
        ifAbsent: () => entry.value is double
            ? entry.value
            : double.tryParse(entry.value) ?? 0,
      );
    }
    return statMap;
  }

  static JsonType toJson(StatMap instance) {
    JsonType _json = {};
    for (var entry in instance.entries) {
      _json.update(
        entry.key.name,
        (v) => entry.value,
        ifAbsent: () => entry.value,
      );
    }
    return _json;
  }
}

extension StatMapEntry on MapEntry<StatName, double> {
  StatValue toStatValue() => StatValue(name: key, value: value);
}
