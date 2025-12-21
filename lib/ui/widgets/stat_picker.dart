import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mix/mix.dart';

import '../style.dart';
import '../widgets/common.dart';
import '../../core/wuthering.dart';

class StatNamePicker extends StatefulWidget {
  const StatNamePicker({
    super.key,
    required this.statName,
    required this.onChange,
    this.enabled = true,
    this.except = const [],
    this.only = const [],
  });

  final StatName statName;
  final bool enabled;
  final void Function(StatName name) onChange;
  final List<StatName> except;
  final List<StatName> only;

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
      initialSelection: _statName,
      textStyle: TextStyle(color: Colors.white),
      enabled: widget.enabled,
      label: Text("Stat Name"),
      inputDecorationTheme: InputDecorationTheme(
        isDense: true,
        contentPadding: EdgeInsets.symmetric(horizontal: 10),
        constraints: BoxConstraints.tight(const Size.fromHeight(40)),
        border: OutlineInputBorder(borderRadius: .circular(10)),
      ),
      onSelected: (value) {
        if (value != null) {
          _statName = value;
          widget.onChange(value);
          setState(() {});
        }
      },
      dropdownMenuEntries: widget.only.isEmpty
          ? StatName.strNames.entries.map((e) {
              return DropdownMenuEntry(
                label: e.value,
                value: e.key,
                // child: Text(e.value),
              );
            }).toList()
          : widget.only.map((e) {
              return DropdownMenuEntry(
                value: e,
                enabled: !widget.except.contains(e),
                label: StatName.strNames[e] ?? "Unknown",
              );
            }).toList(),
    );
  }
}

class StatValuePicker extends StatefulWidget {
  const StatValuePicker({
    super.key,
    required this.statValue,
    required this.onChange,
    this.buttonPress,
    this.enable = true,
    this.except = const [],
    this.only = const [],
  });

  final StatValue statValue;
  final void Function()? buttonPress;
  final void Function(StatValue statValue) onChange;
  final bool enable;
  final List<StatName> except;
  final List<StatName> only;

  @override
  State<StatValuePicker> createState() => _StatValuePickerState();
}

class _StatValuePickerState extends State<StatValuePicker> {
  final _valueController = TextEditingController();
  late StatValue _statValue;

  @override
  void initState() {
    _statValue = widget.statValue;
    _valueController.text =
        "${widget.statValue.value}${widget.statValue.isPercent ? '%' : ''}";
    _valueController.addListener(() {
      _statValue = _statValue.copyWith(
        value: double.tryParse(_valueController.text),
      );
      widget.onChange(_statValue);
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return HBox(
      style: flexStyle.applyVariant(flexH),
      children: [
        Tooltip(
          message: "Remove Stats",
          child: widget.buttonPress != null
              ? IconButton.filled(
                  onPressed: widget.enable ? widget.buttonPress : null,
                  icon: Icon(Icons.remove),
                )
              : IconButton(onPressed: () {}, icon: Icon(Icons.remove)),
        ),
        Flexible(
          child: StatNamePicker(
            statName: _statValue.name,
            onChange: _nameChange,
            enabled: widget.enable,
            except: widget.except,
            only: widget.only,
          ),
        ),
        Flexible(
          child: TextField(
            decoration: InputDecoration(label: const Text("Value")),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r"[\d\,\.\%]")),
            ],
            controller: _valueController,
            keyboardType: .number,
            // onChanged: (value) => _valueChange(double.tryParse(value)),
          ),
        ),
      ],
    );
  }

  void _nameChange(StatName name) {
    _statValue = _statValue.copyWith(name: name);
    widget.onChange(_statValue);
    setState(() {});
  }

  void _valueChange(double? val) {
    _statValue = _statValue.copyWith(value: val);
    widget.onChange(_statValue);
    _valueController.text =
        "${_statValue.value}${_statValue.isPercent ? '%' : ''}";
    setState(() {});
  }
}
