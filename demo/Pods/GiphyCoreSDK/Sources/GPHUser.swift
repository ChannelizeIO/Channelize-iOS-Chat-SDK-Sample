//
//  GPHUser.swift
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

/// Represents a Giphy User Object
///
/// http://api.giphy.com/v1/gifs/categories/animals/cats?api_key=4OMJYpPoYwVpe

@objcMembers public class GPHUser: GPHFilterable, NSCoding {
    // MARK: Properties
    
    /// Username.
    public fileprivate(set) var username: String = ""

    /// User ID.
    public fileprivate(set) var userId: String?

    /// Name of the User.
    public fileprivate(set) var name: String?
    
    /// Description of the User.
    public fileprivate(set) var userDescription: String?

    /// Attribution Display Name.
    public fileprivate(set) var attributionDisplayName: String?
    
    /// Display Name for the User.
    public fileprivate(set) var displayName: String?
    
    /// Twitter Handler.
    public fileprivate(set) var twitter: String?

    /// URL of the Twitter Handler.
    public fileprivate(set) var twitterUrl: String?

    /// URL of the Facebook Handler.
    public fileprivate(set) var facebookUrl: String?

    /// URL of the Instagram Handler.
    public fileprivate(set) var instagramUrl: String?
    
    /// URL of the Website
    public fileprivate(set) var websiteUrl: String?

    /// Displayable URL of the Website.
    public fileprivate(set) var websiteDisplayUrl: String?
    
    /// URL of the Tumblr Handler.
    public fileprivate(set) var tumblrUrl: String?
    
    /// URL of the Avatar.
    public fileprivate(set) var avatarUrl: String?
    
    /// URL of the Banner.
    public fileprivate(set) var bannerUrl: String?
    
    /// URL of the Profile.
    public fileprivate(set) var profileUrl: String?

    /// User Public/Private.
    public fileprivate(set) var isPublic: Bool = false

    /// User is Staff.
    public fileprivate(set) var isStaff: Bool = false
    
    /// User is Verified
    public fileprivate(set) var isVerified: Bool = false
    
    /// Suppress Chrome.
    public fileprivate(set) var suppressChrome: Bool = false
    
    /// Last Login Date/Time.
    public fileprivate(set) var loginDate: Date?
    
    /// Join Date/Time.
    public fileprivate(set) var joinDate: Date?
    
    /// JSON Representation.
    public fileprivate(set) var jsonRepresentation: GPHJSONObject?
    
    /// User Dictionary to Store data in Obj by the Developer
    public var userDictionary: [String: Any]?
    
    // MARK: Initializers
    
    /// Convenience Initializer
    ///
    /// - parameter username: Username of the User.
    ///
    convenience public init(_ username: String) {
        self.init()
        self.username = username
    }
    
    //MARK: NSCoding
    
    required convenience public init?(coder aDecoder: NSCoder) {
        guard
            let username = aDecoder.decodeObject(forKey: "username") as? String
        else {
            return nil
        }
        
        self.init(username)
        
        self.userId = aDecoder.decodeObject(forKey: "userId") as? String
        self.isPublic = aDecoder.decodeBool(forKey: "isPublic")
        self.isStaff = aDecoder.decodeBool(forKey: "isStaff")
        self.isVerified = aDecoder.decodeBool(forKey: "isVerified")
        self.suppressChrome = aDecoder.decodeBool(forKey: "suppressChrome")
        self.name = aDecoder.decodeObject(forKey: "name") as? String
        self.displayName = aDecoder.decodeObject(forKey: "displayName") as? String
        self.userDescription = aDecoder.decodeObject(forKey: "userDescription") as? String
        self.attributionDisplayName = aDecoder.decodeObject(forKey: "attributionDisplayName") as? String
        self.twitter = aDecoder.decodeObject(forKey: "twitter") as? String
        self.twitterUrl = aDecoder.decodeObject(forKey: "twitterUrl") as? String
        self.facebookUrl = aDecoder.decodeObject(forKey: "facebookUrl") as? String
        self.instagramUrl = aDecoder.decodeObject(forKey: "instagramUrl") as? String
        self.websiteUrl = aDecoder.decodeObject(forKey: "websiteUrl") as? String
        self.websiteDisplayUrl = aDecoder.decodeObject(forKey: "websiteDisplayUrl") as? String
        self.tumblrUrl = aDecoder.decodeObject(forKey: "tumblrUrl") as? String
        self.avatarUrl = aDecoder.decodeObject(forKey: "avatarUrl") as? String
        self.bannerUrl = aDecoder.decodeObject(forKey: "bannerUrl") as? String
        self.profileUrl = aDecoder.decodeObject(forKey: "profileUrl") as? String
        self.loginDate = aDecoder.decodeObject(forKey: "loginDate") as? Date
        self.joinDate = aDecoder.decodeObject(forKey: "joinDate") as? Date
        self.jsonRepresentation = aDecoder.decodeObject(forKey: "jsonRepresentation") as? GPHJSONObject
        self.userDictionary = aDecoder.decodeObject(forKey: "userDictionary") as? [String: Any]
    }

    public func encode(with aCoder: NSCoder) {
        aCoder.encode(self.username, forKey: "username")
        aCoder.encode(self.userId, forKey: "userId")
        aCoder.encode(self.isPublic, forKey: "isPublic")
        aCoder.encode(self.isStaff, forKey: "isStaff")
        aCoder.encode(self.isVerified, forKey: "isVerified")
        aCoder.encode(self.suppressChrome, forKey: "suppressChrome")
        aCoder.encode(self.name, forKey: "name")
        aCoder.encode(self.displayName, forKey: "displayName")
        aCoder.encode(self.userDescription, forKey: "userDescription")
        aCoder.encode(self.attributionDisplayName, forKey: "attributionDisplayName")
        aCoder.encode(self.twitter, forKey: "twitter")
        aCoder.encode(self.twitterUrl, forKey: "twitterUrl")
        aCoder.encode(self.facebookUrl, forKey: "facebookUrl")
        aCoder.encode(self.instagramUrl, forKey: "instagramUrl")
        aCoder.encode(self.websiteUrl, forKey: "websiteUrl")
        aCoder.encode(self.websiteDisplayUrl, forKey: "websiteDisplayUrl")
        aCoder.encode(self.tumblrUrl, forKey: "tumblrUrl")
        aCoder.encode(self.avatarUrl, forKey: "avatarUrl")
        aCoder.encode(self.bannerUrl, forKey: "bannerUrl")
        aCoder.encode(self.profileUrl, forKey: "profileUrl")
        aCoder.encode(self.loginDate, forKey: "loginDate")
        aCoder.encode(self.joinDate, forKey: "joinDate")
        aCoder.encode(self.jsonRepresentation, forKey: "jsonRepresentation")
        aCoder.encode(self.userDictionary, forKey: "userDictionary")
    }
    
    // MARK: NSObject

    override public func isEqual(_ object: Any?) -> Bool {
        if object as? GPHUser === self {
            return true
        }
        if let other = object as? GPHUser, self.username == other.username {
            return true
        }
        return false
    }
    
    override public var hash: Int {
        return "gph_user_\(self.username)".hashValue
    }
    
}

// MARK: Extension -- Human readable

/// Make objects human readable.
///
extension GPHUser {
    
    override public var description: String {
        return "GPHUser(\(self.username))"
    }
    
}

// MARK: Extension -- Parsing & Mapping

/// For parsing/mapping protocol.
///
extension GPHUser: GPHMappable {
    
    /// This is where the magic/mapping happens + error handling.
    public static func mapData(_ data: GPHJSONObject, options: [String: Any?]) throws -> GPHUser {
        
        guard
            let username = data["username"] as? String
        else {
            throw GPHJSONMappingError(description: "Couldn't map GPHUser for \(data)")
        }
       
        let obj = GPHUser(username)

        obj.userId = data["id"] as? String
        obj.isPublic = data["is_public"] as? Bool ?? false
        obj.isStaff = data["is_staff"] as? Bool ?? false
        obj.isVerified = data["is_verified"] as? Bool ?? false
        obj.suppressChrome = data["suppress_chrome"] as? Bool ?? false
        obj.name = data["name"] as? String
        obj.displayName = data["display_name"] as? String
        obj.userDescription = data["description"] as? String
        obj.attributionDisplayName = data["attribution_display_name"] as? String
        obj.twitter = data["twitter"] as? String
        obj.twitterUrl = data["twitter_url"] as? String
        obj.facebookUrl = data["facebook_url"] as? String
        obj.instagramUrl = data["instagram_url"] as? String
        obj.websiteUrl = data["website_url"] as? String
        obj.websiteDisplayUrl = data["website_display_url"] as? String
        obj.tumblrUrl = data["tumblr_url"] as? String
        obj.avatarUrl = data["avatar_url"] as? String
        obj.bannerUrl = data["banner_url"] as? String
        obj.profileUrl = data["profile_url"] as? String
        obj.loginDate = parseDate(data["last_login"] as? String)
        obj.joinDate = parseDate(data["date_joined"] as? String)
        obj.jsonRepresentation = data
        
        return obj
    }
    
}
