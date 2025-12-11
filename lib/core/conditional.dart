import 'package:fluent_ui/fluent_ui.dart';
import 'package:ww_optimizer/core/wuthering/buff.dart';

class Conditional<T> {
  T? _value;
  bool Function()? _condition;

  Conditional({T? value, bool Function()? condition}) : _value = value, _condition = condition;
  set condition(bool Function()? condition) => _condition = condition;
  set value(T? value) => _value = value;
  T? get value => (_condition != null && _condition!()) ? _value : null;
}

final Conditional<Buff> conditionalBuff = Conditional<Buff>(value: Buff());
