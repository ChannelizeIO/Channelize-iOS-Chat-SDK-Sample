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

import UIKit
import Chatto
import SDWebImage
public protocol TextBubbleViewStyleProtocol {
    func bubbleImage(viewModel: TextMessageViewModelProtocol, isSelected: Bool) -> UIImage
    func bubbleImageBorder(viewModel: TextMessageViewModelProtocol, isSelected: Bool) -> UIImage?
    func textFont(viewModel: TextMessageViewModelProtocol, isSelected: Bool) -> UIFont
    func textColor(viewModel: TextMessageViewModelProtocol, isSelected: Bool) -> UIColor
    func baseColor(viewModel: TextMessageViewModelProtocol) -> UIColor
    func textInsets(viewModel: TextMessageViewModelProtocol, isSelected: Bool) -> UIEdgeInsets
}

public final class TextBubbleView: UIView, MaximumLayoutWidthSpecificable, BackgroundSizingQueryable {
    
    public var preferredMaxLayoutWidth: CGFloat = 0
    public var animationDuration: CFTimeInterval = 0.33
    public var viewContext: ViewContext = .normal {
        didSet {
            if self.viewContext == .sizing {
                self.textView.dataDetectorTypes = .all//UIDataDetectorTypes()
                self.textView.isSelectable = true
            } else {
                self.textView.dataDetectorTypes = .all
                self.textView.isSelectable = true
            }
        }
    }
    
    public var style: TextBubbleViewStyleProtocol! {
        didSet {
            self.updateViews()
        }
    }
    
    public var textMessageViewModel: TextMessageViewModelProtocol! {
        didSet {
            self.accessibilityIdentifier = self.textMessageViewModel.bubbleAccessibilityIdentifier
            self.updateViews()
        }
    }
    
    public var selected: Bool = false {
        didSet {
            if self.selected != oldValue {
                self.updateViews()
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInit()
    }
    
    private func commonInit() {
        self.addSubview(self.bubbleImageView)
        self.addSubview(self.textView)
        self.addSubview(self.quoteMessageView)
        self.textView.delegate = self
    }
    
    private lazy var bubbleImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.addSubview(self.borderImageView)
        return imageView
    }()
    
    private lazy var quoteMessageView: QuoteMessageView = {
        let view = QuoteMessageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    
    private var borderImageView: UIImageView = UIImageView()
    private var textView: UITextView = {
        let textView = ChatMessageTextView()
        UIView.performWithoutAnimation({ () -> Void in // fixes iOS 8 blinking when cell appears
            textView.backgroundColor = UIColor.clear
        })
        textView.isEditable = false
        textView.isSelectable = true
        textView.dataDetectorTypes = .all
        textView.scrollsToTop = false
        textView.isScrollEnabled = false
        textView.bounces = false
        textView.bouncesZoom = false
        textView.showsHorizontalScrollIndicator = false
        textView.showsVerticalScrollIndicator = false
        textView.isExclusiveTouch = true
        textView.textContainer.lineFragmentPadding = 0
        return textView
    }()
    
    public private(set) var isUpdating: Bool = false
    public func performBatchUpdates(_ updateClosure: @escaping () -> Void, animated: Bool, completion: (() -> Void)?) {
        self.isUpdating = true
        let updateAndRefreshViews = {
            updateClosure()
            self.isUpdating = false
            self.updateViews()
            if animated {
                self.layoutIfNeeded()
            }
        }
        if animated {
            UIView.animate(withDuration: self.animationDuration, animations: updateAndRefreshViews, completion: { (_) -> Void in
                completion?()
            })
        } else {
            updateAndRefreshViews()
        }
    }
    
    private func updateViews() {
        if self.viewContext == .sizing { return }
        if isUpdating { return }
        guard let style = self.style else { return }
        
        self.updateTextView()
        let bubbleImage = style.bubbleImage(viewModel: self.textMessageViewModel, isSelected: self.selected)
        let borderImage = style.bubbleImageBorder(viewModel: self.textMessageViewModel, isSelected: self.selected)
        if self.bubbleImageView.image != bubbleImage { self.bubbleImageView.image = bubbleImage }
        if self.borderImageView.image != borderImage { self.borderImageView.image = borderImage }
    }
    
    private func updateTextView() {
        guard let style = self.style, let viewModel = self.textMessageViewModel else { return }
        
        let font = style.textFont(viewModel: viewModel, isSelected: self.selected)
        let textColor = style.textColor(viewModel: viewModel, isSelected: self.selected)
        var needsToUpdateText = false
        
        if self.textView.font != font {
            self.textView.font = font
            needsToUpdateText = true
        }
        
        if self.textView.textColor != textColor {
            self.textView.textColor = textColor
            self.textView.linkTextAttributes = [
                NSAttributedString.Key.foregroundColor: textColor,
                NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue
            ]
            needsToUpdateText = true
        }
        
        let textInsets = style.textInsets(viewModel: viewModel, isSelected: self.selected)
        if self.textView.textContainerInset != textInsets { self.textView.textContainerInset = textInsets }
        
        if needsToUpdateText || self.textView.text != viewModel.text {
            
            if viewModel.isDeleted != nil && viewModel.isDeleted == true{
                
                let deletedAttributes : [NSAttributedString.Key:Any] = [NSAttributedString.Key.font:UIFont.italicSystemFont(ofSize: 16.0),NSAttributedString.Key.foregroundColor : textColor]
                self.textView.attributedText = NSAttributedString(string: viewModel.text, attributes: deletedAttributes)
                self.quoteMessageView.isHidden = true
                return
            }
            
            //self.textView.text = viewModel.text
            
            // Member Tagging Work
            //let normalAttributes = [NSAttributedString.Key.font:UIFont.systemFont(ofSize: 16.0, weight: .regular),NSAttributedString.Key.foregroundColor:textColor]
            //let attributedString = NSMutableAttributedString(string: viewModel.text, attributes: normalAttributes)
            
            let textMessageString = viewModel.text.replacingOccurrences(of: "```", with: "$")
            let attributedString = MarkDown.shared.tranverseString(string: textMessageString, startingIndex: 0, textColor: textColor, withFont: UIFont.systemFont(ofSize: 16.0, weight: .regular))
            
            if let usersDictionary = viewModel.taggedUsersDictionary{
                for (memberId,memberName) in usersDictionary{
                    let allRanges = attributedString.string.ranges(of: memberName)
                    if allRanges.count > 0{
                        for range in allRanges{
                            let nsRange = NSRange(range, in: attributedString.string)
                            attributedString.addAttribute(.link, value: "username://"+memberId, range: nsRange)
                        }
                    }
                }
            }
            
            let originalText = NSMutableAttributedString(attributedString: attributedString)
            let newString = NSMutableAttributedString(attributedString: attributedString)
            
            originalText.enumerateAttributes(in: NSRange(0..<originalText.length), options: .reverse) { (attributes, range, pointer) in
                if let _ = attributes[NSAttributedString.Key.link] {
                    newString.removeAttribute(NSAttributedString.Key.font, range: range)
                    newString.addAttributes([NSAttributedString.Key.font:UIFont.systemFont(ofSize: 16.0, weight: .bold),NSAttributedString.Key.foregroundColor:textColor,NSAttributedString.Key.underlineStyle:0,NSAttributedString.Key.underlineColor:UIColor.clear], range: range)
                }
            }
            self.textView.attributedText = newString
        }
        
        
        
        if let body = viewModel.quotedBody{
            self.quoteMessageView.isHidden = false
            let quotedViewColor = style.baseColor(viewModel: viewModel)
            self.quoteMessageView.setIndicatorColor(quotedViewColor)
            self.quoteMessageView.nameView.textColor = quotedViewColor
            self.quoteMessageView.messageView.textColor = quotedViewColor
            self.quoteMessageView.nameView.text = viewModel.quotedUser
            
            let replacedBody = body.replacingOccurrences(of: "```", with: "$")
            self.quoteMessageView.messageView.attributedText = MarkDown.shared.tranverseString(string: replacedBody, startingIndex: 0   , textColor: quotedViewColor)
            
            if let url = viewModel.quotedImage{
                self.quoteMessageView.imageView.isHidden = false
                self.quoteMessageView.imageView.sd_setImage(with: URL(string: url), completed: nil)
            }else {
                self.quoteMessageView.imageView.isHidden = true
            }
        }else{
            self.quoteMessageView.isHidden = true
        }
    }
    
    private func bubbleImage() -> UIImage {
        return self.style.bubbleImage(viewModel: self.textMessageViewModel, isSelected: self.selected)
    }
    
    public override func sizeThatFits(_ size: CGSize) -> CGSize {
        return self.calculateTextBubbleLayout(preferredMaxLayoutWidth: size.width).size
    }
    
    // MARK: Layout
    public override func layoutSubviews() {
        super.layoutSubviews()
        let layout = self.calculateTextBubbleLayout(preferredMaxLayoutWidth: self.preferredMaxLayoutWidth)
        self.textView.bma_rect = layout.textFrame
        self.bubbleImageView.bma_rect = layout.bubbleFrame
        self.borderImageView.bma_rect = self.bubbleImageView.bounds
        self.quoteMessageView.bma_rect = layout.quoteBubbleFrame
    }
    
    public var layoutCache: NSCache<AnyObject, AnyObject>!
    private func calculateTextBubbleLayout(preferredMaxLayoutWidth: CGFloat) -> TextBubbleLayoutModel {
        let layoutContext = TextBubbleLayoutModel.LayoutContext(
            text: self.textMessageViewModel.text,
            font: self.style.textFont(viewModel: self.textMessageViewModel, isSelected: self.selected),
            textInsets: self.style.textInsets(viewModel: self.textMessageViewModel, isSelected: self.selected),
            preferredMaxLayoutWidth: preferredMaxLayoutWidth, isQuoteMessage: self.textMessageViewModel.quotedBody != nil, taggedUsersDictionary: self.textMessageViewModel.taggedUsersDictionary, isDeleted: self.textMessageViewModel.isDeleted
        )
        
        if let layoutModel = self.layoutCache.object(forKey: layoutContext.hashValue as AnyObject) as? TextBubbleLayoutModel, layoutModel.layoutContext == layoutContext {
            return layoutModel
        }
        
        let layoutModel = TextBubbleLayoutModel(layoutContext: layoutContext)
        layoutModel.calculateLayout()
        
        self.layoutCache.setObject(layoutModel, forKey: layoutContext.hashValue as AnyObject)
        return layoutModel
    }
    
    public var canCalculateSizeInBackground: Bool {
        return true
    }
}

private final class TextBubbleLayoutModel {
    let layoutContext: LayoutContext
    var textFrame: CGRect = CGRect.zero
    var bubbleFrame: CGRect = CGRect.zero
    var size: CGSize = CGSize.zero
    var quoteBubbleFrame: CGRect = CGRect.zero
    var minimumQuoteBubbleWidth: CGFloat = 255
    var quoteMessageViewHeight: CGFloat = 50
    var imageHeight: CGFloat = 30
    
    init(layoutContext: LayoutContext) {
        self.layoutContext = layoutContext
    }
    
    struct LayoutContext: Equatable, Hashable {
        let text: String
        let font: UIFont
        let textInsets: UIEdgeInsets
        let preferredMaxLayoutWidth: CGFloat
        let isQuoteMessage: Bool
        let taggedUsersDictionary : [String:String]?
        let isDeleted : Bool?
        
        var hashValue: Int {
            return Chatto.bma_combine(hashes: [self.text.hashValue, self.textInsets.bma_hashValue, self.preferredMaxLayoutWidth.hashValue, self.font.hashValue,self.isQuoteMessage.hashValue])
        }
        
        static func == (lhs: TextBubbleLayoutModel.LayoutContext, rhs: TextBubbleLayoutModel.LayoutContext) -> Bool {
            let lhsValues = (lhs.text, lhs.textInsets, lhs.font, lhs.preferredMaxLayoutWidth)
            let rhsValues = (rhs.text, rhs.textInsets, rhs.font, rhs.preferredMaxLayoutWidth)
            return lhsValues == rhsValues
        }
    }
    
    func calculateLayout() {
        
        let textHorizontalInset = self.layoutContext.textInsets.bma_horziontalInset
        let maxTextWidth = self.layoutContext.preferredMaxLayoutWidth - textHorizontalInset
        let textSize = self.textSizeThatFitsWidth(maxTextWidth)
        let finalTextSize = textSize.bma_outsetBy(dx: textHorizontalInset, dy: self.layoutContext.textInsets.bma_verticalInset)
        
        if layoutContext.isQuoteMessage {
            let quoteBubbleSize = CGSize(width: maxTextWidth, height: quoteMessageViewHeight)
            let height = textSize.height + quoteBubbleSize.height
            let bubbleSize = CGSize(width: maxTextWidth, height: height).bma_outsetBy(dx: textHorizontalInset, dy: self.layoutContext.textInsets.bma_verticalInset)
            
            self.textFrame = CGRect(origin: CGPoint(x: 0, y: quoteBubbleSize.height), size: finalTextSize)
            self.quoteBubbleFrame = CGRect(x: 20, y: textHorizontalInset/2,width: quoteBubbleSize.width, height: quoteBubbleSize.height)
            self.bubbleFrame = CGRect(origin: CGPoint.zero, size: bubbleSize)
            self.size = bubbleSize
        }else{
            self.quoteBubbleFrame = .zero
            self.textFrame = CGRect(origin: .zero, size: finalTextSize)
            self.bubbleFrame = CGRect(origin: CGPoint.zero, size: finalTextSize)
            self.size = finalTextSize
        }
    }
    
    private func textSizeThatFitsWidth(_ width: CGFloat) -> CGSize {
        let textContainer: NSTextContainer = {
            let size = CGSize(width: width, height: .greatestFiniteMagnitude)
            let container = NSTextContainer(size: size)
            container.lineFragmentPadding = 0
            return container
        }()
        
        let textStorage = self.replicateUITextViewNSTextStorage()
        let layoutManager: NSLayoutManager = {
            let layoutManager = NSLayoutManager()
            layoutManager.addTextContainer(textContainer)
            textStorage.addLayoutManager(layoutManager)
            return layoutManager
        }()
        
        let rect = layoutManager.usedRect(for: textContainer)
        return rect.size.bma_round()
    }
    
    private func replicateUITextViewNSTextStorage() -> NSTextStorage {
        
        if self.layoutContext.isDeleted != nil && self.layoutContext.isDeleted == true{
            let deletedAttributes : [NSAttributedString.Key:Any] = [NSAttributedString.Key.font:UIFont.italicSystemFont(ofSize: 16.0)]
            let deletedString = NSAttributedString(string: self.layoutContext.text, attributes: deletedAttributes)
            return NSTextStorage(attributedString: deletedString)
        }
        
        //let normalAttributes = [NSAttributedString.Key.font:UIFont.systemFont(ofSize: 16.0, weight: .regular)]
        //let attributedString = NSMutableAttributedString(string: self.layoutContext.text, attributes: normalAttributes)
        
        let textMessageString = self.layoutContext.text.replacingOccurrences(of: "```", with: "$")
        let attributedString = MarkDown.shared.tranverseString(string: textMessageString, startingIndex: 0, withFont: UIFont.systemFont(ofSize: 16.0, weight: .regular))
        
        if let taggedDic = self.layoutContext.taggedUsersDictionary{
            for (memberId,memberName) in taggedDic{
                let allRanges = attributedString.string.ranges(of: memberName)
                if allRanges.count > 0{
                    for range in allRanges{
                        let nsRange = NSRange(range, in: attributedString.string)
                        attributedString.addAttribute(.link, value: "username://"+memberId, range: nsRange)
                    }
                }
            }
        }
        let originalText = NSMutableAttributedString(attributedString: attributedString)
        let newString = NSMutableAttributedString(attributedString: attributedString)
        
        originalText.enumerateAttributes(in: NSRange(0..<originalText.length), options: .reverse) { (attributes, range, pointer) in
            if let _ = attributes[NSAttributedString.Key.link] {
                newString.removeAttribute(NSAttributedString.Key.font, range: range)
                newString.addAttributes([NSAttributedString.Key.font:UIFont.systemFont(ofSize: 16.0, weight: .bold),NSAttributedString.Key.underlineStyle:0], range: range)
            }
        }
        return NSTextStorage(attributedString: newString)
    }
}

extension TextBubbleView:UITextViewDelegate{
    public func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange) -> Bool {
        NotificationCenter.default.post(name: NSNotification.Name("linkTapped"), object: nil, userInfo: ["userId":URL])
        return false
    }
}

/// UITextView with hacks to avoid selection, loupe, define...
private final class ChatMessageTextView: UITextView {
    
    override var canBecomeFirstResponder: Bool {
        return false
    }
    
    // See https://github.com/badoo/Chatto/issues/363
    override var gestureRecognizers: [UIGestureRecognizer]? {
        set {
            super.gestureRecognizers = newValue
        }
        get {
            return super.gestureRecognizers?.filter({ (gestureRecognizer) -> Bool in
                return type(of: gestureRecognizer) == UILongPressGestureRecognizer.self && gestureRecognizer.delaysTouchesEnded
            })
        }
    }
    
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        return false
    }
    
    override var selectedRange: NSRange {
        get {
            return NSRange(location: 0, length: 0)
        }
        set {
            // Part of the heaviest stack trace when scrolling (when updating text)
            // See https://github.com/badoo/Chatto/pull/144
        }
    }
    
    override var contentOffset: CGPoint {
        get {
            return .zero
        }
        set {
            // Part of the heaviest stack trace when scrolling (when bounds are set)
            // See https://github.com/badoo/Chatto/pull/144
        }
    }
}


extension String
{
    func stringByReplacingFirstOccurrenceOfString(
        target: String, withString replaceString: String) -> String
    {
        if let range = self.range(of: target) {
            return self.replacingCharacters(in: range, with: replaceString)
        }
        return self
    }
    
    func ranges(of substring: String, options: CompareOptions = [], locale: Locale? = nil) -> [Range<Index>] {
        var ranges: [Range<Index>] = []
        while ranges.last.map({ $0.upperBound < self.endIndex }) ?? true,
            let range = self.range(of: substring, options: options, range: (ranges.last?.upperBound ?? self.startIndex)..<self.endIndex, locale: locale)
        {
            ranges.append(range)
        }
        return ranges
    }
}

open class MarkDown{
    
    var currentMarkElement = ""
    var currentDelimitor = ""
    
    var initialIndex : Int!
    var endIndex : Int!
    var markElements = ["*","_","~","$"]
    
    var currentAttribute = ""
    var currentWord = ""
    public static var shared : MarkDown = {
        let instance = MarkDown()
        return instance
    }()
    
    public func tranverseString(string:String,startingIndex:Int,textColor:UIColor = .black,withFont:UIFont = UIFont.systemFont(ofSize: 14.0))->NSMutableAttributedString{
        let attributedString = NSMutableAttributedString(string: string, attributes: [NSAttributedString.Key.font:withFont])
        
        let normalAttributes = [NSAttributedString.Key.font:withFont,NSAttributedString.Key.foregroundColor:textColor]
        
        let finalString = NSMutableAttributedString(string: "", attributes: normalAttributes)
        
        for (index,char) in string.enumerated(){
            let currentString = String(char)
            if markElements.contains(currentString){
                if currentMarkElement == ""{
                    
                    let normalAttributedString = NSAttributedString(string: currentWord,attributes:normalAttributes)
                    finalString.append(normalAttributedString)
                    currentWord = ""
                    
                    currentMarkElement = currentString
                    currentWord.append(char)
                } else{
                    if currentString == currentMarkElement{
                        currentWord.append(char)
                        
                        var rangeWord = String(currentWord.dropFirst())
                        rangeWord = String(rangeWord.dropLast())
                        
                        var attributes : [NSAttributedString.Key:Any]?
                        if currentMarkElement == "*"{
                            attributes = [NSAttributedString.Key.font:UIFont.boldSystemFont(ofSize: withFont.pointSize),NSAttributedString.Key.foregroundColor:textColor]
                        } else if currentMarkElement == "_"{
                            attributes = [NSAttributedString.Key.font:UIFont.italicSystemFont(ofSize: withFont.pointSize),NSAttributedString.Key.foregroundColor:textColor]
                        } else if currentMarkElement == "~"{
                            attributes = [NSAttributedString.Key.strikethroughStyle:NSUnderlineStyle.single.rawValue,NSAttributedString.Key.baselineOffset:0,NSAttributedString.Key.foregroundColor:textColor,NSAttributedString.Key.font:UIFont.systemFont(ofSize: withFont.pointSize, weight: .regular)]
                        } else if currentMarkElement == "$"{
                            attributes = [NSAttributedString.Key.font:UIFont(name: "Courier", size: withFont.pointSize)!,NSAttributedString.Key.foregroundColor:textColor]
                        }
                        
                        if attributes != nil{
                            let normalAttributedString = NSAttributedString(string: rangeWord, attributes: attributes!)
                            finalString.append(normalAttributedString)
                            currentWord = ""
                            currentMarkElement = ""
                        } else{
                            let normalAttributedString = NSAttributedString(string: rangeWord)
                            finalString.append(normalAttributedString)
                            currentWord = ""
                            currentMarkElement = ""
                        }
                    } else{
                        currentWord.append(char)
                    }
                }
            } else{
                currentWord.append(char)
            }
        }
        
        if currentMarkElement != "" && currentWord != ""{
            if currentWord.count < 2{
                let finalWord = "\(currentWord)"
                let normalAttributedString = NSAttributedString(string: finalWord, attributes: normalAttributes)
                finalString.append(normalAttributedString)
            } else{
                let finalWord = "\(currentWord)"
                let normalAttributedString = NSAttributedString(string: finalWord, attributes: normalAttributes)
                finalString.append(normalAttributedString)
            }
            
        } else if currentWord != ""{
            let finalWord = "\(currentWord)"
            let normalAttributedString = NSAttributedString(string: finalWord, attributes: normalAttributes)
            finalString.append(normalAttributedString)
        }
        
        currentWord = ""
        currentMarkElement = ""
        currentAttribute = ""
        
        return finalString
    }
}
