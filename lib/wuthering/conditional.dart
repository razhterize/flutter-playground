import 'package:ww_optimizer/wuthering/buff.dart';
import 'package:ww_optimizer/wuthering/stat.dart';

class Conditional<T> {
  late T _object;
  bool Function([Object?])? _activeOn;
  T? get object => _activeOn == null || _activeOn!() ? _object : null;
  set object(T object) => _object = object;
  set activeOn(bool Function([Object?])? condition) => _activeOn = condition;
}
