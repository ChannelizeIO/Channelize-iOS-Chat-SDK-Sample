//
//  GPHBottleData.swift
//  GiphyCoreSDK
//
//  Created by Cem Kozinoglu, Gene Goykhman, Giorgia Marenda on 3/13/18.
//  Copyright © 2018 Giphy. All rights reserved.
//
//  This Source Code Form is subject to the terms of the Mozilla Public
//  License, v. 2.0. If a copy of the MPL was not distributed with this
//  file, You can obtain one at http://mozilla.org/MPL/2.0/.
//

import Foundation

/// Represents a Giphy Bottle Data
///
@objcMembers public class GPHBottleData: GPHFilterable, NSCoding {
    // MARK: Properties
    
    /// Tid.
    public private(set) var tid: String = ""
    
    /// Tags.
    public private(set) var tags: [String]?

    /// JSON Representation.
    public fileprivate(set) var jsonRepresentation: GPHJSONObject?
    
    /// User Dictionary to Store data in Obj by the Developer
    public var userDictionary: [String: Any]?
    
    // MARK: Initializers
    
    /// Convenience Initializer
    ///
    /// - parameter tid: tid.
    ///
    convenience public init(_ tid: String) {
        self.init()
        self.tid = tid
    }
    
    //MARK: NSCoding
    
    required convenience public init?(coder aDecoder: NSCoder) {
        guard let tid = aDecoder.decodeObject(forKey: "tid") as? String
            else { return nil }
        
        self.init(tid)
        self.jsonRepresentation = aDecoder.decodeObject(forKey: "jsonRepresentation") as? GPHJSONObject
        self.tags = aDecoder.decodeObject(forKey: "tags") as? [String]
        self.userDictionary = aDecoder.decodeObject(forKey: "userDictionary") as? [String: Any]
    }
    
    public func encode(with aCoder: NSCoder) {
        aCoder.encode(self.tid, forKey: "tid")
        aCoder.encode(self.tags, forKey: "tags")
        aCoder.encode(self.jsonRepresentation, forKey: "jsonRepresentation")
        aCoder.encode(self.userDictionary, forKey: "userDictionary")
    }
    
    // MARK: NSObject
    
    override public func isEqual(_ object: Any?) -> Bool {
        if object as? GPHBottleData === self {
            return true
        }
        if let other = object as? GPHBottleData, self.tid == other.tid {
            return true
        }
        return false
    }
    
    override public var hash: Int {
        return "gph_bottle_\(self.tid)".hashValue
    }
    
}

// MARK: Extension -- Human readable

/// Make objects human readable.
///
extension GPHBottleData {
    
    override public var description: String {
        return "GPHBottleData(\(self.tid))"
    }
    
}

// MARK: Extension -- Parsing & Mapping

/// For parsing/mapping protocol.
///
extension GPHBottleData: GPHMappable {
    
    /// This is where the magic/mapping happens + error handling.
    public static func mapData(_ data: GPHJSONObject, options: [String: Any?]) throws -> GPHBottleData {
        
        guard
            let tid = data["tid"] as? String
            else {
                throw GPHJSONMappingError(description: "Couldn't map GPHBottleData for \(data)")
        }
        
        let obj = GPHBottleData(tid)
        
        obj.tags = data["tags"] as? [String]
        obj.jsonRepresentation = data
        return obj
    }
    
}
