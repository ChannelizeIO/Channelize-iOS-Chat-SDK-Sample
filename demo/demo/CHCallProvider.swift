//
//  CHCallProvider.swift
//  Demo
//
//  Created by Ashish on 21/11/18.
//  Copyright © 2018 bigstep. All rights reserved.
//

import Foundation
import UIKit
import CallKit
import AVFoundation
import PrimeMessenger


@available(iOS 10.0, *)
class CHCallProvider: NSObject {
    
    private var session:PMCallSession?
    fileprivate let controller = CXCallController()
    private let provider = CXProvider(configuration: CHCallProvider.providerConfiguration)
    
    private static var providerConfiguration: CXProviderConfiguration {
        let appName = Bundle.main.infoDictionary?["CFBundleDisplayName"] ?? ""
        let providerConfiguration = CXProviderConfiguration(localizedName: appName as! String)
        providerConfiguration.supportsVideo = true
        providerConfiguration.maximumCallsPerCallGroup = 1
        providerConfiguration.maximumCallGroups = 1
        providerConfiguration.supportedHandleTypes = [.generic]
        
        if let iconMaskImage = UIImage(named: "logo") {
            providerConfiguration.iconTemplateImageData = UIImagePNGRepresentation(iconMaskImage)
        }
        
        return providerConfiguration
    }
    
    fileprivate var sessionPool = [String: PMActiveCall]()
    
    override init() {
        super.init()
        self.session = PMCallSession(apiKey: "channelizecall", delegate: self)
        provider.setDelegate(self, queue: nil)
    }
    
    deinit {
        provider.invalidate()
    }
    
    func activeCall()->PMActiveCall?{
        return self.session?.currentSession()
    }
    
    func reportIncomingCall(of session: PMActiveCall){
        if let activeCall = activeCall(){
            if activeCall.callId != session.callId{
                self.session?.newCallReceived(session,isBusy: true)
            }
        }else{
            self.session?.newCallReceived(session)
            showIncomingCall(of: session)
        }
    }
    
    func showIncomingCall(of session: PMActiveCall) {
        let callUpdate = CXCallUpdate()
        callUpdate.remoteHandle = CXHandle(type: .generic, value: session.userId)
        callUpdate.localizedCallerName = session.displayName?.capitalized
        callUpdate.hasVideo = (session.type == .video)
        callUpdate.supportsDTMF = false

        let uuid = pairedUUID(of: session)

        provider.reportNewIncomingCall(with: uuid, update: callUpdate, completion: { error in
            if let error = error {
                debugPrint("reportNewIncomingCall error: \(error.localizedDescription)")
            }else{
                debugPrint("Call started")
            }
        })
    }

    func startOutgoingCall(of session: PMActiveCall) {
        let handle = CXHandle(type: .generic, value: session.userId)
        let uuid = pairedUUID(of: session)
        let startCallAction = CXStartCallAction(call: uuid, handle: handle)
        startCallAction.isVideo = (session.type == .video)
        let transaction = CXTransaction(action: startCallAction)
        controller.request(transaction) { (error) in
            if let error = error {
                print("startOutgoingSession failed: \(error.localizedDescription)")
            }
        }
    }

    func setCallConnected(of session: PMActiveCall) {
        let uuid = pairedUUID(of: session)
        if let call = currentCall(of: uuid), call.isOutgoing, !call.hasConnected, !call.hasEnded {
            provider.reportOutgoingCall(with: uuid, connectedAt: nil)
        }
    }

    func muteAudio(of session: PMActiveCall, muted: Bool) {
        let muteCallAction = CXSetMutedCallAction(call: pairedUUID(of: session), muted: muted)
        let transaction = CXTransaction(action: muteCallAction)
        controller.request(transaction) { (error) in
            if let error = error {
                print("muteSession \(muted) failed: \(error.localizedDescription)")
            }
        }
    }

    func endCall(of session: PMActiveCall) {
        let endCallAction = CXEndCallAction(call: pairedUUID(of: session))
        let transaction = CXTransaction(action: endCallAction)
        controller.request(transaction) { error in
            if let error = error {
                print("endSession failed: \(error.localizedDescription)")
            }
        }
    }
}

@available(iOS 10.0, *)
extension CHCallProvider: CXProviderDelegate {
    func providerDidReset(_ provider: CXProvider) {
        sessionPool.removeAll()
        debugPrint("provider did reset")
    }
    
    func provider(_ provider: CXProvider, perform action: CXStartCallAction) {
        guard let session = pairedSession(of:action.callUUID) else {
            action.fail()
            return
        }
        let callUpdate = CXCallUpdate()
        callUpdate.remoteHandle = action.handle
        callUpdate.hasVideo = (session.type == .video)
        callUpdate.localizedCallerName = session.displayName?.capitalized
        callUpdate.supportsDTMF = false
        provider.reportCall(with: action.callUUID, updated: callUpdate)
        debugPrint("Start call action")
        //self.session?.startSession(session)
        action.fulfill()
    }
    
    func provider(_ provider: CXProvider, perform action: CXSetMutedCallAction) {
        guard let session = pairedSession(of:action.callUUID) else {
            action.fail()
            return
        }
        debugPrint("mute call action - ")
        self.session?.muteAudio(of: session, action.isMuted)

        action.fulfill()
    }
    
    func provider(_ provider: CXProvider, perform action: CXAnswerCallAction) {
        guard let session = pairedSession(of:action.callUUID) else {
            action.fail()
            return
        }
        self.session?.startSession(session)
        debugPrint("answered call action - ",session)
        action.fulfill()
    }
    
    func provider(_ provider: CXProvider, perform action: CXEndCallAction) {
        guard let session = pairedSession(of:action.callUUID) else {
            action.fail()
            return
        }
        debugPrint("end call sction - ",session)
        if let call = currentCall(of: action.callUUID) {
            if call.isOutgoing || call.hasConnected {
                self.session?.endCall(session, declined: false)
            } else {
                self.session?.endCall(session, declined: true)
            }
        }

        sessionPool.removeAll()
        action.fulfill()
    }
    
    func provider(_ provider: CXProvider, perform action: CXSetHeldCallAction) {
        guard let session = pairedSession(of:action.callUUID) else {
            action.fail()
            return
        }
        self.session?.endCall(session, declined: false)
        sessionPool.removeAll()
        action.fulfill()
        
    }
    func provider(_ provider: CXProvider, didActivate audioSession: AVAudioSession) {
        debugPrint("did audio session activated")
        //delegate?.callCenterDidActiveAudioSession(self)
    }
    
    func provider(_ provider: CXProvider, didDeactivate audioSession: AVAudioSession) {
        debugPrint("did audio session deactivated")
    }
    func provider(_ provider: CXProvider, timedOutPerforming action: CXAction) {
        guard let session = pairedSession(of:action.uuid) else {
            action.fail()
            return
        }
        self.session?.endCall(session, declined: false)
        sessionPool.removeAll()
        action.fulfill()
    }
}

@available(iOS 10.0, *)
extension CHCallProvider {
    func pairedUUID(of session: PMActiveCall) -> UUID {
        if let uuid = sessionPool[session.callId]?.uuid {
            return uuid
        }
        sessionPool[session.callId] = session
        return session.uuid
    }

    func pairedSession(of uuId: UUID) -> PMActiveCall? {
        for session in sessionPool.values {
            if session.uuid == uuId {
                return session
            }
        }
        return nil
    }
    
    func pairedSession(of callId: String) -> PMActiveCall? {
        return sessionPool[callId]
    }
    
    func currentCall(of uuid: UUID) -> CXCall? {
        let calls = controller.callObserver.calls
        if let index = calls.index(where: {$0.uuid == uuid}) {
            return calls[index]
        } else {
            return nil
        }
    }
}

extension CHCallProvider:PMCallSessionDelegate{
    
    func didCallConnected(with call: PMActiveCall) {
        self.setCallConnected(of: call)
    }
    
    func didAudioMuted(with call:PMActiveCall) {
        //self.muteAudio(of: call, muted: call.hasMuted ?? false)
    }
    
    func didEndCall(with call:PMActiveCall){
        self.endCall(of: call)
    }
    
    func didStartNewCall(with call:PMActiveCall){
        self.startOutgoingCall(of: call)
    }
}
