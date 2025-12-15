import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/services.dart';
import 'package:ww_optimizer/wuthering/stat.dart';

class StatNamePicker extends StatefulWidget {
  const StatNamePicker({
    super.key,
    required this.name,
    required this.onChange,
    this.enabled = true,
    this.except = const [],
  });

  final StatName name;
  final bool enabled;
  final void Function(StatName name) onChange;
  final List<StatName> except;

  @override
  State<StatNamePicker> createState() => _StatNamePickerState();
}

class _StatNamePickerState extends State<StatNamePicker> {
  late StatName _statName;

  @override
  void initState() {
    _statName = widget.name;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final validStatNames = strStatNames.entries
        .where((e) => widget.except.contains(e.key) == false)
        .toList();
    return ComboBox<StatName>(
      value: _statName,
      onChanged: (value) {
        _statName = value!;
        widget.onChange(value);
        setState(() {});
      },
      items: validStatNames.map((e) {
        return ComboBoxItem(value: e.key, child: Text(e.value));
      }).toList(),
    );
  }
}

class StatValuePicker extends StatefulWidget {
  const StatValuePicker({
    super.key,
    required this.onChange,
    required this.statValue,
    this.buttonPress,
    this.enable = true,
    this.except = const [],
  });

  final StatValue statValue;
  final void Function()? buttonPress;
  final void Function(StatValue statValue) onChange;
  final bool enable;
  final List<StatName> except;

  @override
  State<StatValuePicker> createState() => _StatValuePickerState();
}

class _StatValuePickerState extends State<StatValuePicker> {
  late StatValue _statValue;

  @override
  void initState() {
    _statValue = widget.statValue;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: .start,
      crossAxisAlignment: .center,
      children: [
        SizedBox(
          width: 40,
          height: 32,
          child: FilledButton(
            onPressed: widget.enable ? widget.buttonPress : null,
            style: ButtonStyle(),
            child: Icon(FluentIcons.skype_minus),
          ),
        ),
        Container(width: 5, color: Colors.transparent),
        Flexible(
          flex: 9,
          child: StatNamePicker(
            name: _statValue.name,
            onChange: nameFn,
            enabled: widget.enable,
            except: widget.except,
          ),
        ),
        Container(width: 5, color: Colors.transparent),
        Flexible(
          flex: 10,
          child: NumberBox<double>(
            value: _statValue.value,
            placeholder: "Value",
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r"[\d\.\,]")),
            ],
            keyboardType: .number,
            onChanged: valueFn,
          ),
        ),
      ],
    );
  }

  void nameFn(StatName name) {
    _statValue = _statValue.copyWith(name: name);
    widget.onChange(_statValue);
    setState(() {});
  }

  void valueFn(double? val) {
    _statValue = _statValue.copyWith(value: val);
    widget.onChange(_statValue);
    setState(() {});
  }
}
