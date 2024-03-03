import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_playground/blocs/history_bloc.dart';
import 'package:flutter_playground/model/struct_model.dart';
import 'package:flutter_playground/ui/widgets/struct_view.dart';
import 'package:path_provider/path_provider.dart';

void main(List<String> args) async {
  final dataDir = await getApplicationDocumentsDirectory();
  runApp(App(dataDirectory: dataDir));
}

class App extends StatelessWidget {
  const App({super.key, required this.dataDirectory});

  final Directory dataDirectory;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(),
      home: Scaffold(
        body: BlocProvider(
          create: (context) => HistoryBloc(dataDirectory),
          child: BlocBuilder<HistoryBloc, HistoryState>(
            builder: (context, state) {
              if (state.structs.isEmpty) {
                return Center(
                  child: Column(
                    children: [
                      const Text("No Data"),
                      MaterialButton(
                        onPressed: () => generateRandomStructs(count: 20).forEach((struct) => context.read<HistoryBloc>().add(AddHistory(struct))),
                        child: const Text("Add Data"),
                      ),
                    ],
                  ),
                );
              }
              return ListView.builder(
                itemCount: state.structs.length,
                itemBuilder: (context, index) {
                  return StructView(state.structs[index]);
                },
              );
            },
          ),
        ),
      ),
    );
  }
}

List<StructModel> generateRandomStructs({int count = 1}) {
  var structs = <StructModel>[];
  for (int i = 1; i <= count; i++) {
    var struct = StructModel()
      ..name = 'razh'
      ..items = [
        for (var x = 1; x <= Random().nextInt(20); x++)
          Item()
            ..name = "rand $x"
            ..price = Random().nextDouble() * 10000
            ..weight = Random().nextDouble() * 10
      ];
    structs.add(struct);
  }
  return structs;
}
