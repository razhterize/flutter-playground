import 'dart:async';
import 'dart:convert';
import 'dart:io' show Directory, File;
import 'package:dio/dio.dart';
import 'logger.dart';
import 'paths.dart';
import 'cubit/status_cubit.dart';
import 'core/types.dart';

final WutheringAssets localAssets = WutheringAssets();

class WutheringAssets {
  final Dio client = Dio();
  final _log = Logger("AssetManager");
  StatusCubit? _statusCubit;

  WutheringAssets({StatusCubit? statusCubit}) {
    _log.info("Init");
    _statusCubit = statusCubit;
    final imageDir = Directory("${assetDir.path}/images");
    if (!imageDir.existsSync()) imageDir.createSync(recursive: true);
    _imageList = imageDir
        .listSync()
        .whereType<File>()
        .where((f) => f.path.endsWith(".webp"))
        .map((f) => f.path)
        .toList();
  }
  List<String> _imageList = [];

  String? getImagePath(String name) {
    _log.debug("Get image for $name");
    bool pred(String f) {
      return f.split('/').last.toLowerCase() == "${name.toLowerCase()}.webp";
    }

    final valids = _imageList.where(pred).toList();
    if (valids.isNotEmpty) {
      return valids.first;
    }
    return null;
  }

  Future<void> updateAssets() async {
    final indexes = await _fetchIndexes();
    await _fetchCharacters(indexes["character"]);
    await _fetchWeapons(indexes["weapon"]);
    await _fetchEchoes(indexes["echo"]);
    // Update images after assets
    final imageDir = Directory("${assetDir.path}/images");
    _imageList = imageDir
        .listSync()
        .whereType<File>()
        .where((f) => f.path.endsWith(".webp"))
        .map((f) => f.path)
        .toList();
  }

  Future<JsonType> _fetchIndexes() async {
    final indexList = ["character", "echo", "weapon"];
    JsonType indexes = {};
    _log.debug("Fetch Indexes");
    _statusCubit?.notify(
      message: "Fetching Index",
      progress: ProgressData(current: 0, total: 3),
    );
    int idx = 0;
    for (String index in indexList) {
      final url = "$_apiHost/data/$index.json";
      _statusCubit?.notify(progress: ProgressData(total: 3, current: idx++));
      try {
        final res = await client.get(url);
        if (res.statusCode == 200) {
          _log.debug("Adding ${res.data.length} items to $index");
          indexes.addAll({index: res.data});
        }
      } on DioException catch (e) {
        _log.error("${e.message}", st: e.stackTrace);
      }
    }
    return indexes;
  }

  Future<void> _fetchCharacters(JsonType characters) async {
    Directory resonatorDir = Directory("${assetDir.path}/resonators");
    int idx = 0;
    _log.debug("Fetch resonators");
    _statusCubit?.notify(message: "Fetch Resonators");
    characters.forEach((key, val) async {
      final url = "$_apiHost/data/en/character/$key.json";
      _statusCubit?.notify(
        progress: ProgressData(total: characters.length, current: idx++),
      );
      try {
        final response = await client.get(url);
        if (response.statusCode == 200) {
          final filePath = "${resonatorDir.path}/${val["en"]}.json";
          JsonType parsedJson = response.data is Map
              ? _convertResonator(response.data)
              : _convertResonator(jsonDecode(response.data));
          _saveFile(filePath, parsedJson);
          final imageList = _findImages(response.data);
          await _fetchImages(imageList);
        }
      } on DioException catch (e) {
        _log.error(
          "Failed request on ${e.response?.realUri}",
          st: e.stackTrace,
        );
      }
    });
  }

  Future<void> _fetchEchoes(JsonType echoes) async {
    Directory echoDir = Directory("${assetDir.path}/echoes");
    int idx = 0;
    _log.debug("Fetch echoes");
    _statusCubit?.notify(message: "Fetch Echoes");
    echoes.forEach((key, val) async {
      final url = "$_apiHost/data/en/echo/$key.json";
      _statusCubit?.notify(
        progress: ProgressData(total: echoes.length, current: idx++),
      );
      try {
        final response = await client.get(url);
        if (response.statusCode == 200) {
          final filePath = "${echoDir.path}/${val["en"]}.json";
          JsonType parsedJson = response.data is Map
              ? _convertEcho(response.data)
              : _convertEcho(jsonDecode(response.data));
          _saveFile(filePath, parsedJson);
          final imageList = _findImages(response.data);
          await _fetchImages(imageList);
        }
      } on DioException catch (e) {
        _log.error("${e.message}", st: e.stackTrace);
      }
    });
  }

  Future<void> _fetchWeapons(JsonType weapons) async {
    Directory weaponDir = Directory("${assetDir.path}/weapons");
    int idx = 0;
    _log.debug("Fetch weapons");
    _statusCubit?.notify(message: "Fetching Weapons");
    weapons.forEach((key, val) async {
      final url = "$_apiHost/data/en/weapon/$key.json";
      _statusCubit?.notify(
        progress: ProgressData(
          total: weapons.length,
          current: idx++,
          message: "${val["en"]}",
        ),
      );
      try {
        final response = await client.get(url);
        if (response.statusCode == 200) {
          final filePath = "${weaponDir.path}/${val["en"]}.json";
          JsonType parsedJson = response.data is Map
              ? _convertWeapon(response.data)
              : _convertWeapon(jsonDecode(response.data));
          _saveFile(filePath, parsedJson);
          final imageList = _findImages(response.data);
          await _fetchImages(imageList);
        }
      } on DioException catch (e) {
        _log.error("${e.message}", st: e.stackTrace);
      }
    });
  }

  Future<void> _fetchImages(Map<String, String> images) async {
    // For some reason element icon isnt available in all jsons
    images.addAll({
      "Glacio": "https://api.hakush.in/ww/UI/Static/T_IconElementIce.webp",
      "Fusion": "https://api.hakush.in/ww/UI/Static/T_IconElementFire.webp",
      "Electro": "https://api.hakush.in/ww/UI/Static/T_IconElementThunder.webp",
      "Aero": "https://api.hakush.in/ww/UI/Static/T_IconElementWind.webp",
      "Spectro": "https://api.hakush.in/ww/UI/Static/T_IconElementLight.webp",
      "Havoc": "https://api.hakush.in/ww/UI/Static/T_IconElementDark.webp",
    });

    final imageDir = Directory("${assetDir.path}/images");
    if (!imageDir.existsSync()) imageDir.createSync();
    int idx = 0;
    _statusCubit?.notify(message: "Fetch Images");
    images.forEach((name, path) async {
      _statusCubit?.notify(
        progress: ProgressData(
          total: images.length,
          current: idx++,
          message: path,
        ),
      );
      try {
        // Only download if file doesnt already exist
        if (!File("${imageDir.path}/$name.webp").existsSync()) {
          await client.download(path, "${imageDir.path}/$name.webp");
        }
      } on DioException catch (e) {
        _log.error("${e.message}", st: e.stackTrace);
      }
    });
  }

  void _saveFile(String path, JsonType json) {
    final file = File(path);
    if (!file.parent.existsSync()) file.parent.createSync(recursive: true);
    file.writeAsStringSync(jsonEncode(json));
  }

  JsonType _convertEcho(JsonType json) {
    Map<String, dynamic> echo = {};
    // name
    echo['name'] = json['Name'] ?? "";
    // cost
    switch (json["IntensityCode"]) {
      case 0:
        echo['cost'] = 1;
        break;
      case 1:
        echo['cost'] = 3;
        break;
      case 2:
        echo['cost'] = 4;
        break;
      default:
        echo['cost'] = 1;
    }
    echo["sonatas"] = [];
    // sonata
    for (var group in (json["Group"] as Map).values) {
      echo['sonatas'].add(group['Name']);
    }
    return echo;
  }

  JsonType _convertWeapon(JsonType json) {
    // Broadblade 1
    // Sword 2
    // Pistol 3
    // Gauntlet 4
    // Rectifier 5
    JsonType weapon = {};
    weapon['name'] = json['Name'];
    const weaponTypes = [
      "None",
      "Broadblade",
      "Sword",
      "Pistol",
      "Gauntlet",
      "Rectifier",
    ];
    weapon['type'] = weaponTypes[json["Type"]];
    // Include stat value maps?
    weapon['stats'] = {};
    if (json.containsKey("Stats")) {
      for (var ascLevel in json["Stats"].values) {
        for (MapEntry level in ascLevel.entries) {
          final key = "${level.key}";
          final val = (level.value as List);
          Map stats = {};
          for (var stat in val) {
            String key = "${stat["Name"]}";
            if (key == "ATK" && stats.containsKey(key)) {
              key = "ATK %";
            }
            stats[key] = stat["Value"];
          }
          weapon['stats'][key] = stats;
        }
      }
    }
    return weapon;
  }

  JsonType _convertResonator(JsonType json) {
    const weaponTypes = [
      "None",
      "Broadblade",
      "Sword",
      "Pistol",
      "Gauntlet",
      "Rectifier",
    ];
    const elementTypes = [
      "None",
      "Glacio",
      "Fusion",
      "Electro",
      "Aero",
      "Spectro",
      "Havoc",
    ];
    JsonType resonator = {};
    resonator['name'] = json["Name"];
    resonator['weaponType'] = weaponTypes[json["Weapon"]];
    resonator['element'] = elementTypes[json["Element"]];
    resonator['stats'] = {};
    if (json.containsKey("Stats")) {
      for (var ascLevel in json["Stats"].values) {
        for (MapEntry level in ascLevel.entries) {
          final key = "${level.key}";
          // print(level.value);
          resonator['stats'][key] = {
            'ATK': level.value["Atk"],
            'HP': level.value["Life"],
            "DEF": level.value["Def"],
          };
        }
      }
    }
    return resonator;
  }

  // Courtesy of Gemini 2.5 Thinking
  Map<String, String> _findImages(Map<String, dynamic> inputData) {
    Map<String, String> imagesMap = {};

    void traverse(dynamic data) {
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
          traverse(value);
        }
      } else if (data is List) {
        // 4. Recursive search through lists
        for (var item in data) {
          traverse(item);
        }
      }
    }

    traverse(inputData);
    return imagesMap;
  }

  final String _apiHost = "https://api.hakush.in/ww";
}
