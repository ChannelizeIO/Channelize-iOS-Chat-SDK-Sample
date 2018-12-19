//
//  AudioMessageModel.swift
//  ChattoAdditions
//
//  Created by Ashish on 12/09/18.
//  Copyright © 2018 Badoo. All rights reserved.
//

import Foundation

public protocol AudioMessageModelProtocol:DecoratedMessageModelProtocol{
    var duration:String? { get }
}

open class AudioMessageModel<MessageModelT: MessageModelProtocol>: AudioMessageModelProtocol {
    public var messageModel: MessageModelProtocol {
        return self._messageModel
    }
    public let _messageModel: MessageModelT // Can't make messasgeModel: MessageModelT: https://gist.github.com/diegosanchezr/5a66c7af862e1117b556
    public var duration:String?
    
    public init(messageModel: MessageModelT, duration:String? = nil) {
        self._messageModel = messageModel
        self.duration = duration
    }
}

