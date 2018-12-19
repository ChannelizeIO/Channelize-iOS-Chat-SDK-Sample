//
//  GPHListCategoryResponse.swift
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

/// Represents a Giphy List Category Response (multiple results)
///
@objcMembers public class GPHListCategoryResponse: GPHResponse {
    // MARK: Properties
    
    /// Category Objects.
    public fileprivate(set) var data: [GPHCategory]?
    
    /// Pagination info.
    public fileprivate(set) var pagination: GPHPagination?
    
    
    // MARK: Initializers
    
    /// Convenience Initializer
    ///
    /// - parameter meta: init with a GPHMeta object.
    /// - parameter data: GPHMedia array (optional).
    /// - parameter pagination: GPHPagination object (optional).
    ///
    convenience public init(_ meta:GPHMeta, data: [GPHCategory]?, pagination: GPHPagination?) {
        self.init()
        self.data = data
        self.pagination = pagination
        self.meta = meta
    }
    
}

// MARK: Extension -- Human readable

/// Make objects human readable.
///
extension GPHListCategoryResponse {
    
    override public var description: String {
        return "GPHListCategoryResponse(\(self.meta.responseId) status: \(self.meta.status) msg: \(self.meta.msg))"
    }
    
}

// MARK: Extension -- Parsing & Mapping

/// For parsing/mapping protocol.
///
extension GPHListCategoryResponse: GPHMappable {
    
    /// This is where the magic/mapping happens + error handling.
    public static func mapData(_ data: GPHJSONObject, options: [String: Any?]) throws -> GPHListCategoryResponse {
        
        guard
            let metaData = data["meta"] as? GPHJSONObject
            else {
                throw GPHJSONMappingError(description: "Couldn't map GPHMediaResponse due to Meta missing for \(data)")
        }
        
        let meta = try GPHMeta.mapData(metaData, options: options)
        
        // Try to see if we can get the Media object
        if let mediaData = data["data"] as? [GPHJSONObject], let paginationData = data["pagination"] as? GPHJSONObject {
            
            // Get Pagination
            let pagination = try GPHPagination.mapData(paginationData, options: options)
            
            // Get Results
            var results: [GPHCategory]? = []
            
            for result in mediaData {
                let result = try GPHCategory.mapData(result, options: options)
                if result.isValidObject() {
                    results?.append(result)
                }
            }
            if results != nil {
                pagination.updateFilteredCount(results!.count)
            }
            
            // We have images and the meta data and pagination
            return GPHListCategoryResponse(meta, data: results, pagination: pagination)
        }
        
        // No image and pagination data, return the meta data
        return GPHListCategoryResponse(meta, data: nil, pagination: nil)
    }
    
}


