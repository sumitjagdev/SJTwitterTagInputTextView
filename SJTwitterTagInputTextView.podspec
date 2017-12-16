
Pod::Spec.new do |s|
  s.name             = 'SJTwitterTagInputTextView'
  s.version          = '1.0'
  s.summary          = 'SJTwitterTagInputTextView is Twitter Style input text view for "@" tag and "#" tag'


  s.description      = <<-DESC
SJTwitterTagTextView for text input with suggestion.
It's like Twitter for getting @ and # tag as input and showing Suggestion for tags and mentions in an Table view which will automatically appear when the user will input @ and # tag.

                       DESC

  s.homepage         = 'https://github.com/sumitjagdev/SJTwitterTagInputTextView'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Sumit Jagdev' => 'sumitjagdev3@gmail.com' }
  s.source           = { :git => 'https://github.com/sumitjagdev/SJTwitterTagInputTextView.git', :tag => s.version.to_s }

  s.ios.deployment_target = '8.0'

  s.source_files = 'SJTwitterTagInputTextView/Classes/**/*'

  
  s.pod_target_xcconfig = { 'SWIFT_VERSION' => '4.0' }
end
