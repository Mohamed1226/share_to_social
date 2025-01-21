import Flutter
import Photos
import UIKit
import TikTokOpenSDKCore
import TikTokOpenShareSDK
import UniformTypeIdentifiers

public class SocialSharingPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "social_sharing", binaryMessenger: registrar.messenger())
    let instance = SocialSharingPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
            switch call.method {
            case "addStickerToSnapchat":
                guard let args = call.arguments as? [String: Any] else { return result(FlutterError(code: "INVALID_ARGUMENTS", message: "Invalid arguments", details: nil)) }
                self.addStickerToSnapchat(args: args, result: result)

            case "launchSnapchatPreviewWithImage":
                guard let args = call.arguments as? [String: Any] else { return result(FlutterError(code: "INVALID_ARGUMENTS", message: "Invalid arguments", details: nil)) }
                self.launchSnapchatPreviewWithImage(args: args, result: result)

            case "launchSnapchatPreviewWithVideo":
                guard let args = call.arguments as? [String: Any] else { return result(FlutterError(code: "INVALID_ARGUMENTS", message: "Invalid arguments", details: nil)) }
                self.launchSnapchatPreviewWithVideo(args: args, result: result)

            case "launchSnapchatCamera":
                guard let args = call.arguments as? [String: Any] else { return result(FlutterError(code: "INVALID_ARGUMENTS", message: "Invalid arguments", details: nil)) }
                self.launchSnapchatCamera(args: args, result: result)

            case "launchSnapchatCameraWithLens":
                guard let args = call.arguments as? [String: Any] else { return result(FlutterError(code: "INVALID_ARGUMENTS", message: "Invalid arguments", details: nil)) }
                self.launchSnapchatCameraWithLens(args: args, result: result)

            case "launchSnapchatPreviewWithMultipleFiles":
                guard let args = call.arguments as? [String: Any] else { return result(FlutterError(code: "INVALID_ARGUMENTS", message: "Invalid arguments", details: nil)) }
                self.launchSnapchatPreviewWithMultipleFiles(args: args, result: result)

            case "shareToTikTokMultiFiles":
                guard let args = call.arguments as? [String: Any] else {return result(FlutterError(code: "INVALID_ARGUMENT", message: "File paths required", details: nil)) }
                self.shareToTikTokMultiFiles(args: args, result : result)

//             case "shareToTiktokMultiFilesV1":
//                 guard let args = call.arguments as? [String: Any] else {return result(FlutterError(code: "INVALID_ARGUMENT", message: "File paths required", details: nil)) }
//                 self.shareToTiktokMultiFilesV1(args: args, result : result)
//
            case "shareToInstagram":
                guard let args = call.arguments as? [String: Any] else { return result(FlutterError(code: "INVALID_ARGUMENTS", message: "Invalid arguments", details: nil)) }
                self.shareToInstagram(args: args, result: result)

            case "airdropShareText":
                guard let args = call.arguments as? [String: Any] else { return result(FlutterError(code: "INVALID_ARGUMENTS", message: "Invalid arguments", details: nil)) }
                self.airdropShareText(args: args, result: result)

    default:
      result(FlutterMethodNotImplemented)
    }
  }

      private func addStickerToSnapchat(args: [String: Any], result: @escaping FlutterResult) {
          guard let stickerPath = args["stickerPath"] as? String,
                let posX = args["posX"] as? Double,
                let clientId = args["clientId"] as? String,
                let posY = args["posY"] as? Double,
                let rotation = args["rotation"] as? Double,
                let widthDp = args["widthDp"] as? Int,
                let heightDp = args["heightDp"] as? Int else {
              return result(FlutterError(code: "INVALID_ARGUMENTS", message: "Missing required arguments", details: nil))
          }

          guard let imageData = UIImage(contentsOfFile: stickerPath)?.jpegData(compressionQuality: 1.0) else {
              return result(FlutterError(code: "FILE_NOT_FOUND", message: "Sticker file not found", details: nil))
          }

          let sticker = StickerData(posX: posX, posY: posY, rotation: rotation, widthDp: widthDp, heightDp: heightDp, image: imageData)
          shareToCamera(clientID: clientId, caption: nil, sticker: sticker)
          result(nil)
      }

      private func launchSnapchatPreviewWithImage(args: [String: Any], result: @escaping FlutterResult) {
          guard let filePath = args["filePath"] as? String,
                let clientId = args["clientId"] as? String,
                let caption = args["caption"] as? String else {
              return result(FlutterError(code: "INVALID_ARGUMENTS", message: "Missing required arguments", details: nil))
          }

          guard let imageData = UIImage(contentsOfFile: filePath)?.jpegData(compressionQuality: 1.0) else {
              return result(FlutterError(code: "FILE_NOT_FOUND", message: "Image file not found", details: nil))
          }

          shareToPreview(clientID: clientId, mediaType: .image, mediaData: imageData, caption: caption, sticker: nil)
          result(nil)
      }

      private func launchSnapchatPreviewWithVideo(args: [String: Any], result: @escaping FlutterResult) {
          guard let filePath = args["filePath"] as? String,
                let clientId = args["clientId"] as? String,
                let caption = args["caption"] as? String else {
              return result(FlutterError(code: "INVALID_ARGUMENTS", message: "Missing required arguments", details: nil))
          }

          guard let videoData = try? Data(contentsOf: URL(fileURLWithPath: filePath)) else {
              return result(FlutterError(code: "FILE_NOT_FOUND", message: "Video file not found", details: nil))
          }

          shareToPreview(clientID: clientId, mediaType: .video, mediaData: videoData, caption: caption, sticker: nil)
          result(nil)
      }

      private func launchSnapchatCamera(args: [String: Any], result: @escaping FlutterResult) {
          guard let clientId = args["clientId"] as? String,
                let caption = args["caption"] as? String,
                let appName = args["appName"] as? String else {
              return result(FlutterError(code: "INVALID_ARGUMENTS", message: "Missing required arguments", details: nil))
          }

          shareToCamera(clientID: clientId, caption: caption, sticker: nil)
          result(nil)
      }

      private func launchSnapchatCameraWithLens(args: [String: Any], result: @escaping FlutterResult) {
          guard let lensUUID = args["lensUUID"] as? String,
                let clientId = args["clientId"] as? String,
                let launchData = args["launchData"] as? [String: String] else {
              return result(FlutterError(code: "INVALID_ARGUMENTS", message: "Missing required arguments", details: nil))
          }

          shareDynamicLenses(clientID: clientId, lensUUID: lensUUID, launchData: launchData as NSDictionary, caption: nil, sticker: nil)
          result(nil)
      }



    private var saveCount = 0
      private var totalFiles = 0
      private var saveCompletionResult: FlutterResult?

      private func shareToInstagram(args: [String: Any], result: @escaping FlutterResult) {
          guard let filePaths = args["filePaths"] as? [String] else {
              return result(FlutterError(code: "INVALID_ARGUMENTS", message: "Invalid arguments. Expected an array of file paths.", details: nil))
          }

          saveCount = 0
          totalFiles = filePaths.count
          saveCompletionResult = result

          for filePath in filePaths {
              let fileURL = URL(fileURLWithPath: filePath)
              let fileExtension = fileURL.pathExtension.lowercased()

              if fileExtension == "mp4" || fileExtension == "mov" || fileExtension == "3gp" || fileExtension == "m4v" || fileExtension == "hevc" {
                  // Save video to Photos Library
                  UISaveVideoAtPathToSavedPhotosAlbum(filePath, self, #selector(videoSaveCompleted(_:didFinishSavingWithError:contextInfo:)), nil)
              } else if fileExtension == "jpg" || fileExtension == "jpeg" || fileExtension == "png" {
                  // Save image to Photos Library
                  if let image = UIImage(contentsOfFile: filePath) {
                      UIImageWriteToSavedPhotosAlbum(image, self, #selector(imageSaveCompleted(_:didFinishSavingWithError:contextInfo:)), nil)
                  } else {
                      result(FlutterError(code: "FILE_NOT_FOUND", message: "Image file not found: \(filePath)", details: nil))
                      return
                  }
              } else {
                  result(FlutterError(code: "INVALID_FILE_TYPE", message: "Unsupported file type: \(filePath)", details: nil))
                  return
              }
          }
      }

      // Image save completion handler
      @objc private func imageSaveCompleted(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
          handleSaveCompletion(error: error)
      }

      // Video save completion handler
      @objc private func videoSaveCompleted(_ videoPath: String, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
          handleSaveCompletion(error: error)
      }

      // Handle save completion for all files
      private func handleSaveCompletion(error: Error?) {
          if let error = error {
              saveCompletionResult?(FlutterError(code: "SAVE_FAILED", message: error.localizedDescription, details: nil))
              saveCompletionResult = nil
              return
          }

          saveCount += 1
          if saveCount == totalFiles {
              // All files saved, open Instagram
              DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { // Add delay for indexing
                  guard let instagramURL = URL(string: "instagram://share"),
                        UIApplication.shared.canOpenURL(instagramURL) else {
                      self.saveCompletionResult?(FlutterError(code: "INSTAGRAM_NOT_INSTALLED", message: "Instagram is not installed", details: nil))
                      self.saveCompletionResult = nil
                      return
                  }

                  UIApplication.shared.open(instagramURL, options: [:]) { success in
                      if success {
                          self.saveCompletionResult?(nil) // Successfully opened Instagram
                      } else {
                          self.saveCompletionResult?(FlutterError(code: "OPEN_URL_FAILED", message: "Failed to open Instagram", details: nil))
                      }
                      self.saveCompletionResult = nil
                  }
              }
          }
      }

    
//     func shareToTiktokMultiFilesV1(args: [String: Any?], result: @escaping FlutterResult) {
//         guard let filePaths = args["filePaths"] as? [String],
//               let redirectUrl = args["redirectUrl"] as? String,
//               let fileType = args["fileType"] as? String else {
//             result("Invalid arguments")
//             return
//         }
//
//         PHPhotoLibrary.shared().performChanges({
//             for filePath in filePaths {
//                 guard let videoData = try? Data(contentsOf: URL(fileURLWithPath: filePath)) as NSData else {
//                     continue // Skip files that can't be read
//                 }
//
//                 let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
//                 let filePath = "\(documentsPath)/\(Date().description)" + (fileType == "image" ? ".jpeg" : ".mp4")
//
//                 videoData.write(toFile: filePath, atomically: true)
//
//                 if fileType == "image" {
//                     PHAssetChangeRequest.creationRequestForAssetFromImage(atFileURL: URL(fileURLWithPath: filePath))
//                 } else {
//                     PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: URL(fileURLWithPath: filePath))
//                 }
//             }
//         }, completionHandler: { success, error in
//             if success {
//                 let fetchOptions = PHFetchOptions()
//                 fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
//
//                 let fetchResult = PHAsset.fetchAssets(with: fileType == "image" ? .image : .video, options: fetchOptions)
//
//                 var localIdentifiers: [String] = []
//
//                 fetchResult.enumerateObjects { asset, _, _ in
//                     localIdentifiers.append(asset.localIdentifier)
//                 }
//
//                 if !localIdentifiers.isEmpty {
//                     let shareRequest = TikTokShareRequest(
//                         localIdentifiers: localIdentifiers,
//                         mediaType: fileType == "image" ? .image : .video,
//                         redirectURI: redirectUrl
//                     )
//                     shareRequest.shareFormat = .normal
//
//                     DispatchQueue.main.async {
//                         shareRequest.send()
//                         result("success")
//                     }
//                 } else {
//                     result("No assets found to share!")
//                 }
//             } else if let error = error {
//                 print(error.localizedDescription)
//                 result("Error: \(error.localizedDescription)")
//             } else {
//                 result("Unknown error occurred!")
//             }
//         })
//     }

    
    
    private func shareToTikTokMultiFiles(args: [String: Any], result: @escaping FlutterResult) {
        guard let filePaths = args["filePaths"] as? [String],
              let redirectUrl = args["redirectUrl"] as? String,
              let fileTypeString = args["fileType"] as? String else {
            return result(FlutterError(code: "INVALID_ARGUMENTS", message: "Missing required arguments", details: nil))
        }

        // Determine media type from the fileType argument
        let mediaType: TikTokShareMediaType = (fileTypeString.lowercased() == "image") ? .image : .video

        let group = DispatchGroup()
        var assetIdentifiers: [String] = []

        for filePath in filePaths {
            group.enter()
            let fileURL = URL(fileURLWithPath: filePath)

            PHPhotoLibrary.shared().performChanges({
                if mediaType == .image {
                    let creationRequest = PHAssetChangeRequest.creationRequestForAssetFromImage(atFileURL: fileURL)
                    if let placeholder = creationRequest?.placeholderForCreatedAsset {
                        assetIdentifiers.append(placeholder.localIdentifier)
                    }
                } else {
                    let creationRequest = PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: fileURL)
                    if let placeholder = creationRequest?.placeholderForCreatedAsset {
                        assetIdentifiers.append(placeholder.localIdentifier)
                    }
                }
            }, completionHandler: { success, error in
                if let error = error {
                    print("Error saving \(mediaType == .image ? "image" : "video") to Photos library: \(error.localizedDescription)")
                }
                group.leave()
            })
        }

        group.notify(queue: .main) {
            guard !assetIdentifiers.isEmpty else {
                return result(FlutterError(code: "FILES_NOT_FOUND", message: "Failed to save files to Photos library", details: nil))
            }

            print("Asset Identifiers: \(assetIdentifiers)")

            let shareRequest = TikTokShareRequest(localIdentifiers: assetIdentifiers,
                                                  mediaType: mediaType,
                                                  redirectURI: redirectUrl)

            shareRequest.send { response in
                guard let shareResponse = response as? TikTokShareResponse else {
                    return result(FlutterError(code: "TIKTOK_SHARE_FAILED", message: "Failed to share to TikTok", details: nil))
                }

                if shareResponse.errorCode == .noError {
                    print("TikTok share successful!")
                    result(nil)
                } else {
                    result(FlutterError(code: "TIKTOK_SHARE_FAILED",
                                        message: "TikTok reported a failure.",
                                        details: shareResponse.errorDescription))
                }
            }
        }
    }



private func airdropShareText(args: [String: Any], result: @escaping FlutterResult) {
    guard let text = args["text"] as? String else {
        return result(FlutterError(code: "INVALID_ARGUMENTS", message: "Missing required arguments", details: nil))
    }

    var rootViewController: UIViewController?

    if #available(iOS 13.0, *) {
        rootViewController = UIApplication.shared.connectedScenes
            .compactMap({ $0 as? UIWindowScene })
            .first?.windows
            .first(where: { $0.isKeyWindow })?.rootViewController
    } else {
        rootViewController = UIApplication.shared.keyWindow?.rootViewController
    }

    guard let rootVC = rootViewController else {
        return result(FlutterError(code: "NO_VIEW_CONTROLLER", message: "Root view controller not found", details: nil))
    }

    let activityController = UIActivityViewController(activityItems: [text], applicationActivities: nil)

    // Exclude all activity types except AirDrop
    activityController.excludedActivityTypes = [
        .postToFacebook,
        .postToTwitter,
        .postToWeibo,
        .message,
        .mail,
        .print,
        .copyToPasteboard,
        .assignToContact,
        .saveToCameraRoll,
        .addToReadingList,
        .postToFlickr,
        .postToVimeo,
        .postToTencentWeibo,
        .airDrop, // Explicitly include AirDrop (optional)
        .openInIBooks,
        .markupAsPDF
    ].filter { $0 != .airDrop } // Keep only AirDrop

    activityController.popoverPresentationController?.sourceView = rootVC.view

    rootVC.present(activityController, animated: true) {
        result(nil) // Success
    }
}

  private func launchSnapchatPreviewWithMultipleFiles(args: [String: Any], result: @escaping FlutterResult) {
      guard let filePaths = args["filePaths"] as? [String],
            let clientId = args["clientId"] as? String else {
          return result(FlutterError(code: "INVALID_ARGUMENTS", message: "Invalid arguments", details: nil))
      }

      var items: [[String: Any]] = []

      // Iterate through each file path and add to the items array
      for filePath in filePaths {
          let fileURL = URL(fileURLWithPath: filePath)
          let fileExtension = fileURL.pathExtension.lowercased()

          if fileExtension == "mp4" || fileExtension == "mov" {
              // Add video data
              guard let videoData = try? Data(contentsOf: fileURL) else {
                  return result(FlutterError(code: "FILE_NOT_FOUND", message: "Video file not found: \(filePath)", details: nil))
              }
              items.append([CreativeKitLiteKeys.backgroundVideo: videoData])
          } else if fileExtension == "jpg" || fileExtension == "jpeg" || fileExtension == "png" {
              // Add image data
              guard let imageData = UIImage(contentsOfFile: filePath)?.jpegData(compressionQuality: 1.0) else {
                  return result(FlutterError(code: "FILE_NOT_FOUND", message: "Image file not found: \(filePath)", details: nil))
              }
              items.append([CreativeKitLiteKeys.backgroundImage: imageData])
          } else {
              return result(FlutterError(code: "INVALID_FILE_TYPE", message: "Unsupported file type: \(filePath)", details: nil))
          }
      }

      // Combine all items into the clipboard dictionary
      var dict: [String: Any] = [
          CreativeKitLiteKeys.clientID: clientId
      ]

      // Add all media items to the dictionary
      for item in items {
          dict.merge(item) { (_, new) in new }
      }

      // Set the items into the UIPasteboard
      UIPasteboard.general.setItems([dict], options: [
          UIPasteboard.OptionsKey.expirationDate: Date().addingTimeInterval(300) // Expire in 5 minutes
      ])

      // Create the Snapchat URL and open it
      guard let snapchatURL = URL(string: ShareDestination.preview.rawValue),
            UIApplication.shared.canOpenURL(snapchatURL) else {
          return result(FlutterError(code: "SNAPCHAT_NOT_INSTALLED", message: "Snapchat is not installed on this device", details: nil))
      }

      UIApplication.shared.open(snapchatURL, options: [:]) { success in
          if success {
              result(nil)
          } else {
              result(FlutterError(code: "OPEN_URL_FAILED", message: "Failed to open Snapchat", details: nil))
          }
      }
  }
}
