Pod::Spec.new do |s|
  s.name         = "SKDanmakuManager"
  s.version      = "0.0.1"
  s.summary      = "A danmakus manager for iOS."
  s.description  = <<-DESC
	Create danmakus quickly and show in video's layer.
  DESC
  s.homepage     = "https://github.com/lskyme/SKDanmakuManager"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author       = { "Lskyme" => "lskyme@sina.com" }
  s.platform     = :ios, '8.0'
  s.source       = { :git => "https://github.com/lskyme/SKDanmakuManager.git", :tag => s.version }
  s.source_files  = "SKDanmakuManager/*.{h,m}"
  s.public_header_files = "SKDanmakuManager/*.h"
  s.requires_arc = true
end
