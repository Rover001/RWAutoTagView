
Pod::Spec.new do |spec|
  spec.name         = "RWAutoTagView"
  spec.version      = "0.1.3"
  spec.summary      = "自定义标签管理"
  spec.homepage     = "https://blog.csdn.net/RoverWord/article/details/102827798"
  spec.license      = { :type => "MIT", :file => "LICENSE" }
  spec.author       = { "Rover001" => "zengyun6666@163.com" }
  spec.platform     = :ios, "9.0"
  spec.ios.deployment_target = "9.0"
  spec.source       = { :git => "https://github.com/Rover001/RWAutoTagView.git", :tag => "#{spec.version}" }
  spec.requires_arc = true
  spec.source_files = 'RWAutoTagView/*{h,m}'
  spec.resource     = 'RWAutoTagView/RWAutoTag.bundle'
  spec.public_header_files = 'RWAutoTagView/*.h'
  spec.frameworks = 'UIKit'
  spec.social_media_url = 'https://cocoapods.org/pods/RWAutoTagView'
    
end
