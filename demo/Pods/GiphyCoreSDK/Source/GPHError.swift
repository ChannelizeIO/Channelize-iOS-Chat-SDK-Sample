//
//  GPHError.swift
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

/// Custom JSON Mapper Error
///
public struct GPHJSONMappingError: CustomNSError {
    // MARK: Properties

    /// Human readable issue.
    public let description: String
    
    /// Custom error code.
    public var errorCode: Int { return 1001 }
    
    
    // MARK: Initializers

    /// Initializer
    ///
    /// - parameter description: textual description of the error.
    ///
    public init(description: String) {
        self.description = description
    }
    
    
    // MARK: Helpers
    
    /// Creates a string with a detailed representation of the given value, suitable for debugging.
    public static var errorDomain: String = String(reflecting: GPHJSONMappingError.self)
    
    /// NSError style, return the dict for the error with description in place.
    public var errorUserInfo: GPHJSONObject {
        return [
            NSLocalizedDescriptionKey: description
        ]
    }
    
}

/// Custom HTTP Error
///
public struct GPHHTTPError: CustomNSError {
    // MARK: Properties
    
    /// Human readable issue, returned by the server.
    public let description: String?
    
    /// The HTTP status code returned by the server.
    public let statusCode: Int
    
    /// Custom error code.
    public var errorCode: Int { return statusCode }
    

    // MARK: Initializers
    
    /// Initializer
    ///
    /// - parameter statusCode: Status code from the server.
    /// - parameter description: Description returned from the server.
    ///
    public init(statusCode: Int, description: String? = nil) {
        self.statusCode = statusCode
        self.description = description
    }
    
    
    // MARK: Helpers
    
    /// Creates a string with a detailed representation of the given value, suitable for debugging.
    public static var errorDomain: String = String(reflecting: GPHJSONMappingError.self)
    
    /// NSError style, return the dict for the error with description in place.
    public var errorUserInfo: GPHJSONObject {
        var userInfo = GPHJSONObject()
        if let description = description {
            userInfo[NSLocalizedDescriptionKey] = description
        }
        return userInfo
    }

}
