import 'package:json_annotation/json_annotation.dart';

import 'package:ww_optimizer/logger.dart';
import 'package:ww_optimizer/wuthering/buff.dart';
import 'package:ww_optimizer/wuthering/stat.dart';
import 'package:ww_optimizer/wuthering/echo.dart';
import 'package:ww_optimizer/wuthering/sonata.dart';

part 'echo_set.g.dart';

@JsonSerializable()
class EchoSet {
  EchoSet({this.echoes = const []}) {
    _effects = [];
  }
  List<Echo> echoes;
  late List<SonataEffect> _effects;
  int _totalCost = 0;

  void addEcho(Echo echo) {
    if (echoes.length >= 5) return rootLogger.error("Too many echoes");
    if (_totalCost + echo.cost > 12) return rootLogger.error("EchoSet cost exceeded");
    echoes.add(echo);
    _totalCost += echo.cost;
    _updateEffects();
  }

  void removeEcho(Echo echo) {
    if (echoes.isEmpty) return rootLogger.error("EchoSet is emtpy");
  }

  StatList getStats() {
    throw UnimplementedError();
  }

  BuffList getBuffs() {
    throw UnimplementedError();
  }

  void _updateEffects() {
    throw UnimplementedError();
  }
}
