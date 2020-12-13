Pod::Spec.new do |s|
  s.name             = 'CDAlertView'
  s.version          = '0.11.0'
  s.summary          = 'Highly customizable alert/notification/success/error/alarm popup'
  s.description      = <<-DESC
CDAlertView is highly customizable alert popup written in Swift 5. Usage is similar to UIAlertController.
                       DESC

  s.homepage         = 'https://github.com/candostdagdeviren/CDAlertView'
  s.screenshots     = 'https://cloud.githubusercontent.com/assets/1971963/20238308/4bc1516e-a8e8-11e6-8e8b-c1a088f5daa0.png'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Candost Dagdeviren' => 'candostdagdeviren@gmail.com' }
  s.source           = { :git => 'https://github.com/candostdagdeviren/CDAlertView.git', :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/candostdagdevrn'

  s.ios.deployment_target = '12.0'

  s.source_files = 'CDAlertView/Classes/**/*'
  s.swift_version = '5.0'
  s.resource_bundles = {
    'CDAlertView' => ['CDAlertView/Resources/Assets/*.*']
  }

  s.frameworks = 'UIKit'
end
