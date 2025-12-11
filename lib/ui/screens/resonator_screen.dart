import 'dart:io';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ww_optimizer/assets.dart';
import 'package:ww_optimizer/core/wuthering/resonator.dart';
import 'package:ww_optimizer/cubit/resonator_cubit.dart';
import 'package:ww_optimizer/ui/widgets/paddings.dart';

class ResonatorScreen extends StatelessWidget {
  const ResonatorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ResonatorCubit>();
    return Column(
      children: [
        Row(
          mainAxisAlignment: .start,
          crossAxisAlignment: .center,
          children: [
            CommonUI.padding8(
              child: FilledButton(child: const Text("Add Resonator"), onPressed: () {}),
            ),
          ],
        ),
        Expanded(child: _resonatorGridView()),
      ],
    );
  }

  Widget _resonatorGridView() {
    return ResonatorBuilder(
      builder: (_, state) {
        if (state.processing) return Center(child: ProgressRing());
        if (state.resonators.isEmpty) return Center(child: const Text("No Resonators Saved"));
        return GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4),
          itemBuilder: (_, index) => _resonatorImage(state.resonators[index]),
        );
      },
    );
  }

  Widget _resonatorImage(Resonator resonator) {
    String? imagePath = localAssets.getImagePath(resonator.name);
    return ListTile(
      leading: imagePath == null ? null : Image.file(File(imagePath)),
      title: Text(resonator.name),
      subtitle: Row(
        crossAxisAlignment: .center,
        mainAxisAlignment: .start,
        children: [Text(resonator.weaponType.name), Text(resonator.elementType.name)],
      ),
    );
  }
}
