//
//  GPHCategory.swift
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

/// Represents Giphy Categories & Subcategories
///
@objcMembers public class GPHCategory: GPHFilterable, NSCoding {
    // MARK: Properties

    /// Name of the Category.
    public fileprivate(set) var name: String = ""
    
    /// Encoded name of the Category.
    public fileprivate(set) var nameEncoded: String = ""
    
    /// URL Encoded path of the Category (to make sure we have the full-path for subcategories).
    public fileprivate(set) var encodedPath: String = ""
    
    /// GIF representation of the Category.
    public fileprivate(set) var gif: GPHMedia?
    
    /// Subcategories of the Category.
    public fileprivate(set) var subCategories: [GPHCategory]?
    
    /// JSON Representation.
    public fileprivate(set) var jsonRepresentation: GPHJSONObject?
    
    /// User Dictionary to Store data in Obj by the Developer
    public var userDictionary: [String: Any]?
    
    // MARK: Initializers
    
    /// Convenience Initializer
    ///
    /// - parameter name: Name of the Category.
    /// - parameter nameEncoded: URL Encoded name of the Category.
    /// - parameter encodedPath: URL Encoded path of the Category (to make sure we have the full-path for subcategories).
    ///
    convenience public init(_ name: String, nameEncoded: String, encodedPath: String) {
        self.init()
        self.name = name
        self.nameEncoded = nameEncoded
        self.encodedPath = encodedPath
    }
    
    //MARK: NSCoding
    
    required convenience public init?(coder aDecoder: NSCoder) {
        guard
            let name = aDecoder.decodeObject(forKey: "name") as? String,
            let nameEncoded = aDecoder.decodeObject(forKey: "nameEncoded") as? String,
            let encodedPath = aDecoder.decodeObject(forKey: "encodedPath") as? String
        else {
            return nil
        }
        
        self.init(name, nameEncoded: nameEncoded, encodedPath: encodedPath)
        
        self.gif = aDecoder.decodeObject(forKey: "gif") as? GPHMedia
        self.subCategories = aDecoder.decodeObject(forKey: "subCategories") as? [GPHCategory]
        self.jsonRepresentation = aDecoder.decodeObject(forKey: "jsonRepresentation") as? GPHJSONObject
        self.userDictionary = aDecoder.decodeObject(forKey: "userDictionary") as? [String: Any]
    }
    
    public func encode(with aCoder: NSCoder) {
        aCoder.encode(self.name, forKey: "name")
        aCoder.encode(self.nameEncoded, forKey: "nameEncoded")
        aCoder.encode(self.encodedPath, forKey: "encodedPath")
        aCoder.encode(self.gif, forKey: "gif")
        aCoder.encode(self.subCategories, forKey: "subCategories")
        aCoder.encode(self.jsonRepresentation, forKey: "jsonRepresentation")
        aCoder.encode(self.userDictionary, forKey: "userDictionary")
    }
    
    // MARK: NSObject

    override public func isEqual(_ object: Any?) -> Bool {
        if object as? GPHCategory === self {
            return true
        }
        if let other = object as? GPHCategory, self.name == other.name {
            return true
        }
        return false
    }
    
    override public var hash: Int {
        return "gph_category_\(self.name)".hashValue
    }
    
}

// MARK: Extension -- Helper Methods

/// Picking renditions and stuff.
///
extension GPHCategory {
    
    @objc
    public func addSubCategory(_ subCategory: GPHCategory) {
        if self.subCategories != nil {
            self.subCategories?.append(subCategory)
        } else {
            self.subCategories = [subCategory];
        }
    }
    
}

// MARK: Extension -- Human readable

/// Make objects human readable.
///
extension GPHCategory {
    
    override public var description: String {
        return "GPHCategory(\(self.name)) encoded: \(self.nameEncoded) and path:\(self.encodedPath)"
    }
    
}

// MARK: Extension -- Parsing & Mapping

/// For parsing/mapping protocol.
///
extension GPHCategory: GPHMappable {
    
    /// This is where the magic/mapping happens + error handling.
    public static func mapData(_ data: GPHJSONObject, options: [String: Any?]) throws -> GPHCategory {
        
        guard let requestType = options["request"] as? String else {
            throw GPHJSONMappingError(description: "Need Request type to map the data")
        }
        
        guard let name = data["name"] as? String,
              let nameEncoded = data["name_encoded"] as? String
        else {
            throw GPHJSONMappingError(description: "Couldn't map GPHCategory for \(data)")
        }
        
        let obj = GPHCategory(name, nameEncoded: nameEncoded, encodedPath: "")
        
        var gif: GPHMedia? = nil
        
        if let gifData = data["gif"] as? GPHJSONObject {
            gif = try GPHMedia.mapData(gifData, options: options)
        }
        
        obj.gif = gif
        
        switch requestType {
        case "categories":
            obj.encodedPath = nameEncoded
            
            if let subCategoriesJSON = data["subcategories"] as? [GPHJSONObject] {
                if subCategoriesJSON.count > 0 {
                    obj.subCategories = []
                    for subCategoryJSON in subCategoriesJSON {
                        // Create all the sub categories
                        var optionsCopy = options
                        optionsCopy["root"] = obj
                        optionsCopy["request"] = "subCategories"
                        let subObj = try GPHCategory.mapData(subCategoryJSON, options: optionsCopy)
                        obj.subCategories?.append(subObj)
                    }
                }
            }
            
        case "subCategories":
            guard let root = options["root"] as? GPHCategory else {
                throw GPHJSONMappingError(description: "Root object can not be nil, expected a GPHCategory")
            }
            obj.encodedPath = root.nameEncoded + "/" + nameEncoded
            obj.subCategories = nil
            
        default:
           throw GPHJSONMappingError(description: "Request type is not valid for Categories")
        }
        
        obj.jsonRepresentation = data
        
        return obj
    }
    
}
