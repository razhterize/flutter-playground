import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mix/mix.dart';
import 'package:ww_optimizer/assets.dart';
import 'package:ww_optimizer/cubit/saved_cubit.dart';
import 'package:ww_optimizer/ui/style.dart';

class MenuEntry {
  const MenuEntry({
    required this.label,
    this.shortcut,
    this.onPressed,
    this.menuChildren,
  }) : assert(
         menuChildren == null || onPressed == null,
         "onPressed is ignored if menuChildren is not emtpy",
       );

  final String label;
  final MenuSerializableShortcut? shortcut;
  final void Function()? onPressed;
  final List<MenuEntry>? menuChildren;

  static List<Widget> build(List<MenuEntry> menuEntries) {
    Widget buildEntry(MenuEntry entry) {
      if (entry.menuChildren != null) {
        return SubmenuButton(
          menuChildren: MenuEntry.build(entry.menuChildren!),
          child: Text(entry.label),
        );
      }
      return MenuItemButton(
        shortcut: entry.shortcut,
        onPressed: entry.onPressed,
        child: Text(entry.label),
      );
    }

    return menuEntries.map(buildEntry).toList();
  }

  static Map<MenuSerializableShortcut, Intent> shortcuts(
    List<MenuEntry> menuEntries,
  ) {
    final Map<MenuSerializableShortcut, Intent> result = {};
    for (var entry in menuEntries) {
      if (entry.menuChildren != null) {
        result.addAll(MenuEntry.shortcuts(entry.menuChildren!));
      } else {
        if (entry.shortcut != null && entry.onPressed != null) {
          result[entry.shortcut!] = VoidCallbackIntent(entry.onPressed!);
        }
      }
    }
    return result;
  }
}

class WutheringMenuBar extends StatefulWidget {
  const WutheringMenuBar({super.key});

  @override
  State<WutheringMenuBar> createState() => _WutheringMenuBarState();
}

class _WutheringMenuBarState extends State<WutheringMenuBar> {
  ShortcutRegistryEntry? _shortcutEntries;
  String? _lastEntry;

  @override
  Widget build(BuildContext context) {
    return HBox(
      style: hboxStyle,
      children: [MenuBar(children: MenuEntry.build(_getMenus()))],
    );
  }

  List<MenuEntry> _getMenus() {
    final List<MenuEntry> result = [
      MenuEntry(
        label: "File",
        menuChildren: [
          MenuEntry(
            label: "Load Data",
            onPressed: () {
              // TODO: Implement Manual Load Data
            },
          ),
          MenuEntry(
            label: "Save Data",
            onPressed: () {
              // TODO: Implement Manual Save Data
              context.read<SavedDataCubit>().saveData(true);
            },
            shortcut: SingleActivator(.keyS, control: true),
          ),
          MenuEntry(
            label: "Exit",
            onPressed: () {
              SystemNavigator.pop();
            },
          ),
        ],
      ),
      MenuEntry(
        label: "Assets",
        menuChildren: [
          MenuEntry(label: "Update", onPressed: localAssets.updateAssets),
          MenuEntry(label: "Clear", onPressed: localAssets.removeAssets,)
        ],
      ),
      MenuEntry(label: "About", onPressed: () {}),
    ];
    _shortcutEntries?.dispose();
    final _shortcutMap = MenuEntry.shortcuts(result);
    if (_shortcutMap.isNotEmpty) {
      _shortcutEntries = ShortcutRegistry.of(context).addAll(_shortcutMap);
    }
    return result;
  }

  @override
  void dispose() {
    _shortcutEntries?.dispose();
    super.dispose();
  }
}
