import 'package:flutter/material.dart';
import 'package:ww_optimizer/cubit/status_cubit.dart';

class StatusBar extends StatelessWidget {
  const StatusBar({super.key});

  @override
  Widget build(BuildContext context) {
    return StatusBuilder(
      buildWhen: (_, current) =>
          current.message != null && current.progress != null,
      builder: (_, state) {
        return Row(
          mainAxisAlignment: .start,
          crossAxisAlignment: .center,
          children: [
            Text(state.message ?? ""),
            state.progress != null
                ? LinearProgressIndicator(value: state.progress?.percentage)
                : Container(),
          ],
        );
      },
    );
  }
}
