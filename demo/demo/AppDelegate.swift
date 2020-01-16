//
//  AppDelegate.swift
//  demo
//
//  Created by Apple on 12/18/18.
//  Copyright © 2018 Channelize. All rights reserved.
//

import UIKit
import Channelize_API
import Channelize
import Channelize_Voice_Video
import CallKit
import PushKit
import Firebase
import FirebaseMessaging
import UserNotifications
import Intents
import AWSCore
import AWSIoT
import AWSMobileClient
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate  {
    
    
    var window: UIWindow?
    let pushRegistry = PKPushRegistry(queue: DispatchQueue.main)
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        
        if #available(iOS 10.0, *)
        {
            let center = UNUserNotificationCenter.current()
            center.delegate = self
            let types: UNAuthorizationOptions = [UNAuthorizationOptions.badge, UNAuthorizationOptions.alert, UNAuthorizationOptions.sound]
            center.requestAuthorization(options: types, completionHandler: { (granted, error) in
                //print(granted)
                if (granted){
                    DispatchQueue.main.async(execute: {
                        UIApplication.shared.registerForRemoteNotifications()
                    })
                }
            })
            
        }
        else
        {
            let types: UIUserNotificationType = [UIUserNotificationType.badge, UIUserNotificationType.alert, UIUserNotificationType.sound]
            let settings: UIUserNotificationSettings = UIUserNotificationSettings( types: types, categories: nil )
            application.registerUserNotificationSettings( settings )
            application.registerForRemoteNotifications()
            // Fallback on earlier versions
        }
        
        
        let rootController = LoginViewController()
        
        let navigationController = UINavigationController(rootViewController: rootController)
        window =  UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = navigationController
        appDefaultColor = defaultColor
        //ThemeManager.applyTheme(theme: .normal)
        
        let sharedApplication = UIApplication.shared
        sharedApplication.delegate?.window??.tintColor = defaultColor
        UINavigationBar.appearance().barStyle = .black
        
        UINavigationBar.appearance().barTintColor = defaultColor
        UINavigationBar.appearance().tintColor = .white
        UITabBar.appearance().tintColor = defaultColor
        UITabBar.appearance().barTintColor = defaultColor
        
        self.window?.makeKeyAndVisible()
        
        FirebaseApp.configure()
        //Fabric.sharedSDK().debug = true
        Messaging.messaging().delegate = self
        Channelize.configure()
        //CustomUi.setUpUIVariables()
        CHCustomOptions.enableCallModule = true
        if CHCustomOptions.enableCallModule{
            if let callClass = stringClassFromString("ChVoiceVideo"){
                //let obj = callClass.init()
                if let callMainClass = callClass as? CallSDKDelegates.Type{
                    callMainClass.configureVoiceVideo()
                }
            }
        }
        let config = Realm.Configuration(
            schemaVersion: 2,
            migrationBlock: { migration, oldSchemaVersion in
                if (oldSchemaVersion < 1) {
                    // Nothing to do!
                    // Realm will automatically detect new properties and removed properties
                    // And will update the schema on disk automatically
                }
        })
        Realm.Configuration.defaultConfiguration = config
        AllMembers.initializeRealm()
        AllConversations.initializeRealm()
        pushRegistry.delegate = self
        pushRegistry.desiredPushTypes = [.voIP]
        
        return true
    }
    
    
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
        Channelize.setUserOffline(completion: {(status,error) in
            
        })
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        Channelize.setUserOffline(completion: {(status,error) in
            
        })
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
        Channelize.setUserOnline(completion: {(status,error) in
            
        })
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        Channelize.setUserOnline(completion: {(status,error) in
            
        })
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func stringClassFromString(_ className: String) -> AnyClass? {
        
        //let bundlePath = Bundle.main.path(forResource: "Channelize_Voice_Video", ofType: "bundle")
        //let resourcePath = Bundle.init(path: bundlePath!)
        
        let bundleUrl = Bundle.url(forResource: "Channelize_Voice_Video", withExtension: "framework", subdirectory: "Frameworks", in: Bundle.main.bundleURL)
        let bundle = Bundle(url: bundleUrl!)
        bundle?.load()
        let aClass : AnyClass? = NSClassFromString("Channelize_Voice_Video.ChVoiceVideo")
        
        return aClass
    }
    
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        //Handle the notification
        if CHMain.instance.currentChatIdUserName.lowercased() == notification.request.content.title.lowercased(){
            
        } else{
            completionHandler([.alert,.badge,.sound])
        }
        
    }
    
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        //Handle the notification
        if userInfo["isMessenger"] != nil{
            openPrimeMessenger(contentInfo: userInfo)
        }
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        if application.applicationState != UIApplication.State.background{
            if userInfo["isMessenger"] != nil{
                openPrimeMessenger(contentInfo: userInfo)
            }
        }
    }
    
    func openPrimeMessenger(contentInfo: [AnyHashable : Any]){
        if let recipient = contentInfo["recipient"]{
            if let jsonData = (recipient as! String).data(using: .utf8){
                if let data = try? JSONSerialization.jsonObject(with: jsonData, options:    []) as! [String:Any]{
                    if(data["recipientId"] as! String == Channelize.currentUserId()!){
                        if let navigationController = UIApplication.shared.keyWindow?.rootViewController as? UINavigationController{
                            CHMain.launchApp(navigationController: navigationController, data: contentInfo)
                        }
                    }
                }
            }
        }
    }
    
    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
        
        guard let interaction = userActivity.interaction else {
            return false
        }
        
        var userId: String?
        if let callIntent = interaction.intent as? INStartVideoCallIntent {
            userId = callIntent.contacts?.first?.personHandle?.value
        } else if let callIntent = interaction.intent as? INStartAudioCallIntent {
            userId = callIntent.contacts?.first?.personHandle?.value
        }
        if let id = userId {
            debugPrint("User Id get called - ",id)
        }
        return true
    }
    
}

extension AppDelegate : MessagingDelegate {
    // [START refresh_token]
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        print("Firebase registration token: \(fcmToken)")
        Channelize.updateToken(token: fcmToken)
        let dataDict:[String: String] = ["token": fcmToken]
        NotificationCenter.default.post(name: Notification.Name("FCMToken"), object: nil, userInfo: dataDict)
    }
    // [END refresh_token]
    
    // [START ios_10_data_message]
    // Receive data messages on iOS 10+ directly from FCM (bypassing APNs) when the app is in the foreground.
    // To enable direct data messages, you can set Messaging.messaging().shouldEstablishDirectChannel to true.
    func messaging(_ messaging: Messaging, didReceive remoteMessage: MessagingRemoteMessage) {
        print("Received data message: \(remoteMessage.appData)")
    }
}

extension AppDelegate : PKPushRegistryDelegate{
    func pushRegistry(_ registry: PKPushRegistry, didUpdate pushCredentials: PKPushCredentials, for type: PKPushType) {
        let deviceToken = pushCredentials.token.reduce("", {$0 + String(format: "%02X", $1) })
        debugPrint("Token recieved - ",deviceToken)
        debugPrint("Device Id - ",UIDevice.current.identifierForVendor!.uuidString)
        //VSDK Changes
        Channelize.updateVoipToken(token: deviceToken)
    }
    
    func pushRegistry(_ registry: PKPushRegistry, didReceiveIncomingPushWith payload: PKPushPayload, for type: PKPushType) {
        print("VOIP Notification Recieved")
        print("PayLoad Dictionary is \(payload.dictionaryPayload)")
        
        if let callTopic = payload.dictionaryPayload["topic"] as? String{
            if (payload.dictionaryPayload["userId"] as? String) != nil{
                if callTopic.contains("/reject"){
                    ChVoiceVideo.performOutGoingCallRejected(callTopic: callTopic)
                    return
                } else if callTopic.contains("/end"){
                    ChVoiceVideo.performOnGoingCallEnded(callTopic:callTopic)
                    return
                } else if callTopic.contains("/received"){
                    ChVoiceVideo.postCallRecievedNotification(callTopic:callTopic)
                    return
                } else if callTopic.contains("/accept"){
                    ChVoiceVideo.postCallAcceptedNotification(callTopic:callTopic)
                    return
                }
            }
        }
        
        
        
        if let callId = payload.dictionaryPayload["callId"] as? String{
            if let uid = payload.dictionaryPayload["userId"] as? String{
                if let uuidString = payload.dictionaryPayload["uuid"] as? String{
                    if let uuid = UUID(uuidString: uuidString){
                        let call = CHActiveCall(uuid: uuid, callId: callId, uid: uid, isOutgoing: false)
                        call.displayName = payload.dictionaryPayload["displayName"] as? String
                        call.profileImageUrl = payload.dictionaryPayload["profileImageUrl"] as? String
                        if let callType = payload.dictionaryPayload["type"] as? String{
                            if callType == "video"{
                                call.type = .video
                            }
                        }
                        let backgroundTaskIdentifier = UIApplication.shared.beginBackgroundTask(expirationHandler: nil)
                        if CHCustomOptions.enableCallModule{
                            ChVoiceVideo.showIncomingCall(call: call, completion: {_ in
                                UIApplication.shared.endBackgroundTask(backgroundTaskIdentifier)
                            })
                        }
                    }
                }
            }
        }
    }
    
    func pushRegistry(_ registry: PKPushRegistry, didInvalidatePushTokenFor type: PKPushType) {
        print("\(#function) token invalidated")
    }
}
