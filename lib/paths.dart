import 'dart:io' show Directory, File, Platform;
import 'logger.dart';

const appIdentifier = "io.github.razhterize.wuwa_optimizer";

Directory getAssetDirectory() {
  final rootDir = File(Platform.resolvedExecutable).parent.path;
  final assetDir = Directory("$rootDir/assets");
  if (!assetDir.existsSync()) assetDir.createSync(recursive: true);
  return assetDir;
}

String getRootDir() => File(Platform.resolvedExecutable).parent.path;
