import 'dart:developer';

import 'package:flutter/services.dart';

class AirDrop {
  static const platform = MethodChannel('social_sharing');

  static share(String text) async {
    try {
      await platform.invokeMethod('airdropShareText', {'text': text});
    } on PlatformException catch (e, s) {
      log("Failed with error : '${e.message}'. \n $s");
      throw (e, s);
    } catch (e, s) {
      log("Failed with error : '$e'. \n $s");
      throw (e, s);
    }
  }
}
