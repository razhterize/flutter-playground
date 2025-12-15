import 'dart:convert';
import 'dart:io';

import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ww_optimizer/core/types.dart';
import 'package:ww_optimizer/paths.dart';
import 'package:ww_optimizer/ui/widgets/images.dart';
import 'package:ww_optimizer/ui/widgets/stat_picker.dart';
import 'package:ww_optimizer/wuthering/resonator.dart';
import 'package:ww_optimizer/wuthering/stat.dart';
import 'package:ww_optimizer/cubit/resonator_cubit.dart';
import 'package:ww_optimizer/ui/widgets/paddings.dart';

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
  late JsonType _rawJson;

  @override
  Widget build(BuildContext context) {
    var edited = context.read<ResonatorCubit>().state.editedResonator!;
    _rawJson = jsonDecode(
      File(
        "${assetDir.path}/resonators/${edited.name}.json",
      ).readAsStringSync(),
    );
    return ResonatorBuilder(
      builder: (_, state) {
        return Column(
          children: [
            ListTile(
              leading: ResonatorImage(edited, imageSize: Size(150, 150)),
              title: TextBox(placeholder: edited.name, enabled: false),
              subtitle: _levelSlider(context),
            ),
            _statsEditor(context),
            _buffsEditor(context),
            _skillsEditor(context),
          ],
        );
      },
    );
  }

  Widget _levelSlider(BuildContext context) {
    var resonator = context.read<ResonatorCubit>().state.editedResonator!;
    return Row(
      children: [
        const Text("Level", style: TextStyle(fontSize: 18)),
        Flexible(
          child: Slider(
            min: 1,
            max: 90,
            label: "${resonator.level}",
            value: resonator.level.toDouble(),
            onChanged: (v) {
              resonator.level = v.toInt();
              StatMap _levelStats = {
                StatName.ATK: _rawJson["stats"]["${v.toInt()}"]["ATK"],
                StatName.HP: _rawJson["stats"]["${v.toInt()}"]["HP"],
                StatName.DEF: _rawJson["stats"]["${v.toInt()}"]["DEF"],
              };
              for (var levelStat in _levelStats.entries) {
                resonator.stats.update(
                  levelStat.key,
                  (value) => levelStat.value,
                  ifAbsent: () => levelStat.value,
                );
              }
              _update(context);
            },
          ),
        ),
      ],
    );
  }

  Widget _statsEditor(BuildContext context) {
    var resonator = context.read<ResonatorCubit>().state.editedResonator!;
    var statEntries = resonator.stats.entries.toList();
    return Expander(
      header: const Text("Stats"),
      content: SizedBox(
        height: 200,
        child: ListView.separated(
          separatorBuilder: (_, _) {
            return Container(height: 10, color: Colors.transparent);
          },
          itemCount: resonator.stats.isEmpty ? 1 : resonator.stats.length + 1,
          itemBuilder: (_, index) {
            if (resonator.stats.isEmpty || index >= resonator.stats.length) {
              return FilledButton(
                child: Icon(FluentIcons.add),
                onPressed: () {
                  bool pred(StatName n) {
                    return !resonator.stats.containsKey(n) &&
                        n != StatName.None;
                  }

                  List<StatName> validKeys = StatName.values
                      .where(pred)
                      .toList();
                  resonator.stats.update(
                    validKeys.first,
                    (v) => 0,
                    ifAbsent: () => 0,
                  );
                  _update(context);
                },
              );
            }
            final entry = statEntries[index];
            return StatValuePicker(
              statValue: StatValue(entry.key, entry.value),
              except: statEntries.map((e) => e.key).toList(),
              buttonPress: () {
                resonator.stats.remove(entry.key);
                _update(context);
              },
              onChange: (stat) {
                // Check if key changes. Delete previous if it does
                if (stat.name != entry.key) {
                  resonator.stats.remove(entry.key);
                }
                resonator.stats.update(
                  stat.name,
                  (v) => stat.value,
                  ifAbsent: () => stat.value,
                );
                _update(context);
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buffsEditor(BuildContext context) {
    var resonator = context.read<ResonatorCubit>().state.editedResonator;
    return Expander(header: const Text("Buffs"), content: Placeholder());
  }

  Widget _skillsEditor(BuildContext context) {
    var resonator = context.read<ResonatorCubit>().state.editedResonator;
    return Expander(header: const Text("Skills"), content: Placeholder());
  }

  void _update(BuildContext context) {
    final cubit = context.read<ResonatorCubit>();
    cubit.updateResonator(cubit.state.editedResonator!);
  }
}
