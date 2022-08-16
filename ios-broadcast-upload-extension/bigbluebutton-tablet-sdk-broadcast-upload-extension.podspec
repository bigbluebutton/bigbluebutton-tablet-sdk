require "json"

package = JSON.parse(File.read(File.join(__dir__, "../package.json")))

Pod::Spec.new do |s|
  s.name         = "bigbluebutton-tablet-sdk-broadcast-upload-extension"
  s.version      = package["version"]
  s.summary      = package["description"]
  s.homepage     = package["homepage"]
  s.license      = package["license"]
  s.authors      = package["author"]

  s.platforms    = { :ios => "14.7" }
  s.source       = { :git => "https://github.com/bigbluebutton/bigbluebutton-tablet-sdk.git", :tag => "#{s.version}" }

  s.source_files = "Classes/*.{h,m,mm,swift}"
  s.public_header_files = ["Classes/*.h"]
  s.dependency "WebRTC-lib"
  s.dependency "bigbluebutton-tablet-sdk-common"
end
