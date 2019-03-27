//
//  GPHImages.swift
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

/// Represents a Giphy Images (Renditions) for a GPHMedia
///
@objcMembers public class GPHImages: GPHFilterable, NSCoding {
    // MARK: Properties

    /// ID of the Represented Object.
    public fileprivate(set) var mediaId: String = ""
    
    /// Original file size and file dimensions. Good for desktop use.
    public fileprivate(set) var original: GPHImage?
    
    /// Preview image for original.
    public fileprivate(set) var originalStill: GPHImage?
    
    /// File size under 50kb. Duration may be truncated to meet file size requirements. Good for thumbnails and previews.
    public fileprivate(set) var preview: GPHImage?
    
    /// Duration set to loop for 15 seconds. Only recommended for this exact use case.
    public fileprivate(set) var looping: GPHImage?
    
    /// Height set to 200px. Good for mobile use.
    public fileprivate(set) var fixedHeight: GPHImage?
    
    /// Static preview image for fixed_height.
    public fileprivate(set) var fixedHeightStill: GPHImage?
    
    /// Height set to 200px. Reduced to 6 frames to minimize file size to the lowest.
    /// Works well for unlimited scroll on mobile and as animated previews. See Giphy.com on mobile web as an example.
    public fileprivate(set) var fixedHeightDownsampled: GPHImage?
    
    /// Height set to 100px. Good for mobile keyboards.
    public fileprivate(set) var fixedHeightSmall: GPHImage?
    
    /// Static preview image for fixed_height_small.
    public fileprivate(set) var fixedHeightSmallStill: GPHImage?

    /// Width set to 200px. Good for mobile use.
    public fileprivate(set) var fixedWidth: GPHImage?
    
    /// Static preview image for fixed_width.
    public fileprivate(set) var fixedWidthStill: GPHImage?
    
    /// Width set to 200px. Reduced to 6 frames. Works well for unlimited scroll on mobile and as animated previews.
    public fileprivate(set) var fixedWidthDownsampled: GPHImage?
    
    /// Width set to 100px. Good for mobile keyboards.
    public fileprivate(set) var fixedWidthSmall: GPHImage?
    
    /// Static preview image for fixed_width_small.
    public fileprivate(set) var fixedWidthSmallStill: GPHImage?
    
    /// File size under 2mb.
    public fileprivate(set) var downsized: GPHImage?

    /// File size under 200kb.
    public fileprivate(set) var downsizedSmall: GPHImage?
    
    /// File size under 5mb.
    public fileprivate(set) var downsizedMedium: GPHImage?
    
    /// File size under 8mb.
    public fileprivate(set) var downsizedLarge: GPHImage?
    
    /// Static preview image for downsized.
    public fileprivate(set) var downsizedStill: GPHImage?
    
    /// JSON Representation.
    public fileprivate(set) var jsonRepresentation: GPHJSONObject?
    
    /// User Dictionary to Store data in Obj by the Developer
    public var userDictionary: [String: Any]?
    
    // MARK: Initializers
    
    /// Convenience Initializer
    ///
    /// - parameter mediaId: Media Objects ID.
    ///
    convenience public init(_ mediaId: String) {
        self.init()
        self.mediaId = mediaId
    }
    
    //MARK: NSCoding

    required convenience public init?(coder aDecoder: NSCoder) {
        guard
            let mediaId = aDecoder.decodeObject(forKey: "mediaId") as? String
        else {
            return nil
        }
        
        self.init(mediaId)
        
        self.original = aDecoder.decodeObject(forKey: "original") as? GPHImage
        self.originalStill = aDecoder.decodeObject(forKey: "originalStill") as? GPHImage
        self.preview = aDecoder.decodeObject(forKey: "preview") as? GPHImage
        self.looping = aDecoder.decodeObject(forKey: "looping") as? GPHImage
        self.fixedHeight = aDecoder.decodeObject(forKey: "fixedHeight") as? GPHImage
        self.fixedHeightStill = aDecoder.decodeObject(forKey: "fixedHeightStill") as? GPHImage
        self.fixedHeightDownsampled = aDecoder.decodeObject(forKey: "fixedHeightDownsampled") as? GPHImage
        self.fixedHeightSmall = aDecoder.decodeObject(forKey: "fixedHeightSmall") as? GPHImage
        self.fixedHeightSmallStill = aDecoder.decodeObject(forKey: "fixedHeightSmallStill") as? GPHImage
        self.fixedWidth = aDecoder.decodeObject(forKey: "fixedWidth") as? GPHImage
        self.fixedWidthStill = aDecoder.decodeObject(forKey: "fixedWidthStill") as? GPHImage
        self.fixedWidthDownsampled = aDecoder.decodeObject(forKey: "fixedWidthDownsampled") as? GPHImage
        self.fixedWidthSmall = aDecoder.decodeObject(forKey: "fixedWidthSmall") as? GPHImage
        self.fixedWidthSmallStill = aDecoder.decodeObject(forKey: "fixedWidthSmallStill") as? GPHImage
        self.downsized = aDecoder.decodeObject(forKey: "downsized") as? GPHImage
        self.downsizedSmall = aDecoder.decodeObject(forKey: "downsizedSmall") as? GPHImage
        self.downsizedMedium = aDecoder.decodeObject(forKey: "downsizedMedium") as? GPHImage
        self.downsizedLarge = aDecoder.decodeObject(forKey: "downsizedLarge") as? GPHImage
        self.downsizedStill = aDecoder.decodeObject(forKey: "downsizedStill") as? GPHImage
        self.jsonRepresentation = aDecoder.decodeObject(forKey: "jsonRepresentation") as? GPHJSONObject
        self.userDictionary = aDecoder.decodeObject(forKey: "userDictionary") as? [String: Any]
    }
    
    public func encode(with aCoder: NSCoder) {
        aCoder.encode(self.mediaId, forKey: "mediaId")
        aCoder.encode(self.original, forKey: "original")
        aCoder.encode(self.originalStill, forKey: "originalStill")
        aCoder.encode(self.preview, forKey: "preview")
        aCoder.encode(self.looping, forKey: "looping")
        aCoder.encode(self.fixedHeight, forKey: "fixedHeight")
        aCoder.encode(self.fixedHeightStill, forKey: "fixedHeightStill")
        aCoder.encode(self.fixedHeightDownsampled, forKey: "fixedHeightDownsampled")
        aCoder.encode(self.fixedHeightSmall, forKey: "fixedHeightSmall")
        aCoder.encode(self.fixedHeightSmallStill, forKey: "fixedHeightSmallStill")
        aCoder.encode(self.fixedWidth, forKey: "fixedWidth")
        aCoder.encode(self.fixedWidthStill, forKey: "fixedWidthStill")
        aCoder.encode(self.fixedWidthDownsampled, forKey: "fixedWidthDownsampled")
        aCoder.encode(self.fixedWidthSmall, forKey: "fixedWidthSmall")
        aCoder.encode(self.fixedWidthSmallStill, forKey: "fixedWidthSmallStill")
        aCoder.encode(self.downsized, forKey: "downsized")
        aCoder.encode(self.downsizedSmall, forKey: "downsizedSmall")
        aCoder.encode(self.downsizedMedium, forKey: "downsizedMedium")
        aCoder.encode(self.downsizedLarge, forKey: "downsizedLarge")
        aCoder.encode(self.downsizedStill, forKey: "downsizedStill")
        aCoder.encode(self.jsonRepresentation, forKey: "jsonRepresentation")
        aCoder.encode(self.userDictionary, forKey: "userDictionary")
    }
    
    // MARK: NSObject

    override public func isEqual(_ object: Any?) -> Bool {
        if object as? GPHImages === self {
            return true
        }
        if let other = object as? GPHImages, self.mediaId == other.mediaId {
            return true
        }
        return false
    }
    
    override public var hash: Int {
        return "gph_renditions_\(self.mediaId)".hashValue
    }

}

// MARK: Extension -- Helper Methods

/// Picking renditions and stuff.
///
extension GPHImages {
    
    @objc
    public func rendition(_ rendition: GPHRenditionType = .original) -> GPHImage? {
        
        switch rendition {
        case .original:
            return self.original
        case .originalStill:
            return self.originalStill
        case .preview:
            return self.preview
        case .looping:
            return self.looping
        case .fixedHeight:
            return self.fixedHeight
        case .fixedHeightStill:
            return self.fixedHeightStill
        case .fixedHeightDownsampled:
            return self.fixedHeightDownsampled
        case .fixedHeightSmall:
            return self.fixedHeightSmall
        case .fixedHeightSmallStill:
            return self.fixedHeightSmallStill
        case .fixedWidth:
            return self.fixedWidth
        case .fixedWidthStill:
            return self.fixedWidthStill
        case .fixedWidthDownsampled:
            return self.fixedWidthDownsampled
        case .fixedWidthSmall:
            return self.fixedWidthSmall
        case .fixedWidthSmallStill:
            return self.fixedWidthSmallStill
        case .downsized:
            return self.downsized
        case .downsizedSmall:
            return self.downsizedSmall
        case .downsizedMedium:
            return self.downsizedMedium
        case .downsizedLarge:
            return self.downsizedLarge
        case .downsizedStill:
            return self.downsizedStill
//        default:
//            return self.original
        }
    }
    
}


// MARK: Extension -- Human readable

/// Make objects human readable.
///
extension GPHImages {
    
    override public var description: String {
        return "GPHImages(for: \(self.mediaId))"
    }
    
}

// MARK: Extension -- Parsing & Mapping

/// For parsing/mapping protocol.
///
extension GPHImages: GPHMappable {
    
    // convinience method to convert Random endpoint results to structured renditions
    static func mapRandomData(_ keyPrefix: String, data: GPHJSONObject) -> GPHJSONObject? {
        
        var keyPrefixMap = keyPrefix
        if keyPrefix == "original" {
            keyPrefixMap = "image"
        }
        var mappedDict: GPHJSONObject = [:]
        mappedDict["url"] = data["\(keyPrefixMap)_url"] as? String
        mappedDict["width"] = parseInt(data["\(keyPrefixMap)_width"] as? String)
        mappedDict["height"] = parseInt(data["\(keyPrefixMap)_height"] as? String)
        mappedDict["frames"] = parseInt(data["\(keyPrefixMap)_frames"] as? String)
        mappedDict["size"] = parseInt(data["\(keyPrefixMap)_size"] as? String)
        mappedDict["mp4"] = data["\(keyPrefixMap)_mp4_url"] as? String
        mappedDict["still_url"] = data["\(keyPrefixMap)_still_url"] as? String
        
        if mappedDict.count == 0 {
            return nil
        }
        
        return mappedDict
    }
    
    
    // convinience method to get GPHImage or nil safely
    static func image(_ data: GPHJSONObject,  options: [String: Any?]) -> (object: GPHImage?, error: GPHJSONMappingError?) {
        
        guard let renditionType = options["rendition"] as? GPHRenditionType else {
            return (nil, GPHJSONMappingError(description: "Need Rendition to map the object"))
        }
        guard let requestType = options["request"] as? String else {
            return (nil, GPHJSONMappingError(description: "Need Request type to map the object"))
        }
        
        var jsonKeyData:GPHJSONObject?
        
        // handle structural changes on how data is mapped depending on the request type (search, trending, random....)
        switch requestType {
        case "random":
            jsonKeyData = mapRandomData(renditionType.rawValue, data: data)
        default:
            jsonKeyData = data[renditionType.rawValue] as? GPHJSONObject
        }
        
        if let jsonKeyData = jsonKeyData {
            do {
                let keyImage = try GPHImage.mapData(jsonKeyData, options: options)
                return (keyImage, nil)
            } catch let error as GPHJSONMappingError {
                return (nil, error)
            } catch {
                return (nil, GPHJSONMappingError(description: "Fatal error, this should never happen"))
            }
        }
        return (nil, GPHJSONMappingError(description: "Couldn't map GPHImage for the rendition \(renditionType.rawValue)"))
    }
    
    static func optionsWithRendition(_ options: [String: Any?], rendition: GPHRenditionType) -> [String: Any?] {
        var optionsCopy = options
        optionsCopy["rendition"] = rendition
        return optionsCopy
    }
    
    /// This is where the magic/mapping happens + error handling.
    public static func mapData(_ data: GPHJSONObject, options: [String: Any?]) throws -> GPHImages {
        
        guard let root = options["root"] as? GPHMedia else {
            throw GPHJSONMappingError(description: "Root object can not be nil, expected a GPHMedia")
        }
        
        let obj = GPHImages(root.id)
        
        obj.original = GPHImages.image(data, options: optionsWithRendition(options, rendition: .original)).object
        obj.originalStill = GPHImages.image(data, options: optionsWithRendition(options, rendition: .originalStill)).object
        obj.preview = GPHImages.image(data, options: optionsWithRendition(options, rendition: .preview)).object
        obj.looping = GPHImages.image(data, options: optionsWithRendition(options, rendition: .looping)).object
        obj.fixedHeight = GPHImages.image(data, options: optionsWithRendition(options, rendition: .fixedHeight)).object
        obj.fixedHeightStill = GPHImages.image(data, options: optionsWithRendition(options, rendition: .fixedHeightStill)).object
        obj.fixedHeightDownsampled = GPHImages.image(data, options: optionsWithRendition(options, rendition: .fixedHeightDownsampled)).object
        obj.fixedHeightSmall = GPHImages.image(data, options: optionsWithRendition(options, rendition:.fixedHeightSmall)).object
        obj.fixedHeightSmallStill = GPHImages.image(data, options: optionsWithRendition(options, rendition: .fixedHeightSmallStill)).object
        obj.fixedWidth = GPHImages.image(data, options: optionsWithRendition(options, rendition: .fixedWidth)).object
        obj.fixedWidthStill = GPHImages.image(data, options: optionsWithRendition(options, rendition: .fixedWidthStill)).object
        obj.fixedWidthDownsampled = GPHImages.image(data, options: optionsWithRendition(options, rendition: .fixedWidthDownsampled)).object
        obj.fixedWidthSmall = GPHImages.image(data, options: optionsWithRendition(options, rendition: .fixedWidthSmall)).object
        obj.fixedWidthSmallStill = GPHImages.image(data, options: optionsWithRendition(options, rendition: .fixedWidthSmallStill)).object
        obj.downsized = GPHImages.image(data, options: optionsWithRendition(options, rendition: .downsized)).object
        obj.downsizedSmall = GPHImages.image(data, options: optionsWithRendition(options, rendition: .downsizedSmall)).object
        obj.downsizedMedium = GPHImages.image(data, options: optionsWithRendition(options, rendition: .downsizedMedium)).object
        obj.downsizedLarge = GPHImages.image(data, options: optionsWithRendition(options, rendition: .downsizedLarge)).object
        obj.downsizedStill = GPHImages.image(data, options: optionsWithRendition(options, rendition: .downsizedStill)).object
        obj.jsonRepresentation = data
        
        return obj
    }
    
}
