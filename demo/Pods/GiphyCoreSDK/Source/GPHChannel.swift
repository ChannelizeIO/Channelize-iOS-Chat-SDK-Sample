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

/// Represents Giphy Channels
///
@objcMembers public class GPHChannel: GPHFilterable, NSCoding {
    // MARK: Properties
    
    // Stickers Packs Channel Root ID
    public static let StickersRootId = 3143
    
    /// ID of this Channel.
    public fileprivate(set) var id: Int = 0
    
    /// Slug of the Channel.
    public fileprivate(set) var slug: String?
    
    /// Display name of the Channel.
    public fileprivate(set) var displayName: String?
    
    /// Shortd display name of the Channel.
    public fileprivate(set) var shortDisplayName: String?

    /// Type for this Channel.
    public fileprivate(set) var type: String?
    
    /// Content Type (Gif or Sticker) of the Channel
    public fileprivate(set) var contentType: String?
    
    /// Description of the Channel.
    public fileprivate(set) var descriptionText: String?
    
    /// Banner Image of the Channel.
    public fileprivate(set) var bannerImage: String?
    
    /// [optional] The featured gif for the pack itself.
    public fileprivate(set) var featuredGif: GPHMedia?
    
    /// User who owns this Channel.
    public fileprivate(set) var user: GPHUser?
    
    /// A list of tags for this Channel.
    public fileprivate(set) var tags: Array<GPHChannelTag>?
    
    /// A list of direct ancestors of this Channel.
    public fileprivate(set) var ancestors: Array<GPHChannel> = []
    
    /// JSON Representation.
    public fileprivate(set) var jsonRepresentation: GPHJSONObject?
    
    /// User Dictionary to Store data in Obj by the Developer
    public var userDictionary: [String: Any]?
    
    /// Convenience Initializer
    ///
    /// - parameter id: ID of the Channel.
    ///
    convenience public init(_ id: Int) {
        self.init()
        self.id = id
    }
    
    //MARK: NSCoding
    
    required convenience public init?(coder aDecoder: NSCoder) {
        guard
            let id = aDecoder.decodeObject(forKey: "id") as? Int
            else {
                return nil
        }
        
        self.init(id)
        
        self.slug = aDecoder.decodeObject(forKey: "slug") as? String
        self.type = aDecoder.decodeObject(forKey: "type") as? String
        self.contentType = aDecoder.decodeObject(forKey: "content_type") as? String
        self.bannerImage = aDecoder.decodeObject(forKey: "banner_image") as? String
        self.displayName = aDecoder.decodeObject(forKey: "display_name") as? String
        self.shortDisplayName = aDecoder.decodeObject(forKey: "short_display_name") as? String
        self.descriptionText = aDecoder.decodeObject(forKey: "description") as? String
        self.user = aDecoder.decodeObject(forKey: "user") as? GPHUser
        self.featuredGif = aDecoder.decodeObject(forKey: "featured_gif") as? GPHMedia ?? nil
        self.tags = aDecoder.decodeObject(forKey: "tags") as? Array<GPHChannelTag> ?? []
        self.ancestors = aDecoder.decodeObject(forKey: "ancestors") as? Array<GPHChannel> ?? []
        self.jsonRepresentation = aDecoder.decodeObject(forKey: "jsonRepresentation") as? GPHJSONObject
        self.userDictionary = aDecoder.decodeObject(forKey: "userDictionary") as? [String: Any]
    }
    
    public func encode(with aCoder: NSCoder) {
        aCoder.encode(self.id, forKey: "id")
        aCoder.encode(self.slug, forKey: "slug")
        aCoder.encode(self.type, forKey: "type")
        aCoder.encode(self.bannerImage, forKey: "banner_image")
        aCoder.encode(self.contentType, forKey: "content_type")
        aCoder.encode(self.displayName, forKey: "display_name")
        aCoder.encode(self.descriptionText, forKey: "description")
        aCoder.encode(self.shortDisplayName, forKey: "short_display_name")
        aCoder.encode(self.user, forKey: "user")
        aCoder.encode(self.tags, forKey: "tags")
        aCoder.encode(self.ancestors, forKey: "ancestors")
        aCoder.encode(self.featuredGif, forKey: "featured_gif")
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
        return "gph_channel_\(self.id)".hashValue
    }
    
    
}

/// Make objects human readable.
///
extension GPHChannel {
    
    override public var description: String {
        return "GPHChannel(\(self.displayName ?? "unknown")) id: \(self.id)"
    }
    
}

extension GPHChannel: GPHMappable {
    
    /// This is where the magic/mapping happens + error handling.
    public static func mapData(_ data: GPHJSONObject, options: [String: Any?]) throws -> GPHChannel {
        guard
            let objId: Int = data["id"] as? Int
            else {
                throw GPHJSONMappingError(description: "Couldn't map GPHChannel due to missing 'id' field \(data)")
        }
        
        let obj = GPHChannel()
        
        // These fields are OPTIONAL in the sense that we won't `throw` if they're missing
        // (though we might want to reconsider some of them).
        obj.id = objId
        obj.slug = (data["slug"] as? String)
        obj.displayName = (data["display_name"] as? String)
        obj.shortDisplayName = (data["short_display_name"] as? String)
        obj.type = (data["type"] as? String)
        obj.contentType = (data["content_type"] as? String)
        obj.descriptionText = (data["description"] as? String)
        obj.bannerImage = (data["banner_image"] as? String)
        obj.tags = (data["tags"] as? [GPHChannelTag])
        
        obj.jsonRepresentation = data
        
        if let imageData = data["featured_gif"] as? GPHJSONObject {
            obj.featuredGif = try GPHMedia.mapData(imageData, options: options)
        }
        
        // Handle User Data
        if let userData = data["user"] as? GPHJSONObject {
            obj.user = try GPHUser.mapData(userData, options: options)
        }
        
        if let ancestors = data["ancestors"] as? [GPHJSONObject] {
            for ancestor in ancestors {
                let ancestor = try GPHChannel.mapData(ancestor, options: options)
                obj.ancestors.append(ancestor)
            }
        }
        
        return obj
    }
    
}
