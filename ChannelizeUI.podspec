Pod::Spec.new do |s|

  s.name         = "ChannelizeUI"
  s.version      = "4.11.1"
  s.summary      = "Channelize UI SDK"
  s.description  = "A Messaging UI SDK built for Channelize API SDK"
  s.homepage     = "https://channelize.io/"
  s.license      = { :type => "GPL", :file => "LICENSE" }
  s.author       = { "Channelize" => "support@channelize.io" }
  s.platform     = :ios, "9.0"
  s.swift_version = "4.2"
  s.requires_arc = true
 s.source       = { :git => "https://github.com/ChannelizeIO/Channelize-iOS.git", :tag => "#{s.version}", :branch => "pods/Xcode11" }
  s.vendored_frameworks = "Channelize.framework"
  s.dependency "CWStatusBarNotification", "2.3.5"
  s.dependency "Crashlytics", "3.12.0"
  s.dependency "SDWebImage/GIF", "4.4.3"
  s.dependency "SwiftIconFont", "3.0.0"
  s.dependency "InputBarAccessoryView", "4.2.1"
  s.dependency "ZVProgressHUD", "2.0.3"
  s.dependency "ZVActivityIndicatorView", "0.1.3"
  s.dependency "RealmSwift", "3.17.3"
end
