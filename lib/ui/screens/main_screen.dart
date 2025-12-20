import 'package:flutter/material.dart';

import '../widgets/status_bar.dart';

class BuildScreen extends StatelessWidget {
  const BuildScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: .center,
      crossAxisAlignment: .center,
      children: [
        Center(child: Text("Build Screen")),
        StatusBar()
      ],
    );
  }
}
