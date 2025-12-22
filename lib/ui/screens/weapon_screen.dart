import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mix/mix.dart';
import 'package:ww_optimizer/ui/style.dart';

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
          Box(style: cardStyle.add($box.maxHeight(600)), child: WeaponEditor()),
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
    return VBox(
      style: vboxStyle,
      children: [
        Expanded(
          child: HBox(
            style: hboxStyle,
            children: [
              WeaponBuilder(
                builder: (_, state) {
                  if (state.editedWeapon != null) {
                    return WeaponImage(state.editedWeapon!);
                  }
                  return Placeholder();
                },
              ),
              Expanded(
                child: VBox(
                  style: vboxStyle,
                  children: [
                    TextField(
                      controller: _nameController,
                      decoration: _labelDecor("Weapon Name"),
                    ),
                    // TODO: Level Slider
                  ],
                ),
              ),
            ],
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
    return CommonUI.padding8(
      child: SizedBox(
        height: 30,
        width: size.width,
        child: Row(
          children: [
            // Name search box
            Flexible(
              child: TextField(
                controller: _filterController,
                onChanged: (_) => setState(() {}),
                expands: false,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
