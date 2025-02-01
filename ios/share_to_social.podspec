Pod::Spec.new do |s|
  s.name             = 'share_to_social'
  s.version          = '0.0.1'
  s.summary          = 'A new Flutter project.'
  s.description      = <<-DESC
A new Flutter project.
                       DESC
  s.homepage         = 'https://github.com/Mohamed1226/share_to_social'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Your Company' => 'mohamed.adel.dev9@gmail.com'}
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.dependency 'Flutter'
  s.platform = :ios, '11.0'
  s.static_framework = true

  s.dependency 'SnapSDK', '~> 1.15.0'
  s.dependency 'TikTokOpenSDK', '~> 5.0.15'
  s.dependency 'TikTokOpenSDKCore', '~> 2.4.0'
  s.dependency 'TikTokOpenAuthSDK', '~> 2.4.0'
  s.dependency 'TikTokOpenShareSDK', '~> 2.4.0'

  s.pod_target_xcconfig = {
    'DEFINES_MODULE' => 'YES',
    'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386 arm64',
    'ENABLE_BITCODE' => 'NO'
  }
  s.swift_version = '5.0'
end
