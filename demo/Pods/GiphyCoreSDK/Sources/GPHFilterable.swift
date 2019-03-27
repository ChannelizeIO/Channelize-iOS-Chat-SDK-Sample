//
//  GPHFilterable.swift
//  GiphyCoreSDK
//
//  Created by Cem Kozinoglu on 2/26/18.
//  Copyright © 2018 Giphy. All rights reserved.
//
//  This Source Code Form is subject to the terms of the Mozilla Public
//  License, v. 2.0. If a copy of the MPL was not distributed with this
//  file, You can obtain one at http://mozilla.org/MPL/2.0/.
//

import Foundation

public typealias GPHFilterBlock = (_ obj: GPHFilterable) -> Bool

@objc
open class GPHFilterable: NSObject {
    
    @objc public static var filter:GPHFilterBlock? = nil
    
    @objc public func isValidObject() -> Bool {
        if let filter = GPHFilterable.filter {
            return filter(self)
        }
        return true
    }
}
