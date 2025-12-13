import 'dart:io';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ww_optimizer/assets.dart';
import 'package:ww_optimizer/core/wuthering/resonator.dart';
import 'package:ww_optimizer/core/wuthering/stat.dart';
import 'package:ww_optimizer/cubit/resonator_cubit.dart';
import 'package:ww_optimizer/logger.dart';
import 'package:ww_optimizer/ui/widgets/paddings.dart';

class ResonatorScreen extends StatefulWidget {
  const ResonatorScreen({super.key});

  @override
  State<ResonatorScreen> createState() => _ResonatorScreenState();
}

class _ResonatorScreenState extends State<ResonatorScreen> {
  Resonator? _editedResonator = null;
  final TextEditingController _filterController = TextEditingController();
  ElementType _filterElement = ElementType.None;
  int _filteredSize = 0;

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
                autocorrect: true,
                expands: false,
                placeholder: "Search",
                enableSuggestions: true,
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
        rootLogger.info("Size: ${size.width}x${size.height}");
        if (state.processing) return Center(child: ProgressRing());
        if (state.resonators.isEmpty) {
          return Center(child: const Text("No Resonators Saved"));
        }
        List<Resonator> showedResonator = state.resonators;
        if (_filterController.text.isNotEmpty && _filterElement == ElementType.None) {
          bool matchFilter(Resonator r) => r.name.toLowerCase().contains(
            _filterController.text.toLowerCase(),
          );
          showedResonator = state.resonators.where(matchFilter).toList();
        }
        _filteredSize = showedResonator.length;
        return GridView.builder(
          itemCount: _filteredSize,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: numCols,
          ),
          itemBuilder: (context, index) => Padding(
            padding: const EdgeInsets.all(20.0),
            child: _resonatorImage(showedResonator[index], context),
          ),
        );
      },
    );
  }

  Widget _resonatorImage(Resonator resonator, [BuildContext? context]) {
    String? imagePath = localAssets.getImagePath(resonator.name);
    const _decor = BoxDecoration(
      gradient: LinearGradient(
        begin: .bottomCenter,
        colors: [
          Color.fromARGB(255, 0, 0, 0),
          Color.fromARGB(45, 255, 255, 255),
        ],
        end: .topCenter,
      ),
    );
    const _textStyle = TextStyle(fontSize: 24, color: Colors.white);
    return imagePath != null
        ? Stack(
            alignment: .bottomCenter,
            children: [
              Image.file(File(imagePath), semanticLabel: resonator.name),
              Container(
                width: MediaQuery.of(context!).size.width,
                decoration: _decor,
                child: Text(resonator.name, style: _textStyle),
              ),
            ],
          )
        : Placeholder();
  }
}
