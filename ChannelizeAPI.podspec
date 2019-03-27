Pod::Spec.new do |s|

  s.name         = "ChannelizeAPI"
  s.version      = "4.2.0"
  s.summary      = "Channelize API SDK"
  s.description  = "A Real Time Messaging API SDK"
  s.homepage     = "https://channelize.io/"
  s.license      = { :type => "GPL", :file => "LICENSE" }
  s.author       = { "Channelize" => "support@channelize.io" }
  s.platform     = :ios, "9.0"
s.source       = { :git => "https://github.com/ChannelizeIO/Channelize-iOS.git", :tag => "#{s.version}", :branch => "master" }
  s.vendored_frameworks = "Channelize_API.framework"
  s.dependency "AWSMobileClient", "2.9.3"
  s.dependency "AWSIoT", "2.9.3"
  s.dependency "Alamofire", "4.8.0"
  s.dependency "AlamofireObjectMapper", "5.2.0"
end
