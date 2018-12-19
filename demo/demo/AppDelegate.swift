//
//  AppDelegate.swift
//  demo
//
//  Created by Apple on 12/18/18.
//  Copyright © 2018 Channelize. All rights reserved.
//

import UIKit
import Intents
import PushKit
import PrimeMessenger

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    
    var window: UIWindow?
    let pushRegistry = PKPushRegistry(queue: DispatchQueue.main)
    var callProvider: CHCallProvider?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = mainStoryboard.instantiateViewController(withIdentifier: "PMMain")
        let navigationController = UINavigationController(rootViewController: viewController)
        window =  UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = navigationController
        PrimeMessenger.configure()
        appDefaultColor = defaultColor
        ThemeManager.applyTheme(theme: .normal)
        self.window?.makeKeyAndVisible()
        
        
        pushRegistry.delegate = self
        pushRegistry.desiredPushTypes = [.voIP]
        
        callProvider = CHCallProvider()
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func application(_ application: UIApplication, continue userActivity: NSUserActivity,
                     restorationHandler: @escaping ([Any]?) -> Void) -> Bool {
        
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
