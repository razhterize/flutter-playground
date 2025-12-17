import 'package:flutter/material.dart';
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
    return DropdownMenu<StatName>(
      onSelected: (value) {
        if (value != null) {
          _statName = value;
          widget.onChange(value);
          setState(() {});
        }
      },
      dropdownMenuEntries: StatName.strNames.entries.map((e) {
        return DropdownMenuEntry(
          label: e.value,
          value: e.key,
          enabled: !widget.except.contains(e.key),
          // child: Text(e.value),
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
            child: Icon(Icons.minimize_outlined),
          ),
        ),
        CommonUI.spacer(width: 10),
        Flexible(
          child: StatNamePicker(
            statName: widget.statValue.name,
            onChange: _nameChange,
            enabled: widget.enable,
            except: widget.except,
          ),
        ),
        CommonUI.spacer(width: 10),
        Flexible(
          child: TextField(
            keyboardType: .number,
            onChanged: (value) => _valueChange(double.tryParse(value)),
          ),
          // child: NumberBox<double>(
          //   value: widget.statValue.value,
          //   placeholder: "Value",
          //   inputFormatters: [
          //     FilteringTextInputFormatter.allow(RegExp(r"[\d\.\,]")),
          //   ],
          //   keyboardType: .number,
          //   mode: .inline,
          //   onChanged: _valueChange,
          // ),
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
