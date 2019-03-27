Pod::Spec.new do |s|

  s.name         = "ChannelizeUI"
  s.version      = "4.1.1"
  s.summary      = "Channelize UI SDK"
  s.description  = "A Messaging UI SDK built for Channelize API SDK"
  s.homepage     = "https://channelize.io/"
  s.license      = { :type => "GPL", :file => "LICENSE" }
  s.author       = { "Channelize" => "support@channelize.io" }
  s.platform     = :ios, "9.0"
s.source       = { :git => "https://github.com/ChannelizeIO/Channelize-iOS.git", :tag => "#{s.version}", :branch => "Swift_4.1" }
  s.vendored_frameworks = "Channelize.framework"
  s.dependency "MQTTClient", "0.14.0"
  s.dependency "MQTTClient/Websocket"
  s.dependency "Alamofire", "4.7.3"
  s.dependency "AlamofireObjectMapper", "5.1.0"
  s.dependency "Gallery", "2.0.6"
  s.dependency "Lightbox", "2.1.2"
  s.dependency "SwiftIconFont", "2.8.0"
  s.dependency "CWStatusBarNotification", "2.3.5"
  s.dependency "GiphyCoreSDK", "1.2.0"
  s.dependency "Crashlytics", "3.10.7"
  s.dependency "InputBarAccessoryView", "2.2.2"
  s.dependency "SDWebImage/GIF"
  s.dependency "ZVProgressHUD", "2.0.0"
  s.dependency "ZVActivityIndicatorView", "0.1.2"
end
