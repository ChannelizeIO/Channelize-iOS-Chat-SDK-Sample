//
//  GPHMediaResponse.swift
//  GiphyCoreSDK
//
//  Created by Cem Kozinoglu, Gene Goykhman, Giorgia Marenda on 4/24/17.
//  Copyright © 2017 Giphy. All rights reserved.
//
//  This Source Code Form is subject to the terms of the Mozilla Public
//  License, v. 2.0. If a copy of the MPL was not distributed with this
//  file, You can obtain one at http://mozilla.org/MPL/2.0/.
//

import Foundation

/// Represents a Giphy Media Response (single result)
///
@objcMembers public class GPHMediaResponse: GPHResponse {
    // MARK: Properties

    /// Message description.
    public fileprivate(set) var data: GPHMedia?
    
    
    // MARK: Initializers
    
    /// Convenience Initializer
    ///
    /// - parameter meta: init with a GPHMeta object.
    /// - parameter data: GPHMedia object (optional).
    ///
    convenience public init(_ meta:GPHMeta, data: GPHMedia?) {
        self.init()
        self.data = data
        self.meta = meta
    }
    
}

// MARK: Extension -- Human readable

/// Make objects human readable.
///
extension GPHMediaResponse {
    
    override public var description: String {
        return "GPHMediaResponse(\(self.meta.responseId) status: \(self.meta.status) msg: \(self.meta.msg))"
    }
    
}

// MARK: Extension -- Parsing & Mapping

/// For parsing/mapping protocol.
///
extension GPHMediaResponse: GPHMappable {
    
    /// this is where the magic will happen + error handling
    public static func mapData(_ data: GPHJSONObject, options: [String: Any?]) throws -> GPHMediaResponse {
        
        guard
            let metaData = data["meta"] as? GPHJSONObject
            else {
                throw GPHJSONMappingError(description: "Couldn't map GPHMediaResponse due to Meta missing for \(data)")
        }
        
        let meta = try GPHMeta.mapData(metaData, options: options)
        
        // Try to see if we can get the Media object
        if let mediaData = data["data"] as? GPHJSONObject {
            
            let data = try GPHMedia.mapData(mediaData, options: options)
            if data.isValidObject() {
                // We got the image and the meta data
                return GPHMediaResponse(meta, data: data)
            }
            return GPHMediaResponse(meta, data: nil)
        }
        
        // No image and the meta data
        return GPHMediaResponse(meta, data: nil)
    }
    
}
