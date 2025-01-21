import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:permission_handler/permission_handler.dart';
import 'package:share_to_social/social/airdrop.dart';
import 'package:share_to_social/social/instgram.dart';
import 'package:share_to_social/social/snapchat.dart';
import 'package:share_to_social/social/tiktok.dart';

import 'package:file_picker/file_picker.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    _requestPermission();
    super.initState();
  }

  _requestPermission() async {
    late PermissionStatus status;

    status = await Permission.photos.status;
    //  PermissionStatus status1 = await Permission.videos.status;

    if (status.isGranted) {
      return;
    } else {
      status = await Permission.photos.request();
      if (status.isGranted) {
      } else {}
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('social share example app'),
        ),
        body: Center(
          child: Column(
            children: [
              ElevatedButton(
                onPressed: () async {
                  FilePickerResult? result = await FilePicker.platform.pickFiles();

                  if (result != null) {
                    try {
                      await SnapChat.shareAsSticker(
                          clintID: "add your client id",
                          stickerPath: result.files.single.path!);
                    } catch (e, s) {
                      log("error is $e  $s");
                      AppToast.showErrorToast(e.toString());
                    }
                  }
                },
                child: const Text("share to snapchat as sticker"),
              ),
              ElevatedButton(
                onPressed: () async {
                  FilePickerResult? result = await FilePicker.platform.pickFiles();

                  if (result != null) {
                    try {
                      await SnapChat.share(
                          clintID: "add your client id",
                          files: [result.files.single.path!]);
                    } catch (e, s) {
                      log("error is $e  $s");
                      AppToast.showErrorToast(e.toString());
                    }
                  }
                },
                child: const Text("share to snapchat"),
              ),
              if (Platform.isIOS)
                ElevatedButton(
                  onPressed: () async {
                    FilePickerResult? result = await FilePicker.platform.pickFiles();

                    if (result != null) {
                      final fileType =
                          determineFileType(result.files.map((file) => file.extension).toList());
                      if (fileType == null) return;

                      try {
                        await Tiktok.shareToIos(
                            files: result.files.map((file) => file.path!).toList(),
                            filesType: fileType,
                            redirectUrl: "yourapp://tiktok-share");
                      } catch (e, s) {
                        log("error is $e  $s");
                        AppToast.showErrorToast(e.toString());
                      }
                    }
                  },
                  child: const Text("share to tiktok"),
                ),
              if (Platform.isAndroid)
                ElevatedButton(
                  onPressed: () async {
                    FilePickerResult? result = await FilePicker.platform.pickFiles();

                    if (result != null) {
                      final fileType =
                          determineFileType(result.files.map((file) => file.extension).toList());
                      if (fileType == null) return;

                      try {
                        Tiktok.shareToAndroid(
                          result.files.map((file) => file.path!).toList(),
                        );
                      } catch (e, s) {
                        log("error is $e  $s");
                        AppToast.showErrorToast(e.toString());
                      }
                    }
                  },
                  child: const Text("share to tiktok"),
                ),
              ElevatedButton(
                onPressed: () async {
                  FilePickerResult? result = await FilePicker.platform.pickFiles();

                  if (result != null) {
                    try {
                      await Instagram.share([result.files.single.path!]);
                    } catch (e, s) {
                      log("error is $e  $s");
                      AppToast.showErrorToast(e.toString());
                    }
                  }
                },
                child: const Text("share to instagram"),
              ),
              if (Platform.isIOS)
                ElevatedButton(
                  onPressed: () async {
                    try {
                      await AirDrop.share("sharing this text");
                    } catch (e, s) {
                      log("error is $e  $s");
                      AppToast.showErrorToast(e.toString());
                    }
                  },
                  child: const Text("share to airDrop"),
                ),
            ],
          ),
        ),
      ),
    );
  }

  String? determineFileType(List<String?> fileExtensions) {
    // Supported extensions for images and videos
    final imageExtensions = ['jpg', 'jpeg', 'png', 'gif', 'bmp', 'webp'];
    final videoExtensions = ['mp4', 'mov', 'avi', 'mkv', 'flv', 'wmv'];

    bool hasImage = false;
    bool hasVideo = false;

    for (var extension in fileExtensions) {
      if (extension == null) continue; // Skip null extensions
      final ext = extension.toLowerCase();

      if (imageExtensions.contains(ext)) {
        hasImage = true;
      } else if (videoExtensions.contains(ext)) {
        hasVideo = true;
      }
    }

    // Return the result based on what types were found
    if (hasImage && !hasVideo) {
      return 'image';
    } else if (hasVideo && !hasImage) {
      return 'video';
    }
    return null;
  }
}

class AppToast {
  static void showErrorToast(String msg, {Toast toast = Toast.LENGTH_SHORT}) {
    Fluttertoast.showToast(
        msg: msg,
        toastLength: toast,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.white,
        textColor: Colors.red,
        fontSize: 16.0);
  }
}
