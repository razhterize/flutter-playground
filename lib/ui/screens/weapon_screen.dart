import 'dart:io';

import 'package:fluent_ui/fluent_ui.dart';
import 'package:ww_optimizer/assets.dart';
import 'package:ww_optimizer/cubit/weapons_cubit.dart';
import 'package:ww_optimizer/ui/widgets/paddings.dart';
import 'package:ww_optimizer/wuthering/weapon.dart';

class WeaponScreen extends StatefulWidget {
  const WeaponScreen({super.key});

  @override
  State<WeaponScreen> createState() => _WeaponScreenState();
}

class _WeaponScreenState extends State<WeaponScreen> {
  final _filterController = TextEditingController();

  String get _filterText => _filterController.text;

  final WeaponType _filterType = WeaponType.None;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Flexible(child: _weaponFilter(context)),
        Flexible(flex: 9, child: _weaponGrid(context)),
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
              child: TextBox(
                controller: _filterController,
                onChanged: (_) => setState(() {}),
                expands: false,
                placeholder: "Search",
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _weaponGrid(BuildContext context) {
    return WeaponBuilder(
      builder: (context, state) {
        const int imageSize = 200;
        final size = MediaQuery.of(context).size;
        final numCols = (size.width / imageSize).floor();
        if (state.processing) return ProgressRing();
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
          itemBuilder: (_, index) {
            return CommonUI.padding8(child: _weaponImage(showedWeapon[index]));
          },
        );
      },
    );
  }

  Widget _weaponImage(Weapon w) {
    String? imagePath = localAssets.getImagePath(w.name);
    return Stack(
      alignment: .bottomCenter,
      children: [
        imagePath != null
            ? Image.file(File(imagePath), semanticLabel: w.name)
            : Placeholder(),
        Text(w.name),
      ],
    );
  }
}
