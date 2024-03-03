import 'package:flutter/material.dart';
import 'package:flutter_playground/common/calculation.dart';
import 'package:flutter_playground/common/utils.dart';
import 'package:intl/intl.dart';
import 'package:flutter_playground/model/struct_model.dart';

class StructView extends StatefulWidget {
  const StructView(this.struct, {super.key});

  final StructModel struct;

  @override
  State<StructView> createState() => _StructViewState();
}

class _StructViewState extends State<StructView> {
  bool expanded = false;

  @override
  Widget build(BuildContext context) {
    return Card.outlined(
      child: ListTile(
        title: Row(
          children: [
            Text(widget.struct.name ?? ""),
            const Spacer(),
            Text(DateFormat('M/d/y - H:MM').format(widget.struct.created ?? DateTime.now())),
          ],
        ),
        subtitle: expanded ? _detaileditems() : Text(idrMoney(calculateTotal(widget.struct)).symbolOnLeft),
        onTap: () => setState(() {
          expanded = !expanded;
        }),
      ),
    );
  }

  Widget _detaileditems() {
    return const Placeholder();
  }
}
