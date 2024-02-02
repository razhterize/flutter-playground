import 'package:flutter/material.dart';
import 'package:flutter_playground/common/logger.dart';
import 'package:flutter_playground/models/struct_model.dart';
import 'package:flutter_playground/providers/struct_database.dart';
// import 'package:isar/isar.dart';
// import 'package:path_provider/path_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Struct testStruct = Struct(
    name: "razh",
    items: [
      Item(name: 'iron', weight: 22.69, price: 2500),
      Item(name: 'battery', weight: 22.69, price: 2500),
      Item(name: 'plastic', weight: 22.69, price: 2500),
      Item(name: 'steel', weight: 22.69, price: 2500),
      Item(name: 'aluminum', weight: 22.69, price: 2500),
      Item(name: 'can', weight: 22.69, price: 2500),
      Item(name: 'paper', weight: 22.69, price: 2500),
      Item(name: 'misc', weight: 22.69, price: 2500),
    ],
    repayment: 5000,
  );

  final database = await StructProvider.init();
  // database.add(testStruct);

  Struct? newStruct = await database.first;

  // if (newStruct != null) {
  //   newStruct.name = "razh but second one";
  //   await database.edit(newStruct);
  // }

  // final dataDirectory = await getApplicationSupportDirectory();
  // final isar = await Isar.open(
  //   [StructSchema],
  //   directory: dataDirectory.path,
  // );
  // await isar.writeTxn(() async => await isar.structs.put(testStruct));
  // final existingStructs = await isar.structs.get(testStruct.id);
  logger.i('finished: ${newStruct!.totalPayment}');
}
