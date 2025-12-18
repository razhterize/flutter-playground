import 'package:flutter/material.dart';
import 'package:mix/mix.dart';
import 'package:ww_optimizer/ui/style.dart';
import 'package:ww_optimizer/ui/widgets/common.dart';

class ExpandableBox extends StatefulWidget {
  const ExpandableBox({
    super.key,
    required this.child,
    this.header,
    this.onExpandChange,
    this.style,
  });

  final Widget child;
  final Widget? header;
  final Function()? onExpandChange;
  final Style? style;

  @override
  State<ExpandableBox> createState() => _ExpandableBoxState();
}

class _ExpandableBoxState extends State<ExpandableBox> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return PressableBox(
      style: cardStyle,
      onPress: () {
        _expanded = !_expanded;
        setState(() {});
      },
      child: VBox(
        style: flexStyle.applyVariant(flexV).applyVariant(flexNoGap),
        children: [
          ListTile(
            leading: Icon(
              _expanded
                  ? Icons.keyboard_arrow_down
                  : Icons.keyboard_arrow_right,
            ),
            title: widget.header,
          ),
          Box(
            style: AnimatedStyle(
              _expanded ? Style($box.height(400)) : Style($box.height(0)),
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeInOutCirc,
            ),
            child: widget.child,
          ),
        ],
      ),
    );
  }
}
