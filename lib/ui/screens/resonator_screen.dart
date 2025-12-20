import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mix/mix.dart';
import 'package:ww_optimizer/core/types.dart';
import 'package:ww_optimizer/paths.dart';
import 'package:ww_optimizer/ui/style.dart';
import 'package:ww_optimizer/ui/widgets/buff_editor.dart';
import 'package:ww_optimizer/ui/widgets/expandable_box.dart';
import 'package:ww_optimizer/ui/widgets/images.dart';
import 'package:ww_optimizer/ui/widgets/skill_editor.dart';
import 'package:ww_optimizer/ui/widgets/stat_picker.dart';
import 'package:ww_optimizer/cubit/resonator_cubit.dart';
import 'package:ww_optimizer/ui/widgets/common.dart';
import 'package:ww_optimizer/wuthering/wuthering.dart';

class ResonatorScreen extends StatefulWidget {
  const ResonatorScreen({super.key});

  @override
  State<ResonatorScreen> createState() => _ResonatorScreenState();
}

class _ResonatorScreenState extends State<ResonatorScreen> {
  final _filterController = TextEditingController();
  ElementType _filterElement = ElementType.None;

  @override
  Widget build(BuildContext context) {
    return ResonatorBuilder(
      builder: (_, state) {
        if (state.editedResonator != null) {
          return ResonatorEditor();
        }
        return Column(
          mainAxisSize: .min,
          crossAxisAlignment: .start,
          mainAxisAlignment: .spaceEvenly,
          children: [
            Flexible(child: _resonatorFilter(context)),
            Flexible(flex: 9, child: _resonatorGridView()),
          ],
        );
      },
    );
  }

  Widget _resonatorFilter(BuildContext context) {
    return CommonUI.padding8(
      child: Row(
        children: [
          Icon(Icons.search),
          CommonUI.spacer(),
          Expanded(
            child: TextField(
              decoration: InputDecoration(label: const Text("Filter by name")),
              controller: _filterController,
              onChanged: (_) => setState(() {}),
            ),
          ),
        ],
      ),
    );
  }

  Widget _resonatorGridView() {
    // context.read<ResonatorCubit>();
    return ResonatorBuilder(
      builder: (context, state) {
        const imageSize = 200;
        final size = MediaQuery.of(context).size;
        final numCols = (size.width / imageSize).floor();
        if (state.processing) return Center(child: CircularProgressIndicator());
        if (state.resonators.isEmpty) {
          return Center(child: const Text("No Resonators Saved"));
        }
        List<Resonator> showedResonator = state.resonators;
        if (_filterController.text.isNotEmpty && _filterElement == .None) {
          bool matchFilter(Resonator r) => r.name.toLowerCase().contains(
            _filterController.text.toLowerCase(),
          );
          showedResonator = state.resonators.where(matchFilter).toList();
        }
        return GridView.builder(
          itemCount: showedResonator.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: numCols,
          ),
          itemBuilder: (context, index) => Padding(
            padding: const EdgeInsets.all(20.0),
            child: ResonatorImage(
              showedResonator[index],
              onClick: context.read<ResonatorCubit>().editResonator,
            ),
          ),
        );
      },
    );
  }
}

class ResonatorEditor extends StatefulWidget {
  const ResonatorEditor({super.key});

  @override
  State<ResonatorEditor> createState() => _ResonatorEditorState();
}

class _ResonatorEditorState extends State<ResonatorEditor> {
  // Raw Json to get base stats per level
  late JsonType _rawJson;
  late ResonatorCubit _cubit;
  Resonator edited = Resonator();
  final _nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    _cubit = context.read<ResonatorCubit>();
    _nameController.text = _cubit.edited!.name;
    edited = _cubit.edited!;
    _rawJson = jsonDecode(
      File(
        "${assetDir.path}/resonators/${edited.name}.json",
      ).readAsStringSync(),
    );
    return SingleChildScrollView(
      child: VBox(
        style: flexStyle,
        children: [
          _resonatorInfo(context),
          // Box(style: cardStyle, child: _statsEditor(context)),
          ExpandableBox(
            header: const Text("Stats"),
            expandedHeight: (100 + (50 * edited.stats.length)).toDouble(),
            child: _statsEditor(context),
          ),
          ExpandableBox(
            header: const Text("Buffs"),
            expandedHeight: (100 + (50 * edited.buffs.length)).toDouble(),
            child: _buffsEditor(context),
          ),
          ExpandableBox(
            header: const Text("Skill"),
            expandedHeight: (100 + (600 * edited.skills.length)).toDouble(),
            child: _skillsEditor(context),
          ),
        ],
      ),
    );
  }

  Widget _resonatorInfo(BuildContext context) {
    return Box(
      style: cardStyle.applyVariant(horizontalMargin),
      child: HBox(
        style: flexStyle,
        children: [
          ResonatorImage(edited, imageSize: Size(200, 200), showName: false),
          Expanded(
            child: VBox(
              style: flexStyle,
              children: [
                TextField(
                  controller: _nameController,
                  readOnly: true,
                  decoration: InputDecoration(
                    label: const Text("Resonator Name"),
                  ),
                ),
                _levelSlider(context),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _levelSlider(BuildContext context) {
    return Slider(
      min: 1,
      max: 90,
      label: "${edited.level}",
      value: edited.level.toDouble(),
      onChanged: (v) {
        edited.level = v.toInt();
        StatMap _levelStats = {
          StatName.ATK: _rawJson["stats"]["${v.toInt()}"]["ATK"],
          StatName.HP: _rawJson["stats"]["${v.toInt()}"]["HP"],
          StatName.DEF: _rawJson["stats"]["${v.toInt()}"]["DEF"],
        };
        for (var levelStat in _levelStats.entries) {
          edited.stats.update(
            levelStat.key,
            (value) => levelStat.value,
            ifAbsent: () => levelStat.value,
          );
        }
        _update();
      },
    );
  }

  Widget _statsEditor(BuildContext context) {
    return ListView.separated(
      separatorBuilder: (_, _) => CommonUI.spacer(),
      itemCount: edited.stats.isEmpty ? 1 : edited.stats.length + 1,
      itemBuilder: (_, index) {
        if (edited.stats.isEmpty || index >= edited.stats.length) {
          return IconButton.filled(
            onPressed: () {
              StatName validKey = StatName.values.where((n) {
                return !edited.stats.containsKey(n) && n != StatName.None;
              }).first;
              edited.stats.update(validKey, (v) => 0, ifAbsent: () => 0);
              _update();
            },
            icon: Icon(Icons.add),
          );
        }
        final entry = edited.stats.entries.elementAt(index);
        return StatValuePicker(
          statValue: StatValue(name: entry.key, value: entry.value),
          except: edited.stats.entries.map((e) => e.key).toList(),
          buttonPress: () {
            edited.stats.remove(entry.key);
            _update();
          },
          onChange: (stat) {
            // Check if key changes. Delete previous if it does
            if (stat.name != entry.key) {
              edited.stats.remove(entry.key);
            }
            edited.stats.update(
              stat.name,
              (v) => stat.value,
              ifAbsent: () => stat.value,
            );
            _update();
          },
        );
      },
    );
  }

  Widget _buffsEditor(BuildContext context) {
    return ListView.separated(
      separatorBuilder: (_, _) => CommonUI.spacer(height: 8),
      itemCount: edited.buffs.length + 1,
      itemBuilder: (_, index) {
        // Add Buff Button
        if (edited.buffs.isEmpty || index >= edited.buffs.length) {
          return Tooltip(
            message: "Add Buff",
            child: FilledButton(
              onPressed: () {
                edited.buffs.add(Buff());
                _update();
              },
              child: Icon(Icons.add),
            ),
          );
        }
        final buff = edited.buffs[index];
        return BuffPicker(
          buff: buff,
          buttonPress: () {
            edited.buffs.removeAt(index);
            _update();
          },
          onChange: (buff) {
            edited.buffs[index] = buff;
            _update();
          },
        );
      },
    );
  }

  Widget _skillsEditor(BuildContext context) {
    return ListView.separated(
      itemCount: edited.skills.length + 1,
      separatorBuilder: (_, _) => CommonUI.spacer(),
      itemBuilder: (_, index) {
        if (index >= edited.skills.length) {
          return Tooltip(
            message: "Add Skill",
            child: FilledButton(
              onPressed: () {
                edited.skills.add(Skill());
                _update();
              },
              child: Icon(Icons.add),
            ),
          );
        }
        return SkillEditor(
          skill: edited.skills[index],
          onChange: (skill) {
            edited.skills[index] = skill;
            _update();
          },
        );
      },
    );
  }

  void _update() {
    _cubit.updateResonator(edited);
    _cubit.editResonator(edited);
  }
}
