Pod::Spec.new do |s|

s.name         = "ChannelizeCall"
s.version      = "4.10.1"
s.summary      = "Channelize Call SDK"
s.description  = "A Video and Audio call SDK using Channelize API SDK"
s.homepage     = "https://channelize.io/"
s.license      = { :type => "GPL", :file => "LICENSE" }
s.author       = { "Channelize" => "support@channelize.io" }
s.platform     = :ios, "10.3"
s.swift_version = "4.2"
s.requires_arc = true
s.source       = { :git => "https://github.com/ChannelizeIO/Channelize-iOS.git", :tag => "#{s.version}", :branch => "pods/Xcode10" }
s.vendored_frameworks = "Channelize_Voice_Video.framework"
s.dependency "AgoraRtcEngine_iOS", ">= 2.3.1"
s.dependency "SDWebImage/GIF", "4.4.3"
end

