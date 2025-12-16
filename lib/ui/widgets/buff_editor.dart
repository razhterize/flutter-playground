import 'dart:io';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:ww_optimizer/logger.dart';
import 'package:ww_optimizer/ui/widgets/common.dart';
import 'package:ww_optimizer/ui/widgets/stat_picker.dart';
import 'package:ww_optimizer/wuthering/wuthering.dart';

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
  final _flyoutController = FlyoutController();

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
      child: FlyoutTarget(
        controller: _flyoutController,
        child: GestureDetector(
          onSecondaryTap: () => _openFlyout(),
          child: Container(
            decoration: BoxDecoration(border: Border.all(width: 1)),
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
          // child: Button(child: Text(_buff.name), onPressed: () {}),
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
  void _openFlyout() async {
    _flyoutController.showFlyout<void>(
      placementMode: .topCenter,
      dismissOnPointerMoveAway: false,
      dismissWithEsc: true,
      builder: (_) {
        return FlyoutContent(
          child: SizedBox(
            width: 600,
            height: 300,
            child: Column(
              children: [
                TextBox(
                  controller: _textController,
                  placeholder: "Buff Name",
                  onChanged: _nameChange,
                  clipBehavior: .antiAlias,
                ),
                CommonUI.spacer(height: 10),
                NumberBox(
                  mode: .inline,
                  value: _buff.maxStack,
                  placeholder: "Max Stacks",
                  onChanged: _stackChange,
                ),
                CommonUI.spacer(height: 10),
                const Text("Stats"),
                CommonUI.spacer(),
                ..._buff.stats.asMap().entries.map((entry) {
                  return StatValuePicker(
                    buttonPress: () {
                      _buff.stats.removeAt(entry.key);
                      _update();
                    },
                    onChange: (statValue) {
                      _buff.stats[entry.key] = statValue;
                      _update();
                    },
                    statValue: entry.value,
                  );
                }),
                FilledButton(
                  child: Icon(FluentIcons.add),
                  onPressed: () {
                    _buff.stats.add(StatValue(.ATK, 0));
                    _update();
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _nameChange(String name) {
    _buff = _buff.copyWith(name: name);
    _update();
  }

  void _stackChange(int? stack) {
    _buff = _buff.copyWith(maxStack: stack);
    _update();
  }

  void _update() {
    if (widget.onChange != null) {
      widget.onChange!(_buff);
    }
    setState(() {});
  }
}
