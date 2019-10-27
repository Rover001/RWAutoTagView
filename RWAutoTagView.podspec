
Pod::Spec.new do |spec|
  spec.name         = "RWAutoTagView"
  spec.version      = "0.1.0"
  spec.summary      = "自定义管理标签管理"
  spec.homepage     = "https://cocoapods.org/pods/CustomEngine"
  spec.license      = { :type => "MIT", :file => "LICENSE" }
  spec.author       = { "Rover001" => "zengyun6666@163.com" }
  spec.platform     = :ios
  spec.platform     = :ios, "8.0"
  spec.ios.deployment_target = "8.0"
  spec.source       = { :git => "https://github.com/Rover001/RWCustomUIKit.git", :tag => "#{spec.version}" }
  spec.requires_arc = true
  s.source_files = 'RWAutoTagView/*{h,m}'
  s.public_header_files = 'RWAutoTagView/*.h'
  s.frameworks = 'UIKit'
  s.social_media_url = 'https://blog.csdn.net/RoverWord'
    
end
