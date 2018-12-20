# Channelize-iOS
 Sample app illustrating how to build applications with the Channelize IOS SDK

The following documentation is built to help you with installing our iOS SDK into your project.



The Channelize SDK can be installed using the following method

Firstly, you will need to register on Channelize: https://channelize.io/pricing

After the successful payment at https://channelize.io/pricing you'll get the "channelize.framework" file that will contains the all messaging and other feature of channelize.io.

 - Download the `channelize.framework` file.
 - Copy and paste it in your project directory.
 - Drag and drop it in the `Embedded Binaries` section of your project as described in the below image. 
 
 ![alt text](https://github.com/ChannelizeIO/Channelize-iOS/blob/master/demo/Assests/framwork_placement.png)
 

## Dependencies
**Requirement**

Before we begin, please do make sure that

 - Your application is built on iOS 9.0 or above. Since Channelize SDK as of now only supports Version 9.0 or higher.
 - You have Xcode 9.4.1 or later as your IDE to install and run Channelize SDK on iOS.
 - Swift 4 / 4.1
 
**Pod Installation**

 - You need to install few dependancy pods just after you are done coyping SDK in you project otherwise the project will not compile.

```xml

  pod 'MQTTClient', '0.14.0'
  pod 'MQTTClient/Websocket'
  pod 'Alamofire', '4.7.3'
  pod 'AlamofireObjectMapper', '5.1.0'
  pod 'Gallery', '2.0.6'
  pod 'Lightbox', '2.1.2'
  pod 'SwiftIconFont', '2.8.0'
  pod 'CWStatusBarNotification', '2.3.5'
  pod 'GiphyCoreSDK', '1.2.0'
  pod 'Crashlytics', '3.10.7'
  pod 'Chatto',  :git => 'https://github.com/BigStepTechnologies/Chatto', :branch => 'bigstep/v1.0'
  pod 'ChattoAdditions',  :git => 'https://github.com/BigStepTechnologies/Chatto', :branch => 'bigstep/v1.0'
  pod 'InputBarAccessoryView', '2.2.2'
  pod 'SDWebImage/GIF'
  pod 'ZVProgressHUD', '2.0.0'
  pod 'ZVActivityIndicatorView', '0.1.2'
  pod 'AgoraRtcEngine_iOS', '2.3.1' 
  
```
 - Run `pod install` after setting up pods in your peoject.
 
 
 ## Configuration
 
  **Step 1** - Create a file with name PrimeMessenger-Info.plist file as mentioned in the demo project (Or you can copy the file fro the demo app too)-  [Config File](https://github.com/ChannelizeIO/Channelize-iOS/blob/master/demo/demo/PrimeMessenger-Info.plist)

  **Step 2** - Place all the required keys in the PrimeMessenger-info.plist file.
  
  **Step 3** - You also need to place the language string file with name PrimeLocalizable.strings. [Language File](https://github.com/ChannelizeIO/Channelize-iOS/blob/master/demo/demo/PrimeLocalizable.strings)
  
  **Step 4** - Make sure you have the follwoing permissions in your `Info.plist` file
  
  ```xml
<key>NSAppTransportSecurity</key>
	<dict>
		<key>NSAllowsArbitraryLoads</key>
		<true/>
	</dict>
	<key>NSCameraUsageDescription</key>
	<string>You can take photos to document your job.</string>
	<key>NSLocationAlwaysUsageDescription</key>
	<string>This app wants to access your location</string>
	<key>NSLocationWhenInUseUsageDescription</key>
	<string>This app wants to access your location</string>
	<key>NSPhotoLibraryUsageDescription</key>
	<string>You can select photos to attach to reports.</string>
	<key>NSMicrophoneUsageDescription</key>
	<string>Microphone to start a call</string>
	<key>UIBackgroundModes</key>
	<array>
		<string>voip</string>
	</array>
```
 
 ## Voip notification setup
 
 - You need to copy the [CallProvider](https://github.com/ChannelizeIO/Channelize-iOS/blob/master/demo/demo/CHCallProvider.swift) and paste it in your project directory 
 - Add the following code in you ```swift AppDelegate.swift``` file
 
 ```swift
 extension AppDelegate: PKPushRegistryDelegate {
    
    func pushRegistry(_ registry: PKPushRegistry, didUpdate credentials: PKPushCredentials, for type: PKPushType) {
        
        let deviceToken = credentials.token.reduce("", {$0 + String(format: "%02X", $1) })
        debugPrint("Voip Token - ",deviceToken)
        PrimeMessenger.updateVoipToken(token: deviceToken)
    }
    
    func pushRegistry(_ registry: PKPushRegistry, didReceiveIncomingPushWith payload: PKPushPayload, for type: PKPushType) {
        
        print("\(#function) incoming voip notfication: \(payload.dictionaryPayload)")
        if let callId = payload.dictionaryPayload["callId"] as? String,let uid = payload.dictionaryPayload["userId"] as? String {
            let uuid = UUID()
            let call = PMActiveCall(uuid: uuid, callId: callId, uid: uid)
            call.displayName = payload.dictionaryPayload["displayName"] as? String
            call.profileImageUrl = payload.dictionaryPayload["profileImageUrl"] as? String
            if let callType = payload.dictionaryPayload["type"] as? String,callType == "video" {
                call.type = .video
            }
            
            // display incoming call UI when receiving incoming voip notification
            let backgroundTaskIdentifier = UIApplication.shared.beginBackgroundTask(expirationHandler: nil)
            self.displayIncomingCall(call: call) { _ in
                UIApplication.shared.endBackgroundTask(backgroundTaskIdentifier)
            }
            
        }
    }
    
    func pushRegistry(_ registry: PKPushRegistry, didInvalidatePushTokenFor type: PKPushType) {
        print("\(#function) token invalidated")
    }
    
    // Display the incoming call to the user
    func displayIncomingCall(call: PMActiveCall, completion: ((NSError?) -> Void)? = nil) {
        callProvider?.reportIncomingCall(of: call)
    }
    
}
 ```
 - Create the following variables in your project's `AppDelegate.swift` file
 ```swift
    let pushRegistry = PKPushRegistry(queue: DispatchQueue.main)
    var callProvider: CHCallProvider?
 ```
 - Place the following code in ` didFinishLaunchingWithOptions ` function of your project's `AppDelegate.swift` file 
 ```swift
 
        pushRegistry.delegate = self
        pushRegistry.desiredPushTypes = [.voIP]
    
        callProvider = CHCallProvider()
        
 ```
