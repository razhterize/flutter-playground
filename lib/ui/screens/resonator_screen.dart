import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ww_optimizer/assets.dart';
import 'package:ww_optimizer/ui/widgets/images.dart';
import 'package:ww_optimizer/wuthering/resonator.dart';
import 'package:ww_optimizer/wuthering/stat.dart';
import 'package:ww_optimizer/cubit/resonator_cubit.dart';
import 'package:ww_optimizer/ui/widgets/paddings.dart';

class ResonatorScreen extends StatefulWidget {
  const ResonatorScreen({super.key});

  @override
  State<ResonatorScreen> createState() => _ResonatorScreenState();
}

class _ResonatorScreenState extends State<ResonatorScreen> {
  Resonator? _editedResonator = null;
  final _filterController = TextEditingController();
  ElementType _filterElement = ElementType.None;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: .min,
      crossAxisAlignment: .start,
      mainAxisAlignment: .spaceEvenly,
      children: [
        Flexible(child: _resonatorFilter(context)),
        Flexible(flex: 9, child: _resonatorGridView()),
      ],
    );
  }

  Widget _resonatorFilter(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return CommonUI.padding8(
      child: SizedBox(
        height: 30,
        width: size.width,
        child: Row(
          children: [
            Flexible(
              child: TextBox(
                controller: _filterController,
                onChanged: (_) => setState(() {}),
                expands: false,
                placeholder: "Search",
              ),
            ),
            Flexible(child: Row(children: [])),
          ],
        ),
      ),
    );
  }

  Widget _resonatorGridView() {
    // context.read<ResonatorCubit>();
    return ResonatorBuilder(
      builder: (context, state) {
        const imageSize = 200;
        final size = MediaQuery.of(context).size;
        final numCols = (size.width / imageSize).floor();
        if (state.processing) return Center(child: ProgressRing());
        if (state.resonators.isEmpty) {
          return Center(child: const Text("No Resonators Saved"));
        }
        List<Resonator> showedResonator = state.resonators;
        if (_filterController.text.isNotEmpty && _filterElement == .None) {
          bool matchFilter(Resonator r) => r.name.toLowerCase().contains(
            _filterController.text.toLowerCase(),
          );
          showedResonator = state.resonators.where(matchFilter).toList();
        }
        return GridView.builder(
          itemCount: showedResonator.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: numCols,
          ),
          itemBuilder: (context, index) => Padding(
            padding: const EdgeInsets.all(20.0),
            child: ResonatorImage(showedResonator[index]),
          ),
        );
      },
    );
  }
}
