Pod::Spec.new do |s|
  s.name = "Refresher"
  s.version = "0.3.0"
  s.summary = "A refresh control library for Custom UI."
  s.homepage = "https://github.com/yutmr/Refresher"
  s.license = "MIT"
  s.author = { "yutmr" => "yu.ampm@gmail.com" }
  s.source = { :git => "https://github.com/yutmr/Refresher.git", :tag => s.version.to_s }
  s.ios.deployment_target = '8.0'
  s.requires_arc = true
  s.ios.source_files = 'Sources/*'
  s.ios.frameworks = 'UIKit', 'Foundation'
end
