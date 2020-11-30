#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint passikey_flutter_sdk.podspec' to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'passikey_flutter_sdk'
  s.version          = '0.0.1'
  s.summary          = 'Passikey Flutter SDK'
  s.description      = <<-DESC
Passikey Flutter SDK
                       DESC
  s.homepage         = 'https://passikey.com'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'PASSIKEY' => 'passikey_cs@rowem.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.public_header_files = 'Classes/**/*.h'
  s.dependency 'Flutter'
  s.vendored_frameworks = ['PASSIKEYauth.framework']
  s.platform = :ios, '8.0'

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
  s.swift_version = '5.0'
end
