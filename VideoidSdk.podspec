# VideoidSdk.podspec

require "json"
package = JSON.parse(File.read(File.join(__dir__, "package.json")))

Pod::Spec.new do |s|
  s.name         = "VideoidSdk"
  s.version      = package["version"]
  s.summary      = package["description"]
  s.homepage     = package["homepage"]
  s.license      = package["license"]
  s.authors      = package["author"]

  s.platform     = :ios, "15.0"
  s.swift_version = "5.0"

  s.source = {
    :git => "https://github.com/m-junaid-butt/react-native-videoid-sdk.git",
    :tag => "#{s.version}"
  }

  # Dependencies
  s.dependency "VideoIDSDK", "~> 1.45.0"

  s.dependency "React-Core"
  s.dependency "React-Codegen"
  s.dependency "React-Fabric"


  # Include **all** .h, .m, .mm, .swift under ios/ — ensure paths match actual repository
  s.source_files       = "ios/**/*.{h,m,mm,swift}"
  s.public_header_files = "ios/**/*.h"
  
end
