import 'dart:io';
import 'dart:convert';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ww_optimizer/core/types.dart';
import 'package:ww_optimizer/paths.dart';
import 'package:ww_optimizer/ui/widgets/buff_editor.dart';
import 'package:ww_optimizer/ui/widgets/images.dart';
import 'package:ww_optimizer/ui/widgets/stat_picker.dart';
import 'package:ww_optimizer/wuthering/resonator.dart';
import 'package:ww_optimizer/wuthering/stat.dart';
import 'package:ww_optimizer/cubit/resonator_cubit.dart';
import 'package:ww_optimizer/ui/widgets/common.dart';

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
    final size = MediaQuery.of(context).size;
    return CommonUI.padding8(
      child: SizedBox(
        height: 30,
        width: size.width,
        child: Row(
          children: [
            Flexible(
              child: TextBox(
                controller: _filterController,
                onChanged: (_) => setState(() {}),
                expands: false,
                placeholder: "Search",
              ),
            ),
            Flexible(child: Row(children: [])),
          ],
        ),
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
        if (state.processing) return Center(child: ProgressRing());
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
  late Resonator edited;
  late ResonatorCubit _cubit;

  @override
  Widget build(BuildContext context) {
    _cubit = context.read<ResonatorCubit>();
    edited = _cubit.state.editedResonator!;
    _rawJson = jsonDecode(
      File(
        "${assetDir.path}/resonators/${edited.name}.json",
      ).readAsStringSync(),
    );
    return ListView(
      children: [
        ListTile(
          leading: ResonatorImage(edited, imageSize: Size(150, 150)),
          title: TextBox(placeholder: edited.name, enabled: false),
          subtitle: _levelSlider(context),
        ),
        _statsEditor(context),
        CommonUI.spacer(height: 10),
        _buffsEditor(context),
        CommonUI.spacer(height: 10),
        _skillsEditor(context),
      ],
    );
  }

  Widget _levelSlider(BuildContext context) {
    return Row(
      children: [
        const Text("Level", style: TextStyle(fontSize: 18)),
        Flexible(
          child: Slider(
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
          ),
        ),
      ],
    );
  }

  Widget _statsEditor(BuildContext context) {
    return Expander(
      header: const Text("Stats"),
      content: SizedBox(
        height: 400,
        child: ListView.separated(
          separatorBuilder: (_, _) {
            return Container(height: 10, color: Colors.transparent);
          },
          itemCount: edited.stats.isEmpty ? 1 : edited.stats.length + 1,
          itemBuilder: (_, index) {
            if (edited.stats.isEmpty || index >= edited.stats.length) {
              return FilledButton(
                child: Icon(FluentIcons.add),
                onPressed: () {
                  bool pred(StatName n) {
                    return !edited.stats.containsKey(n) && n != StatName.None;
                  }

                  List<StatName> validKeys = StatName.values
                      .where(pred)
                      .toList();
                  edited.stats.update(
                    validKeys.first,
                    (v) => 0,
                    ifAbsent: () => 0,
                  );
                  // TODO: Why the stats isn't updating when slider changes?
                  _update();
                },
              );
            }
            final entry = edited.stats.entries.elementAt(index);
            return StatValuePicker(
              statValue: entry.toStatValue(),
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
        ),
      ),
    );
  }

  Widget _buffsEditor(BuildContext context) {
    return Expander(
      header: const Text("Buffs"),
      content: SizedBox(
        height: 200,
        child: ListView.separated(
          separatorBuilder: (_, _) => CommonUI.spacer(height: 8),
          itemCount: edited.buffs.length,
          itemBuilder: (_, index) {
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
        ),
      ),
    );
  }

  Widget _skillsEditor(BuildContext context) {
    var resonator = context.read<ResonatorCubit>().state.editedResonator;
    return Expander(header: const Text("Skills"), content: Placeholder());
  }

  void _update() {
    _cubit.updateResonator(edited);
    _cubit.editResonator(edited);
  }
}
