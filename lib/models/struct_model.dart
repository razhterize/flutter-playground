import 'package:isar/isar.dart';

part 'struct_model.g.dart';

@collection
class Struct {
  Id id = Isar.autoIncrement;
  String? name;
  List<Item>? items;
  double? repayment;
  DateTime? created;
  DateTime? updated;

  double? get totalPayment {
    double total = 0;
    if (items!.isEmpty) return null;
    for (var element in items!) {
      total += element.total!;
    }
    return total;
  }

  Struct({this.name, this.items, this.repayment}) {
    created ??= DateTime.now();
    updated ??= DateTime.now();
  }
}

@embedded
class Item {
  String? name;
  double? weight;
  double? price;

  Item({this.name, this.weight, this.price});

  double? get total => weight! * price!;

  factory Item.fromJaon(Map map) {
    return Item(
      name: map['name'],
      weight: map['weight'],
      price: map['price'],
    );
  }
}
