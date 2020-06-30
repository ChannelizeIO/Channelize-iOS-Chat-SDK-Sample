Pod::Spec.new do |s|

  s.name         = 'ChannelizeAPI'
  s.version      = '4.20.8'
  s.summary      = 'Channelize API SDK'
  s.description  = 'A Real Time Messaging API SDK'
  s.homepage     = 'https://channelize.io/'
  s.license      = { :type => 'GPL', :file => 'LICENSE' }
  s.author       = { "Channelize" => 'support@channelize.io' }
  s.platform     = :ios, '10.3'
  s.requires_arc = true
  s.swift_version = '4.2'
  s.source       = { :git => "https://github.com/ChannelizeIO/Channelize-iOS-Chat-SDK-Sample.git", :tag => "#{s.version}", :branch => "release/V2Pods" }
  s.vendored_frameworks = 'ChannelizeAPI.xcframework'
  s.dependency 'AWSMobileClient', '2.9.3'
  s.dependency 'AWSIoT', '2.9.3'
  s.dependency 'Alamofire', '4.8.2'
  s.dependency 'AlamofireObjectMapper', '5.2.0'
end
