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
public typealias GPHCompletionHandler<T> = (_ response: T?, _ error: Error?) -> Void


/// Entry point into the Swift API.
///
@objcMembers public class GPHClient : GPHAbstractClient {
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
                                   completionHandler: @escaping GPHCompletionHandler<GPHListMediaResponse>) -> Operation {
    
        // Build the request endpoint
        let queryItems:[URLQueryItem] = [
            URLQueryItem(name: "q", value: query),
            URLQueryItem(name: "offset", value: "\(offset)"),
            URLQueryItem(name: "limit", value: "\(limit)"),
            URLQueryItem(name: "rating", value: rating.rawValue),
            URLQueryItem(name: "lang", value: lang.rawValue),
        ]
        
        let request = GPHRequestRouter.request("\(media.rawValue)s/search", .get, queryItems, nil).asURLRequest(apiKey)
        return self.listRequest(with: request, type: "search", media: media, completionHandler: completionHandler)
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
                                     completionHandler: @escaping GPHCompletionHandler<GPHListMediaResponse>) -> Operation {
        
        // Build the request endpoint
        let queryItems:[URLQueryItem] = [
            URLQueryItem(name: "offset", value: "\(offset)"),
            URLQueryItem(name: "limit", value: "\(limit)"),
            URLQueryItem(name: "rating", value: rating.rawValue),
        ]
        let request = GPHRequestRouter.request("\(media.rawValue)s/trending", .get, queryItems, nil).asURLRequest(apiKey)
        return self.listRequest(with: request, type: "trending", media: media, completionHandler: completionHandler)
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
                                      completionHandler: @escaping GPHCompletionHandler<GPHMediaResponse>) -> Operation {
    
        // Build the request endpoint
        let queryItems:[URLQueryItem] = [
            URLQueryItem(name: "s", value: term),
            URLQueryItem(name: "rating", value: rating.rawValue),
            URLQueryItem(name: "lang", value: lang.rawValue),
        ]
        let request = GPHRequestRouter.request("\(media.rawValue)s/translate", .get, queryItems, nil).asURLRequest(apiKey)
        return self.getRequest(with: request, type: "translate", media: media, completionHandler: completionHandler)
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
                                   completionHandler: @escaping GPHCompletionHandler<GPHMediaResponse>) -> Operation {
    
        
        // Build the request endpoint
        let queryItems:[URLQueryItem] = [
            URLQueryItem(name: "tag", value: query),
            URLQueryItem(name: "rating", value: rating.rawValue),
        ]
        let request = GPHRequestRouter.request("\(media.rawValue)s/random", .get, queryItems, nil).asURLRequest(apiKey)
        return self.getRequest(with: request, type: "random", media: media, completionHandler: completionHandler)
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
                                    completionHandler: @escaping GPHCompletionHandler<GPHMediaResponse>) -> Operation {
        
        let request = GPHRequestRouter.request("gifs/\(id)", .get, nil, nil).asURLRequest(apiKey)
        return self.getRequest(with: request, type: "get", media: .gif, completionHandler: completionHandler)
    }
    
    
    /// GIFs by IDs
    ///
    /// - parameter ids: array of GIF IDs.
    /// - parameter completionHandler: Completion handler to be notified of the request's outcome.
    /// - returns: A cancellable operation.
    ///
    @objc
    @discardableResult public func gifsByIDs(_ ids: [String],
                                     completionHandler: @escaping GPHCompletionHandler<GPHListMediaResponse>) -> Operation {
    

        // Build the request endpoint
        let queryItems:[URLQueryItem] = [
            URLQueryItem(name: "ids", value: ids.joined(separator:","))
        ]
        let request = GPHRequestRouter.request("gifs", .get, queryItems, nil).asURLRequest(apiKey)
        return self.listRequest(with: request, type: "getAll", media: .gif, completionHandler: completionHandler)
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
                                                        completionHandler: @escaping GPHCompletionHandler<GPHListCategoryResponse>) -> Operation {
        
        // Build the request endpoint
        let queryItems:[URLQueryItem] = [
            URLQueryItem(name: "sort", value: "\(sort)"),
            URLQueryItem(name: "offset", value: "\(offset)"),
            URLQueryItem(name: "limit", value: "\(limit)"),
        ]
        let request = GPHRequestRouter.request("gifs/categories", .get, queryItems, nil).asURLRequest(apiKey)
        return self.listCategoriesRequest(with: request, type: "categories", media: .gif, completionHandler: completionHandler)
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
                                                          completionHandler: @escaping GPHCompletionHandler<GPHListCategoryResponse>) -> Operation {
        
        let categoryObj = GPHCategory(category, nameEncoded: encodedStringForUrl(category), encodedPath:encodedStringForUrl(category))
        
        // Build the request endpoint
        let queryItems:[URLQueryItem] = [
            URLQueryItem(name: "sort", value: "\(sort)"),
            URLQueryItem(name: "offset", value: "\(offset)"),
            URLQueryItem(name: "limit", value: "\(limit)"),
        ]
        let request = GPHRequestRouter.request("gifs/categories/\(categoryObj.encodedPath)", .get, queryItems, nil).asURLRequest(apiKey)
        return self.listCategoriesRequest(categoryObj, with: request, type: "subCategories", media: .gif, completionHandler: completionHandler)
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
                                                    completionHandler: @escaping GPHCompletionHandler<GPHListMediaResponse>) -> Operation {
        
        let encodedPath = "\(encodedStringForUrl(category))/\(encodedStringForUrl(subCategory))"
        let categoryObj = GPHCategory(category, nameEncoded: encodedStringForUrl(category), encodedPath:encodedPath)
        
        // Build the request endpoint
        let queryItems:[URLQueryItem] = [
            URLQueryItem(name: "offset", value: "\(offset)"),
            URLQueryItem(name: "limit", value: "\(limit)"),
            URLQueryItem(name: "rating", value: rating.rawValue),
            URLQueryItem(name: "lang", value: lang.rawValue),
        ]
        let request = GPHRequestRouter.request("gifs/categories/\(categoryObj.encodedPath)", .get, queryItems, nil).asURLRequest(apiKey)
        return self.listRequest(with: request, type: "categoryContent", media: .gif, completionHandler: completionHandler)
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
                                                   completionHandler: @escaping GPHCompletionHandler<GPHListTermSuggestionResponse>) -> Operation {
        
        let request = GPHRequestRouter.request("queries/suggest/\(term)", .get, nil, nil).asURLRequest(apiKey)
        return self.listTermSuggestionsRequest(with: request, type: "termSuggestions", media: .gif, completionHandler: completionHandler)
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
                                          completionHandler: @escaping GPHCompletionHandler<GPHChannelResponse>) -> Operation {
        
        let request = GPHRequestRouter.request("stickers/packs/\(channelId)", .get, nil, nil).asURLRequest(apiKey)
        return self.channelRequest(with: request, type: "channel", media: media, completionHandler: completionHandler)
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
                                              completionHandler: @escaping GPHCompletionHandler<GPHListChannelResponse>) -> Operation {
        
        // Build the request endpoint
        let queryItems:[URLQueryItem] = [
            URLQueryItem(name: "offset", value: "\(offset)"),
            URLQueryItem(name: "limit", value: "\(limit)"),
        ]
        let request = GPHRequestRouter.request("stickers/packs/\(channelId)/children", .get, queryItems, nil).asURLRequest(apiKey)
        return self.channelChildrenRequest(with: request, type: "channelChildren", media: media, completionHandler: completionHandler)
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
                                              completionHandler: @escaping GPHCompletionHandler<GPHListMediaResponse>) -> Operation {
        
        
        // Build the request endpoint
        let queryItems:[URLQueryItem] = [
            URLQueryItem(name: "offset", value: "\(offset)"),
            URLQueryItem(name: "limit", value: "\(limit)"),
        ]
        let request = GPHRequestRouter.request("stickers/packs/\(channelId)/stickers", .get, queryItems, nil).asURLRequest(apiKey)
        return self.channelContentRequest(with: request, type: "channel", media: media, completionHandler: completionHandler)
    }

}
