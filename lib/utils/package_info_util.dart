
import 'dart:io';

import 'package:device_info/device_info.dart';
import 'package:package_info/package_info.dart';

class PackageInfoUtil {
  static bool inProduction() {
    return bool.fromEnvironment("dart.vm.product");
  }

  static Future<PackageInfo> getPackageInfo() async {
    PackageInfo info = await PackageInfo.fromPlatform();
    return info;
  }

  static Future<String> getVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    return packageInfo.version;
  }

  static Future getDeviceInfo() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    if (Platform.isAndroid) {
      return await deviceInfo.androidInfo;
    } else if (Platform.isIOS) {
      return await deviceInfo.iosInfo;
    } else {
      return null;
    }
  }
}


