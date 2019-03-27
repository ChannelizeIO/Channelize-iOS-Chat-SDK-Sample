//
//  GPHRequestConfig.swift
//  GiphyCoreSDK
//
//  Created by Cem Kozinoglu on 3/15/18.
//  Copyright © 2018 Giphy. All rights reserved.
//

import Foundation


@objcMembers public class GPHRequestConfig:NSObject {
    
    public var base = "https://api.giphy.com/v1/"
    public var method: GPHRequestType = .get
    public var queryItems: [URLQueryItem]? = nil
    public var headers: [String: String]? = nil
    public var path: String = ""
    public var requestType: String = ""
    public var options: [String: Any?]? = nil
    public var apiKey: String = ""
    public var retry: Int = 3
    
    public func getRequest() -> URLRequest {
        return GPHRequestRouter.request(base, path, method, queryItems, headers).asURLRequest(apiKey)
    }
}
