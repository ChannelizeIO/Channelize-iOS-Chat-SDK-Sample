//
//  GPHMedia.swift
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

/// Represents a Giphy Media Object
///
@objcMembers public class GPHMedia: GPHFilterable, NSCoding {
    // MARK: Properties
    
    /// ID of the Object.
    public fileprivate(set) var id: String = ""
    
    /// Media Type (GIF|Sticker).
    public fileprivate(set) var type: GPHMediaType = .gif
    
    /// URL of the GIF/Sticker.
    public fileprivate(set) var url: String = ""
    
    /// Content Rating (Default G).
    public fileprivate(set) var rating: GPHRatingType = .unrated
    
    /// Title.
    public fileprivate(set) var title: String?
    
    /// Caption.
    public fileprivate(set) var caption: String?
    
    /// URL Slug.
    public fileprivate(set) var slug: String?
    
    /// Indexable or Not.
    public fileprivate(set) var indexable: String?
    
    /// Content.
    public fileprivate(set) var contentUrl: String?
    
    /// Bitly Short URL.
    public fileprivate(set) var bitlyUrl: String?
    
    /// Bitly Short URL for GIF.
    public fileprivate(set) var bitlyGifUrl: String?
    
    /// Embed URL.
    public fileprivate(set) var embedUrl: String?
    
    /// Attribution Source.
    public fileprivate(set) var source: String?
    
    /// Attribution Source Domain TLD.
    public fileprivate(set) var sourceTld: String?
    
    /// Attribution Source Post URL.
    public fileprivate(set) var sourcePostUrl: String?
    
    /// Atrribution / User.
    public fileprivate(set) var user: GPHUser?
    
    /// Renditions of the Media Object.
    public fileprivate(set) var images: GPHImages?
    
    /// Bottle Data.
    public fileprivate(set) var bottleData: GPHBottleData?
    
    /// Tags representing the Media Object.
    public fileprivate(set) var tags: [String]?
    
    /// Featured Tags.
    public fileprivate(set) var featuredTags: [String]?
    
    /// Import Date/Time.
    public fileprivate(set) var importDate: Date?
    
    /// Creation Date/Time.
    public fileprivate(set) var createDate: Date?
    
    /// Last Update Date/Time.
    public fileprivate(set) var updateDate: Date?
    
    /// Trending Date/Time.
    public fileprivate(set) var trendingDate: Date?
    
    // NOTE: Categories endpoint.
    // Example: http://api.giphy.com/v1/gifs/categories/actions?api_key=4OMJYpPoYwVpe
    public fileprivate(set) var isHidden: Bool = false
    public fileprivate(set) var isRemoved: Bool = false
    public fileprivate(set) var isCommunity: Bool = false
    public fileprivate(set) var isAnonymous: Bool = false
    public fileprivate(set) var isFeatured: Bool = false
    public fileprivate(set) var isRealtime: Bool = false
    public fileprivate(set) var isIndexable: Bool = false
    public fileprivate(set) var isSticker: Bool = false
    
    /// JSON Representation.
    public fileprivate(set) var jsonRepresentation: GPHJSONObject?
    
    /// User Dictionary to Store data in Obj by the Developer
    public var userDictionary: [String: Any]?
    
    /// Convenience Initializer
    ///
    /// - parameter id: Media Object ID.
    /// - parameter type: Media Type (GIF/Sticker).
    /// - parameter url: URL of the Media Object.
    ///
    convenience public init(_ id: String, type: GPHMediaType, url: String) {
        self.init()
        self.id = id
        self.type = type
        self.url = url
    }
    
    //MARK: NSCoding
    
    required public convenience init?(coder aDecoder: NSCoder) {
        guard let id = aDecoder.decodeObject(forKey: "id") as? String,
            let type = GPHMediaType(rawValue: aDecoder.decodeObject(forKey: "type") as! String),
            let url = aDecoder.decodeObject(forKey: "url") as? String
            else { return nil }
        
        self.init(id, type: type, url: url)
        
        self.rating = GPHRatingType(rawValue: aDecoder.decodeObject(forKey: "rating") as? String ?? "") ?? .unrated
        self.title = aDecoder.decodeObject(forKey: "title") as? String
        self.caption = aDecoder.decodeObject(forKey: "caption") as? String
        self.slug = aDecoder.decodeObject(forKey: "slug") as? String
        self.importDate = aDecoder.decodeObject(forKey: "importDate") as? Date
        self.trendingDate = aDecoder.decodeObject(forKey: "trendingDate") as? Date
        self.indexable = aDecoder.decodeObject(forKey: "indexable") as? String
        self.contentUrl = aDecoder.decodeObject(forKey: "contentUrl") as? String
        self.bitlyUrl = aDecoder.decodeObject(forKey: "bitlyUrl") as? String
        self.bitlyGifUrl = aDecoder.decodeObject(forKey: "bitlyGifUrl") as? String
        self.embedUrl = aDecoder.decodeObject(forKey: "embedUrl") as? String
        self.source = aDecoder.decodeObject(forKey: "source") as? String
        self.sourceTld = aDecoder.decodeObject(forKey: "sourceTld") as? String
        self.sourcePostUrl = aDecoder.decodeObject(forKey: "sourcePostUrl") as? String
        self.user = aDecoder.decodeObject(forKey: "user") as? GPHUser
        self.images = aDecoder.decodeObject(forKey: "images") as? GPHImages
        self.bottleData = aDecoder.decodeObject(forKey: "bottleData") as? GPHBottleData
        self.tags = aDecoder.decodeObject(forKey: "tags") as? [String]
        self.featuredTags = aDecoder.decodeObject(forKey: "featuredTags") as? [String]
        self.isHidden = aDecoder.decodeBool(forKey: "isHidden")
        self.isRemoved = aDecoder.decodeBool(forKey: "isRemoved")
        self.isCommunity = aDecoder.decodeBool(forKey: "isCommunity")
        self.isAnonymous = aDecoder.decodeBool(forKey: "isAnonymous")
        self.isFeatured = aDecoder.decodeBool(forKey: "isFeatured")
        self.isRealtime = aDecoder.decodeBool(forKey: "isRealtime")
        self.isIndexable = aDecoder.decodeBool(forKey: "isIndexable")
        self.isSticker = aDecoder.decodeBool(forKey: "isSticker")
        self.updateDate = aDecoder.decodeObject(forKey: "updateDate") as? Date
        self.createDate = aDecoder.decodeObject(forKey: "createDate") as? Date
        self.jsonRepresentation = aDecoder.decodeObject(forKey: "jsonRepresentation") as? GPHJSONObject
        self.userDictionary = aDecoder.decodeObject(forKey: "userDictionary") as? [String: Any]
    }
    
    public func encode(with aCoder: NSCoder) {
        aCoder.encode(self.id, forKey: "id")
        aCoder.encode(self.type.rawValue, forKey: "type")
        aCoder.encode(self.url, forKey: "url")
        aCoder.encode(self.rating.rawValue, forKey: "rating")
        aCoder.encode(self.title, forKey: "title")
        aCoder.encode(self.caption, forKey: "caption")
        aCoder.encode(self.slug, forKey: "slug")
        aCoder.encode(self.importDate, forKey: "importDate")
        aCoder.encode(self.trendingDate, forKey: "trendingDate")
        aCoder.encode(self.indexable, forKey: "indexable")
        aCoder.encode(self.contentUrl, forKey: "contentUrl")
        aCoder.encode(self.bitlyUrl, forKey: "bitlyUrl")
        aCoder.encode(self.bitlyGifUrl, forKey: "bitlyGifUrl")
        aCoder.encode(self.embedUrl, forKey: "embedUrl")
        aCoder.encode(self.source, forKey: "source")
        aCoder.encode(self.sourceTld, forKey: "sourceTld")
        aCoder.encode(self.sourcePostUrl, forKey: "sourcePostUrl")
        aCoder.encode(self.user, forKey: "user")
        aCoder.encode(self.images, forKey: "images")
        aCoder.encode(self.bottleData, forKey: "bottleData")
        aCoder.encode(self.tags, forKey: "tags")
        aCoder.encode(self.featuredTags, forKey: "featuredTags")
        aCoder.encode(self.isHidden, forKey: "isHidden")
        aCoder.encode(self.isRemoved, forKey: "isRemoved")
        aCoder.encode(self.isCommunity, forKey: "isCommunity")
        aCoder.encode(self.isAnonymous, forKey: "isAnonymous")
        aCoder.encode(self.isFeatured, forKey: "isFeatured")
        aCoder.encode(self.isRealtime, forKey: "isRealtime")
        aCoder.encode(self.isIndexable, forKey: "isIndexable")
        aCoder.encode(self.isSticker, forKey: "isSticker")
        aCoder.encode(self.updateDate, forKey: "updateDate")
        aCoder.encode(self.createDate, forKey: "createDate")
        aCoder.encode(self.jsonRepresentation, forKey: "jsonRepresentation")
        aCoder.encode(self.userDictionary, forKey: "userDictionary")
    }
    
    // MARK: NSObject
    
    override public func isEqual(_ object: Any?) -> Bool {
        if object as? GPHMedia === self {
            return true
        }
        if let other = object as? GPHMedia, self.id == other.id {
            return true
        }
        return false
    }
    
    override public var hash: Int {
        return "gph_object_\(self.id)".hashValue
    }
    
}

// MARK: Extension -- Human readable

/// Make objects human readable.
///
extension GPHMedia {
    
    override public var description: String {
        return "GPHMedia(\(self.type.rawValue)) for \(self.id) --> \(self.url)"
    }
    
}

// MARK: Extension -- Allow setting JSON

/// Make objects human readable.
///
public extension GPHMedia {
    
    @objc public static func mapJSON(_ json: GPHJSONObject, request:String,  media: GPHMediaType) throws -> GPHMedia {
        let options: [String: Any?] = [
            "request": request,
            "media": media
        ]
        let media = try GPHMedia.mapData(json, options: options)
        return media
    }
    
}

// MARK: Extension -- Parsing & Mapping

/// For parsing/mapping protocol.
///
extension GPHMedia: GPHMappable {

    /// This is where the magic/mapping happens + error handling.
    public static func mapData(_ data: GPHJSONObject, options: [String: Any?]) throws -> GPHMedia {
        guard
            let objId: String = data["id"] as? String,
            let url: String = data["url"] as? String
        else {
            throw GPHJSONMappingError(description: "Couldn't map GPHMedia for \(data)")
        }
        
        guard let mediaType = options["media"] as? GPHMediaType else {
            throw GPHJSONMappingError(description: "Need Media type to map the object")
        }
        
        guard let requestType = options["request"] as? String else {
            throw GPHJSONMappingError(description: "Need Request type to map the object")
        }
        
        let obj = GPHMedia(objId, type: mediaType, url: url)
        
        obj.rating = parseRating(data["rating"] as? String)
        obj.title = data["title"] as? String
        obj.caption = data["caption"] as? String
        obj.slug = data["slug"] as? String
        obj.importDate = parseDate(data["import_datetime"] as? String)
        obj.trendingDate = parseDate(data["trending_datetime"] as? String)
        obj.indexable = data["indexable"] as? String
        obj.contentUrl = data["content_url"] as? String
        obj.bitlyUrl = data["bitly_url"] as? String
        obj.bitlyGifUrl = data["bitly_gif_url"] as? String
        obj.embedUrl = data["embed_url"] as? String
        obj.source = data["source"] as? String
        obj.sourceTld = data["source_tld"] as? String
        obj.sourcePostUrl = data["source_post_url"] as? String
        obj.tags = data["tags"] as? [String]
        obj.featuredTags = data["featured_tags"] as? [String]
        obj.isHidden = data["is_hidden"] as? Bool ?? false
        obj.isRemoved = data["is_removed"] as? Bool ?? false
        obj.isCommunity = data["is_community"] as? Bool ?? false
        obj.isAnonymous = data["is_anonymous"] as? Bool ?? false
        obj.isFeatured = data["is_featured"] as? Bool ?? false
        obj.isRealtime = data["is_realtime"] as? Bool ?? false
        obj.isIndexable = data["is_indexable"] as? Bool ?? false
        obj.isSticker = data["is_sticker"] as? Bool ?? false
        obj.updateDate = parseDate(data["update_datetime"] as? String)
        obj.createDate = parseDate(data["create_datetime"] as? String)
        obj.jsonRepresentation = data
        
        
        // New options with root object
        var optionsCopy = options
        optionsCopy["root"] = obj
        
        // Handle User Data
        if let userData = data["user"] as? GPHJSONObject {
            obj.user = try GPHUser.mapData(userData, options: optionsCopy)
        }

        // Handle Bottle Data
        if let bottleData = data["bottle_data"] as? GPHJSONObject {
            obj.bottleData = try GPHBottleData.mapData(bottleData, options: optionsCopy)
        }
        
        // Handling exception of the Random endpoint structure
        switch requestType {
        case "random":
            let renditions = try GPHImages.mapData(data, options: optionsCopy)
            obj.images = renditions

        default:
            if let renditionData = data["images"] as? GPHJSONObject {
                let renditions = try GPHImages.mapData(renditionData, options: optionsCopy)
                obj.images = renditions
            }
        }

        return obj
    }

}
