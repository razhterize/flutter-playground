import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ww_optimizer/assets.dart';
import 'package:ww_optimizer/cubit/echoes_cubit.dart';
import 'package:ww_optimizer/cubit/resonator_cubit.dart';
import 'package:ww_optimizer/cubit/status_cubit.dart';
import 'package:ww_optimizer/cubit/weapons_cubit.dart';
import 'package:ww_optimizer/ui/screens/echo_screen.dart';
import 'package:ww_optimizer/ui/screens/main_screen.dart';
import 'package:ww_optimizer/ui/screens/resonator_screen.dart';
import 'package:ww_optimizer/ui/screens/weapon_screen.dart';
import 'package:ww_optimizer/ui/widgets/menu_bar.dart';

void main() {
  runApp(WutheringOptimizer());
}

class WutheringOptimizer extends StatefulWidget {
  const WutheringOptimizer({super.key});

  @override
  State<WutheringOptimizer> createState() => _WutheringOptimizerState();
}

class _WutheringOptimizerState extends State<WutheringOptimizer> {
  WutheringAssets assets = WutheringAssets();

  int _activeScreen = 0;

  var _orientation = 'landscape';
  var _iconSize = 'small_icons';

  @override
  Widget build(BuildContext context) {
    return FluentApp(
      title: "Wuthering Optimizer",
      theme: FluentThemeData(brightness: .dark),
      home: BlocProvider(
        create: (_) => StatusCubit(),
        child: MultiBlocProvider(
          providers: [
            BlocProvider(create: (_) => ResonatorCubit()),
            BlocProvider(create: (_) => EchoesCubit()),
            BlocProvider(create: (_) => WeaponCubit()),
          ],
          child: Builder(builder: _buildLayout),
        ),
      ),
    );
  }

  Widget _buildLayout(BuildContext _) {
    return NavigationView(
      appBar: NavigationAppBar(leading: WutheringMenuBar()),
      pane: NavigationPane(
        onChanged: (idx) => setState(() {
          _activeScreen = idx;
        }),
        selected: _activeScreen,
        displayMode: .compact,
        items: [
          PaneItem(icon: Icon(FluentIcons.accept), body: BuildScreen()),
          PaneItem(icon: Icon(FluentIcons.album), body: ResonatorScreen()),
          PaneItem(icon: Icon(FluentIcons.album), body: WeaponScreen()),
          PaneItem(icon: Icon(FluentIcons.album), body: EchoScreen()),
        ],
      ),
    );
  }
}
