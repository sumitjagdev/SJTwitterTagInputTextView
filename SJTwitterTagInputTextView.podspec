#
# Be sure to run `pod lib lint SJTwitterTagInputTextView.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'SJTwitterTagInputTextView'
  s.version          = '0.1.0'
  s.summary          = 'SJTwitterTagInputTextView is Twitter Style input text view for "@" tag and "#" tag'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
SJTwitterTagTextView for text input with suggestion.
It's like Twitter for getting @ and # tag as input and showing Suggestion for tags and mentions in an Table view which will automatically appear when the user will input @ and # tag.

                       DESC

  s.homepage         = 'https://github.com/sumitjagdev/SJTwitterTagInputTextView'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Sumit Jagdev' => 'sumitjagdev3@gmail.com' }
  s.source           = { :git => 'https://github.com/sumitjagdev/SJTwitterTagInputTextView.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'

  s.source_files = 'SJTwitterTagInputTextView/Classes/**/*'
  
  # s.resource_bundles = {
  #   'SJTwitterTagInputTextView' => ['SJTwitterTagInputTextView/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
  
  s.pod_target_xcconfig = { 'SWIFT_VERSION' => '2.3' }
end
