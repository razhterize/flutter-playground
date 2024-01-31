import 'dart:convert';

import 'package:flutter_playground/providers/struct/struct.dart';

class StructModel {
  final int id;
  final String client;
  final List data;
  final DateTime created;
  final DateTime modified;

  StructModel({required this.id, required this.client, required this.data, required this.created, required this.modified});

  factory StructModel.fromStructData(StructData data) {
    return StructModel(
      id: data.id,
      client: data.client,
      data: jsonDecode(data.data),
      created: data.created,
      modified: data.modified,
    );
  }

  StructCompanion toCompanion() {
    return StructCompanion.insert(
      client: client,
      data: json.encode(data),
      created: created,
      modified: modified,
    );
  }
}
