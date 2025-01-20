package stocker.social.com.social_sharing

import android.content.Context
import android.content.Intent
import android.net.Uri
import android.util.Log
import androidx.annotation.NonNull
import androidx.core.content.FileProvider
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import org.json.JSONObject
import java.io.File

/** SocialSharingPlugin */
class SocialSharingPlugin: FlutterPlugin, MethodCallHandler {
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private lateinit var channel : MethodChannel
  private lateinit var context: Context
  override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    channel = MethodChannel(flutterPluginBinding.binaryMessenger, "social_sharing")
    channel.setMethodCallHandler(this)
    context = flutterPluginBinding.applicationContext
  }

  override fun onMethodCall(call: MethodCall, result: Result) {

    when (call.method) {
      "shareToTiktok" -> {
        val filePath = call.argument<List<String>>("filePaths") ?: emptyList()
        shareToTiktok(filePath)
        result.success(null)
      }
      "shareToInstagram" -> {
        val filePath = call.argument<List<String>>("filePaths") ?: emptyList()
        shareToInstgram(filePath)
        result.success(null)
      }
      "launchSnapchatPreviewWithMultipleFiles" -> {
        val filePaths = call.argument<List<String>>("filePaths") ?: emptyList()
        launchSnapchatPreviewWithMultipleFiles(filePaths)
        result.success(null)
      }
      "addStickerToSnapchat" -> {
        val stickerPath = call.argument<String>("stickerPath") ?: ""
        val posX = call.argument<Double>("posX")?.toFloat() ?: 0.5f
        val posY = call.argument<Double>("posY")?.toFloat() ?: 0.5f
        val rotation = call.argument<Double>("rotation")?.toFloat() ?: 0f
        val widthDp = call.argument<Int>("widthDp") ?: 200
        val clientId = call.argument<String>("clientId") ?: ""
        val heightDp = call.argument<Int>("heightDp") ?: 200

        addStickerToSnapchat(
          stickerPath,
          clientId,
          posX,
          posY,
          rotation,
          widthDp,
          heightDp
        )
        result.success(null)
      }

      "launchSnapchatCamera" -> {
        val clientId = call.argument<String>("clientId") ?: ""
        val caption = call.argument<String>("caption") ?: ""
        val appName = call.argument<String>("appName") ?: ""
        launchSnapchatCamera(clientId, caption, appName)
        result.success(null)
      }
      "launchSnapchatCameraWithLens" -> {
        val lensUUID = call.argument<String>("lensUUID") ?: ""
        val clientId = call.argument<String>("clientId") ?: ""
        val launchDataMap =
          call.argument<Map<String, String>>("launchData") ?: emptyMap()
        val launchData = JSONObject(launchDataMap)
        launchSnapchatCameraWithLens(lensUUID, clientId, launchData)
        result.success(null)
      }

      else -> result.notImplemented()
    }

  }

  override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
  }

  private fun launchSnapchatCamera(clientId: String, caption: String, appName: String) {
    val intent = CKLite.shareToCamera(context, clientId, caption, appName)
    context.startActivity(intent)
  }

  private fun launchSnapchatCameraWithLens(
    lensUUID: String,
    clientId: String,
    launchData: JSONObject
  ) {
    val intent = CKLite.shareToDynamicLens(context, lensUUID, clientId, launchData)
    context.startActivity(intent)
  }

  private fun shareToTiktok(filePaths: List<String>) {
    val uris = ArrayList<Uri>()
    val authority = "${context.packageName}.fileprovider"
    for (filePath in filePaths) {
      val file = File(filePath)
      val uri = FileProvider.getUriForFile(context, authority, file)
      uris.add(uri)

      // Grant TikTok read permission for each URI
      context.grantUriPermission(
        "com.zhiliaoapp.musically",
        uri,
        Intent.FLAG_GRANT_READ_URI_PERMISSION
      )
    }

    val shareIntent = Intent(Intent.ACTION_SEND_MULTIPLE).apply {
      putExtra(Intent.EXTRA_STREAM, uris)
      type = "*/*"
      setPackage("com.zhiliaoapp.musically") // TikTok's package name
      addFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION) // Grant read permissions
      addFlags(Intent.FLAG_ACTIVITY_NEW_TASK) // Add this flag for non-Activity context
    }

//    // Create an Intent specifically for TikTok
//    val shareIntent = Intent(Intent.ACTION_SEND_MULTIPLE)
//    shareIntent.putExtra(Intent.EXTRA_STREAM, uris)
//
//    /// todo according to requirements
//    shareIntent.type = "*/*"
//    shareIntent.setPackage("com.zhiliaoapp.musically") // TikTok's package name
    context.startActivity(shareIntent)
  }

  private fun shareToInstgram(filePaths: List<String>) {
    val uris = ArrayList<Uri>()
    val authority = "${context.packageName}.fileprovider"
    for (filePath in filePaths) {
      val file = File(filePath)
      val uri = FileProvider.getUriForFile(context, authority, file)
      uris.add(uri)

      // Grant TikTok read permission for each URI
      context.grantUriPermission(
        "com.instagram.android",
        uri,
        Intent.FLAG_GRANT_READ_URI_PERMISSION
      )
    }


    val shareIntent = Intent(Intent.ACTION_SEND_MULTIPLE).apply {
      putExtra(Intent.EXTRA_STREAM, uris)
      type = "*/*"
      setPackage("com.instagram.android") // TikTok's package name
      addFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION) // Grant read permissions
      addFlags(Intent.FLAG_ACTIVITY_NEW_TASK) // Add this flag for non-Activity context
    }

    context.startActivity(shareIntent);

  }

  private fun launchSnapchatPreviewWithMultipleFiles(filePaths: List<String>) {
    val uris = ArrayList<Uri>()
    val authority = "${context.packageName}.fileprovider"

    // Add URIs for both images and videos
    for (filePath in filePaths) {
      val file = File(filePath)
      val uri = FileProvider.getUriForFile(context, authority, file)
      uris.add(uri)

      // Grant Snapchat read permission for each URI
      context.grantUriPermission(
        "com.snapchat.android",
        uri,
        Intent.FLAG_GRANT_READ_URI_PERMISSION
      )
    }

    // Create the intent with ACTION_SEND_MULTIPLE and set a generic MIME type
    val intent = Intent().apply {
      action = Intent.ACTION_SEND_MULTIPLE
      type = "*/*"  // Allows sharing of mixed media types
      putParcelableArrayListExtra(Intent.EXTRA_STREAM, uris)
      addFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION)
      addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
      // Ensure the intent opens only Snapchat
      setPackage("com.snapchat.android")
    }
      context.startActivity(intent)
  }

  private fun addStickerToSnapchat(
    stickerPath: String,
    clientId: String,
    posX: Float,
    posY: Float,
    rotation: Float,
    widthDp: Int,
    heightDp: Int
  ) {
    // Convert the sticker file path to a Uri using FileProvider
    val stickerFile = File(stickerPath)
    if (!stickerFile.exists()) {
      Log.e("SnapchatIntegration", "Sticker file does not exist: $stickerPath")
      return
    }

    val stickerUri: Uri = FileProvider.getUriForFile(
      context,
      "${context.packageName}.fileprovider",
      stickerFile
    )

    val intent = CKLite.shareToCamera(context, clientId, "", "MyApp")

    CKLite.addSticker(
      intent,
      stickerUri,
      posX = posX,
      posY = posY,
      rotation = rotation,
      widthDp = widthDp,
      heightDp = heightDp
    )

    context.grantUriPermission(
      "com.snapchat.android",
      stickerUri,
      Intent.FLAG_GRANT_READ_URI_PERMISSION
    )
    intent.addFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION)
    intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
    intent.putExtra(Intent.EXTRA_STREAM, stickerUri)
    Log.d("SnapchatIntegration", "stickerPath $stickerPath Uri $stickerUri intent $intent")

      context.startActivity(intent)

  }
}
