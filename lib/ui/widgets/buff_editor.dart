import 'dart:io';
import 'package:flutter/material.dart';
import 'package:mix/mix.dart';

import '../style.dart';
import '../widgets/common.dart';
import '../widgets/stat_picker.dart';
import '../../core/wuthering.dart';
import '../../logger.dart';

class BuffPicker extends StatefulWidget {
  const BuffPicker({
    super.key,
    required this.buff,
    this.onChange,
    this.buttonPress,
    this.enabled = false,
  });

  final bool enabled;
  final Buff buff;
  final Function(Buff buff)? onChange;
  final Function()? buttonPress;

  @override
  State<BuffPicker> createState() => _BuffPickerState();
}

class _BuffPickerState extends State<BuffPicker> {
  late Buff _buff;
  final _textController = TextEditingController();

  @override
  void initState() {
    _buff = widget.buff;
    _textController.text = _buff.name;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: "Right click to edit buff",
      child: GestureDetector(
        onSecondaryTap: () => _openBuffDialog(context),
        child: Box(
          style: cardStyle,
          child: CommonUI.padding4(
            child: Row(
              children: [
                Expanded(child: Text(_buff.name)),
                Expanded(child: _buildStatList()),
                Expanded(child: Text("Max Stack: ${_buff.maxStack}")),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatList() {
    final mq = MediaQuery.of(context);
    return SizedBox(
      height: mq.orientation == .landscape ? 20 : 40,
      child: ListView(
        children: _buff.stats.map((sv) => Text(sv.toString())).toList(),
      ),
    );
  }

  // Buff Flyout. Where actual buff configuration happens
  void _openBuffDialog(BuildContext context) async {
    final _nameController = TextEditingController();
    final _stakController = TextEditingController();
    _nameController.text = _buff.name;
    _stakController.text = "${_buff.maxStack}";
    await showDialog<Buff>(
      context: context,
      builder: (_) {
        final isLandscape = MediaQuery.of(context).orientation == .landscape;
        return Dialog(
          alignment: .center,
          constraints: BoxConstraints(
            maxWidth: isLandscape ? 600 : 400,
            maxHeight: 200 + (_buff.stats.length * 50),
          ),
          child: _BuffPopup(
            buff: _buff,
            onChange: (buff) {
              _buff = _buff.copyWith(
                name: buff.name,
                stats: buff.stats,
                maxStack: buff.maxStack,
              );
              _update();
            },
          ),
        );
      },
    );
    rootLogger.info("Flyout Open");
  }

  void _update() {
    if (widget.onChange != null) {
      widget.onChange!(_buff);
    }
  }
}

class _BuffPopup extends StatefulWidget {
  const _BuffPopup({super.key, required this.buff, required this.onChange});

  final Buff buff;
  final Function(Buff buff) onChange;

  @override
  State<_BuffPopup> createState() => __BuffPopupState();
}

class __BuffPopupState extends State<_BuffPopup> {
  Buff _buff = Buff();
  final _nameController = TextEditingController();
  final _stackController = TextEditingController();

  @override
  void initState() {
    _buff = widget.buff;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _nameController.text = widget.buff.name;
    _stackController.text = "${widget.buff.maxStack}";

    return Box(
      style: cardStyle.add(
        $box.constraints.maxHeight(200 + (_buff.stats.length * 50)),
        $box.margin.all(0),
      ),
      child: VBox(
        style: vboxStyle,
        children: [
          // Name and Stack Size
          HBox(
            style: hboxStyle,
            children: [
              Expanded(
                child: TextField(
                  decoration: const InputDecoration(label: Text("Buff Name")),
                  controller: _nameController,
                  onChanged: _nameChange,
                ),
              ),
              Expanded(
                child: TextField(
                  controller: _stackController,
                  decoration: const InputDecoration(label: Text("Max Stack")),
                  onChanged: _stackChange,
                ),
              ),
            ],
          ),
          Expanded(
            child: VBox(
              style: flexStyle.applyVariant(flexV),
              children: [
                ..._buff.stats.map(
                  (sv) => StatValuePicker(
                    statValue: sv,
                    buttonPress: () => _removeBuff(sv),
                    onChange: (newStats) => _statChange(sv, newStats),
                  ),
                ),
                FilledButton(onPressed: _addBuff, child: const Icon(Icons.add)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _removeBuff(StatValue toRemove) {
    _buff = _buff.copyWith(stats: _buff.stats..remove(toRemove));
    widget.onChange(_buff);
    setState(() {});
  }

  void _nameChange(String name) {
    _buff = _buff.copyWith(name: name);
    widget.onChange(_buff);
    setState(() {});
  }

  void _stackChange(String stack) {
    _buff = _buff.copyWith(maxStack: int.tryParse(stack));
    widget.onChange(_buff);
    setState(() {});
  }

  void _addBuff() {
    _buff = _buff.copyWith(
      stats: [
        ..._buff.stats,
        StatValue(name: .ATK, value: 0),
      ],
    );
    setState(() {});
    widget.onChange(_buff);
  }

  void _statChange(StatValue previous, StatValue current) {
    final statIndex = _buff.stats.indexOf(previous);
    final newStats = _buff.stats;
    newStats[statIndex] = previous.copyWith(
      name: current.name,
      value: current.value,
    );
    _buff = _buff.copyWith(stats: newStats);
    widget.onChange(_buff);
    setState(() {});
  }
}
