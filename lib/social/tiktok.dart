import 'dart:developer';

import 'package:flutter/services.dart';

class Tiktok {
  static const platform = MethodChannel('social_sharing');

  static shareToAndroid(List<String> files) async {
    try {
      await platform.invokeMethod('shareToTiktok', {'filePaths': files});
    } on PlatformException catch (e, s) {
      log("Failed with error : '${e.message}'. \n $s");
      throw (e, s);
    } catch (e, s) {
      log("Failed with error : '$e'. \n $s");
      throw (e, s);
    }
  }

  static shareToIos(
      {required List<String> files, required String redirectUrl, required String filesType}) async {
    try {
      await platform.invokeMethod('shareToTikTokMultiFiles1',
          {'filePaths': files, "redirectUrl": redirectUrl, "fileType": filesType});
    } on PlatformException catch (e, s) {
      log("Failed with error : '${e.message}'. \n $s");
      throw (e, s);
    } catch (e, s) {
      log("Failed with error : '$e'. \n $s");
      throw (e, s);
    }
  }

  // static shareToTikTokMultiFiles(
  //     {required List<String> files,
  //     required String redirectUrl,
  //     required String filesType}) async {
  //   try {
  //     await platform.invokeMethod('shareToTiktokMultiFilesV1', {
  //       'filePaths': files,
  //       "redirectUrl": redirectUrl,
  //       "fileType": filesType
  //     });
  //   } on PlatformException catch (e, s) {
  //     log("Failed with error : '${e.message}'. \n $s");
  //     throw (e, s);
  //   } catch (e, s) {
  //     log("Failed with error : '$e'. \n $s");
  //     throw (e, s);
  //   }
  // }
  //
}
