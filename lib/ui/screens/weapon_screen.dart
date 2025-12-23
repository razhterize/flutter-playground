import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mix/mix.dart';
import 'package:ww_optimizer/ui/style.dart';
import 'package:ww_optimizer/ui/widgets/buff_editor.dart';
import 'package:ww_optimizer/ui/widgets/stat_picker.dart';

import '../widgets/images.dart';
import '../widgets/common.dart';
import '../../assets.dart';
import '../../cubit/weapons_cubit.dart';
import '../../core/wuthering.dart';

class WeaponScreen extends StatefulWidget {
  const WeaponScreen({super.key});

  @override
  State<WeaponScreen> createState() => _WeaponScreenState();
}

class _WeaponScreenState extends State<WeaponScreen> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: VBox(
        style: vboxStyle,
        children: [
          Box(style: cardStyle.add($box.maxHeight(400)), child: WeaponEditor()),
          Box(
            style: cardStyle.add($box.maxHeight(800)),
            child: _WeaponInventory(),
          ),
        ],
      ),
    );
  }
}

class WeaponEditor extends StatefulWidget {
  const WeaponEditor({super.key});

  @override
  State<WeaponEditor> createState() => _WeaponEditorState();
}

class _WeaponEditorState extends State<WeaponEditor> {
  final _nameController = TextEditingController();
  late WeaponCubit _cubit;
  Weapon _weapon = Weapon();

  @override
  void initState() {
    _nameController.addListener(() {
      _updateWeapon(name: _nameController.text);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _cubit = context.read<WeaponCubit>();
    return BlocListener<WeaponCubit, WeaponState>(
      listener: (_, state) {
        _weapon = state.editedWeapon!;
        _nameController.text = _weapon.name;
      },
      child: VBox(
        style: vboxStyle,
        children: [
          HBox(
            style: hboxStyle,
            children: [
              FilledButton.icon(
                onPressed: () => _cubit.editWeapon(_weapon),
                label: Icon(Icons.add),
              ),
              FilledButton.icon(
                onPressed: () => _cubit.addWeapon(_weapon),
                label: Icon(Icons.save),
              ),
            ],
          ),
          Expanded(
            child: WeaponBuilder(
              builder: (_, state) {
                if (state.editedWeapon == null) {
                  return Center(
                    child: Text(
                      textAlign: .center,
                      "No Edited Weapon.\n"
                      "Create new or pick from inventory below",
                    ),
                  );
                }
                return VBox(
                  style: vboxStyle,
                  children: [
                    _weaponInfo(),
                    Expanded(
                      child: HBox(
                        style: hboxStyle,
                        children: [
                          Expanded(child: _weaponStats()),
                          Expanded(child: _weaponBuffs()),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _weaponInfo() {
    return HBox(
      style: hboxStyle,
      children: [
        WeaponImage(_weapon, showName: false, imageSize: Size(100, 100)),
        Expanded(
          child: VBox(
            style: vboxStyle,
            children: [
              TextField(
                controller: _nameController,
                decoration: _labelDecor("Weapon Name"),
              ),
              // TODO: Level Slider
              HBox(
                style: hboxStyle,
                children: [
                  Text("Level: ${_weapon.level}"),
                  Expanded(
                    child: Slider(
                      min: 0,
                      max: 90,
                      value: _weapon.level.toDouble(),
                      onChanged: (v) {
                        _updateWeapon(level: v.toInt());
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _weaponStats() {
    return VBox(
      style: vboxStyle,
      children: [
        ..._weapon.stats.map((sv) {
          return StatValuePicker(
            statValue: sv,
            buttonPress: () {
              _weapon.stats.remove(sv);
              _updateWeapon(stats: _weapon.stats);
            },
            onChange: (newStats) {
              var _stats = _weapon.stats;
              _stats[_stats.indexOf(sv)] = newStats;
              _updateWeapon(stats: _stats);
            },
          );
        }),
        Tooltip(
          message: "Add Stat",
          child: FilledButton(
            onPressed: () {
              _updateWeapon(stats: [..._weapon.stats, StatValue()]);
            },
            child: Icon(Icons.add),
          ),
        ),
      ],
    );
  }

  Widget _weaponBuffs() {
    return VBox(
      style: vboxStyle,
      children: [
        ..._weapon.buffs.map((buff) {
          return BuffPicker(
            buff: buff,
            buttonPress: () {
              _weapon.buffs.remove(buff);
              _updateWeapon(buffs: _weapon.buffs);
            },
            onChange: (newBuff) {
              var _buffs = _weapon.buffs;
              _buffs[_buffs.indexOf(buff)] = newBuff;
              _updateWeapon(buffs: _buffs);
            },
          );
        }),
        Tooltip(
          message: "Add Buff",
          child: FilledButton(
            onPressed: () {
              _updateWeapon(buffs: [..._weapon.buffs, Buff()]);
            },
            child: Icon(Icons.add),
          ),
        ),
      ],
    );
  }

  void _updateWeapon({
    int? id,
    String? name,
    int? level,
    WeaponType? type,
    StatList? stats,
    BuffList? buffs,
  }) {
    _weapon = _weapon.copyWith(
      id: id,
      name: name,
      level: level,
      type: type,
      stats: stats,
      buffs: buffs,
    );
    _cubit.editWeapon(_weapon);
    setState(() {});
  }

  InputDecoration _labelDecor(String text) =>
      InputDecoration(label: Text(text));
}

class _WeaponInventory extends StatefulWidget {
  const _WeaponInventory({super.key});

  @override
  State<_WeaponInventory> createState() => _WeaponInventoryState();
}

class _WeaponInventoryState extends State<_WeaponInventory> {
  final TextEditingController _filterController = TextEditingController();
  WeaponType _filterType = .None;

  String get _filterText => _filterController.text;

  @override
  Widget build(BuildContext context) {
    final _cubit = context.read<WeaponCubit>();
    return VBox(
      children: [
        _weaponFilter(context),
        Expanded(
          child: WeaponBuilder(
            builder: (context, state) {
              const int imageSize = 125;
              final size = MediaQuery.of(context).size;
              final numCols = (size.width / imageSize).floor();
              if (state.processing) return CircularProgressIndicator();
              if (state.weapons.isEmpty) return const Text("No Weapon Saved");
              List<Weapon> showedWeapon = state.weapons;
              if (_filterText.isNotEmpty && _filterType == .None) {
                bool matchFilter(Weapon w) =>
                    w.name.toLowerCase().contains(_filterText.toLowerCase());
                showedWeapon = state.weapons.where(matchFilter).toList();
              }
              return GridView.builder(
                itemCount: showedWeapon.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: numCols,
                ),
                itemBuilder: (_, index) => CommonUI.padding8(
                  child: WeaponImage(
                    showedWeapon[index],
                    onClick: _cubit.editWeapon,
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _weaponFilter(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SizedBox(
      height: 40,
      width: size.width,
      child: Row(
        children: [
          // Name search box
          Flexible(
            child: TextField(
              controller: _filterController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                isDense: true,
                label: Text("Search Weapon"),
              ),
              onChanged: (_) => setState(() {}),
              expands: false,
            ),
          ),
        ],
      ),
    );
  }
}
