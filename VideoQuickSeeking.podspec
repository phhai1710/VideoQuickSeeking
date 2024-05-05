#
# Be sure to run `pod lib lint VideoQuickSeeking.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'VideoQuickSeeking'
  s.version          = '1.0.2'
  s.summary          = 'Youtube-like double tap to forward/rewind animation with ripple effect'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = 'Youtube-like double tap to forward/rewind animation with ripple effect.'

  s.homepage         = 'https://github.com/phhai1710/VideoQuickSeeking'
  s.screenshots      = 'https://raw.githubusercontent.com/phhai1710/VideoQuickSeeking/master/Resources/screenshot1.png'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Hai Pham' => 'phhai1710@gmail.com' }
  s.source           = { :git => 'https://github.com/phhai1710/VideoQuickSeeking.git', :tag => s.version.to_s }
  s.social_media_url = 'https://github.com/phhai1710'

  s.ios.deployment_target = '9.0'

  s.source_files = 'VideoQuickSeeking/Classes/**/*'
  s.resources = 'VideoQuickSeeking/Assets/*.xcassets'
  s.swift_version = '4.0'
  # s.resource_bundles = {
  #   'VideoQuickSeeking' => ['VideoQuickSeeking/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
