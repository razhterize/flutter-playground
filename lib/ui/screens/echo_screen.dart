import 'dart:convert';
import 'dart:io' show Directory, File;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mix/mix.dart';
import 'package:ww_optimizer/assets.dart';
import 'package:ww_optimizer/core/types.dart';
import 'package:ww_optimizer/cubit/echoes_cubit.dart';
import 'package:ww_optimizer/paths.dart';
import 'package:ww_optimizer/ui/style.dart';
import 'package:ww_optimizer/ui/widgets/images.dart';
import 'package:ww_optimizer/ui/widgets/stat_picker.dart';
import 'package:ww_optimizer/wuthering/wuthering.dart';

class EchoScreen extends StatefulWidget {
  const EchoScreen({super.key});

  @override
  State<EchoScreen> createState() => _EchoScreenState();
}

class _EchoScreenState extends State<EchoScreen> {
  @override
  Widget build(BuildContext context) {
    return VBox(
      style: vboxStyle.merge(Style($box.margin.all(10))),
      children: [
        // TODO: Echo creator (substat, level, sonata, etc)
        Expanded(child: _EchoCreator()),
        // TODO: Echo Inventory, show saved echoes. edit when clicked
        Expanded(child: _EchoInventory()),
      ],
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
  JsonType _rawJson = {};
  late EchoesCubit _cubit;

  final List<String> echoNames = Directory(assetDir.join("echoes"))
      .listSync()
      .whereType<File>()
      .where((e) => e.path.endsWith("json"))
      .map((f) => f.path.split('/').last.replaceAll(".json", ""))
      .toList();

  @override
  Widget build(BuildContext context) {
    _cubit = context.read<EchoesCubit>();
    if (_cubit.editedEcho != null) {
      _echoNameController.text = _cubit.editedEcho?.name ?? "Invalid Echo";
      final rawFile = File("${assetDir.path}/echoes/${_echo.name}.json");
      _rawJson = jsonDecode(rawFile.readAsStringSync());
    }
    return Box(
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
    );
  }

  Widget _buildEchoEditor() {
    return Box(
      style: cardStyle,
      child: HBox(
        style: hboxStyle,
        children: [
          EchoImage(
            _cubit.editedEcho!,
            imageSize: Size(150, 150),
            showName: false,
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
                  dropdownMenuEntries: echoNames.map((name) {
                    return DropdownMenuEntry(value: name, label: name);
                  }).toList(),
                ),
                // Sonata Selection
                _sonataSelector(),
                _levelSlider(),
                _mainStatSelector(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _newEcho([String? name]) {
    String _name = echoNames.first;
    if (name != null) _name = name;
    File rawFile = File("${assetDir.path}/echoes/$_name.json");
    _rawJson = jsonDecode(rawFile.readAsStringSync());
    int cost = _rawJson["cost"] ?? 1;
    StatValue topMainStat = echoTopMainStats.getTopMainStat(
      cost,
      25,
      StatName.ATKPercent,
    );
    StatValue botMainStat = echoBotMainStats.getBottomMainStat(cost, 25);
    _echo = _echo.copyWith(
      id: _cubit.echoes.length + 1,
      name: _name,
      level: 25,
      cost: _rawJson["cost"],
      mainStats: Pair(first: topMainStat, second: botMainStat),
      buffs: [],
      substats: [],
      sonata: _getSonata().keys.first,
    );
    _cubit.editEcho(_echo);
  }

  void _saveEcho() {
    _cubit.addEcho(_echo);
  }

  Widget _levelSlider() {
    return Slider(
      max: 25,
      min: 1,
      value: _echo.level.toDouble(),
      onChanged: (v) {
        StatValue topStat = echoTopMainStats.getTopMainStat(
          _echo.cost,
          v.toInt(),
          _echo.mainStats.first.name,
        );
        StatValue botStat = echoBotMainStats.getBottomMainStat(
          _echo.cost,
          v.toInt(),
        );
        _echo = _echo.copyWith(
          level: v.toInt(),
          mainStats: Pair(first: topStat, second: botStat),
        );
        _cubit.editEcho(_echo);
      },
    );
  }

  Widget _mainStatSelector() {
    // Set Default values

    return Box(
      child: VBox(
        style: vboxStyle.merge(Style($box.constraints.maxHeight(150))),
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
              _echo = _echo.copyWith(
                mainStats: mainStats.copyWith(first: topStat, second: botStat),
              );
              _cubit.editEcho(_echo);
            },
            only: echoTopMainStats.getStatNames(_echo.cost),
          ),
          StatValuePicker(
            statValue: _echo.mainStats.second,
            onChange: (_) {},
            only: echoBotMainStats.getStatNames(_echo.cost),
            enable: false,
          ),
        ],
      ),
    );
  }

  Map<Sonata, String> _getSonata() {
    bool predicate(MapEntry<Sonata, String> e) {
      return (_rawJson["sonatas"] as List).contains(e.value);
    }

    if (_rawJson.containsKey("sonatas")) {
      Map<Sonata, String> sonatas = {};
      final entries = sonataNames.entries.where(predicate);
      sonatas.addEntries(entries);
      return sonatas;
    }
    return {};
  }

  Widget _sonataSelector() {
    final sonatas = _getSonata();
    return HBox(
      style: hboxStyle,
      children: sonatas.entries.map((e) {
        String? imagePath = localAssets.getImagePath(e.value);
        if (imagePath != null) {
          // return Image.file(File(imagePath), width: 32, height: 32);
          return IconButton(
            icon: Image.file(File(imagePath), width: 32, height: 32),
            onPressed: () {
              _echo = _echo.copyWith(sonata: e.key);
              _cubit.editEcho(_echo);
            },
          );
        }
        return SizedBox(height: 32, width: 32, child: Placeholder());
      }).toList(),
    );
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
          const imageSize = 200;
          final size = MediaQuery.of(context).size;
          final numCols = (size.width / imageSize).floor();
          return GridView.builder(
            itemCount: state.echoes.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: numCols,
            ),
            itemBuilder: (_, index) {
              return Box(
                style: Style(
                  $box.border.width(1),
                  $box.border.color(Colors.white),
                ),
                child: EchoImage(state.echoes[index], onClick: _cubit.editEcho),
              );
            },
          );
        },
      ),
    );
  }
}
