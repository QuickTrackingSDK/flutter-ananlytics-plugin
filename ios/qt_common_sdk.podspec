#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint qt_common_sdk.podspec' to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'qt_common_sdk'
  s.version          = '1.0.0'
  s.summary          = 'QuickTracking Analytics Flutter plugin.'
  s.description      = <<-DESC
A new Flutter plugin.
                       DESC
  s.homepage         = 'https://help.aliyun.com/document_detail/201089.html'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'lydaas' => 'changliang.lcl@alibaba-inc.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.public_header_files = 'Classes/**/*.h'
  s.dependency 'Flutter'
  s.platform = :ios, '8.0'
  s.dependency 'QTCommon', '1.5.5.PX'

  s.static_framework = true

  # Flutter.framework does not contain a i386 slice. Only x86_64 simulators are supported.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'VALID_ARCHS[sdk=iphonesimulator*]' => 'x86_64' }
end
