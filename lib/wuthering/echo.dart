// ignore_for_file: non_constant_identifier_names, constant_identifier_names
import 'package:json_annotation/json_annotation.dart';
import 'package:ww_optimizer/core/types.dart';
import 'package:ww_optimizer/utils.dart';
import 'package:ww_optimizer/wuthering/buff.dart';
import 'package:ww_optimizer/wuthering/sonata.dart';
import 'package:ww_optimizer/wuthering/stat.dart';

part 'echo.g.dart';

@JsonSerializable()
class Echo {
  final int id;
  final String name;
  final BuffList buffs;
  final StatList substats;
  final int cost;
  final Sonata sonata;
  @JsonKey(toJson: _statPairToJson, fromJson: _statPairFromJson)
  final Pair<StatValue, StatValue> mainStats;
  late int _level;

  int get level => _level;

  Echo({
    this.id = 0,
    this.name = "",
    this.buffs = const [],
    this.mainStats = const Pair(first: StatValue(), second: StatValue()),
    this.cost = Echo.Cost1,
    this.substats = const [],
    this.sonata = Sonata.None,
    int level = 25,
  }) {
    _level = level;
  }

  Echo copyWith({
    int? id,
    String? name,
    BuffList? buffs,
    StatList? substats,
    Sonata? sonata,
    int? cost,
    int? level,
    Pair<StatValue, StatValue>? mainStats,
  }) {
    return Echo(
      id: id ?? this.id,
      name: name ?? this.name,
      cost: cost ?? this.cost,
      buffs: buffs ?? this.buffs,
      substats: substats ?? this.substats,
      sonata: sonata ?? this.sonata,
      level: level ?? this.level,
      mainStats: mainStats ?? this.mainStats,
    );
  }

  static const int Cost1 = 1;
  static const int Cost3 = 3;
  static const int Cost4 = 4;

  factory Echo.fromJson(JsonType json) => _$EchoFromJson(json);
  JsonType toJson() => _$EchoToJson(this);
}

Pair<StatValue, StatValue> _statPairFromJson(JsonType json) {
  assert(json.containsKey('first') && json.containsKey('second'));
  StatValue first = StatValue.fromJson(json['first']);
  StatValue second = StatValue.fromJson(json['second']);
  return Pair(first: first, second: second);
}

JsonType _statPairToJson(Pair<StatValue, StatValue> instance) {
  return {'first': instance.first.toJson(), 'second': instance.second.toJson()};
}

Set<double> _critSubstatModifiers = {
  1,
  1.09524,
  1.19048,
  1.28571,
  1.38095,
  1.47619,
  1.57143,
  1.66667,
};
Set<double> _nonSubstatCritModifiers = {
  1,
  1.10938,
  1.23438,
  1.34375,
  1.46875,
  1.57812,
  1.70312,
  1.8125,
};

Set<double> _levelModifiers = {
  1.0000,
  1.1583,
  1.3183,
  1.4767,
  1.6367,
  1.7950,
  1.9550,
  2.1133,
  2.2733,
  2.4317,
  2.5917,
  2.7500,
  2.9083,
  3.0683,
  3.2267,
  3.3867,
  3.5450,
  3.7050,
  3.8633,
  4.0233,
  4.1817,
  4.3417,
  4.5000,
  4.6583,
  4.8183,
  5.0000,
};

List<double> _generateMainStats(
  double initialValue,
  Iterable<double> modifiers,
) {
  return modifiers.map((mod) => (mod * initialValue).toPrecision(2)).toList();
}

Map<int, Map<StatName, List<double>>> echoTopMainStats = {
  1: {
    .ATKPercent: _generateMainStats(6, _levelModifiers),
    .DEFPercent: _generateMainStats(6, _levelModifiers),
    .HPPercent: _generateMainStats(4.5, _levelModifiers),
  },
  3: {
    .ATKPercent: _generateMainStats(6, _levelModifiers),
    .DEFPercent: _generateMainStats(7.6, _levelModifiers),
    .HPPercent: _generateMainStats(6, _levelModifiers),
    .EnergyRegen: _generateMainStats(6, _levelModifiers),
    .SpectroDamage: _generateMainStats(6, _levelModifiers),
    .HavocDamage: _generateMainStats(6, _levelModifiers),
    .ElectroDamage: _generateMainStats(6, _levelModifiers),
    .GlacioDamage: _generateMainStats(6, _levelModifiers),
    .FusionDamage: _generateMainStats(6, _levelModifiers),
  },
  4: {
    .CritDamage: _generateMainStats(8.8, _levelModifiers),
    .CritRate: _generateMainStats(4.4, _levelModifiers),
    .ATKPercent: _generateMainStats(6.6, _levelModifiers),
    .HPPercent: _generateMainStats(6.6, _levelModifiers),
    .DEFPercent: _generateMainStats(8.3, _levelModifiers),
    .HealingBonus: _generateMainStats(5.2, _levelModifiers),
  },
};

Map<int, Map<StatName, List<double>>> echoBotMainStats = {
  1: {.HP: _generateMainStats(456, _levelModifiers)},
  3: {.ATK: _generateMainStats(20, _levelModifiers)},
  4: {.HP: _generateMainStats(30, _levelModifiers)},
};

Map<StatName, List<double>> substatValues = {
  StatName.CritRate: _generateMainStats(6.3, _critSubstatModifiers),
  StatName.CritDamage: _generateMainStats(12.6, _critSubstatModifiers),
  StatName.ATKPercent: _generateMainStats(6, _nonSubstatCritModifiers),
  StatName.EnergyRegen: _generateMainStats(6.8, _nonSubstatCritModifiers),
  StatName.BasicAttackDamage: _generateMainStats(6, _nonSubstatCritModifiers),
  StatName.HeavyAttackDamage: _generateMainStats(6, _nonSubstatCritModifiers),
  StatName.ResonanceDamage: _generateMainStats(6, _nonSubstatCritModifiers),
  StatName.LiberationDamage: _generateMainStats(6, _nonSubstatCritModifiers),
  StatName.HPPercent: _generateMainStats(6, _nonSubstatCritModifiers),
  StatName.DEFPercent: _generateMainStats(8.1, _nonSubstatCritModifiers),
  StatName.ATK: const [30, 40, 50, 60],
  StatName.DEF: const [40, 50, 60, 70],
  StatName.HP: _generateMainStats(320, _nonSubstatCritModifiers),
  StatName.None: [0],
};

extension GetMainStat on Map<int, Map<StatName, List<double>>> {
  StatValue getTopMainStat(int cost, int level, StatName statName) {
    assert(containsKey(cost));
    Map<StatName, List<double>> costMap = this[cost]!;
    assert(costMap.containsKey(statName));
    assert(costMap[statName]!.length >= level);
    return StatValue(name: statName, value: costMap[statName]![level]);
  }

  StatValue getBottomMainStat(int cost, int level) {
    assert(containsKey(cost));
    Map<StatName, List<double>> costMap = this[cost]!;
    StatName statName = costMap.keys.first;
    assert(costMap[statName]!.length >= level);
    return StatValue(name: statName, value: costMap[statName]![level]);
  }

  List<StatName> getStatNames(int cost) {
    assert(containsKey(cost));
    List<StatName> statNames = this[cost]!.entries.map((e) => e.key).toList();
    return statNames;
  }
}
