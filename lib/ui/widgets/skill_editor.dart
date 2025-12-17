import 'package:flutter/material.dart';
import 'package:ww_optimizer/wuthering/wuthering.dart';

class SkillEditor extends StatefulWidget {
  const SkillEditor({
    super.key,
    required this.skill,
    required this.onChange,
    this.enabled = true,
    this.buttonPress,
  });

  final Skill skill;
  final bool enabled;
  final void Function(Skill skill) onChange;
  final void Function()? buttonPress;

  @override
  State<SkillEditor> createState() => _SkillEditorState();
}

class _SkillEditorState extends State<SkillEditor> {
  late Skill _skill;
  @override
  void initState() {
    _skill = widget.skill;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
