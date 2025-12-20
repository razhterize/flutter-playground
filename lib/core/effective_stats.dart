import 'wuthering.dart';

class EffectiveStats {
  EffectiveStats() {
    for (var entry in StatName.values) {
      if (entry == .None) continue;
      _effectiveStats[entry] = 0.0;
    }
  }

  final Map<StatName, double> _effectiveStats = {};
  Map<StatName, double> get effectiveStats => _effectiveStats;

  double addStat(StatValue stat) {
    assert(stat.name != StatName.None, "Cannot update StatName.None");
    double updated = _effectiveStats.update(
      stat.name,
      (value) => value + stat.value,
      ifAbsent: () => stat.value,
    );
    return updated;
  }

  List<double> addStats(List<StatValue> stats) {
    assert(
      stats.any((stat) => stat.name != StatName.None),
      "Cannot update StatName.None",
    );
    List<double> updatedValues = [];
    for (var stat in stats) {
      double updated = addStat(stat);
      updatedValues.add(updated);
    }
    return updatedValues;
  }

  double removeStat(StatValue stat) {
    assert(stat.name != StatName.None, "Cannot update StatName.None");
    double updated = _effectiveStats.update(
      stat.name,
      (value) => value - stat.value,
      ifAbsent: () => -stat.value,
    );
    return updated;
  }

  List<double> removeStats(List<StatValue> stats) {
    assert(
      stats.any((stat) => stat.name != StatName.None),
      "Cannot update StatName.None",
    );
    List<double> updatedValues = [];
    for (var stat in stats) {
      double updated = removeStat(stat);
      updatedValues.add(updated);
    }
    return updatedValues;
  }

  double operator [](StatName name) => _effectiveStats[name] ?? 0.0;

  StatValue operator +(StatValue stat) {
    double updatedValue = addStat(stat);
    return StatValue(name: stat.name, value: updatedValue);
  }

  StatValue operator -(StatValue stat) {
    double updatedValue = addStat(
      StatValue(name: stat.name, value: -stat.value),
    );
    return StatValue(name: stat.name, value: updatedValue);
  }
}
