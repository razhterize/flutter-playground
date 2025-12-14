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

  @override
  String toString() {
    StringBuffer buffer = StringBuffer();
    buffer.write("[$name] ");
    final padding = buffer.length;
    for (var stat in stats) {
      buffer.write("\n${' ' * padding}${stat.toString()}");
    }
    return buffer.toString();
  }

  factory Buff.fromJson(JsonType json) => _$BuffFromJson(json);
  JsonType toJson() => _$BuffToJson(this);
}
