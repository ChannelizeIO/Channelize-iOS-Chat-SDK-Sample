//
//  GPHChannel.swift
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

/// Represents Giphy A Channel Tag Object
///
@objcMembers public class GPHChannelTag: GPHFilterable, NSCoding {
    // MARK: Properties
    
    /// ID of this Channel.
    public fileprivate(set) var id: Int?
    
    /// Slug of the Channel.
    public fileprivate(set) var channel: Int?
    
    /// Display name of the Channel.
    public fileprivate(set) var tag: String?
    
    /// Shortd display name of the Channel.
    public fileprivate(set) var rank: Int?
    
    /// JSON Representation.
    public fileprivate(set) var jsonRepresentation: GPHJSONObject?
    
    /// User Dictionary to Store data in Obj by the Developer
    public var userDictionary: [String: Any]?
    
    //MARK: NSCoding

    required convenience public init?(coder aDecoder: NSCoder) {
        self.init()
        
        self.id = aDecoder.decodeObject(forKey: "id") as? Int
        self.channel = aDecoder.decodeObject(forKey: "channel") as? Int
        self.tag = aDecoder.decodeObject(forKey: "tag") as? String
        self.rank = aDecoder.decodeObject(forKey: "rank") as? Int
        self.jsonRepresentation = aDecoder.decodeObject(forKey: "jsonRepresentation") as? GPHJSONObject
        self.userDictionary = aDecoder.decodeObject(forKey: "userDictionary") as? [String: Any]
    }
    
    public func encode(with aCoder: NSCoder) {
        aCoder.encode(self.id, forKey: "id")
        aCoder.encode(self.channel, forKey: "channel")
        aCoder.encode(self.tag, forKey: "tag")
        aCoder.encode(self.rank, forKey: "rank")
        aCoder.encode(self.jsonRepresentation, forKey: "jsonRepresentation")
        aCoder.encode(self.userDictionary, forKey: "userDictionary")
    }
    
    
    // MARK: NSObject
    
    override public func isEqual(_ object: Any?) -> Bool {
        if object as? GPHChannel === self {
            return true
        }
        if let other = object as? GPHChannel, self.id == other.id {
            return true
        }
        return false
    }
    
    override public var hash: Int {
        return "gph_channel_tag_\(self.id ?? 0)".hashValue
    }
    
}

/// Make objects human readable.
///
extension GPHChannelTag {
    
    override public var description: String {
        return "GPHChannelTag(\(self.tag ?? "unknown"))"
    }
    
}

extension GPHChannelTag: GPHMappable {

    /// This is where the magic/mapping happens + error handling.
    public static func mapData(_ data: GPHJSONObject, options: [String: Any?]) throws -> GPHChannelTag {
        
        let obj = GPHChannelTag()
        
        obj.id = (data["id"] as? Int)
        obj.channel = (data["channel"] as? Int)
        obj.tag = (data["tag"] as? String)
        obj.rank = (data["rank"] as? Int)
        
        obj.jsonRepresentation = data
        
        return obj
    }
    
}
