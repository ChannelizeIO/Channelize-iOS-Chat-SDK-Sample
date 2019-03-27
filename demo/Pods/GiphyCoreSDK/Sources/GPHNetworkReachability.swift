//
//  GPHNetworkReachability.swift
//  GiphyCoreSDK
//
//  Created by Cem Kozinoglu, Gene Goykhman, Giorgia Marenda on 4/24/17.
//  Copyright © 2017 Giphy. All rights reserved.
//
//  This Source Code Form is subject to the terms of the Mozilla Public
//  License, v. 2.0. If a copy of the MPL was not distributed with this
//  file, You can obtain one at http://mozilla.org/MPL/2.0/.
//
// Credit goes to Algolia here:
// https://github.com/algolia/algoliasearch-client-swift/blob/master/Source/NetworkReachability.swift

#if !os(watchOS)
    
    import Foundation
    import SystemConfiguration
    
    
    /// Detects network reachability using the system's built-in mechanism.
    ///
    @objcMembers public class GPHNetworkReachability {
        
        /// Reachability handle used to test connectivity.
        private var reachability: SCNetworkReachability
        
        // MARK: Initialization
        
        public init() {
            // Create reachability handle to an all-zeroes address.
            var zeroAddress = GPHNetworkReachability.zeroAddress
            reachability = withUnsafePointer(to: &zeroAddress) {
                $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {
                    SCNetworkReachabilityCreateWithAddress(nil, $0)
                }
                }!
        }
        
        /// Test if network connectivity is currently available.
        ///
        /// - returns: true if network connectivity is available, false otherwise.
        ///
        public func isReachable() -> Bool {
            var flags: SCNetworkReachabilityFlags = []
            if !SCNetworkReachabilityGetFlags(reachability, &flags) {
                return false
            }
            
            let reachable = flags.contains(.reachable)
            let connectionRequired = flags.contains(.connectionRequired)
            return reachable && !connectionRequired
        }
        
        // MARK: Constants
        
        /// An all zeroes IP address.
        static let zeroAddress: sockaddr_in = {
            var address = sockaddr_in()
            address.sin_len = UInt8(MemoryLayout<sockaddr_in>.size)
            address.sin_family = sa_family_t(AF_INET)
            return address
        }()
    }
    
#endif // !os(watchOS)
