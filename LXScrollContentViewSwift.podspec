
Pod::Spec.new do |s|

  s.name         = "LXScrollContentViewSwift"
  s.version      = "1.0"
  s.summary      = "LXScrollContentViewSwift"
  s.description  = "LXScrollContentViewSwift desc"
  s.homepage     = "https://github.com/LiuXingCode/LXScollContentViewSwift"
  s.license      = "MIT"
  s.author             = { "liuxing" => "liuxinghenau@163.com" }
  s.source       = { :git => "https://github.com/LiuXingCode/LXScollContentViewSwift", :tag => "#{s.version}" }
  s.source_files  = "LXScrollContentViewLib/**/*.{h,m}"
  s.ios.deployment_target = '8.0'

end
