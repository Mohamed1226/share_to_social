import 'social_sharing_platform_interface.dart';

class SocialSharing {
  Future<String?> getPlatformVersion() {
    return SocialSharingPlatform.instance.getPlatformVersion();
  }
}
