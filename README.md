The following documentation is built to help you with installing our iOS SDK into your project.	The following documentation is built to help you with installing our iOS SDK into your project.

The Channelize SDK can be installed using the following method	The Channelize SDK can be installed using the following method

Firstly, you will need to register on Channelize: https://channelize.io/pricing	Firstly, you will need to register on Channelize: https://channelize.io/pricing

 After the successful payment at https://channelize.io/pricing you'll get the zip file file that will contains the all messaging and other feature of channelize.io.	

- Extract Zip File
- You will get the `PrimeMessenger.framework` file.	
- Copy and paste it in your project directory.	
- Drag and drop it in the `Embedded Binaries` section of your project as described in the below image. 	

ScreenShot url:

https://github.com/ChannelizeIO/Channelize-iOS/blob/master/demo/Assests/framwork_placement.png	

## Dependencies	
**Requirement**	

 Before we begin, please do make sure that	

- Your application is built on iOS 9.0 or above. Since Channelize SDK as of now only supports Version 9.0 or higher.	
- You have Xcode 9.4.1 or later as your IDE to install and run Channelize SDK on iOS.	
- Swift 4.2	

 **Pod Installation**	

  - You need to install few dependancy pods just after you are done coyping SDK in you project otherwise the project will not compile.	
 ```xml	
  pod 'MQTTClient', '0.15.2'
    pod 'MQTTClient/Websocket', '0.15.2'
    pod 'Alamofire', '4.8.0'
    pod 'AlamofireObjectMapper', '5.2.0'
    pod 'Gallery' , '2.2.0'
    pod 'Hue' , '4.0.0'
    pod 'Lightbox', '2.3.0'
    pod 'SwiftIconFont', '3.0.0'
    pod 'ZVProgressHUD', '2.0.3'
    pod 'CWStatusBarNotification', '2.3.5'
    pod 'GiphyCoreSDK', '1.4.0'
    pod 'Chatto',  :git => 'https://github.com/BigStepTechnologies/Chatto', :branch => 'update/v1.0'
    pod 'ChattoAdditions',  :git => 'https://github.com/BigStepTechnologies/Chatto', :branch => 'update/v1.0'
    pod 'InputBarAccessoryView' , '4.2.1'
    pod 'SDWebImage/GIF', '4.4.3'
# this pod is required if you have video and voice call module enabled 	
  pod 'AgoraRtcEngine_iOS', '2.3.1' 	

 ```	
 - Run `pod install` after setting up pods in your peoject.	


  ## Configuration	

   **Step 1** - Create a file with name PrimeMessenger-Info.plist or download already created file from here [Config File](https://github.com/ChannelizeIO/Channelize-iOS/blob/master/demo/demo/PrimeMessenger-Info.plist)	

   **Step 2** - Place all the required keys in the PrimeMessenger-Info.plist file.	

   **Step 3** - You also need to create the language string file with name PrimeLocalizable.strings. [Language File](https://github.com/ChannelizeIO/Channelize-iOS/blob/master/demo/demo/PrimeLocalizable.strings)	

   **Step 4** - Make sure you have the following permissions in your `Info.plist` file	

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
 - Add the following code in your ` AppDelegate.swift ` file	
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

 ## Integration 	

 Here are the few steps that you need to follow for integrating Channelize with your application. It includes configuring & launching Channelize. 	

 **Configuring Channelize**	

  - To configure Channelize you need to add the following code in `didFinishLaunchingWithOptions` function of your project's `AppDelegate.swift` file 	

  ```swift	
 PrimeMessenger.configure()	
 ```	
 - To add theme color in Channelize sdk you need to add the following code in `didFinishLaunchingWithOptions` function of your project's `AppDelegate.swift` file 	

  ```swift	
 appDefaultColor = "YOUR_APP'S_THEME_COLOR"	
 ```	

  **Launching Channelize**	
  - You need to **login** first before launching channelize by adding the following code on login button action	
  ```swift	
  PrimeMessenger.app.login(username: email, password: password){(status) in	
    	if(status){	
		if let navigationController = UIApplication.shared.keyWindow?.rootViewController as? UINavigationController{	
	    	navigationController.setNavigationBarHidden(true, animated: false)	
	    	PrimeMessenger.app.openMessenger(navigationController: navigationController,	
					     data: nil)	
		}	
    	}	
   }	
			
  ```	
 - For **launching** channelize from your app you need to to call the following code for the action you want to launch Channelize on	

  ```swift	
 if(PrimeMessenger.currentUserId() != nil){	
    if let navigationController = UIApplication.shared.keyWindow?.rootViewController as? UINavigationController{	
	navigationController.setNavigationBarHidden(true, animated: false)	
	PrimeMessenger.app.openMessenger(navigationController: navigationController,	
					 data: nil)	
    }        	
  }	
 ```	

   - For performing **Logout** action you need to add the following code	
  ```swift	
  PrimeMessenger.logout()	
  ```	
 - For **launching Conversation Screen** for a **specific user** -	
  *User id should be integer	
 ```swift	
let data = [AnyHashable("userId"):"SPECIFIC_USER_ID"]	
if let navigationController = UIApplication.shared.keyWindow?.rootViewController as? UINavigationController{	
    PrimeMessenger.app.openMessenger(navigationController: navigationController, data:data)	
}	
 ```	
  - For setting up user online and offline 
```swift
PrimeMessenger.setUserOnline(completion: {(status,error) in
    if let returnedError = error{
        print(returnedError.localizedDescription)
        debugPrint("User status update operation Failed")
    } else if status != nil{
        debugPrint("User status update operation Complete")
    }
})
```
	
 ```swift	
PrimeMessenger.setUserOffline(completion: {(status,error) in
    if let returnedError = error{
        print(returnedError.localizedDescription)
        debugPrint("User status update operation Failed")
    } else if status != nil{
        debugPrint("User status update operation Complete")
    }
})
 ```	
 ## Note:-	
  - Voip integration required if in case client has Video and voice calls integrated.	
 - Voip permission in info.plist file required if in case client has Video and voice calls integrated.	
 - pod 'AgoraRtcEngine_iOS', '2.3.1' required if in case client has Video and voice calls integrated.
