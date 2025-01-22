import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';

import 'package:permission_handler/permission_handler.dart';
import 'package:share_to_social/social/snapchat.dart';
import 'package:file_picker/file_picker.dart';

import 'dart:ui';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:share_to_social/social/airdrop.dart';
import 'package:share_to_social/social/instgram.dart';
import 'package:share_to_social/social/tiktok.dart';

void main() {
  runApp(const MaterialApp(home: MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  List<PlatformFile> _files = [];

  @override
  void initState() {
    _requestPermission();
    super.initState();
  }

  _requestPermission() async {
    late PermissionStatus status;

    status = await Permission.photos.status;

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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Share to social example app'),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              Center(
                child: ElevatedButton(
                  onPressed: () async {
                    FilePickerResult? result = await FilePicker.platform
                        .pickFiles(allowMultiple: true);

                    if (result != null) {
                      setState(() {
                        _files = result.files;
                      });
                    }
                  },
                  child: const Text("pick files"),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 150,
                    child: SendWidget(
                      onSend: () {
                        shareSticker();
                      },
                      text: "share as sticker",
                    ),
                  ),
                  SizedBox(
                    width: 80,
                    child: SendWidget(
                      onSend: () {
                        shareFiles(context);
                      },
                      text: "share",
                    ),
                  ),
                ],
              ),
              if (_files.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Wrap(
                    children: _files
                        .map((file) => Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Image.file(File(file.path!)),
                    ))
                        .toList(),
                  ),
                )
              else
                const Padding(
                  padding: EdgeInsets.only(top: 118.0),
                  child: Text("No selected files"),
                )
            ],
          ),
        ),
      ),
    );
  }

  shareFiles(BuildContext context) async {
    if (_files.isEmpty) return;
    SocialShareDialog.open(files: _files, context: context);
  }

  shareSticker() async {
    if (_files.isEmpty) return;
    try {
      await SnapChat.shareAsSticker(
          clintID: "add your client id", stickerPath: _files.first.path!);
    } catch (e, s) {
      log("error is $e  $s");
      AppToast.showErrorToast(e.toString());
    }
  }
}

class SocialShareDialog {
  static open(
      {required List<PlatformFile> files, required BuildContext context}) {
    final filePaths = files.map((file) => file.path!).toList();
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: .5,
            sigmaY: .5,
          ),
          child: AlertDialog(
            elevation: 0.0,
            content: SingleChildScrollView(
              physics: const NeverScrollableScrollPhysics(),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(26)),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: EdgeInsets.zero,
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.black),
                              borderRadius: BorderRadius.circular(3)),
                          child: InkWell(
                              onTap: () {
                                Navigator.of(context).pop();
                              },
                              child: const Icon(Icons.close)),
                        ),
                        const SizedBox(height: 24),
                        const Text("select the app you want to share to"),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SocialButton(
                                onPressed: () async {
                                  try {
                                    await SnapChat.share(
                                        clintID: "add your client id",
                                        files: filePaths);
                                  } catch (e, s) {
                                    log("error is $e  $s");
                                    AppToast.showErrorToast(e.toString());
                                  }
                                },
                                icon: "assets/snapchat.png",
                                title: "snapchat"),
                            const SizedBox(width: 4),
                            SocialButton(
                                onPressed: () async {
                                  final fileType = determineFileType(files
                                      .map((file) => file.extension)
                                      .toList());
                                  if (fileType == null) return;

                                  try {
                                    if (Platform.isIOS) {
                                      await Tiktok.shareToIos(
                                          files: filePaths,
                                          filesType: fileType,
                                          redirectUrl:
                                              "yourapp://tiktok-share");
                                    } else {
                                      Tiktok.shareToAndroid(filePaths);
                                    }
                                  } catch (e, s) {
                                    log("error is $e  $s");
                                    AppToast.showErrorToast(e.toString());
                                  }
                                },
                                icon: "assets/tiktok.png",
                                title: "tiktok"),
                            const SizedBox(width: 4),
                            SocialButton(
                                onPressed: () async {
                                  try {
                                    await Instagram.share(filePaths);
                                  } catch (e, s) {
                                    log("error is $e  $s");
                                    AppToast.showErrorToast(e.toString());
                                  }
                                },
                                icon: "assets/insta.png",
                                title: "instagram"),
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
                                child: const Text("share text to airDrop"),
                              ),
                          ],
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            backgroundColor: Colors.white,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
            contentPadding: EdgeInsets.zero,
            insetPadding: const EdgeInsets.symmetric(horizontal: 16),
          ),
        );
      },
    );
  }
}

class SocialButton extends StatelessWidget {
  const SocialButton(
      {super.key,
      required this.icon,
      required this.onPressed,
      required this.title});

  final String icon, title;
  final Function onPressed;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).pop();
        onPressed();
      },
      child: SizedBox(
        width: 70,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(icon, width: 30, height: 40),
            const SizedBox(height: 12),
            FittedBox(
              child: Text(
                title,
                textAlign: TextAlign.center,
                maxLines: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

String? determineFileType(List<String?> fileExtensions) {
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

class SendWidget extends StatelessWidget {
  const SendWidget({super.key, required this.text, required this.onSend});

  final Function onSend;
  final String text;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onSend();
      },
      child: Column(
        children: [
          CircleAvatar(
            backgroundColor: Colors.yellow,
            radius: 20,
            child: Image.asset(
              "assets/send.png",
              color: Colors.black,
              width: 20,
            ),
          ),
          Text(
            text,
            maxLines: 1,
            textAlign: TextAlign.center,
          )
        ],
      ),
    );
  }
}
