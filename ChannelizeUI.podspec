Pod::Spec.new do |s|

  s.name         = "ChannelizeUI"
  s.version      = "4.2.0"
  s.summary      = "Channelize UI SDK"
  s.description  = "A Messaging UI SDK built for Channelize API SDK"
  s.homepage     = "https://channelize.io/"
  s.license      = { :type => "GPL", :file => "LICENSE" }
  s.author       = { "Channelize" => "support@channelize.io" }
  s.platform     = :ios, "9.0"
s.source       = { :git => "https://github.com/ChannelizeIO/Channelize-iOS.git", :tag => "#{s.version}", :branch => "master" }
  s.vendored_frameworks = "Channelize.framework"
  s.dependency "AWSMobileClient", "2.9.3"
  s.dependency "AWSIoT", "2.9.3"
  s.dependency "Alamofire", "4.8.0"
  s.dependency "AlamofireObjectMapper", "5.2.0"
  s.dependency "Gallery", "2.2.0"
  s.dependency "Lightbox", "2.3.0"
  s.dependency "SwiftIconFont", "3.0.0"
  s.dependency "CWStatusBarNotification", "2.3.5"
  s.dependency "GiphyCoreSDK", "1.4.0"
  s.dependency "Crashlytics", "3.12.0"
  s.dependency "InputBarAccessoryView", "4.2.1"
  s.dependency "SDWebImage/GIF", "4.4.3"
  s.dependency "ZVProgressHUD", "2.0.3"
  s.dependency "ZVActivityIndicatorView", "0.1.3"
end
