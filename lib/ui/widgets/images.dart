import 'dart:io';
import 'package:flutter/material.dart';
import 'package:ww_optimizer/assets.dart';
import 'package:ww_optimizer/ui/widgets/outline_text.dart';
import 'package:ww_optimizer/wuthering/echo.dart';
import 'package:ww_optimizer/wuthering/resonator.dart';
import 'package:ww_optimizer/wuthering/stat.dart';
import 'package:ww_optimizer/wuthering/weapon.dart';

class ResonatorImage extends StatelessWidget {
  const ResonatorImage(this.resonator, {super.key, this.onClick});

  final Resonator resonator;
  final void Function(Resonator)? onClick;

  @override
  Widget build(BuildContext context) {
    final String? imagePath = localAssets.getImagePath(resonator.name);
    final _boxDecor = BoxDecoration(
      border: BoxBorder.all(color: Colors.white, width: 2),
      borderRadius: BorderRadius.circular(10),
      gradient: LinearGradient(
        begin: .bottomCenter,
        end: .topCenter,
        colors: [
          const Color.fromARGB(62, 185, 185, 185),
          _elementColor[resonator.elementType] ?? Colors.black,
        ],
      ),
    );
    return GestureDetector(
      onTap: () => onClick != null ? (resonator) : null,
      child: Container(
        decoration: _boxDecor,
        child: Stack(
          alignment: .bottomCenter,
          children: [
            imagePath != null ? Image.file(File(imagePath)) : Placeholder(),
            OutlinedText(
              resonator.name,
              fontSize: 18,
              fillColor: _elementColor[resonator.elementType] ?? Colors.black,
            ),
          ],
        ),
      ),
    );
  }

  final Map<ElementType, Color> _elementColor = const {
    ElementType.None: Colors.black,
    ElementType.Aero: Color.fromARGB(255, 0, 190, 171),
    ElementType.Spectro: Colors.yellow,
    ElementType.Electro: Colors.deepPurpleAccent,
    ElementType.Fusion: Colors.deepOrangeAccent,
    ElementType.Glacio: Colors.lightBlue,
    ElementType.Havoc: Colors.purple,
  };
}

class WeaponImage extends StatelessWidget {
  const WeaponImage(this.weapon, {super.key, this.onClick});

  final Weapon weapon;
  final void Function(Weapon)? onClick;

  @override
  Widget build(BuildContext context) {
    final String? imagePath = localAssets.getImagePath(weapon.name);
    final _boxDecor = BoxDecoration(
      border: BoxBorder.all(color: Colors.white, width: 2),
      borderRadius: BorderRadius.circular(10),
    );
    return GestureDetector(
      onTap: () => onClick != null ? (weapon) : null,
      child: Container(
        decoration: _boxDecor,
        child: Stack(
          alignment: .bottomCenter,
          children: [
            imagePath != null ? Image.file(File(imagePath)) : Placeholder(),
            OutlinedText(weapon.name, fontSize: 18),
          ],
        ),
      ),
    );
  }
}

class EchoImage extends StatelessWidget {
  const EchoImage(this.echo, {super.key, this.onClick});

  final Echo echo;
  final void Function(Echo)? onClick;

  @override
  Widget build(BuildContext context) {
    final String? imagePath = localAssets.getImagePath(echo.name);
    final _boxDecor = BoxDecoration(
      border: BoxBorder.all(color: Colors.white, width: 2),
      borderRadius: BorderRadius.circular(10),
    );
    return GestureDetector(
      onTap: () => onClick != null ? (echo) : null,
      child: Container(
        decoration: _boxDecor,
        child: Stack(
          alignment: .bottomCenter,
          children: [
            imagePath != null ? Image.file(File(imagePath)) : Placeholder(),
            OutlinedText(echo.name, fontSize: 18),
          ],
        ),
      ),
    );
  }
}
