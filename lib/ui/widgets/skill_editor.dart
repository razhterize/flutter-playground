import 'package:flutter/material.dart';
import 'package:mix/mix.dart';

import 'common.dart';
import 'damage_type_selector.dart';
import 'expandable_box.dart';
import 'stat_picker.dart';
import '../style.dart';
import '../../core/enum_flag.dart';
import '../../core/wuthering.dart';

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
  final ValueChanged<Skill> onChange;
  final VoidCallback? buttonPress;

  @override
  State<SkillEditor> createState() => _SkillEditorState();
}

class _SkillEditorState extends State<SkillEditor> {
  final _nameController = TextEditingController();
  final _descController = TextEditingController();
  Skill _skill = Skill();

  @override
  void initState() {
    _nameController.text = widget.skill.name;
    _descController.text = widget.skill.description;
    _nameController.addListener(_updateName);
    _descController.addListener(_updateDesc);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _skill = widget.skill;
    return ExpandableBox(
      header: Text(_skill.name),
      child: SingleChildScrollView(
        child: Box(
          style: cardStyle,
          child: VBox(
            style: vboxStyle,
            children: [
              // Name Editor
              TextField(
                controller: _nameController,
                decoration: _labelDecor("Skill Name"),
              ),
              // Description
              TextField(
                maxLines: 4,
                controller: _descController,
                decoration: _labelDecor("Description"),
              ),
              // Damages
              ExpandableBox(
                header: const Text("Attacks"),
                child: _attackBuilder(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _attackBuilder() {
    return ListView.separated(
      itemCount: _skill.attacks.length + 1,
      separatorBuilder: (_, _) => CommonUI.spacer(),
      itemBuilder: (_, index) {
        if (index >= _skill.attacks.length) {
          return Tooltip(
            message: "Add Attack",
            child: FilledButton(
              onPressed: () {
                _skill.attacks.add(Attack());
                _emitChanges();
              },
              child: const Icon(Icons.add),
            ),
          );
        }
        return AttackEditor(
          attack: _skill.attacks[index],
          onChange: (attack) {
            _skill.attacks[index] = attack;
            _emitChanges();
          },
        );
      },
    );
  }

  InputDecoration _labelDecor(String text) {
    return InputDecoration(label: Text(text));
  }

  void _updateName() {
    _skill = _skill.copyWith(name: _nameController.text);
    _emitChanges();
  }

  void _updateDesc() {
    _skill = _skill.copyWith(description: _descController.text);
    _emitChanges();
  }

  void _emitChanges() {
    widget.onChange(_skill);
    setState(() {});
  }
}

class AttackEditor extends StatefulWidget {
  const AttackEditor({
    super.key,
    required this.attack,
    required this.onChange,
    this.buttonPress,
  });

  final Attack attack;
  final VoidCallback? buttonPress;
  final ValueChanged<Attack> onChange;

  @override
  State<AttackEditor> createState() => _AttackEditorState();
}

class _AttackEditorState extends State<AttackEditor> {
  final _nameController = TextEditingController();
  Attack _attack = Attack();

  @override
  void initState() {
    _attack = widget.attack;
    _nameController.text = _attack.name;
    _nameController.addListener(() {
      _attack = _attack.copyWith(name: _nameController.text);
      _emitChanges();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _attack = widget.attack;
    return ExpandableBox(
      style: Style($box.color(Colors.black38)),
      header: Text(_attack.name),
      child: SingleChildScrollView(
        child: VBox(
          style: vboxStyle.merge(
            Style($box.height((200 + 50 * _attack.damages.length).toDouble())),
          ),
          children: [
            HBox(
              style: hboxStyle,
              children: [
                Expanded(
                  child: TextField(
                    controller: _nameController,
                    decoration: _labelDecor("Attack Name"),
                  ),
                ),
                DamageTypeSelector(
                  initialValue: _attack.damageType,
                  onChange: (dts) {
                    _attack = _attack.copyWith(damageType: dts);
                    _emitChanges();
                  },
                ),
              ],
            ),
            Expanded(
              child: ListView.separated(
                separatorBuilder: (_, _) => CommonUI.spacer(),
                itemCount: _attack.damages.length + 1,
                itemBuilder: (_, index) {
                  if (index >= _attack.damages.length) {
                    return Tooltip(
                      message: "Add Damage",
                      child: IconButton.filled(
                        onPressed: () {
                          var currentDamages = _attack.damages;
                          currentDamages.add(Damage());
                          _attack = _attack.copyWith(damages: currentDamages);
                          _emitChanges();
                        },
                        icon: Icon(Icons.add),
                      ),
                    );
                  }
                  Damage _damage = _attack.damages[index];
                  return DamageEditor(
                    damage: _damage,
                    onChange: (damage) {
                      _attack.damages[index] = damage;
                      _emitChanges();
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  InputDecoration _labelDecor(String text) {
    return InputDecoration(label: Text(text));
  }

  void _nameChanges() {
    _attack = _attack.copyWith(name: _nameController.text);
    _emitChanges();
  }

  void _emitChanges() {
    widget.onChange(_attack);
    setState(() {});
  }
}

class DamageEditor extends StatefulWidget {
  const DamageEditor({
    super.key,
    required this.damage,
    required this.onChange,
    this.buttonPress,
  });

  final Damage damage;
  final ValueChanged<Damage> onChange;
  final VoidCallback? buttonPress;

  @override
  State<DamageEditor> createState() => _DamageEditorState();
}

class _DamageEditorState extends State<DamageEditor> {
  final _multiplierController = TextEditingController();
  final _hitCountController = TextEditingController();
  Damage _damage = Damage();
  @override
  void initState() {
    _damage = widget.damage;
    _multiplierController.text = "${_damage.multiplier}";
    _multiplierController.addListener(_multiplerChanges);
    _hitCountController.text = "${_damage.hitCount}";
    _hitCountController.addListener(_hitCountChanges);
    super.initState();
  }

  List<StatName> validSources = const [.ATK, .DEF, .HP, .EnergyRegen];

  @override
  Widget build(BuildContext context) {
    _damage = widget.damage;
    return Box(
      style: cardStyle.merge(Style($box.color(Colors.blueAccent))),
      child: HBox(
        style: hboxStyle,
        children: [
          Tooltip(
            message: "Remove Damage",
            child: FilledButton(
              onPressed: widget.buttonPress,
              child: const Icon(Icons.remove),
            ),
          ),
          Tooltip(
            message: "Flat Damage",
            child: Checkbox(
              value: _damage.isFlat,
              onChanged: (val) {
                _damage = _damage.copyWith(isFlat: val);
                _emitChanges();
              },
            ),
          ),
          // Multiplier
          Expanded(
            child: TextField(
              controller: _multiplierController,
              decoration: _labelDecor("Multiplier"),
            ),
          ),
          Expanded(
            child: TextField(
              controller: _hitCountController,
              decoration: _labelDecor("Hit Count"),
            ),
          ),
          Expanded(
            child: StatNamePicker(
              statName: _damage.source ?? StatName.ATK,
              only: validSources,
              onChange: (name) {
                _damage = _damage.copyWith(source: name);
                _emitChanges();
              },
            ),
          ),
        ],
      ),
    );
  }

  void _multiplerChanges() {
    double? newMultiplier = double.tryParse(_multiplierController.text);
    _damage = _damage.copyWith(multiplier: newMultiplier);
    _emitChanges();
  }

  void _hitCountChanges() {
    int? hitCount = int.tryParse(_hitCountController.text);
    _damage = _damage.copyWith(hitCount: hitCount);
    _emitChanges();
  }

  void _emitChanges() {
    widget.onChange(_damage);
    setState(() {});
  }

  InputDecoration _labelDecor(String text) {
    return InputDecoration(label: Text(text));
  }
}
