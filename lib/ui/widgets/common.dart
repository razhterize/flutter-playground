import 'package:flutter/material.dart';

sealed class CommonUI {
  static Widget padding2({Widget? child}) {
    return Padding(padding: const EdgeInsets.all(2), child: child);
  }

  static Widget padding4({Widget? child}) {
    return Padding(padding: const EdgeInsets.all(4), child: child);
  }

  static Widget padding8({Widget? child}) {
    return Padding(padding: const EdgeInsets.all(8), child: child);
  }

  static Widget padding(double padding, {Widget? child}) {
    return Padding(padding: EdgeInsets.all(padding), child: child);
  }

  static Widget spacer({double width = 10, double height = 10}) {
    return Container(width: width, height: height, color: Colors.transparent);
  }
}
