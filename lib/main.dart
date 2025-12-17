import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ww_optimizer/cubit/echoes_cubit.dart';
import 'package:ww_optimizer/cubit/resonator_cubit.dart';
import 'package:ww_optimizer/cubit/saved_cubit.dart';
import 'package:ww_optimizer/cubit/status_cubit.dart';
import 'package:ww_optimizer/cubit/weapons_cubit.dart';
import 'package:ww_optimizer/paths.dart';
import 'package:ww_optimizer/ui/screens/echo_screen.dart';
import 'package:ww_optimizer/ui/screens/main_screen.dart';
import 'package:ww_optimizer/ui/screens/resonator_screen.dart';
import 'package:ww_optimizer/ui/screens/weapon_screen.dart';
import 'package:ww_optimizer/ui/widgets/menu_bar.dart';

void main() async {
  await initDirectories();
  runApp(WutheringOptimizer());
}

class WutheringOptimizer extends StatefulWidget {
  const WutheringOptimizer({super.key});

  @override
  State<WutheringOptimizer> createState() => _WutheringOptimizerState();
}

class _WutheringOptimizerState extends State<WutheringOptimizer> {
  int _activeScreen = 0;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Wuthering Optimizer",
      theme: .dark(),
      home: Scaffold(
        body: MultiBlocProvider(
          providers: [
            BlocProvider(create: (_) => SavedDataCubit(), lazy: false),
            BlocProvider(create: (_) => StatusCubit(), lazy: false),
          ],
          child: Builder(
            builder: (BuildContext context) {
              final _savedCubit = context.read<SavedDataCubit>();
              return MultiBlocProvider(
                providers: [
                  BlocProvider(create: (_) => ResonatorCubit(_savedCubit)),
                  BlocProvider(create: (_) => EchoesCubit(_savedCubit)),
                  BlocProvider(create: (_) => WeaponCubit(_savedCubit)),
                ],
                child: _buildLayout(),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildLayout() {
    List<Widget> screens = [
      BuildScreen(),
      ResonatorScreen(),
      WeaponScreen(),
      EchoScreen(),
    ];
    return Row(
      children: [
        NavigationRail(
          destinations: [
            NavigationRailDestination(
              icon: Icon(Icons.widgets),
              label: Text("Build"),
            ),
            NavigationRailDestination(
              icon: Icon(Icons.arrow_forward),
              label: Text("Resonator"),
            ),
            NavigationRailDestination(
              icon: Icon(Icons.widgets),
              label: Text("Weapon"),
            ),
            NavigationRailDestination(
              icon: Icon(Icons.widgets),
              label: Text("Echo"),
            ),
          ],
          selectedIndex: _activeScreen,
          onDestinationSelected: (value) {
            _activeScreen = value;
            setState(() {});
          },
        ),
        Expanded(child: screens[_activeScreen]),
      ],
    );
    // return NavigationView(
    //   appBar: NavigationAppBar(leading: WutheringMenuBar()),
    //   pane: NavigationPane(
    //     onChanged: (idx) => setState(() {
    //       _activeScreen = idx;
    //     }),
    //     selected: _activeScreen,
    //     displayMode: .compact,
    //     items: [
    //       PaneItem(icon: Icon(FluentIcons.accept), body: BuildScreen()),
    //       PaneItem(icon: Icon(FluentIcons.album), body: ResonatorScreen()),
    //       PaneItem(icon: Icon(FluentIcons.album), body: WeaponScreen()),
    //       PaneItem(icon: Icon(FluentIcons.album), body: EchoScreen()),
    //     ],
    //   ),
    // );
  }
}
