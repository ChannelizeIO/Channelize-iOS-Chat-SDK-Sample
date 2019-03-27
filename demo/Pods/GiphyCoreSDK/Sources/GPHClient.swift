//
//  GPHClient.swift
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

/// A JSON object.
public typealias GPHJSONObject = [String: Any]

//MARK: Generic Request & Completion Handlers

/// JSON/Error signature of generic request method
///
/// - parameter data: The JSON response (in case of success) or `nil` (in case of error).
/// - parameter response: The URLResponse object
/// - parameter error: The encountered error (in case of error) or `nil` (in case of success).
///
public typealias GPHJSONCompletionHandler = (_ data: GPHJSONObject?, _ response: URLResponse?, _ error: Error?) -> Void

/// Generic Completion Handler which accepts a Response type
///
/// - parameter response: Generic Response (GPHResponse, GPHMediaResponse..)
/// - parameter error: The encountered error (in case of error) or `nil` (in case of success).
///
//public typealias GPHCompletionHandler<T> = (_ response: T?, _ error: Error?) -> Void


/// Entry point into the Swift API.
///
@objc public class GPHClient : GPHAbstractClient {
    // MARK: Properties
    
    /// Giphy API key.
    @objc public var apiKey: String {
        get { return _apiKey! }
        set { _apiKey = newValue }
    }
    
    /// Initializer
    ///
    /// - parameter apiKey: Apps api-key to access end-points.
    ///
    @objc public init(apiKey: String) {
        super.init(apiKey)
    }
    
    //MARK: Search Endpoint
    
    /// Perform a search.
    ///
    /// - parameter query: Search parameters.
    /// - parameter media: Media type (default: .gif)
    /// - parameter offset: Offset of results (default: 0)
    /// - parameter limit: Total hits you request (default: 25)
    /// - parameter rating: maximum rating of returned content (default R)
    /// - parameter lang: Language of the content (default English)
    /// - parameter completionHandler: Completion handler to be notified of the request's outcome.
    /// - returns: A cancellable operation.
    ///
    @objc
    @discardableResult public func search(_ query: String,
                                   media: GPHMediaType = .gif,
                                   offset: Int = 0,
                                   limit: Int = 25,
                                   rating: GPHRatingType = .ratedR,
                                   lang: GPHLanguageType = .english,
                                   completionHandler: @escaping (_ response: GPHListMediaResponse?, _ error: Error?) -> Void) -> Operation {
    
        let config = GPHRequestConfig()
        
        // Build the request endpoint
        config.queryItems = [
            URLQueryItem(name: "q", value: query),
            URLQueryItem(name: "offset", value: "\(offset)"),
            URLQueryItem(name: "limit", value: "\(limit)"),
            URLQueryItem(name: "rating", value: rating.rawValue),
            URLQueryItem(name: "lang", value: lang.rawValue),
        ]
        config.path = "\(media.rawValue)s/search"
        config.method = .get
        config.apiKey = apiKey
        config.options = [
            "request": "search",
            "media": media,
        ]
        
        return self.httpRequest(with: config,
                                completionHandler: GPHAbstractClient.parseJSONResponse(config, completionHandler: completionHandler))
    }
    
    
    //MARK: Trending Endpoint
    
    /// Trending
    ///
    /// - parameter media: Media type (default: .gif)
    /// - parameter offset: offset of results (default: 0)
    /// - parameter limit: total hits you request (default: 25)
    /// - parameter rating: maximum rating of returned content (default R)
    /// - parameter completionHandler: Completion handler to be notified of the request's outcome.
    /// - returns: A cancellable operation.
    ///
    @objc
    @discardableResult public func trending(_  media: GPHMediaType = .gif,
                                     offset: Int = 0,
                                     limit: Int = 25,
                                     rating: GPHRatingType = .ratedR,
                                     completionHandler: @escaping (_ response: GPHListMediaResponse?, _ error: Error?) -> Void) -> Operation {
        
        let config = GPHRequestConfig()
        
        // Build the request endpoint
        config.queryItems = [
            URLQueryItem(name: "offset", value: "\(offset)"),
            URLQueryItem(name: "limit", value: "\(limit)"),
            URLQueryItem(name: "rating", value: rating.rawValue),
        ]
        config.path = "\(media.rawValue)s/trending"
        config.method = .get
        config.apiKey = apiKey
        config.options = [
            "request": "trending",
            "media": media,
        ]
        
        return self.httpRequest(with: config,
                                completionHandler: GPHAbstractClient.parseJSONResponse(config, completionHandler: completionHandler))
    }
    
    
    //MARK: Translate Endpoint
    
    /// Translate
    ///
    /// - parameter term: term or phrase to translate into a GIF|Sticker
    /// - parameter media: Media type (default: .gif)
    /// - parameter rating: maximum rating of returned content (default R)
    /// - parameter lang: language of the content (default English)
    /// - parameter completionHandler: Completion handler to be notified of the request's outcome.
    /// - returns: A cancellable operation.
    ///
    @objc
    @discardableResult public func translate(_ term: String,
                                      media: GPHMediaType = .gif,
                                      rating: GPHRatingType = .ratedR,
                                      lang: GPHLanguageType = .english,
                                      completionHandler: @escaping (_ response: GPHMediaResponse?, _ error: Error?) -> Void) -> Operation {
    
        
        let config = GPHRequestConfig()
        
        // Build the request endpoint
        config.queryItems = [
            URLQueryItem(name: "s", value: term),
            URLQueryItem(name: "rating", value: rating.rawValue),
            URLQueryItem(name: "lang", value: lang.rawValue),
        ]
        config.path = "\(media.rawValue)s/translate"
        config.method = .get
        config.apiKey = apiKey
        config.options = [
            "request": "translate",
            "media": media,
        ]

        return self.httpRequest(with: config,
                                completionHandler: GPHAbstractClient.parseJSONResponse(config, completionHandler: completionHandler))
    }
    
    
    //MARK: Random Endpoint
    
    /// Random
    ///
    /// Example: http://api.giphy.com/v1/gifs/random?api_key=dc6zaTOxFJmzC&tag=cats
    /// - parameter query: Search parameters.
    /// - parameter media: Media type (default: .gif)
    /// - parameter rating: maximum rating of returned content (default R)
    /// - parameter completionHandler: Completion handler to be notified of the request's outcome.
    /// - returns: A cancellable operation.
    ///
    @objc
    @discardableResult public func random(_ query: String,
                                   media: GPHMediaType = .gif,
                                   rating: GPHRatingType = .ratedR,
                                   completionHandler: @escaping (_ response: GPHMediaResponse?, _ error: Error?) -> Void) -> Operation {
    
        let config = GPHRequestConfig()
        
        // Build the request endpoint
        config.queryItems = [
            URLQueryItem(name: "tag", value: query),
            URLQueryItem(name: "rating", value: rating.rawValue),
        ]
        config.path = "\(media.rawValue)s/random"
        config.method = .get
        config.apiKey = apiKey
        config.options = [
            "request": "random",
            "media": media,
        ]
        
        return self.httpRequest(with: config,
                                completionHandler: GPHAbstractClient.parseJSONResponse(config, completionHandler: completionHandler))
    }
    
    
    //MARK: GIFs by ID(s)
    
    /// GIF by ID
    ///
    /// - parameter id: GIF ID.
    /// - parameter completionHandler: Completion handler to be notified of the request's outcome.
    /// - returns: A cancellable operation.
    ///
    @objc
    @discardableResult public func gifByID(_ id: String,
                                    completionHandler: @escaping (_ response: GPHMediaResponse?, _ error: Error?) -> Void) -> Operation {
        
        let config = GPHRequestConfig()
        
        // Build the request endpoint
        config.path = "gifs/\(id)"
        config.method = .get
        config.apiKey = apiKey
        config.options = [
            "request": "get",
            "media": GPHMediaType.gif,
        ]
        
        return self.httpRequest(with: config,
                                completionHandler: GPHAbstractClient.parseJSONResponse(config, completionHandler: completionHandler))
    }
    
    
    /// GIFs by IDs
    ///
    /// - parameter ids: array of GIF IDs.
    /// - parameter completionHandler: Completion handler to be notified of the request's outcome.
    /// - returns: A cancellable operation.
    ///
    @objc
    @discardableResult public func gifsByIDs(_ ids: [String],
                                     completionHandler: @escaping (_ response: GPHListMediaResponse?, _ error: Error?) -> Void) -> Operation {
    
        
        let config = GPHRequestConfig()
        
        // Build the request endpoint
        config.queryItems = [
            URLQueryItem(name: "ids", value: ids.joined(separator:","))
        ]
        config.path = "gifs"
        config.method = .get
        config.apiKey = apiKey
        config.options = [
            "request": "getAll",
            "media": GPHMediaType.gif,
        ]
        
        return self.httpRequest(with: config,
                                completionHandler: GPHAbstractClient.parseJSONResponse(config, completionHandler: completionHandler))
    }
    
    //MARK: Categories Endpoint
    
    /// Top Categories for GIFs
    ///
    /// - parameter offset: offset of results (default: 0)
    /// - parameter limit: total hits you request (default: 25)
    /// - parameter sort: API-specific sorting convention to use (default: blank)
    /// - parameter completionHandler: Completion handler to be notified of the request's outcome.
    /// - returns: A cancellable operation.
    ///
    @objc
    @discardableResult public func categoriesForGifs(_  offset: Int = 0,
                                                        limit: Int = 25,
                                                        sort: String = "",
                                                        completionHandler: @escaping (_ response: GPHListCategoryResponse?, _ error: Error?) -> Void) -> Operation {
        
        let config = GPHRequestConfig()
        
        // Build the request endpoint
        config.queryItems = [
            URLQueryItem(name: "sort", value: "\(sort)"),
            URLQueryItem(name: "offset", value: "\(offset)"),
            URLQueryItem(name: "limit", value: "\(limit)"),
        ]
        config.path = "gifs/categories"
        config.method = .get
        config.apiKey = apiKey
        config.options = [
            "request": "categories",
            "media": GPHMediaType.gif,
            "root": nil,
        ]
        
        return self.httpRequest(with: config,
                                completionHandler: GPHAbstractClient.parseJSONResponse(config, completionHandler: completionHandler))
    }
    
    /// Sub-Categories for GIFs
    ///
    /// - parameter category: top category to get sub-categories from
    /// - parameter offset: offset of results (default: 0)
    /// - parameter limit: total hits you request (default: 25)
    /// - parameter sort: API-specific sorting convention to use (default: blank)
    /// - parameter completionHandler: Completion handler to be notified of the request's outcome.
    /// - returns: A cancellable operation.
    ///
    @objc
    @discardableResult public func subCategoriesForGifs(_ category: String,
                                                          offset: Int = 0,
                                                          limit: Int = 25,
                                                          sort: String = "",
                                                          completionHandler: @escaping (_ response: GPHListCategoryResponse?, _ error: Error?) -> Void) -> Operation {
        
        // root
        let categoryObj = GPHCategory(category, nameEncoded: encodedStringForUrl(category), encodedPath:encodedStringForUrl(category))

        
        let config = GPHRequestConfig()
        
        // Build the request endpoint
        config.queryItems = [
            URLQueryItem(name: "sort", value: "\(sort)"),
            URLQueryItem(name: "offset", value: "\(offset)"),
            URLQueryItem(name: "limit", value: "\(limit)"),
        ]
        config.path = "gifs/categories/\(categoryObj.encodedPath)"
        config.method = .get
        config.apiKey = apiKey
        config.options = [
            "request": "subCategories",
            "media": GPHMediaType.gif,
            "root": categoryObj,
        ]
        
        return self.httpRequest(with: config,
                                completionHandler: GPHAbstractClient.parseJSONResponse(config, completionHandler: completionHandler))
    }
    
    /// Category Content (only works with Sub-categories / top categories won't return content)
    ///
    /// - parameter category: top category
    /// - parameter subCategory: sub-category to get contents from
    /// - parameter offset: offset of results (default: 0)
    /// - parameter limit: total hits you request (default: 25)
    /// - parameter rating: maximum rating of returned content (default R)
    /// - parameter lang: language of the content (default English)
    /// - parameter completionHandler: Completion handler to be notified of the request's outcome.
    /// - returns: A cancellable operation.
    ///
    @objc
    @discardableResult public func gifsByCategory(_ category: String,
                                                    subCategory: String,
                                                    offset: Int = 0,
                                                    limit: Int = 25,
                                                    rating: GPHRatingType = .ratedR,
                                                    lang: GPHLanguageType = .english,
                                                    completionHandler: @escaping (_ response: GPHListMediaResponse?, _ error: Error?) -> Void) -> Operation {
        
        let encodedPath = "\(encodedStringForUrl(category))/\(encodedStringForUrl(subCategory))"
        let categoryObj = GPHCategory(category, nameEncoded: encodedStringForUrl(category), encodedPath:encodedPath)
        
        let config = GPHRequestConfig()
        
        // Build the request endpoint
        config.queryItems = [
            URLQueryItem(name: "offset", value: "\(offset)"),
            URLQueryItem(name: "limit", value: "\(limit)"),
            URLQueryItem(name: "rating", value: rating.rawValue),
            URLQueryItem(name: "lang", value: lang.rawValue),
        ]
        config.path = "gifs/categories/\(categoryObj.encodedPath)"
        config.method = .get
        config.apiKey = apiKey
        config.options = [
            "request": "categoryContent",
            "media": GPHMediaType.gif,
        ]

        return self.httpRequest(with: config,
                                completionHandler: GPHAbstractClient.parseJSONResponse(config, completionHandler: completionHandler))
    }
    
    //MARK: Term Suggestion Endpoint
    
    /// Term Suggestions
    ///
    /// - parameter term: Word/Words
    /// - parameter completionHandler: Completion handler to be notified of the request's outcome.
    /// - returns: A cancellable operation.
    ///
    @objc
    @discardableResult public func termSuggestions(_ term: String,
                                                   completionHandler: @escaping (_ response: GPHListTermSuggestionResponse?, _ error: Error?) -> Void) -> Operation {
        
        let config = GPHRequestConfig()
        
        // Build the request endpoint
        config.path = "queries/suggest/\(term)"
        config.method = .get
        config.apiKey = apiKey
        config.options = [
            "request": "termSuggestions",
            "media": GPHMediaType.gif,
        ]
        
        return self.httpRequest(with: config,
                                completionHandler: GPHAbstractClient.parseJSONResponse(config, completionHandler: completionHandler))
    }
    
    /// Get a channel by id
    ///
    /// - parameter channelId: channel id
    /// - parameter media: the media type gif/stickers
    /// - parameter completionHandler: Completion handler to be notified of the request's outcome.
    /// - returns: A cancellable operation.
    ///
    @objc
    @discardableResult public func channel(_ channelId: Int,
                                          media: GPHMediaType,
                                          completionHandler: @escaping (_ response: GPHChannelResponse?, _ error: Error?) -> Void) -> Operation {
        
        let config = GPHRequestConfig()
        
        // Build the request endpoint
        config.path = "stickers/packs/\(channelId)"
        config.method = .get
        config.apiKey = apiKey
        config.options = [
            "request": "channel",
            "media": media,
        ]
        
        return self.httpRequest(with: config,
                                completionHandler: GPHAbstractClient.parseJSONResponse(config, completionHandler: completionHandler))
    }
    
    /// Get a channel children
    ///
    /// - parameter channelId: channel id
    /// - parameter offset: Offset of results (default: 0)
    /// - parameter limit: Total hits you request (default: 25)
    /// - parameter media: the media type gif/stickers
    /// - parameter completionHandler: Completion handler to be notified of the request's outcome.
    /// - returns: A cancellable operation.
    ///
    @objc
    @discardableResult public func channelChildren(_ channelId: Int,
                                              offset: Int = 0,
                                              limit: Int = 25,
                                              media: GPHMediaType,
                                              completionHandler: @escaping (_ response: GPHListChannelResponse?, _ error: Error?) -> Void) -> Operation {
        
        let config = GPHRequestConfig()
        
        // Build the request endpoint
        config.queryItems = [
            URLQueryItem(name: "offset", value: "\(offset)"),
            URLQueryItem(name: "limit", value: "\(limit)"),
        ]
        config.path = "stickers/packs/\(channelId)/children"
        config.method = .get
        config.apiKey = apiKey
        config.options = [
            "request": "channelChildren",
            "media": media,
        ]

        return self.httpRequest(with: config,
                                completionHandler: GPHAbstractClient.parseJSONResponse(config, completionHandler: completionHandler))
    }

    /// Get a channel gifs
    ///
    /// - parameter channelId: channel id
    /// - parameter offset: Offset of results (default: 0)
    /// - parameter limit: Total hits you request (default: 25)
    /// - parameter completionHandler: Completion handler to be notified of the request's outcome.
    /// - returns: A cancellable operation.
    ///
    @objc
    @discardableResult public func channelContent(_ channelId: Int,
                                              offset: Int = 0,
                                              limit: Int = 25,
                                              media: GPHMediaType,
                                              completionHandler: @escaping (_ response: GPHListMediaResponse?, _ error: Error?) -> Void) -> Operation {
        
        let config = GPHRequestConfig()
        
        // Build the request endpoint
        config.queryItems = [
            URLQueryItem(name: "offset", value: "\(offset)"),
            URLQueryItem(name: "limit", value: "\(limit)"),
        ]
        config.path = "stickers/packs/\(channelId)/stickers"
        config.method = .get
        config.apiKey = apiKey
        config.options = [
            "request": "channel",
            "media": media,
        ]
        
        return self.httpRequest(with: config,
                                completionHandler: GPHAbstractClient.parseJSONResponse(config, completionHandler: completionHandler))
    }

}
