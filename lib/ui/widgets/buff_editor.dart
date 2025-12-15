import 'dart:io';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:ww_optimizer/logger.dart';
import 'package:ww_optimizer/ui/widgets/common.dart';
import 'package:ww_optimizer/ui/widgets/stat_picker.dart';
import 'package:ww_optimizer/wuthering/buff.dart';
import 'package:ww_optimizer/wuthering/stat.dart';

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
    return SizedBox(
      height: 60,
      child: ListView.builder(
        itemCount: _buff.stats.length + 1,
        itemBuilder: (_, index) {
          if (_buff.stats.isEmpty || index >= _buff.stats.length) {
            return FilledButton(
              child: Icon(FluentIcons.add),
              onPressed: () {
                _buff.stats.add(StatValue(.ATK, 0));
                _update();
              },
            );
          }
          final stat = _buff.stats[index];
          return Text(
            "${StatName.strNames[stat.name]}:  ${stat.value}${stat.isPercent ? '%' : ''}",
          );
        },
      ),
    );
  }

  void _openFlyout() async {
    _flyoutController.showFlyout<void>(
      
      dismissOnPointerMoveAway: false,
      dismissWithEsc: false,
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
                  value: _buff.maxStack,
                  placeholder: "Max Stacks",
                  onChanged: _stackChange,
                ),
                CommonUI.spacer(height: 10),
                const Text("Stats"),
                CommonUI.spacer(),
                ..._buff.stats.map((e) {
                  return StatValuePicker(
                    onChange: (statValue) {
                      final statIndex = _buff.stats.indexOf(statValue);
                      _buff.stats[statIndex] = statValue;
                      _update();
                    },
                    statValue: e,
                  );
                }),
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
