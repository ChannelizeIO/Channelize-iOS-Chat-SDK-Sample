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
    /// - parameter config: GPHRequestConfig
    /// - parameter completionHandler: Completion handler to be notified of the request's outcome.
    /// - returns: A cancellable operation.
    ///
    @objc
    @discardableResult public func httpRequest(with config: GPHRequestConfig, completionHandler: @escaping GPHJSONCompletionHandler) -> Operation {
        
        let operation = GPHRequest(self, config: config, completionHandler: completionHandler)
        self.requestQueue.addOperation(operation)
        
        return operation
    }
    
    
    /// Parses a JSON response to an HTTP request expected to return a particular GPHMappable response.
    ///
    /// - parameter config: GPHRequestConfig
    /// - parameter completionHandler: Completion handler to be notified of the request's outcome.
    /// - returns: GPHJSONCompletionHandler to be used as a completion handler for an HTTP request.
    ///
    public class func parseJSONResponse<T>(_ config: GPHRequestConfig,
                                           completionHandler: @escaping ((_ response: T?, _ error: Error?) -> Void)) -> GPHJSONCompletionHandler where T : GPHResponse, T : GPHMappable {
        
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
                let mappableObject: T.GPHMappableObject = try T.mapData(data, options: config.options ?? [:])
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
