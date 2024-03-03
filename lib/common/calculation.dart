import 'package:flutter_playground/model/struct_model.dart';

double calculateTotal(StructModel struct) {
  double total = 0;
  if (struct.items!.isNotEmpty) {
    for (var item in struct.items!) {
      total += (item.price! * item.weight!);
    }
  }
  return total;
}
