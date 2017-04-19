#
# Be sure to run `pod lib lint MAGDebugKit.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'MAGDebugKit'
  s.version          = '0.4.5'
  s.summary          = 'Developers Kit for convenient testing and QA.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = 'Developers Kit for convenient iOS App testing and QA.'

  s.homepage         = 'https://github.com/Magora-IOS/MAGDebugKit'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Evgeniy Stepanov' => 'stepanov@magora.systems' }
  s.source           = { :git => 'https://github.com/Magora-IOS/MAGDebugKit.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'

  s.source_files = 'MAGDebugKit/Classes/**/*'
  s.resource_bundles = {
    'MAGDebugKit' => ['MAGDebugKit/Assets/*.xib']
  }

  #s.public_header_files = 'Pod/Classes/**/*.h'
  #s.frameworks = 'UIKit'
  # s.dependency 'AFNetworking', '~> 2.3'

  s.dependency 'MAGMatveevReusable', '0.3.5'
  s.dependency 'YKMediaPlayerKit', '~> 0.0.3'
  s.dependency 'libextobjc', '~> 0.4'
  s.dependency 'Masonry', '~> 1.0'
  s.dependency 'Bohr', '~> 3.0'
  s.dependency 'ReactiveObjC', '~> 2.1'
  s.dependency 'CocoaLumberjack', '~> 2.4'
  s.dependency 'CocoaAsyncSocket', '~> 7.6'

end
