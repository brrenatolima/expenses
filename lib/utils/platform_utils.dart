import 'package:flutter/foundation.dart';
import 'package:universal_io/io.dart';

class PlatformUtils {
  static bool get isMobile {
    if (kIsWeb) {
      return false;
    } else {
      return Platform.isIOS || Platform.isAndroid;
    }
  }

  static bool get isDesktop {
    if (kIsWeb) {
      return false;
    } else {
      return Platform.isLinux || Platform.isFuchsia || Platform.isWindows || Platform.isMacOS;
    }
  }

  static bool get isWeb {
    if(kIsWeb){
      return true;
    } else {
      return false;
    }
  }
}
