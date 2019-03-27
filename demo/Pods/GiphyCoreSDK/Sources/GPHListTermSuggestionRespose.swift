//
//  GPHListTermSuggestionResponse.swift
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

/// Represents a Giphy List Term Suggestions Response (multiple results)
///
@objcMembers public class GPHListTermSuggestionResponse: GPHResponse {
    // MARK: Properties

    /// Terms Suggested.
    public fileprivate(set) var data: [GPHTermSuggestion]?
    
    
    // MARK: Initializers
    
    /// Convenience Initializer
    ///
    /// - parameter meta: init with a GPHMeta object.
    /// - parameter data: GPHTermSuggestion array (optional).
    ///
    convenience public init(_ meta:GPHMeta, data: [GPHTermSuggestion]?) {
        self.init()
        self.data = data
        self.meta = meta
    }
    
}

// MARK: Extension -- Human readable

/// Make objects human readable.
///
extension GPHListTermSuggestionResponse {
    
    override public var description: String {
        return "GPHListTermSuggestionResponse(\(self.meta.responseId) status: \(self.meta.status) msg: \(self.meta.msg))"
    }
    
}

// MARK: Extension -- Parsing & Mapping

/// For parsing/mapping protocol.
///
extension GPHListTermSuggestionResponse: GPHMappable {
    
    /// This is where the magic/mapping happens + error handling.
    public static func mapData(_ data: GPHJSONObject, options: [String: Any?]) throws -> GPHListTermSuggestionResponse {
        
        guard
            let metaData = data["meta"] as? GPHJSONObject
        else {
            throw GPHJSONMappingError(description: "Couldn't map GPHMediaResponse due to Meta missing for \(data)")
        }
        
        let meta = try GPHMeta.mapData(metaData, options: options)
        
        // Try to see if we can get the Media object
        if let termData = data["data"] as? [GPHJSONObject] {
            
            // Get Results
            var results: [GPHTermSuggestion]? = []
            
            for result in termData {
                let result = try GPHTermSuggestion.mapData(result, options: options)
                if result.isValidObject() {
                    results?.append(result)
                }
            }
            
            // We have images and the meta data and pagination
            return GPHListTermSuggestionResponse(meta, data: results)
        }
        
        // No image and pagination data, return the meta data
        return GPHListTermSuggestionResponse(meta, data: nil)
    }
    
}
