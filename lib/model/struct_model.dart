import 'package:isar/isar.dart';

part 'struct_model.g.dart';

@collection
class StructModel {
  Id id = Isar.autoIncrement;
  String? name;
  List<Item>? items;
  DateTime? created;
  DateTime? updated;
}

@embedded
class Item {
  Item();
  String? name;
  double? price;
  double? weight;
}
