import 'dart:convert' show jsonDecode;
import 'dart:io' show Directory, File;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mix/mix.dart';
import 'package:ww_optimizer/ui/widgets/buff_editor.dart';
import 'package:ww_optimizer/ui/widgets/expandable_box.dart';
import 'package:ww_optimizer/utils.dart';

import '../style.dart';
import '../widgets/common.dart';
import '../widgets/images.dart';
import '../widgets/stat_picker.dart';
import '../../assets.dart';
import '../../paths.dart';
import '../../core/types.dart';
import '../../cubit/echoes_cubit.dart';
import '../../core/wuthering.dart';

class EchoScreen extends StatefulWidget {
  const EchoScreen({super.key});

  @override
  State<EchoScreen> createState() => _EchoScreenState();
}

class _EchoScreenState extends State<EchoScreen> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: VBox(
        style: vboxStyle.merge(Style($box.margin.all(10))),
        children: [
          ExpandableBox(
            expandedHeight: 800,
            header: const Text("Echo Builder"),
            child: _EchoCreator(),
          ),
          ExpandableBox(
            expandedHeight: 800,
            header: const Text("Inventory"),
            child: _EchoInventory(),
          ),
        ],
      ),
    );
  }
}

class _EchoCreator extends StatefulWidget {
  const _EchoCreator({super.key});

  @override
  State<_EchoCreator> createState() => __EchoCreatorState();
}

class __EchoCreatorState extends State<_EchoCreator> {
  Echo _echo = Echo();
  final _echoNameController = TextEditingController();
  late final JsonType _rawJson;
  late EchoesCubit _cubit;

  final List<String> echoNames = Directory(assetDir.join("echoes"))
      .listSync()
      .whereType<File>()
      .where((e) => e.path.endsWith("json"))
      .map((f) => f.path.split('/').last.replaceAll(".json", ""))
      .toList();

  @override
  void initState() {
    // Add all echoes json files into _rawJson
    _rawJson = getAllJson(Directory(assetDir.join('echoes')));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _cubit = context.read<EchoesCubit>();
    if (_cubit.editedEcho != null) {
      _echoNameController.text = _cubit.editedEcho?.name ?? "Invalid Echo";
    }
    return BlocListener<EchoesCubit, EchoState>(
      listener: (_, state) {
        _echo = state.editedEcho!;
      },
      child: Box(
        style: cardStyle,
        child: VBox(
          style: vboxStyle,
          children: [
            HBox(
              style: hboxStyle,
              children: [
                FilledButton(onPressed: _newEcho, child: Icon(Icons.add)),
                FilledButton(onPressed: _saveEcho, child: Icon(Icons.save)),
              ],
            ),
            Expanded(
              child: EchoBuilder(
                builder: (_, state) {
                  if (state.editedEcho == null) {
                    return Center(
                      child: Text(
                        "No Echo Edited. Add new one or select from Inventory below",
                      ),
                    );
                  }
                  return _buildEchoEditor();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEchoEditor() {
    return Box(
      style: cardStyle,
      child: VBox(
        style: vboxStyle.merge(Style($flex.mainAxisAlignment.start())),
        children: [
          HBox(
            style: hboxStyle.merge(Style($flex.crossAxisAlignment.center())),
            children: [
              SizedBox(
                height: 150,
                width: 150,
                child: EchoImage(
                  _cubit.editedEcho!,
                  imageSize: Size(150, 150),
                  showName: false,
                ),
              ),
              Expanded(
                child: VBox(
                  style: vboxStyle
                      .applyVariant(flexNoGap)
                      .merge(
                        Style(
                          $flex.mainAxisAlignment.start(),
                          $flex.crossAxisAlignment.start(),
                        ),
                      ),
                  children: [
                    DropdownMenu<String>(
                      onSelected: _newEcho,
                      enableFilter: true,
                      menuHeight: MediaQuery.sizeOf(context).height * 0.4,
                      dropdownMenuEntries: echoNames.map((name) {
                        return DropdownMenuEntry(value: name, label: name);
                      }).toList(),
                    ),
                    _sonataSelector(),
                    _levelSlider(),
                    _mainStatSelector(),
                  ],
                ),
              ),
            ],
          ),
          HBox(
            style: hboxStyle,
            children: [
              Expanded(
                child: Box(style: cardStyle, child: _substatEditor()),
              ),
              Expanded(
                child: Box(style: cardStyle, child: _buffsEditor()),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _newEcho([String? name]) {
    String _name = echoNames.first;
    if (name != null) _name = name;
    int cost = _rawJson[_name]["cost"] ?? 1;
    final sonatas = _getSonata(_name);
    final statNames = echoTopMainStats.getStatNames(cost);
    assert(sonatas.isNotEmpty, "Sonata is empty");
    final mainStats = Pair(
      first: echoTopMainStats.getTopMainStat(
        cost,
        25,
        echoTopMainStats.getStatNames(cost).first,
      ),
      second: echoBotMainStats.getBottomMainStat(cost, 25),
    );
    _echo = Echo(
      id: _cubit.echoes.length + 1,
      name: _name,
      level: 25,
      cost: cost,
      mainStats: mainStats,
      buffs: [],
      substats: [],
      sonata: sonatas.keys.first,
    );
    _cubit.editEcho(_echo);
  }

  void _saveEcho() {
    _cubit.addEcho(_echo);
    // Remove edited
    _cubit.editEcho(null);
  }

  Widget _levelSlider() {
    return HBox(
      style: hboxStyle,
      children: [
        SizedBox(width: 20, child: Text("${_echo.level}")),
        Expanded(
          child: Slider(
            max: 25,
            min: 0,
            value: _echo.level.toDouble(),
            onChanged: (v) {
              _updateEcho(
                level: v.toInt(),
                mainStats: Pair(
                  first: echoTopMainStats.getTopMainStat(
                    _echo.cost,
                    v.toInt(),
                    _echo.mainStats.first.name,
                  ),
                  second: echoBotMainStats.getBottomMainStat(
                    _echo.cost,
                    v.toInt(),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _mainStatSelector() {
    return VBox(
      style: vboxStyle,
      children: [
        StatValuePicker(
          statValue: _echo.mainStats.first,
          onChange: (statValue) {
            var mainStats = _echo.mainStats;
            StatValue topStat = echoTopMainStats.getTopMainStat(
              _echo.cost,
              _echo.level,
              statValue.name,
            );
            StatValue botStat = echoBotMainStats.getBottomMainStat(
              _echo.cost,
              _echo.level,
            );
            _updateEcho(
              mainStats: Pair(first: topStat, second: botStat),
            );
          },
          only: echoTopMainStats.getStatNames(_echo.cost),
        ),
        // FIXME: Seems like only HP is registered on bottom main stat?
        StatValuePicker(
          statValue: _echo.mainStats.second,
          onChange: (_) {},
          only: echoBotMainStats.getStatNames(_echo.cost),
          enable: false,
        ),
      ],
    );
  }

  Map<Sonata, String> _getSonata([String? echoName]) {
    var _echoName = _echo.name;
    if (echoName != null) _echoName = echoName;
    assert(
      _echoName.isNotEmpty && _rawJson.containsKey(_echoName),
      "echoName used to search Sonata is empty, or data does not exist"
      "key used $_echoName. is in _rawJson: ${_rawJson.containsKey(_echoName)}",
    );

    bool predicate(MapEntry<Sonata, String> e) {
      return (_rawJson[_echoName]["sonatas"] as List).contains(e.value);
    }

    if (_rawJson[_echoName].containsKey("sonatas")) {
      Map<Sonata, String> sonatas = {};
      final entries = sonataNames.entries.where(predicate);
      sonatas.addEntries(entries);
      return sonatas;
    }
    return {};
  }

  Widget _sonataSelector() {
    final sonatas = _getSonata(_echo.name);
    return HBox(
      style: hboxStyle,
      children: sonatas.entries.map((e) {
        String? imagePath = localAssets.getImagePath(e.value);
        if (imagePath != null) {
          // return Image.file(File(imagePath), width: 32, height: 32);
          return Tooltip(
            message: e.value,
            child: IconButton(
              icon: Image.file(File(imagePath), width: 32, height: 32),
              onPressed: () => _updateEcho(sonata: e.key),
            ),
          );
        }
        return SizedBox(height: 32, width: 32, child: Placeholder());
      }).toList(),
    );
  }

  Widget _substatEditor() {
    return VBox(
      style: vboxStyle,
      children: [
        ..._echo.substats.map((sv) {
          assert(substatValues.containsKey(sv.name));
          return HBox(
            style: hboxStyle,
            children: [
              StatNamePicker(
                statName: sv.name,
                onChange: (statName) {
                  var substats = _echo.substats;
                  assert(substatValues.containsKey(statName));
                  substats[_echo.substats.indexOf(sv)] = sv.copyWith(
                    name: statName,
                    value: substatValues[statName]!.first,
                  );
                  _updateEcho(substats: substats);
                },
                only: [...substatValues.keys],
              ),
              DropdownMenu<double>(
                // Max 40% Height
                menuHeight: MediaQuery.sizeOf(context).height * .4,
                initialSelection: sv.value,
                onSelected: (value) {
                  var substats = _echo.substats;
                  substats[_echo.substats.indexOf(sv)] = sv.copyWith(
                    value: value,
                  );
                  _updateEcho(substats: substats);
                },
                dropdownMenuEntries: [
                  ...substatValues[sv.name]!.map((substatValue) {
                    return DropdownMenuEntry(
                      value: substatValue,
                      label: "$substatValue${sv.isPercent ? ' %' : ''}",
                    );
                  }),
                ],
              ),
            ],
          );
        }),
        Tooltip(
          message: "Add Substat",
          child: _echo.substats.length < 5
              ? FilledButton(
                  onPressed: () {
                    if (_echo.substats.length < 5) {
                      _updateEcho(
                        substats: [
                          ..._echo.substats,
                          StatValue(name: substatValues.keys.first),
                        ],
                      );
                    }
                  },
                  child: Icon(Icons.add),
                )
              : Container(),
        ),
      ],
    );
  }

  Widget _buffsEditor() {
    return VBox(
      style: vboxStyle,
      children: [
        ..._echo.buffs.map((buff) {
          return BuffPicker(
            buff: buff,
            onChange: (newBuff) {
              var currentBuffs = _echo.buffs;
              currentBuffs[currentBuffs.indexOf(buff)] = newBuff;
              _updateEcho(buffs: currentBuffs);
            },
          );
        }),
        Tooltip(
          message: "Add Buff",
          child: FilledButton(
            onPressed: () {
              _updateEcho(buffs: [..._echo.buffs, Buff()]);
            },
            child: Icon(Icons.add),
          ),
        ),
      ],
    );
  }

  void _updateEcho({
    int? id,
    String? name,
    BuffList? buffs,
    StatList? substats,
    Sonata? sonata,
    int? cost,
    int? level,
    Pair<StatValue, StatValue>? mainStats,
  }) {
    _echo = _echo.copyWith(
      id: id,
      name: name,
      buffs: buffs,
      substats: substats,
      sonata: sonata,
      cost: cost,
      level: level,
      mainStats: mainStats,
    );
    _cubit.editEcho(_echo);
  }
}

class _EchoInventory extends StatefulWidget {
  const _EchoInventory({super.key});

  @override
  State<_EchoInventory> createState() => __EchoInventoryState();
}

class __EchoInventoryState extends State<_EchoInventory> {
  late EchoesCubit _cubit;

  @override
  Widget build(BuildContext context) {
    _cubit = context.read<EchoesCubit>();
    final maxSize = MediaQuery.of(context).size;
    return Box(
      style: cardStyle.merge(
        // 60% screen sizs max height
        Style($box.constraints.maxHeight(maxSize.height * 0.6)),
      ),
      child: EchoBuilder(
        builder: (_, state) {
          if (state.echoes.isEmpty) {
            return const Center(child: Text("No Echo Saved"));
          }
          const imageSize = 125;
          final size = MediaQuery.of(context).size;
          final numCols = (size.width / imageSize).floor();
          return GridView.builder(
            itemCount: state.echoes.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: numCols,
            ),
            itemBuilder: (_, index) {
              return CommonUI.padding4(
                child: EchoImage(
                  state.echoes[index],
                  onClick: _cubit.editEcho,
                  showName: false,
                ),
              );
            },
          );
        },
      ),
    );
  }
}
