//
//  GPHRequest.swift
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

/// Async Request Operations with Completion Handler Support
///
@objcMembers public class GPHRequest: GPHAsyncOperationWithCompletion {
    // MARK: Properties

    /// Config to form requests.
    var config: GPHRequestConfig
    
    /// The client to which this request is related.
    let client: GPHAbstractClient
    
    var lastRequestStartedAt: Date? = nil
    
    private var retryLimit = 3
    private var retryCount = 0
    private var retryDelay = 1.0
    private var retryDelayPower = 2.0
    
    var hasRequestInFlight: Bool = false
    
    // This flag isn't set until we've receive at least a first response -
    // even if it was empty.
    var hasReceivedAResponse: Bool = false
    
    // This flag is set IFF we have received a failure more recently
    // than a response.
    var hasReceivedAFailure: Bool = false
    
    // This flag is set IFF we have received an empty response, which
    // should indicate that we have "bottomed out" in the paging.
    var hasReceivedEmptyResponse: Bool = false
    
    // MARK: Initializers
    
    /// Convenience Initializer
    ///
    /// - parameter client: GPHClient object to handle the request.
    /// - parameter config: GPHRequestConfig to formulate request(s).
    /// - parameter completionHandler: GPHJSONCompletionHandler to return JSON or Error.
    ///
    init(_ client: GPHAbstractClient, config: GPHRequestConfig, completionHandler: @escaping GPHJSONCompletionHandler) {
        self.client = client
        self.config = config
        self.retryLimit = config.retry
        super.init(completionHandler: completionHandler)
    }
    
    func resetRequest(fireEventImmediately: Bool) {
        
        hasReceivedAResponse = false
        hasReceivedEmptyResponse = false
        hasReceivedAFailure = false
        hasRequestInFlight = false
        
        lastRequestStartedAt = nil
        
        newRequest(force: true)
        
        if fireEventImmediately {
            self.callCompletion(data: nil, response: nil, error: GPHHTTPError(statusCode:101, description: "Reset Request"))
        }
        
    }
    
    func scheduleRetry() {
        
        if self.hasRequestInFlight && state != .finished {
            // A retry is already scheduled, so ignore.
            return
        }
        
        retryCount += 1
        
        // Our retry adopts a simple "exponential backoff" algorithm.
        // Essentially we wait for the square of the retry count, in seconds,
        // although we could tune this if we wanted to.
        // e.g. After the first failure, we wait 1 second,
        // after the second we wait 4 seconds,
        // after the third we wait 9 seconds, etc.
        let retryDelaySeconds = retryDelay * pow(Double(retryCount), retryDelayPower)
        DispatchQueue.main.asyncAfter(deadline: .now() + retryDelaySeconds) {
            self.newRequestFired()
        }
    }
    
    func cancelRetry() {
        self.state = .finished
    }
    
    func newRequestFired() {
        newRequest(force: true)
    }
    
    
    // Initiate a new request if necessary.
    //
    // 1) If force is YES, always create a new request.
    // 2) If force is NO, do not create a new request if there is already a pending retry.
    @discardableResult func newRequest(force: Bool) -> Bool {
        
//        print("New Request retryCount:\(retryCount)")
        if force {
            cancelRetry()
            hasRequestInFlight = false
        }

        if hasRequestInFlight {
            // There already is a request in flight.
            return false
        }

        hasRequestInFlight = true
        lastRequestStartedAt = Date()
        
        self.start()
        return true
    }
    
    func succesfulRequest(data: GPHJSONObject?, response: URLResponse?, error: Error?) {

        self.cancelRetry()
        self.retryCount = 0

        self.hasRequestInFlight = false
        self.hasReceivedAFailure = false
        self.hasReceivedAResponse = true
        
        self.state = .finished
        self.callCompletion(data: data, response: response, error: error)
    }
    
    func failedRequest(retry: Bool = false, data: GPHJSONObject?, response: URLResponse?, error: Error?) {
        
        self.hasRequestInFlight = false
        self.hasReceivedAFailure = true

        if retry {
            if retryCount < retryLimit {
                self.state = .finished
                self.scheduleRetry()
                return
            }
        }
        
        self.retryCount = 0
        self.state = .finished
        self.callCompletion(data: data, response: response, error: error)
    }
    
    
    // MARK: Operation function
    
    /// Override the Operation function main to handle the request
    ///
    override public func main() {
        client.session.dataTask(with: config.getRequest()) { data, response, error in
            
            if self.isCancelled {
                return
            }
            
            #if !os(watchOS)
                if !self.client.isNetworkReachable() {
                    self.failedRequest(retry: true, data: nil, response: response, error: GPHHTTPError(statusCode:100, description: "Network is not reachable"))
                    return
                }
            #endif

            do {
                guard let data = data else {
                    self.failedRequest(retry: true, data: nil, response: response, error:GPHJSONMappingError(description: "Can not map API response to JSON, there is no data"))
                    return
                }
                
                let result = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                
                if let result = result as? GPHJSONObject {
                    // Got the JSON
                    let httpResponse = response! as! HTTPURLResponse
                    // Get the status code from the JSON if available and prefer it over the response code from HTTPURLRespons
                    // If not found return the actual response code from http
                    let statusCode = ((result["meta"] as? GPHJSONObject)?["status"] as? Int) ?? httpResponse.statusCode
                    
                    if httpResponse.statusCode != 200 || statusCode != 200 {
                        // Get the error message from JSON if available.
                        let errorMessage = (result["meta"] as? GPHJSONObject)?["msg"] as? String
                        // Prep the error
                        let errorAPIorHTTP = GPHHTTPError(statusCode: statusCode, description: errorMessage)
                        self.failedRequest(retry: false, data: result, response: response, error: errorAPIorHTTP)
                        return
                    }
                    self.succesfulRequest(data: result, response: response, error: error)
                    
                } else {
                    self.failedRequest(retry: false, data: nil, response: response, error: GPHJSONMappingError(description: "Can not map API response to JSON"))
                }
            } catch {
                self.failedRequest(retry: false, data: nil, response: response, error: error)
            }
            
        }.resume()
    }
}


/// Request Type for URLRequest objects.
///
public enum GPHRequestType: String {
    
    /// POST request
    case post = "POST"
    
    /// GET Request
    case get = "GET"
    
    /// PUT Request
    case put = "PUT"
    
    /// DELETE Request
    case delete = "DELETE"

    /// UPLOAD Request
    case upload = "UPLOAD"
}

/// Router to generate URLRequest objects.
///
public enum GPHRequestRouter {
    /// MARK: Properties
    
    /// Setup the Request: Path, Method, Parameters, Headers)
    case request(String, String, GPHRequestType, [URLQueryItem]?, [String: String]?)
    
    /// HTTP Method type.
    var method: GPHRequestType {
        switch self {
        case .request(_, _, let method, _, _):
            return method
        }
    }
    
    /// Full URL
    var url: URL {
        switch self {
        case .request(let base, let path, _, _, _):
            let baseUrl = URL(string: base)!
            return baseUrl.appendingPathComponent(path)
        }
    }
    
    /// Query Parameters
    var query: [URLQueryItem] {
        switch self {
        case .request(_, _, _, let queryItems, _):
            return queryItems ?? []
        }
    }
    
    /// Custom Headers
    var headers: [String: String] {
        switch self {
        case .request(_, _, _, _, let customHeaders):
            return customHeaders ?? [:]
        }
    }
    
    // MARK: Helper functions
    
    /// Encode a URLQueryItem for including in HTTP requests
    /// (encodes + signs correctly to %2B)
    ///
    /// - parameter queryItem: URLQueryItem to be encoded.
    /// - returns: a URLQueryItem whose value is correctly percent-escaped.
    ///
    public func encodedURLQueryItem(_ queryItem: URLQueryItem) -> URLQueryItem {
        var allowedCharacters: CharacterSet = CharacterSet.urlQueryAllowed
        
        // Removing the characters that AlamoFire removes to match behaviour:
        // https://github.com/Alamofire/Alamofire/blob/master/Source/ParameterEncoding.swift#L236
        
        allowedCharacters.remove(charactersIn: ":#[]@!$&'()*+,;=")
        let encodedValue = queryItem.value?.addingPercentEncoding(withAllowedCharacters: allowedCharacters)
        return URLQueryItem(name: queryItem.name, value: encodedValue)
    }
    

    /// Construct the request from url, method and parameters.
    ///
    /// - parameter apiKey: Api-key for the request.
    /// - returns: A URLRequest object constructed from the current type of the request.
    ///
    public func asURLRequest(_ apiKey: String) -> URLRequest {
        
        var queryItems = query
        queryItems.append(URLQueryItem(name: "api_key", value: apiKey))
        
        // Get the final url
        let finalUrl: URL = {
            switch method {
            case .get:
                var urlComponents = URLComponents(string: url.absoluteString)
                urlComponents?.queryItems = queryItems
                guard let fullUrl = urlComponents?.url else { return url }
                return fullUrl
            default:
                return url
            }
        }()
        
        // Create the request.
        var request = URLRequest(url: finalUrl)
        request.httpMethod = (method == .upload ? "POST" : method.rawValue)
        
        // Add the custom headers.
        for (header, value) in headers {
            request.addValue(value, forHTTPHeaderField: header)
        }
        
        switch method {
        case .post, .delete, .put:
            // Set up request parameters.
            request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "content-type")
            
            var urlComponents = URLComponents(string: url.absoluteString)
            let encodedQueryItems: [URLQueryItem] = queryItems.map { queryItem in
                return encodedURLQueryItem(queryItem)
            }
            urlComponents?.queryItems = encodedQueryItems
            request.httpBody = (urlComponents?.query ?? "").data(using: String.Encoding.utf8)
        case .get:
            request.addValue("application/json", forHTTPHeaderField: "content-type")
        default:
            break
        }
        
        return request
    }
}
