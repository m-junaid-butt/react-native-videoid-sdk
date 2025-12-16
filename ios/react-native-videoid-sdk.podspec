Pod::Spec.new do |s|
  s.name         = "react-native-videoid-sdk"
  s.version      = "1.0.0"
  s.summary      = "React Native bridge for VideoID iOS SDK"
  s.homepage     = "https://github.com/your/repo"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.authors      = { "You" => "you@email.com" }
  s.source       = { :git => "" }
  
  s.platform     = :ios, '16.0'
  
  # Include both Objective-C and Swift files
  s.source_files = "ios/*.{h,m,swift}"
  
  # Swift version
  s.swift_version = '5.0'
  
  s.dependency "React-Core"
  
  s.pod_target_xcconfig = {
    "DEFINES_MODULE" => "YES"
  }
end