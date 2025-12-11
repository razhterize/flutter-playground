import 'dart:developer' show debugger;
import 'dart:io';
import 'dart:convert';

typedef JsonType = Map<String, dynamic>;

void main() {
  final root = Directory.current;
  final files = root
      .listSync(recursive: true)
      .whereType<File>()
      .where((file) => file.path.endsWith(".json"))
      .map((e) => e.path)
      .toList();
  files.forEach((filename) {
    if (filename.contains("echoes")) {
      saveFile(filename.replaceAll("raw_", "converted_"), convertEcho(loadFile(filename)));
    } else if (filename.contains("weapons")) {
      saveFile(filename.replaceAll("raw_", "converted_"), convertWeapon(loadFile(filename)));
    } else if (filename.contains("resonators")) {
      saveFile(filename.replaceAll("raw_", "converted_"), convertResonator(loadFile(filename)));
    }
  });
}

JsonType convertEcho(JsonType json) {
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

JsonType convertWeapon(JsonType json) {
  // Broadblade 1
  // Sword 2
  // Pistol 3
  // Gauntlet 4
  // Rectifier 5
  JsonType weapon = {};
  weapon['name'] = json['Name'];
  const weaponTypes = ["None", "Broadblade", "Sword", "Pistol", "Gauntlet", "Rectifier"];
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

JsonType convertResonator(JsonType json) {
  const weaponTypes = ["None", "Broadblade", "Sword", "Pistol", "Gauntlet", "Rectifier"];
  const elementTypes = ["None", "Glacio", "Fusion", "Electro", "Aero", "Spectro", "Havoc"];
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

JsonType loadFile(String path) {
  final file = File(path);
  assert(file.existsSync(), "File $path does not exist");
  final json = jsonDecode(file.readAsStringSync());
  return json;
}

void saveFile(String path, JsonType json) {
  final file = File(path);
  if (!file.parent.existsSync()) file.parent.createSync(recursive: true);
  file.writeAsStringSync(jsonEncode(json));
}
