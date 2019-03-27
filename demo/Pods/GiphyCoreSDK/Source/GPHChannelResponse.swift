//
//  GPHChannelResponse.swift
//  GiphyCoreSDK
//
//  Created by Cem Kozinoglu, Gene Goykhman, Giorgia Marenda, David Hargat on 4/24/17.
//  Copyright © 2017 Giphy. All rights reserved.
//
//  This Source Code Form is subject to the terms of the Mozilla Public
//  License, v. 2.0. If a copy of the MPL was not distributed with this
//  file, You can obtain one at http://mozilla.org/MPL/2.0/.
//

import Foundation

/// Represents a Giphy List Channel Response (multiple results)
///
@objcMembers public class GPHChannelResponse: GPHResponse {
    // MARK: Properties
    
    /// Channel object.
    public fileprivate(set) var data: GPHChannel?
    
    // MARK: Initializers
    
    /// Convenience Initializer
    ///
    /// - parameter meta: init with a GPHMeta object.
    /// - parameter data: GPHChannel object.
    ///
    convenience public init(_ meta: GPHMeta, data: GPHChannel?) {
        self.init()
        self.data = data
        self.meta = meta
    }
}

// MARK: Extension -- Human readable

/// Make objects human readable.
///
extension GPHChannelResponse {
    
    override public var description: String {
        return "GPHChannelResponse(\(self.meta.responseId) status: \(self.meta.status) msg: \(self.meta.msg))"
    }
    
}

// MARK: Extension -- Parsing & Mapping
extension GPHChannelResponse: GPHMappable {
    
    public static func mapData(_ data: GPHJSONObject, options: [String: Any?]) throws -> GPHChannelResponse {
        
        guard
            let metaData = data["meta"] as? GPHJSONObject
        else {
            throw GPHJSONMappingError(description: "Couldn't map GPHChannel due to missing 'meta' field: \(data)")
        }
        
        guard
            let channelData = data["data"] as? GPHJSONObject
        else {
            throw GPHJSONMappingError(description: "Couldn't map GPHChannel due to missing 'data' field: \(data)")
        }
        
        let meta = try GPHMeta.mapData(metaData, options: options)
        let channel = try GPHChannel.mapData(channelData, options: options)

        if channel.isValidObject() {
            return GPHChannelResponse(meta, data: channel)
        }
        return GPHChannelResponse(meta, data: nil)
    }
    
}
