import 'package:flutter_test/flutter_test.dart';
import 'package:share_to_social/social_sharing.dart';
import 'package:share_to_social/social_sharing_platform_interface.dart';
import 'package:share_to_social/social_sharing_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockSocialSharingPlatform with MockPlatformInterfaceMixin implements SocialSharingPlatform {
  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final SocialSharingPlatform initialPlatform = SocialSharingPlatform.instance;

  test('$MethodChannelSocialSharing is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelSocialSharing>());
  });

  test('getPlatformVersion', () async {
    SocialSharing socialSharingPlugin = SocialSharing();
    MockSocialSharingPlatform fakePlatform = MockSocialSharingPlatform();
    SocialSharingPlatform.instance = fakePlatform;

    expect(await socialSharingPlugin.getPlatformVersion(), '42');
  });
}
