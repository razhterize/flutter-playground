import 'package:json_annotation/json_annotation.dart';
import 'package:ww_optimizer/core/types.dart';
import 'package:ww_optimizer/wuthering/stat.dart';

part 'buff.g.dart';

typedef BuffList = List<Buff>;

enum BuffTarget { Self, Ally, Team }

@JsonSerializable()
class Buff {
  final String name;
  final StatList stats;
  final int maxStack;
  final BuffTarget target;
  bool active;
  int currentStack;

  Buff({
    this.name = "",
    this.stats = const [],
    this.maxStack = 1,
    this.active = false,
    this.currentStack = 1,
    this.target = BuffTarget.Self,
  });

  Buff copyWith({
    String? name,
    StatList? stats,
    int? maxStack,
    BuffTarget? target,
  }) {
    return Buff(
      name: name ?? this.name,
      stats: stats ?? this.stats,
      maxStack: maxStack ?? this.maxStack,
      target: target ?? this.target,
    );
  }

  factory Buff.fromJson(JsonType json) => _$BuffFromJson(json);
  JsonType toJson() => _$BuffToJson(this);
}
