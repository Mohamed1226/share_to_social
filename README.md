
# share_to_social Package
 is a powerful Flutter package that simplifies sharing files to popular social media platforms like TikTok, Snapchat, and Instagram. With this package, you can enable seamless sharing of images, videos, and other files directly from your app to these platforms, enhancing user engagement and making social media integration effortless.

![demo1](images/tiktok.gif)
![demo2](images/sticker.gif)
![demo3](images/insta.gif)
![demo4](images/snapchat.gif)

## Features
### TikTok Integration:
Share videos directly to TikTok using their official SDK.
Support for both private and public sharing.
### Snapchat Integration:
Share photos, videos, and more to Snapchat Stories or Chat.
Fully compatible with Snapchat's sharing capabilities.
### Instagram Integration:
Share photos and videos to Instagram Stories.
Includes support for Instagram Reels.
### Airdrop for Ios:
Share text as strings.


## Table of contents

- [Permissions](#permissions)

- [Public Android Setup](#public-android-setup)

- [Public Ios Setup](#public-ios-setup)

- [Tiktok Setup](#tiktok-setup)

- [Snapchat Setup](#snapchat-setup)

- [Instagram Setup](#instagram-setup)

- [Issues](#issues)

- [Contribute](#contribute)

- [Author](#author)

- [License](#license)

# Package Configuration Guide

## Permissions

You need to request permission in your app as follows:

```dart
var status = await Permission.photos.request();
```

## Public Android setup

Add the following permissions in your AndroidManifest.xml:

```
<uses-permission android:name="android.permission.INTERNET" />
<uses-permission android:name="android.permission.ACCESS_MEDIA_LOCATION" />
<uses-permission android:name="android.permission.READ_MEDIA_IMAGES" />
<uses-permission android:name="android.permission.READ_MEDIA_VIDEO" />
<uses-permission android:name="android.permission.WRITE_MEDIA_IMAGES" />
<uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE" />
<uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE" />
<uses-permission android:name="android.permission.ACCESS_NETWORK_STATE" />
```

### Add Queries
Add the following queries to your AndroidManifest.xml:
```
<queries>
    <intent>
        <action android:name="android.intent.action.PROCESS_TEXT"/>
        <data android:mimeType="text/plain"/>
    </intent>
    <package android:name="com.snapchat.android" />
</queries>
```

Add the following provider configuration in your AndroidManifest.xml:
```
<provider
    android:name="androidx.core.content.FileProvider"
    android:authorities="${applicationId}.fileprovider"
    android:exported="false"
    android:grantUriPermissions="true">
    <meta-data
        android:name="android.support.FILE_PROVIDER_PATHS"
        android:resource="@xml/provider_paths_app" />
</provider>
```

## Create provider_paths_app.xml
Create a file named provider_paths_app.xml in the res/xml folder with the following content:
```
<?xml version="1.0" encoding="utf-8"?>
<paths xmlns:android="http://schemas.android.com/apk/res/android">
    <external-path name="external_files" path="." />
</paths>
```
## Public Ios setup
Add the following configurations in your Info.plist:

```
<key>LSSupportsOpeningDocumentsInPlace</key>
<true/>
<key>NSPhotoLibraryUsageDescription</key>
<string>I need to access the library because my core logic depends on enabling the user to share files to other apps.</string>
```

## Tiktok Setup

#### for android
no need to do anything.

#### for ios
you must Create an app in the TikTok Developer Console.
Add the Share Kit to your product.
then Add the following configurations in your Info.plist:
```

<key>LSApplicationQueriesSchemes</key>
<array>
    <string>tiktokopensdk</string>
    <string>tiktoksharesdk</string>
    <string>snssdk1180</string>
    <string>snssdk1233</string>
</array>
<key>UIFileSharingEnabled</key>
<true/>
<key>TikTokClientKey</key>
<string>your tiktok client key</string>
<key>CFBundleURLTypes</key>
<array>
    <dict>
        <key>CFBundleURLSchemes</key>
        <array>
            <string>your tiktok client key</string>
        </array>
    </dict>
</array>
```
Add Delegate Methods
Update your AppDelegate with the following methods:
```
override func application(_ app: UIApplication, open url: URL,
                 options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
    if (TikTokURLHandler.handleOpenURL(url)) {
        return true
    }
    return false
}

override func application(_ application: UIApplication,
                 continue userActivity: NSUserActivity,
                 restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
    if (TikTokURLHandler.handleOpenURL(userActivity.webpageURL)) {
        return true
    }
    return false
}

```
you can test tiktok by using sandbox client key but you must add your account here
![Image Description](images/tiktok_demo_user.png)


## Snapchat Setup
 you must create app in snapchat developer
 Don’t forget to add your applicationID for android and app bundle for ios in your Snapchat app.
 like this image

 ![Image Description](images/snapchat_appids.png)

### for android
no need to do anything
### for ios
Add the following configurations in your Info.plist:

```
<key>SCSDKClientId</key>
<string>snapchat client id</string>
<key>LSApplicationQueriesSchemes</key>
<array>
    <string>snapchat</string>
    <string>bitmoji-sdk</string>
    <string>itms-apps</string>
</array>
<key>UIFileSharingEnabled</key>
<true/>
```
to use staging client id to need to add testing users in demo user

![Image Description](images/snapchat_demo_user.png)

## Instagram Setup

### for android
no need to do anything
### for ios
Add the following configurations in your Info.plist:

```
<key>LSApplicationQueriesSchemes</key>
<array>
    <string>instagram</string>
    <string>instagram-stories</string>
    <string>musically</string>
</array>
<key>UIFileSharingEnabled</key>
<true/>
```

### Issues

Please file any issues, bugs, or feature requests as an issue on our [GitHub](https://github.com/Mohamed1226/share_to_social/issues) page.

### Contribute

If you would like to contribute to the plugin (e.g. by improving the documentation, solving a bug, or adding a cool new feature), please send us your [pull request](https://github.com/Mohamed1226/share_to_social/pulls).

### Author

This social_sharing_plus plugin for Flutter is developed by [Mohamed tawfiq](https://github.com/Mohamed1226). You can contact me at <mohamed.adel.dev9@gmail.com>


## License

This project is licensed under the [MIT License](LICENSE).
