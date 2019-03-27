//
//  GPHMappable.swift
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

/// Protocol to Map JSON > GPH Objects.
/// Make sure Models implement this protocol to be able to map JSON>Obj
public protocol GPHMappable {
    
    /// Generic Mappable object to return.
    associatedtype GPHMappableObject
    
    /// Static function for mapping JSON to objects.
    ///
    /// - parameter options: Dictionary of options (type, root object, media...)
    /// - returns: object: Self
    ///
    static func mapData(_ data: GPHJSONObject, options: [String: Any?]) throws -> GPHMappableObject
}

// MARK: Extension -- Parsing Helper Implementations

/// Extend protocol to have default behavior
/// We will use this to map JSON to particular types of objs we want like Date, URL, ...
public extension GPHMappable {
    
    /// Map a String to a Date.
    ///
    /// - parameter date: String version of the Date to be mapped to Date type
    /// - returns: a Date object or nil
    ///
    public static func parseDate(_ date: String?) -> Date? {
        //"2013-03-21 04:03:08" "2018-06-05T21:46:37.525Z" "2018-08-02T12:00:00Z"
        let dateFormats = ["yyyy-MM-dd HH:mm:ss", "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'", "yyyy-MM-dd'T'HH:mm:ss'Z'"]
        for format in dateFormats {
            if let parsedDate = parseDate(date, format: format) {
                return parsedDate
            }
        }
        return nil
    }
    
    public static func parseDate(_ date: String?, format: String) -> Date? {
        guard let date = date else { return nil }
        let dateFormatter = DateFormatter.standardDateFormatter
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC") ?? TimeZone.current
        dateFormatter.dateFormat = format
        return dateFormatter.date(from: date)
    }

    /// Map a String to a URL.
    ///
    /// - parameter urk: String version of the URL to be mapped to URL type
    /// - returns: a Date object or nil
    ///
    public static func parseURL(_ url: String?) -> URL? {
        if let url = url {
            return URL(string: url)
        }
        return nil
    }
    
    
    /// Map a String to a GPHRatingType.
    ///
    /// - parameter rating: String version of the rating to be mapped to GPHRatingType type
    /// - returns: a GPHRatingType object or nil
    ///
    public static func parseRating(_ rating: String?) -> GPHRatingType {
        if let rating = rating {
            return GPHRatingType(rawValue: rating) ?? .unrated
        }
        return .unrated
    }
    

    /// Map a String to an Int.
    ///
    /// - parameter number: String version of the Int to be mapped to Int type
    /// - returns: a Int object or nil
    ///
    public static func parseInt(_ number: String?) -> Int? {
        if let number = number {
            return Int(number)
        }
        return nil
    }
}

// MARK: Extension -- DateFormatter

/// Create a more performant static instance of DateFormatter

extension DateFormatter {
    fileprivate static let standardDateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        return dateFormatter
    }()
}
