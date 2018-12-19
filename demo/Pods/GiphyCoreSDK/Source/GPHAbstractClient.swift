//
//  GPHAbstractClient.swift
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


/// GIPHY Abstract API Client.
///
@objc open class GPHAbstractClient : NSObject {
    // MARK: Properties
    
    /// Giphy API key.
    @objc open var _apiKey: String?

    /// Session
    var session: URLSession
    
    /// Default timeout for network requests. Default: 10 seconds.
    @objc open var timeout: TimeInterval = 10
    
    /// Operation queue used to keep track of network requests.
    let requestQueue: OperationQueue
    
    /// Maximum number of concurrent requests we allow per connection.
    private let maxConcurrentRequestsPerConnection = 4
    
    #if !os(watchOS)
    
    /// Network reachability detecter.
    var reachability: GPHNetworkReachability = GPHNetworkReachability()
    
    /// Network reachability status. Not supported in watchOS.
    @objc open var useReachability: Bool = true
    
    #endif
    
    // MARK: Initialization
    
    /// Initializer
    ///
    /// - parameter apiKey: Application api-key to access GIPHY endpoints.
    ///
    public init(_ apiKey: String?) {
        self._apiKey = apiKey

        var clientHTTPHeaders: [String: String] = [:]
        clientHTTPHeaders["User-Agent"] = GPHAbstractClient.defaultUserAgent()
        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = clientHTTPHeaders
        
        session = Foundation.URLSession(configuration: configuration)
        
        requestQueue = OperationQueue()
        requestQueue.name = "Giphy API Requests"
        requestQueue.maxConcurrentOperationCount = configuration.httpMaximumConnectionsPerHost * maxConcurrentRequestsPerConnection
        
        super.init()
    }
    
    // MARK: Request Methods and Helpers
    
    /// User-agent to be used per client
    ///
    /// - returns: Default User-Agent for the SDK
    ///
    private static func defaultUserAgent() -> String {
        
        guard
            let dictionary = Bundle.main.infoDictionary,
            let version = dictionary["CFBundleShortVersionString"] as? String
            else { return "Giphy SDK (iOS)" }
        return "Giphy SDK v\(version) (iOS)"
    }
    
    
    /// Encode Strings for appending to URLs for endpoints like Term Suggestions/Categories
    ///
    /// - parameter string: String to be encoded.
    /// - returns: A percent encoded string.
    ///
    @objc
    func encodedStringForUrl(_ string: String) -> String {
        
        guard
            let encoded = string.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
            else { return string }
        return encoded
    }

        
    /// Perform a request
    ///
    /// - parameter request: URLRequest
    /// - parameter completionHandler: Completion handler to be notified of the request's outcome.
    /// - returns: A cancellable operation.
    ///
    @objc
    @discardableResult public func httpRequest(with request: URLRequest, completionHandler: @escaping GPHJSONCompletionHandler) -> Operation {
        
        let operation = GPHRequest(self, request: request, completionHandler: completionHandler)
        self.requestQueue.addOperation(operation)
        
        return operation
    }
    

    /// Perform a request to get a single result
    ///
    /// - parameter request: URLRequest
    /// - parameter type: GPHRequestType to figure out what endpoint to hit
    /// - parameter media: GPHMediaType to figure out GIF/Sticker
    /// - parameter completionHandler: Completion handler to be notified of the request's outcome.
    /// - returns: A cancellable operation.
    ///
    @objc
    @discardableResult public func getRequest(with request: URLRequest,
                                       type: String,
                                       media: GPHMediaType,
                                       completionHandler: @escaping GPHCompletionHandler<GPHMediaResponse>) -> Operation {
        
        // Build options for the serializer
        let options:[String: Any?] = [
            "request": type,
            "media": media,
        ]
        
        return self.httpRequest(with: request,
                                completionHandler: GPHAbstractClient.parseJSONResponse(options, completionHandler: completionHandler))

    }
    
    
    /// Perform a request to get a list of results
    ///
    /// - parameter request: URLRequest
    /// - parameter type: GPHRequestType to figure out what endpoint to hit
    /// - parameter media: GPHMediaType to figure out GIF/Sticker
    /// - parameter completionHandler: Completion handler to be notified of the request's outcome.
    /// - returns: A cancellable operation.
    ///
    @objc
    @discardableResult public func listRequest(with request: URLRequest,
                                        type: String,
                                        media: GPHMediaType,
                                        completionHandler: @escaping GPHCompletionHandler<GPHListMediaResponse>) -> Operation {

        // Build options for the serializer
        let options:[String: Any?] = [
            "request": type,
            "media": media,
        ]
        
        return self.httpRequest(with: request,
                                completionHandler: GPHAbstractClient.parseJSONResponse(options, completionHandler: completionHandler))
    }
    
    /// Perform a request to get a list of term suggestions
    ///
    /// - parameter request: URLRequest
    /// - parameter type: GPHRequestType to figure out what endpoint to hit
    /// - parameter media: GPHMediaType to figure out GIF/Sticker
    /// - parameter completionHandler: Completion handler to be notified of the request's outcome.
    /// - returns: A cancellable operation.
    ///
    @objc
    @discardableResult public func listTermSuggestionsRequest(with request: URLRequest,
                                                       type: String,
                                                       media: GPHMediaType,
                                                       completionHandler: @escaping GPHCompletionHandler<GPHListTermSuggestionResponse>) -> Operation {
        
        // Build options for the serializer
        let options:[String: Any?] = [
            "request": type,
            "media": media,
        ]
        
        return self.httpRequest(with: request,
                                completionHandler: GPHAbstractClient.parseJSONResponse(options, completionHandler: completionHandler))
    }

    /// Perform a request to get a list of categories
    ///
    /// - parameter root: GPHCategory for which to obtain subcategories, or nil.
    /// - parameter request: URLRequest
    /// - parameter type: GPHRequestType to figure out what endpoint to hit
    /// - parameter media: GPHMediaType to figure out GIF/Sticker
    /// - parameter completionHandler: Completion handler to be notified of the request's outcome.
    /// - returns: A cancellable operation.
    ///
    @objc
    @discardableResult public func listCategoriesRequest(_ root: GPHCategory? = nil,
                                                  with request: URLRequest,
                                                  type: String,
                                                  media: GPHMediaType,
                                                  completionHandler: @escaping GPHCompletionHandler<GPHListCategoryResponse>) -> Operation {
        
        
        // Build options for the serializer
        let options:[String: Any?] = [
            "root": root,
            "request": type,
            "media": media,
        ]
        
        return self.httpRequest(with: request,
                                completionHandler: GPHAbstractClient.parseJSONResponse(options, completionHandler: completionHandler))
    }
    
    /// Perform a request to get a channels object.
    ///
    /// - parameter type: GPHRequestType to figure out what endpoint to hit
    /// - parameter media: GPHMediaType to figure out GIF/Sticker
    ///
    @objc
    @discardableResult public func channelRequest(with request: URLRequest,
                                              type: String,
                                              media: GPHMediaType,
                                              completionHandler: @escaping GPHCompletionHandler<GPHChannelResponse>) -> Operation {
        
        // Build options for the serializer
        let options:[String: Any?] = [
            "request": type,
            "media": media,
        ]
        
        return self.httpRequest(with: request,
                                completionHandler: GPHAbstractClient.parseJSONResponse(options, completionHandler: completionHandler))
    }
    
    /// Get a list of children of a given channel
    ///
    /// - parameter type: GPHRequestType to figure out what endpoint to hit
    /// - parameter media: GPHMediaType to figure out GIF/Sticker
    ///
    @objc
    @discardableResult public func channelChildrenRequest(with request: URLRequest,
                                              type: String,
                                              media: GPHMediaType,
                                              completionHandler: @escaping GPHCompletionHandler<GPHListChannelResponse>) -> Operation {
        
        // Build options for the serializer
        let options:[String: Any?] = [
            "request": type,
            "media": media,
        ]
        
        return self.httpRequest(with: request,
                                completionHandler: GPHAbstractClient.parseJSONResponse(options, completionHandler: completionHandler))
    }
    
    /// Get a list of gifs for a given channel.
    /// NOTE: this has the same response structure as any other getGifs
    ///
    /// - parameter type: GPHRequestType to figure out what endpoint to hit
    /// - parameter media: GPHMediaType to figure out GIF/Sticker
    ///
    @objc
    @discardableResult public func channelContentRequest(with request: URLRequest,
                                              type: String,
                                              media: GPHMediaType,
                                              completionHandler: @escaping GPHCompletionHandler<GPHListMediaResponse>) -> Operation {
        
        
        // Build options for the serializer
        let options:[String: Any?] = [
            "request": type,
            "media": media,
        ]
        
        return self.httpRequest(with: request,
                                completionHandler: GPHAbstractClient.parseJSONResponse(options, completionHandler: completionHandler))
    }
    
    /// Parses a JSON response to an HTTP request expected to return a particular GPHMappable response.
    ///
    /// - parameter options: dict of objects to be passed around for serialziers.
    /// - parameter completionHandler: Completion handler to be notified of the parser's outcome.
    /// - returns: GPHJSONCompletionHandler to be used as a completion handler for an HTTP request.
    ///
    public class func parseJSONResponse<T>(_ options: [String: Any?],
                                           completionHandler: @escaping GPHCompletionHandler<T>) -> GPHJSONCompletionHandler where T : GPHResponse, T : GPHMappable {
        
        return { (data, response, error) in
            // Error returned
            
            if let error = error as? GPHHTTPError, (error.errorCode < 400 && error.errorCode >= 500) {
                completionHandler(nil, error)
                return
            }
            
            // Handle the (impossible?) case where there is no data back from the server,
            // but there is no error returned
            guard let data = data else {
                completionHandler(nil, GPHJSONMappingError(description: "No data returned from the server, but no error reported."))
                return
            }
            
            do {
                let mappableObject: T.GPHMappableObject = try T.mapData(data, options: options)
                guard let obj = mappableObject as? T else {
                    completionHandler(nil, GPHJSONMappingError(description: "Couldn't cast " + String(describing: T.GPHMappableObject.self) + " to " + String(describing: T.self) + " during JSON response parsing."))
                    return
                }
                completionHandler(obj, error)
            } catch {
                completionHandler(nil, error)
            }
        }
    }
    
    
    #if !os(watchOS)
    
    /// Figure out network connectivity
    ///
    /// - returns: `true` if network is reachable
    ///
    public func isNetworkReachable() -> Bool {
        return !useReachability || reachability.isReachable()
    }
    
    #endif
    
}
