//
//  GPHTermSuggestion.swift
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

/// Represents a Giphy Term Suggestion
///
@objcMembers public class GPHTermSuggestion: GPHFilterable, NSCoding {
    // MARK: Properties

    /// Term suggestion.
    public private(set) var term: String = ""
    
    /// JSON Representation.
    public fileprivate(set) var jsonRepresentation: GPHJSONObject?
    
    /// User Dictionary to Store data in Obj by the Developer
    public var userDictionary: [String: Any]?
    
    // MARK: Initializers
    
    /// Convenience Initializer
    ///
    /// - parameter term: Term suggestion.
    ///
    convenience public init(_ term: String) {
        self.init()
        self.term = term
    }
    
    //MARK: NSCoding

    required convenience public init?(coder aDecoder: NSCoder) {
        guard let term = aDecoder.decodeObject(forKey: "term") as? String
            else { return nil }
        
        self.init(term)
        self.jsonRepresentation = aDecoder.decodeObject(forKey: "jsonRepresentation") as? GPHJSONObject
        self.userDictionary = aDecoder.decodeObject(forKey: "userDictionary") as? [String: Any]
    }
    
    public func encode(with aCoder: NSCoder) {
        aCoder.encode(self.term, forKey: "term")
        aCoder.encode(self.jsonRepresentation, forKey: "jsonRepresentation")
        aCoder.encode(self.userDictionary, forKey: "userDictionary")
    }
    
    // MARK: NSObject
    
    override public func isEqual(_ object: Any?) -> Bool {
        if object as? GPHTermSuggestion === self {
            return true
        }
        if let other = object as? GPHTermSuggestion, self.term == other.term {
            return true
        }
        return false
    }
    
    override public var hash: Int {
        return "gph_term_suggestion_\(self.term)".hashValue
    }
    
}

// MARK: Extension -- Human readable

/// Make objects human readable.
///
extension GPHTermSuggestion {
    
    override public var description: String {
        return "GPHTermSuggestion(\(self.term))"
    }
    
}

// MARK: Extension -- Parsing & Mapping

/// For parsing/mapping protocol.
///
extension GPHTermSuggestion: GPHMappable {
    
    /// This is where the magic/mapping happens + error handling.
    public static func mapData(_ data: GPHJSONObject, options: [String: Any?]) throws -> GPHTermSuggestion {
        
        guard
            let term = data["name"] as? String
            else {
                throw GPHJSONMappingError(description: "Couldn't map GPHTermSuggestion for \(data)")
        }
        
        let obj = GPHTermSuggestion(term)
        obj.jsonRepresentation = data
        return obj
    }
    
}
