import 'package:flutter/material.dart';
import 'package:mix/mix.dart';

import 'common.dart';
import '../style.dart';

class ExpandableBox extends StatefulWidget {
  const ExpandableBox({
    super.key,
    required this.child,
    this.header,
    this.onExpandChange,
    this.expandedHeight = 400,
    this.style,
  });

  final Widget child;
  final Widget? header;
  final ValueGetter? onExpandChange;
  final double expandedHeight;
  final Style? style;

  @override
  State<ExpandableBox> createState() => _ExpandableBoxState();
}

class _ExpandableBoxState extends State<ExpandableBox> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return PressableBox(
      style: cardStyle.applyVariant(horizontalMargin).merge(widget.style),
      onPress: () {
        _expanded = !_expanded;
        if (widget.onExpandChange != null) widget.onExpandChange!();
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
              _expanded
                  ? Style($box.height(widget.expandedHeight))
                  : Style($box.height(0)),
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
