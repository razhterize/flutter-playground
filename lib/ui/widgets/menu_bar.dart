import 'package:fluent_ui/fluent_ui.dart';
// ignore: unused_import
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ww_optimizer/assets.dart';

class WutheringMenuBar extends StatelessWidget {
  const WutheringMenuBar({super.key});

  @override
  Widget build(BuildContext context) {
    return MenuBar(
      items: [
        MenuBarItem(
          title: 'File',
          items: [
            MenuFlyoutItem(text: const Text('Open'), onPressed: () {}),
            MenuFlyoutItem(text: const Text('Save'), onPressed: () {}),
            const MenuFlyoutSeparator(),
            MenuFlyoutItem(text: const Text('Exit'), onPressed: () {}),
          ],
        ),
        MenuBarItem(
          title: 'Asset',
          items: [
            MenuFlyoutItem(
              text: const Text('Update Asset'),
              onPressed: () async {
                await localAssets.updateAssets();
              },
            ),
          ],
        ),

        MenuBarItem(
          title: 'Help',
          items: [MenuFlyoutItem(text: const Text('About'), onPressed: () {})],
        ),
      ],
    );
  }
}
