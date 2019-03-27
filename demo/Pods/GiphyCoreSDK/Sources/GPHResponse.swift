//
//  GPHResponse.swift
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

/// Represents a Giphy Response Meta Info
///
@objcMembers open class GPHResponse: NSObject {
    // MARK: Properties

    /// Message description.
    open var meta: GPHMeta
    
    
    // MARK: Initializers
    
    /// Initializer
    ///
    override public init() {
        self.meta = GPHMeta()
        super.init()
    }
    
    /// Convenience Initializer
    ///
    /// - parameter meta: init with a GPHMeta object.
    ///
    convenience public init(_ meta: GPHMeta) {
        self.init()
        self.meta = meta
    }
}

// MARK: Extension -- Human readable

/// Make objects human readable.
///
extension GPHResponse {
    
    override open var description: String {
        return "GPHResponse(\(self.meta.responseId) status: \(self.meta.status) msg: \(self.meta.msg))"
    }
    
}
