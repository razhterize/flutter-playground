import 'package:flutter/material.dart';
import 'package:mix/mix.dart';

import '../style.dart';
import '../../logger.dart';
import '../../core/enum_flag.dart';
import '../../core/wuthering.dart';

class DamageTypeSelector extends StatefulWidget {
  const DamageTypeSelector({
    super.key,
    required this.initialValue,
    required this.onChange,
  });

  final List<DamageType> initialValue;
  final ValueChanged<List<DamageType>> onChange;

  @override
  State<DamageTypeSelector> createState() => _DamageTypeSelectorState();
}

class _DamageTypeSelectorState extends State<DamageTypeSelector> {
  List<DamageType> _damageType = [];

  @override
  void initState() {
    _damageType = widget.initialValue;
    super.initState();
  }

  final List<DamageType> validTypes = DamageType.values
      .where((type) => type != DamageType.None)
      .toList();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onSecondaryTap: () => _openPopup(context),
      child: Tooltip(
        message: "Right Click to open",
        child: FilledButton(
          onPressed: () {},
          child: HBox(
            style: hboxStyle,
            children: const [Text("Damage Types"), Icon(Icons.arrow_right)],
          ),
        ),
      ),
    );
  }

  void _openPopup(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    showDialog(
      context: context,
      builder: (_) {
        return Dialog(
          alignment: .center,
          constraints: BoxConstraints(
            maxWidth: 0.2 * screenSize.width,
            maxHeight: 0.4 * screenSize.height,
          ),
          child: _DamageTypePopup(
            types: _damageType,
            onChange: (dts) {
              _damageType = dts;
              _emitChanges();
            },
          ),
        );
      },
    );
  }

  void _emitChanges() {
    widget.onChange(_damageType);
    setState(() {});
  }
}

class _DamageTypePopup extends StatefulWidget {
  const _DamageTypePopup({
    super.key,
    required this.types,
    required this.onChange,
  });

  final List<DamageType> types;
  final ValueChanged<List<DamageType>> onChange;
  // final Function(List<DamageType> types) onChange;

  @override
  State<_DamageTypePopup> createState() => __DamageTypePopupState();
}

class __DamageTypePopupState extends State<_DamageTypePopup> {
  List<DamageType> _types = [];

  @override
  void initState() {
    _types = widget.types;
    super.initState();
  }

  final List<DamageType> _validTypes = DamageType.values
      .where((dt) => dt != DamageType.None)
      .toList();

  @override
  Widget build(BuildContext context) {
    _types = widget.types;
    return Box(
      style: cardStyle,
      child: ListView(
        children: _validTypes.map((e) {
          bool active = _types.contains(e);
          return CheckboxListTile(
            value: active,
            selected: active,
            title: Text(e.name),
            onChanged: (v) {
              rootLogger.info("DamageType change ${e.name} => $v");
              List<DamageType> newList = _types;
              if (active) {
                _types.remove(e);
              } else {
                _types.add(e);
              }
              _emitChanges();
            },
          );
        }).toList(),
      ),
    );
  }

  void _emitChanges() {
    widget.onChange(_types);
    setState(() {});
  }
}
