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

    /// URLRequest obj to handle the networking.
    var request: URLRequest
    
    /// The client to which this request is related.
    let client: GPHAbstractClient
    
    // MARK: Initializers
    
    /// Convenience Initializer
    ///
    /// - parameter client: GPHClient object to handle the request.
    /// - parameter request: URLRequest to execute.
    /// - parameter completionHandler: GPHJSONCompletionHandler to return JSON or Error.
    ///
    init(_ client: GPHAbstractClient, request: URLRequest, completionHandler: @escaping GPHJSONCompletionHandler) {
        self.client = client
        self.request = request
        super.init(completionHandler: completionHandler)
    }
    
    // MARK: Operation function
    
    /// Override the Operation function main to handle the request
    ///
    override public func main() {
        client.session.dataTask(with: request) { data, response, error in
            
            if self.isCancelled {
                return
            }
            
            #if !os(watchOS)
                if !self.client.isNetworkReachable() {
                    self.callCompletion(data: nil, response: response, error: GPHHTTPError(statusCode:100, description: "Network is not reachable"))
                    return
                }
            #endif

            do {
                guard let data = data else {
                    self.callCompletion(data: nil, response: response, error:GPHJSONMappingError(description: "Can not map API response to JSON, there is no data"))
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
                        self.callCompletion(data: result, response: response, error: errorAPIorHTTP)
                        self.state = .finished
                        return
                    }
                    self.callCompletion(data: result, response: response, error: error)
                } else {
                    self.callCompletion(data: nil, response: response, error: GPHJSONMappingError(description: "Can not map API response to JSON"))
                }
            } catch {
                self.callCompletion(data: nil, response: response, error: error)
            }
            
            self.state = .finished
            
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
    case request(String, GPHRequestType, [URLQueryItem]?, [String: String]?)
    
    /// Base endpoint url.
    static let baseURLString = "https://api.giphy.com/v1/"
    
    /// Base upload endpoint url.
    static let baseUploadURLString = "https://upload.giphy.com/v1/"
    
    /// HTTP Method type.
    var method: GPHRequestType {
        switch self {
        case .request(_, let method, _, _):
            return method
        }
    }
    
    /// Full URL
    var url: URL {
        switch self {
        case .request(let path, let method, _, _):
            let baseUrl = (method == .upload ? URL(string: GPHRequestRouter.baseUploadURLString)! :
                                               URL(string: GPHRequestRouter.baseURLString)!)
            return baseUrl.appendingPathComponent(path)
        }
    }
    
    /// Query Parameters
    var query: [URLQueryItem] {
        switch self {
        case .request(_, _, let queryItems, _):
            return queryItems ?? []
        }
    }
    
    /// Custom Headers
    var headers: [String: String] {
        switch self {
        case .request(_, _, _, let customHeaders):
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
