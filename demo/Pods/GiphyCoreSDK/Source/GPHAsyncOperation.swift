//
//  GPHAsyncOperation.swift
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

/// Sub-classing Operation to make sure we manage its state correctly
///
@objcMembers public class GPHAsyncOperation: Operation {
    // MARK: Properties

    /// State enum to use KVO trick. (cool trick from raywenderlich)
    public enum State: String {
        case ready, executing, finished
        
        /// Keypath for KVO
        fileprivate var keyPath: String {
            return "is" + rawValue.capitalized
        }
    }
    
    /// State of the operation.
    open var state = State.ready {
        
        // Using KVO to update state
        willSet {
            willChangeValue(forKey: newValue.keyPath)
            willChangeValue(forKey: state.keyPath)
        }
        didSet {
            didChangeValue(forKey: oldValue.keyPath)
            didChangeValue(forKey: state.keyPath)
        }
    }
}

/// State management
///
extension GPHAsyncOperation {
    // MARK: Properties
    
    /// To handle KVO for ready state
    override open var isReady: Bool {
        return super.isReady && state == .ready
    }
    
    /// To handle KVO for ready executing
    override open var isExecuting: Bool {
        return state == .executing
    }
    
    /// To handle KVO for finished state
    override open var isFinished: Bool {
        return state == .finished
    }
    
    /// Override so we can claim to be async.
    override open var isAsynchronous: Bool {
        return true
    }
    
    /// Override to manage the state correctly for async.
    override open func start() {
        if isCancelled {
            state = .finished
            return
        }
        
        main()
        state = .executing
    }
    
    /// Override to handle canceling so we can change the state to trigger KVO.
    override open func cancel() {
        super.cancel()
        state = .finished
    }
}

/// A specific type of async operation with a completion handler.
///
@objcMembers public class GPHAsyncOperationWithCompletion: GPHAsyncOperation {
    // MARK: Properties

    /// User completion block to be called.
    let completion: GPHJSONCompletionHandler?
    
    init(completionHandler: GPHJSONCompletionHandler?) {
        self.completion = completionHandler
    }
    
    /// Finish this operation.
    /// This method should be called exactly once per operation.
    internal func callCompletion(data: GPHJSONObject?, response: URLResponse?, error: Error?) {
        if !isCancelled {
            if let completion = completion {
                completion(data, response, error)
            }
            state = .finished
        }
    }

}
