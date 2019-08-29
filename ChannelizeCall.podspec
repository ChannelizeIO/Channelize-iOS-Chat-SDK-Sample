Pod::Spec.new do |s|

s.name         = "ChannelizeCall"
s.version      = "4.0.5"
s.summary      = "Channelize Call SDK"
s.description  = "A Video and Audio call SDK using Channelize API SDK"
s.homepage     = "https://channelize.io/"
s.license      = { :type => "GPL", :file => "LICENSE" }
s.author       = { "Channelize" => "support@channelize.io" }
s.platform     = :ios, "9.0"
s.swift_version = "4.2"
s.source       = { :git => "https://github.com/ChannelizeIO/Channelize-iOS.git", :tag => "#{s.version}", :branch => "master" }
s.vendored_frameworks = "Channelize_Voice_Video.framework"
s.dependency "AgoraRtcEngine_iOS", ">= 2.3.1"
s.dependency "SDWebImage/GIF", "4.4.3"
end

