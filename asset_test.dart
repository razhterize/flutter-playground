import 'dart:io';
import 'package:dio/dio.dart';

void main() async {
  const url = "https://api.hakush.in/ww/data/en/character/1410.json";
  Dio client = Dio();
  final res = await client.get(url);
  final imageList = extractImagesToMap(res.data);
  imageList.entries.forEach((entry){
    print("${entry.key}: ${entry.value}");
  });
}

Map<String, String> extractImagesToMap(Map<String, dynamic> inputData) {
  // The map to store our result: Key = Name, Value = Icon
  Map<String, String> imagesMap = {};

  void _traverse(dynamic data) {
    if (data is Map) {
      // 1. Check if the current Map has "Name" and "Icon"
      if (data.containsKey('Name') && data.containsKey('Icon')) {
        String name = data['Name'].toString();
        String icon = data['Icon'].toString().replaceAll(
          "/Game/Aki/",
          "https://api.hakush.in/ww/",
        );
        icon = icon.replaceRange(icon.lastIndexOf('.'), null, ".webp");

        // 2. CHECK UNIQUENESS: Only add if this Name is not already a key in our map
        if (!imagesMap.containsKey(name)) {
          imagesMap[name] = icon;
        }
      }

      // 3. Recursive search through values
      for (var value in data.values) {
        _traverse(value);
      }
    } else if (data is List) {
      // 4. Recursive search through lists
      for (var item in data) {
        _traverse(item);
      }
    }
  }

  _traverse(inputData);
  return imagesMap;
}
