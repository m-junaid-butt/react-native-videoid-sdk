# ios/VideoIDSDK.podspec
Pod::Spec.new do |s|
  s.name         = "VideoIDSDK"
  s.version      = "1.0.0"
  s.summary      = "VideoID iOS SDK via SPM"
  s.homepage     = "https://github.com/signicat/videoidskd-spm"
  s.license      = { :type => "MIT" }
  s.author       = { "Signicat" => "support@signicat.com" }

  s.platform = :ios, '16.0'
  s.requires_arc = true

  # IMPORTANT: SPM dependencies
  s.dependency "lottie-ios"

  # No source_files or vendored_frameworks since it's SPM
  # The actual SDK will be added via SPM in Xcode
  
  s.pod_target_xcconfig = {
    'DEFINES_MODULE' => 'YES'
  }
  
  s.frameworks = 'UIKit', 'Foundation'
end