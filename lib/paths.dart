import 'dart:io' show Directory, File, Platform;
import 'package:path_provider/path_provider.dart';

import 'logger.dart';

const appIdentifier = "io.github.razhterize.wuwa_optimizer";
late final Directory rootDir;
late final Directory assetDir;

Future<void> initDirectories() async {
  rootDir = File(Platform.resolvedExecutable).parent;
  assetDir = Directory((await getApplicationCacheDirectory()).join("assets"));
}

extension DirectoryJoin on Directory {
  String join(String other) {
    return "$path/$other";
  }
}
