// ignore_for_file: non_constant_identifier_names, constant_identifier_names

import 'package:json_annotation/json_annotation.dart';
import 'package:ww_optimizer/core/types.dart';
import 'package:ww_optimizer/core/wuthering/buff.dart';
import 'package:ww_optimizer/core/wuthering/sonata.dart';
import 'package:ww_optimizer/core/wuthering/stat.dart';

part 'echo.g.dart';

@JsonSerializable()
class Echo {
  final String name;
  final BuffList buffs;
  final StatList substats;
  final int cost;
  Sonata sonata;
  int level;
  StatList mainStats;

  Echo({
    this.name = "",
    this.buffs = const [],
    this.cost = Echo.Cost1,
    this.substats = const [],
    this.mainStats = const [],
    this.sonata = Sonata.None,
    this.level = 25,
  });

  static const int Cost1 = 1;
  static const int Cost3 = 3;
  static const int Cost4 = 4;

  factory Echo.fromJson(JsonType json) => _$EchoFromJson(json);
  JsonType toJson() => _$EchoToJson(this);
}

final List<String> echoNames = [];
