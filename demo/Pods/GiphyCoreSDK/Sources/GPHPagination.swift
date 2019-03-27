//
//  GPHPagination.swift
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

/// Represents a Giphy Response Pagination Info
///
@objcMembers public class GPHPagination: NSObject {
    // MARK: Properties

    /// Total Result Count.
    public private(set) var totalCount: Int
    
    /// Actual Result Count (not always == limit)
    public private(set) var count: Int

    /// Returned (if Filters applied) Result Count (not always == limit)
    public private(set) var filteredCount: Int
    
    /// Offset to start next set of results.
    public private(set) var offset: Int
    
    /// Next Page token
    public private(set) var nextCursor: String?
    
    // MARK: Initializers
    
    /// Initializer
    ///
    override public init() {
        self.totalCount = 0
        self.count = 0
        self.filteredCount = 0
        self.offset = 0
        super.init()
    }
    
    /// Convenience Initializer
    ///
    /// - parameter totalCount: Total number of results available.
    /// - parameter count: Number of results returned.
    /// - parameter offset: Current offset of the result set.
    ///
    convenience init(_ totalCount: Int, count: Int, offset: Int, nextCursor: String? = nil) {
        self.init()
        self.totalCount = totalCount
        self.count = count
        self.filteredCount = count
        self.offset = offset
        self.nextCursor = nextCursor
    }
    
    public func updateFilteredCount(_ count: Int) {
        self.filteredCount = count
    }
    
}

// MARK: Extension -- Human readable

/// Make objects human readable.
///
extension GPHPagination {
    
    override public var description: String {
        return "GPHPagination(totalCount: \(self.totalCount) count: \(self.count) offset: \(self.offset))"
    }
    
}

// MARK: Extension -- Parsing & Mapping

/// For parsing/mapping protocol.
///
extension GPHPagination: GPHMappable {
    
    /// This is where the magic/mapping happens + error handling.
    public static func mapData(_ data: GPHJSONObject, options: [String: Any?]) throws -> GPHPagination {
        
        guard
            let count = data["count"] as? Int
        else {
            throw GPHJSONMappingError(description: "Couldn't map GPHPagination for \(data)")
        }
        
        let totalCount = data["total_count"] as? Int ?? count
        let offset = data["offset"] as? Int ?? 0
        let nextCursor = data["next_cursor"] as? String ?? data["next_page"] as? String
        
        return GPHPagination(totalCount, count: count, offset: offset, nextCursor: nextCursor)
    }
    
}
