# ZVProgressHUD
![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)[](https://github.com/Carthage/Carthage)
![CocoaPods Compatible](https://img.shields.io/badge/pod-1.0.0-4BC51D.svg?style=flat)[](https://cocoapods.org)
![Platform](https://img.shields.io/badge/platform-ios-9F9F9F.svg)[](http://cocoadocs.org/docsets/Alamofire)

<br/>

ZVProgressHUD is a pure-swift and wieldy HUD.

[中文文档](https://github.com/zevwings/ZVProgressHUD/blob/master/README_CN.md)

## Requirements

- iOS 8.0+ 
- Swift 3.0

## Installation
### Cocoapod
[CocoaPods](https://cocoapods.org) is a dependency manager for Swift and Objective-C Cocoa projects.
<br/>

You can install Cocoapod with the following command

```
$ sudo gem install cocoapods
```
To integrate `ZVProgressHUD` into your project using CocoaPods, specify it into your `Podfile`

```
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '8.0'

target 'TargetName' do
    use_frameworks!
    pod 'ZVProgressHUD', :git => 'https://github.com/zevwings/ZVProgressHUD.git'
end
```

Then，install your dependencies with [CocoaPods](https://cocoapods.org).

```
$ pod install
```
### Carthage 

[Carthage](https://github.com/Carthage/Carthage) is intended to be the simplest way to add frameworks to your application.

You can install Carthage with [Homebrew](https://brew.sh) using following command:

```
$ brew update
$ brew install carthage
```

To integrate `ZVProgressHUD` into your project using Carthage, specify it into your `Cartfile`

```
github "zevwings/ZVProgressHUD" ~> 0.0.1
```

Then，build the framework with Carthage
using `carthage update` and drag `ZVProgressHUD.framework` into your project.

#### Note:
The framework is under the Carthage/Build, and you should drag it into  `Target` -> `Genral` -> `Embedded Binaries`

### Manual
Download this project, And drag `ZVProgressHUD.xcodeproj` into your own project.

In your target’s General tab, click the ’+’ button under `Embedded Binaries`

Select the `ZVProgressHUD.framework` to Add to your platform.

## Usage
You can use `import ZVProgressHUD` when you needed to use `ZVProgressHUD`

When you start a task, You can using following code:

```
ZVProgressHUD.show()
DispatchQueue.global().async {
    ZVProgressHUD.dismiss()
}
```

### Showing the HUD
When you start a task, You can using following code to show `ZVProgressHUD`

```
ZVProgressHUD.show()
ZVProgressHUD.show(with: .state(title: "Loading...", state: .indicator))
```

### Dismiss the HUD

```
ZVProgressHUD.dismiss()
```

### Showing the confirmation

```
ZVProgressHUD.show(with: .state(title: "Error", state: .error))
ZVProgressHUD.show(with: .state(title: "Success", state: .success))
ZVProgressHUD.show(with: .state(title: "Warning", state: .warning))
```
### Showing the custom image

```
let image = UIImage(named: "cost")
ZVProgressHUD.show(image: image!)

let image = UIImage(named: "cost")
ZVProgressHUD.show(with: .state(title: "Cost", state: .custom(image: image!)))
```

### Showing the progress

```
ZVProgressHUD.show(title: title, progress: progress)
```

### Showing the custom view

```
let customView = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
customView.backgroundColor = UIColor.white
let label = UILabel(frame: CGRect(x: 0, y: 30, width: 100, height: 40 ))
label.textAlignment = .center
label.font = UIFont.systemFont(ofSize: 14.0)
label.textColor = UIColor(red: 215.0 / 255.0, green: 22.0 / 255.0, blue: 59.0 / 255.0, alpha: 1.0)
label.text = "custom view"
customView.addSubview(label)
ZVProgressHUD.customInsets = .init(top: 10, left: 10, bottom: 10, right: 10)
ZVProgressHUD.show(with: .custom(view: customView))
```

### Custom HUD Properties

```
public static var displayStyle: ZVProgressHUD.DisplayStyle     

public static var maskType: ZVProgressHUD.MaskType
    
public static var titleInsets: UIEdgeInsets 

public static var stateInsets: UIEdgeInsets

public static var customInsets: UIEdgeInsets

public static var offset: CGPoint 
    
public static var font: UIFont 

public static var delay: TimeInterval 

/// The cornerRadius if half of the value when you show a pure-label
public static var cornerRadius: CGFloat
```

### Notifications
When ZVProgressHUD.maskType is not equal to `.none`, There will post a Notification named `.ZVProgressHUDDidReceiveTouchEvent`, you can do something with it.

## License
`ZVProgressHUD` distributed under the terms and conditions of the [MIT License](https://github.com/zevwings/ZVProgressHUD/blob/master/LICENSE)



