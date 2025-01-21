import 'dart:developer';
import 'package:flutter/services.dart';

class SnapChat {
  static const platform = MethodChannel('social_sharing');

  /// this add sticker to camera in snapchat
  static shareAsSticker({
    required String stickerPath,
    required String clintID,
    double posX = 0.2,
    double posY = 0.8,
    double rotation = 0.0,
    int widthDp = 200,
    int heightDp = 200,
  }) async {
    try {
      await platform.invokeMethod('addStickerToSnapchat', {
        'stickerPath': stickerPath,
        'clientId': clintID,
        'posX': posX,
        'posY': posY,
        'rotation': rotation,
        'widthDp': widthDp,
        'heightDp': heightDp,
      });
    } on PlatformException catch (e, s) {
      log("Failed with error : '${e.message}'. \n $s");
      throw (e, s);
    } catch (e, s) {
      log("Failed with error : '${e}'. \n $s");
      throw (e, s);
    }
  }

  /// share multi files videos or images
  static Future<void> share({required String clintID, required List<String> files}) async {
    try {
      await platform.invokeMethod('launchSnapchatPreviewWithMultipleFiles', {
        'filePaths': files,
        'clientId': clintID,
      });
    } on PlatformException catch (e, s) {
      log("Failed with error : '${e.message}'. \n $s");
      throw (e, s);
    } catch (e, s) {
      log("Failed with error : '${e}'. \n $s");
      throw (e, s);
    }
  }
}
