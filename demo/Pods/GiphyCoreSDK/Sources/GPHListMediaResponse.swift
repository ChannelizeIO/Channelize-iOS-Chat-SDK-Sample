//
//  GPHListMediaResponse.swift
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

/// Represents a Giphy List Media Response (multiple results)
///
@objcMembers public class GPHListMediaResponse: GPHResponse {
    // MARK: Properties

    /// Gifs/Stickers.
    public fileprivate(set) var data: [GPHMedia]?
    
    /// Pagination info.
    public fileprivate(set) var pagination: GPHPagination?
    
    
    // MARK: Initializers
    
    /// Convenience Initializer
    ///
    /// - parameter meta: init with a GPHMeta object.
    /// - parameter data: GPHMedia array (optional).
    /// - parameter pagination: GPHPagination object (optional).
    ///
    convenience public init(_ meta:GPHMeta, data: [GPHMedia]?, pagination: GPHPagination?) {
        self.init()
        self.data = data
        self.pagination = pagination
        self.meta = meta
    }
    
}

// MARK: Extension -- Human readable

/// Make objects human readable.
///
extension GPHListMediaResponse {
    
    override public var description: String {
        return "GPHListMediaResponse(\(self.meta.responseId) status: \(self.meta.status) msg: \(self.meta.msg))"
    }
    
}

// MARK: Extension -- Parsing & Mapping

/// For parsing/mapping protocol.
///
extension GPHListMediaResponse: GPHMappable {
    
    /// This is where the magic/mapping happens + error handling.
    public static func mapData(_ data: GPHJSONObject, options: [String: Any?]) throws -> GPHListMediaResponse {
        guard
            let metaData = data["meta"] as? GPHJSONObject
            else {
                throw GPHJSONMappingError(description: "Couldn't map GPHMediaResponse due to Meta missing for \(data)")
        }
        let meta = try GPHMeta.mapData(metaData, options: options)
        
        var pagination: GPHPagination? = nil
        if let paginationData = data["pagination"] as? GPHJSONObject {
            pagination = try GPHPagination.mapData(paginationData, options: options)
        }
        
        var results: [GPHMedia]? = nil
        if let mediaData = data["data"] as? [GPHJSONObject] {
            results = []
            for result in mediaData {
                let result = try GPHMedia.mapData(result, options: options)
                if result.isValidObject() {
                    results?.append(result)
                }
            }
        }
        if results != nil {
            pagination?.updateFilteredCount(results!.count)
        }
        
        // No image and pagination data, return the meta data
        return GPHListMediaResponse(meta, data: results, pagination: pagination)
    }
    
}
