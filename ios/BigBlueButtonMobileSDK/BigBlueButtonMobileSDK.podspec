#
# Be sure to run `pod lib lint BigBlueButtonMobileSDK.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'BigBlueButtonMobileSDK'
  s.version          = '0.1.0'
  s.summary          = 'SDK containing swift code for BigBlueButton mobile application.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
  This SDK is used in BigBlueButton mobile application, and its main goal is to provide abstraction on the internals of BigBlueButton.
                       DESC

  s.homepage         = 'https://github.com/bigbluebutton/bigbluebutton-mobile-sdk'
  s.license          = { :type => 'LGPL-3.0', :file => 'LICENSE' }
  s.author           = { 'Tiago Daniel Jacobs' => 'tiago.jacobs@gmail.com' }
  s.source           = { :git => 'https://github.com/bigbluebutton/bigbluebutton-mobile-sdk.git', :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/BigBlueButton'

  s.ios.deployment_target = '14.0'

  s.source_files = 'BigBlueButtonMobileSDK/Classes/**/*'
  
  # s.resource_bundles = {
  #   'BigBlueButtonMobileSDK' => ['BigBlueButtonMobileSDK/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
  s.dependency 'GoogleWebRTC'
  s.swift_versions = '5.1'
end
