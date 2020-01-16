/*
 The MIT License (MIT)

 Copyright (c) 2015-present Badoo Trading Limited.

 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:

 The above copyright notice and this permission notice shall be included in
 all copies or substantial portions of the Software.

 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 THE SOFTWARE.
*/

import Foundation

public protocol TextMessageModelProtocol: DecoratedMessageModelProtocol {
    var text: String { get }
    var quotedUser: String? { get }
    var quotedBody: String? { get }
    var quotedImage: String? { get }
    var taggedUsersDictionary : [String:String]? { get }
    var isDeleted : Bool? { get }
}

open class TextMessageModel<MessageModelT: MessageModelProtocol>: TextMessageModelProtocol {
    
    public var taggedUsersDictionary: [String : String]?
    public var quotedUser: String?
    public var quotedBody: String?
    public var quotedImage: String?
    public var isDeleted: Bool?
    public var messageModel: MessageModelProtocol {
        return self._messageModel
    }
    public let _messageModel: MessageModelT // Can't make messasgeModel: MessageModelT: https://gist.github.com/diegosanchezr/5a66c7af862e1117b556
    public let text: String
    public init(messageModel: MessageModelT, text: String, quoteMessageParameter: [String: Any]? = nil, taggedUsersDictionary : [String:String]? = nil,isDeleted:Bool?) {
        self._messageModel = messageModel
        self.text = text
        self.isDeleted = isDeleted
        if let params = quoteMessageParameter{
            self.quotedUser = params["name"] as? String
            self.quotedBody = params["body"] as? String
            self.quotedImage = params["image"] as? String
        }
        if let taggedDic = taggedUsersDictionary{
            self.taggedUsersDictionary = taggedDic
        }
    }
}
