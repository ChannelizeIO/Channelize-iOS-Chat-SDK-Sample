Pod::Spec.new do |s|

  s.name         = "ChannelizeAPI"
  s.version      = "4.1.0"
  s.summary      = "Channelize API SDK"
  s.description  = "A Real Time Messaging API SDK"
  s.homepage     = "https://channelize.io/"
  s.license      = { :type => "GPL", :file => "LICENSE" }
  s.author       = { "Channelize" => "support@channelize.io" }
  s.platform     = :ios, "9.0"
s.source       = { :git => "https://github.com/ChannelizeIO/Channelize-iOS.git", :tag => "#{s.version}", :branch => "Swift_4.1" }
  s.vendored_frameworks = "Channelize_API.framework"
  s.dependency "MQTTClient", "0.14.0"
  s.dependency "MQTTClient/Websocket"
  s.dependency "Alamofire", "4.7.3"
  s.dependency "AlamofireObjectMapper", "5.1.0"
end
