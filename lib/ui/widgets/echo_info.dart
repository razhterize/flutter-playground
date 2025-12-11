import 'package:fluent_ui/fluent_ui.dart';

class EchoImage extends StatelessWidget {
  const EchoImage(this.echo, {super.key});

  final String? echo;

  @override
  Widget build(ctx) {
    if (echo == null || echo!.isEmpty) {
      return const Text("No Echo Selected");
    }
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text("Echo: $echo")]);
  }
}
