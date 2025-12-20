import 'package:flutter/material.dart';
import '../../core/wuthering.dart';

class WeaponInfoWidget extends StatelessWidget {
  const WeaponInfoWidget(this.weapon, {super.key});

  final Weapon? weapon;

  @override
  Widget build(ctx) {
    if (weapon == null) {
      return const Text("No Weapon Selected");
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Name: ${weapon!.name}"),
        Text("Type: ${weapon!.type.name}"),
        const SizedBox(height: 8),
        Text("Stats:"),
        ...weapon!.stats.map((stat) => Text("- ${stat.toString()}")),
        const SizedBox(height: 8),
        Text("Buffs:"),
        ...weapon!.buffs.map((buff) => Text("- ${buff.toString()}")),
      ],
    );
  }
}
