import 'dart:io';
import 'package:flutter/material.dart';

import 'outline_text.dart';
import '../../assets.dart';
import '../../core/wuthering.dart';

class ResonatorImage extends StatelessWidget {
  const ResonatorImage(
    this.resonator, {
    super.key,
    this.onClick,
    this.imageSize,
    this.showName = true,
  });

  final Resonator resonator;
  final Size? imageSize;
  final bool showName;
  final ValueChanged<Resonator>? onClick;

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
      onTap: () {
        if (onClick != null) {
          onClick!(resonator);
        }
      },
      child: Container(
        decoration: _boxDecor,
        child: Stack(
          alignment: .bottomCenter,
          children: [
            imagePath != null
                ? Image.file(
                    File(imagePath),
                    height: imageSize?.height,
                    width: imageSize?.width,
                  )
                : Placeholder(),
            showName
                ? OutlinedText(
                    resonator.name,
                    fontSize: 18,
                    fillColor:
                        _elementColor[resonator.elementType] ?? Colors.black,
                  )
                : Container(width: imageSize?.width ?? 100),
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
  const WeaponImage(
    this.weapon, {
    super.key,
    this.onClick,
    this.imageSize,
    this.showName = false,
  });

  final Weapon weapon;
  final Size? imageSize;
  final bool showName;
  final ValueChanged<Weapon>? onClick;

  @override
  Widget build(BuildContext context) {
    final String? imagePath = localAssets.getImagePath(weapon.name);
    final _boxDecor = BoxDecoration(
      border: BoxBorder.all(color: Colors.white, width: 2),
      borderRadius: BorderRadius.circular(10),
    );
    return GestureDetector(
      onTap: () {
        if (onClick != null) {
          onClick!(weapon);
        }
      },
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
  const EchoImage(
    this.echo, {
    super.key,
    this.onClick,
    this.imageSize,
    this.showName = true,
  });

  final Echo echo;
  final ValueChanged<Echo>? onClick;
  final Size? imageSize;
  final bool showName;

  @override
  Widget build(BuildContext context) {
    final String? imagePath = localAssets.getImagePath(echo.name);
    final String? sonataImage = localAssets.getImagePath(
      sonataNames[echo.sonata] ?? "",
    );
    final _boxDecor = BoxDecoration(
      border: BoxBorder.all(color: Colors.white, width: 2),
      borderRadius: BorderRadius.circular(10),
    );
    return GestureDetector(
      onTap: () {
        if (onClick != null) {
          onClick!(echo);
        }
      },
      child: Container(
        decoration: _boxDecor,
        child: Stack(
          alignment: .bottomCenter,
          children: [
            imagePath != null
                ? Image.file(
                    File(imagePath),
                    height: imageSize?.height,
                    width: imageSize?.width,
                  )
                : Placeholder(),
            showName ? OutlinedText(echo.name, fontSize: 18) : Container(),
            Positioned(
              top: 4,
              right: 4,
              // bottom: 100,
              child: sonataImage != null
                  ? Image.file(File(sonataImage), height: 20, width: 20)
                  : Container(height: 32, width: 32),
            ),
          ],
        ),
      ),
    );
  }
}
