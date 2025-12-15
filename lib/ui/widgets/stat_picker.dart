import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/services.dart';
import 'package:ww_optimizer/ui/widgets/common.dart';
import 'package:ww_optimizer/wuthering/stat.dart';

class StatNamePicker extends StatefulWidget {
  const StatNamePicker({
    super.key,
    required this.statName,
    required this.onChange,
    this.enabled = true,
    this.except = const [],
  });

  final StatName statName;
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
    _statName = widget.statName;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ComboBox<StatName>(
      value: _statName,
      onChanged: (value) {
        _statName = value!;
        widget.onChange(value);
        setState(() {});
      },
      items: strStatNames.entries.map((e) {
        return ComboBoxItem(
          value: e.key,
          enabled: !widget.except.contains(e.key),
          child: Text(e.value),
        );
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
        CommonUI.spacer(),
        Flexible(
          flex: 9,
          child: StatNamePicker(
            statName: widget.statValue.name,
            onChange: _nameChange,
            enabled: widget.enable,
            except: widget.except,
          ),
        ),
        CommonUI.spacer(),
        Flexible(
          flex: 2,
          child: NumberBox<double>(
            value: widget.statValue.value,
            placeholder: "Value",
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r"[\d\.\,]")),
            ],
            keyboardType: .number,
            mode: .inline,
            onChanged: _valueChange,
          ),
        ),
      ],
    );
  }

  void _nameChange(StatName name) {
    widget.onChange(widget.statValue.copyWith(name: name));
    setState(() {});
  }

  void _valueChange(double? val) {
    widget.onChange(widget.statValue.copyWith(value: val));
    setState(() {});
  }
}
