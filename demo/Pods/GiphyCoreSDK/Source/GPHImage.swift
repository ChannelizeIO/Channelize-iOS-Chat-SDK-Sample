//
//  GPHImage.swift
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

/// Represents a Giphy Image (GIF/Sticker)
///
@objcMembers public class GPHImage: GPHFilterable, NSCoding {
    // MARK: Properties

    /// ID of the Represented GPHMedia Object.
    public fileprivate(set) var mediaId: String = ""

    /// ID of the Represented Object.
    public fileprivate(set) var rendition: GPHRenditionType = .original
    
    /// URL of the Gif file.
    public fileprivate(set) var gifUrl: String?

    /// URL of the Still Gif file.
    public fileprivate(set) var stillGifUrl: String?
    
    /// Width.
    public fileprivate(set) var width: Int = 0
    
    /// Height.
    public fileprivate(set) var height: Int = 0

    /// # of Frames.
    public fileprivate(set) var frames: Int = 0
    
    /// Gif file size in bytes.
    public fileprivate(set) var gifSize: Int = 0
    
    /// URL of the WebP file.
    public fileprivate(set) var webPUrl: String?

    /// Gif file size in bytes.
    public fileprivate(set) var webPSize: Int = 0
    
    /// URL of the mp4 file.
    public fileprivate(set) var mp4Url: String?
    
    /// Gif file size in bytes.
    public fileprivate(set) var mp4Size: Int = 0
    
    /// JSON Representation.
    public fileprivate(set) var jsonRepresentation: GPHJSONObject?
    
    /// User Dictionary to Store data in Obj by the Developer
    public var userDictionary: [String: Any]?
    
    // MARK: Initializers
    
    /// Convenience Initializer
    ///
    /// - parameter mediaId: Media Objects ID.
    /// - parameter rendition: Rendition Type of the Image.
    ///
    convenience public init(_ mediaId: String,
                     rendition: GPHRenditionType) {
        self.init()
        self.mediaId = mediaId
        self.rendition = rendition
    }
    
    //MARK: NSCoding
    
    required convenience public init?(coder aDecoder: NSCoder) {
        guard
            let mediaId = aDecoder.decodeObject(forKey: "mediaId") as? String,
            let rendition = GPHRenditionType(rawValue: aDecoder.decodeObject(forKey: "rendition") as! String)
        else {
            return nil
        }
        
        self.init(mediaId, rendition: rendition)
                  
        self.gifUrl = aDecoder.decodeObject(forKey: "gifUrl") as? String
        self.stillGifUrl = aDecoder.decodeObject(forKey: "stillGifUrl") as? String
        self.gifSize = aDecoder.decodeInteger(forKey: "gifSize")
        self.width = aDecoder.decodeInteger(forKey: "width")
        self.height = aDecoder.decodeInteger(forKey: "height")
        self.frames = aDecoder.decodeInteger(forKey: "frames")
        self.webPUrl = aDecoder.decodeObject(forKey: "webPUrl") as? String
        self.webPSize = aDecoder.decodeInteger(forKey: "webPSize")
        self.mp4Url = aDecoder.decodeObject(forKey: "mp4Url") as? String
        self.mp4Size = aDecoder.decodeInteger(forKey: "mp4Size")
        self.jsonRepresentation = aDecoder.decodeObject(forKey: "jsonRepresentation") as? GPHJSONObject
        self.userDictionary = aDecoder.decodeObject(forKey: "userDictionary") as? [String: Any]
    }
    
    public func encode(with aCoder: NSCoder) {
        aCoder.encode(self.mediaId, forKey: "mediaId")
        aCoder.encode(self.rendition.rawValue, forKey: "rendition")
        aCoder.encode(self.gifUrl, forKey: "gifUrl")
        aCoder.encode(self.stillGifUrl, forKey: "stillGifUrl")
        aCoder.encode(self.gifSize, forKey: "gifSize")
        aCoder.encode(self.width, forKey: "width")
        aCoder.encode(self.height, forKey: "height")
        aCoder.encode(self.frames, forKey: "frames")
        aCoder.encode(self.webPUrl, forKey: "webPUrl")
        aCoder.encode(self.webPSize, forKey: "webPSize")
        aCoder.encode(self.mp4Url, forKey: "mp4Url")
        aCoder.encode(self.mp4Size, forKey: "mp4Size")
        aCoder.encode(self.jsonRepresentation, forKey: "jsonRepresentation")
        aCoder.encode(self.userDictionary, forKey: "userDictionary")
    }
    
    // MARK: NSObject
    
    override public func isEqual(_ object: Any?) -> Bool {
        if object as? GPHImage === self {
            return true
        }
        if let other = object as? GPHImage, self.mediaId == other.mediaId, self.rendition.rawValue == other.rendition.rawValue {
            return true
        }
        return false
    }
    
    override public var hash: Int {
        return "gph_image_\(self.mediaId)_\(self.rendition.rawValue)".hashValue
    }
    
}

// MARK: Extension -- Human readable

/// Make objects human readable.
///
extension GPHImage {
    
    override public var description: String {
        return "GPHImage(for: \(self.mediaId)) rendition: \(self.rendition.rawValue)"
    }
    
}

// MARK: Extension -- Parsing & Mapping

/// For parsing/mapping protocol.
///
extension GPHImage: GPHMappable {
    
    /// This is where the magic/mapping happens + error handling.
    public static func mapData(_ data: GPHJSONObject, options: [String: Any?]) throws -> GPHImage {
        
        guard let root = options["root"] as? GPHMedia else {
            throw GPHJSONMappingError(description: "Root object can not be nil, expected a GPHMedia")
        }
        
        guard let renditionType = options["rendition"] as? GPHRenditionType else {
            throw GPHJSONMappingError(description: "Need Rendition to map the object")
        }
        
        let obj = GPHImage(root.id, rendition: renditionType)
        
        obj.gifUrl = data["url"] as? String
        obj.stillGifUrl = data["still_url"] as? String
        obj.gifSize = parseInt(data["size"] as? String) ?? 0
        obj.width = parseInt(data["width"] as? String) ?? 0
        obj.height = parseInt(data["height"] as? String) ?? 0
        obj.frames = parseInt(data["frames"] as? String) ?? 0
        obj.webPUrl = data["webp"] as? String
        obj.webPSize = parseInt(data["webp_size"] as? String) ?? 0
        obj.mp4Url = data["mp4"] as? String
        obj.mp4Size = parseInt(data["mp4_size"] as? String) ?? 0
        obj.jsonRepresentation = data
        
        return obj
    }
    
}
