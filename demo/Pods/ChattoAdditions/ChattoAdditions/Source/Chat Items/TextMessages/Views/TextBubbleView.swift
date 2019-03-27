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
                self.textView.dataDetectorTypes = UIDataDetectorTypes()
                self.textView.isSelectable = false
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
                NSAttributedStringKey.foregroundColor.rawValue: textColor,
                NSAttributedStringKey.underlineStyle.rawValue: NSUnderlineStyle.styleSingle.rawValue
            ]
            needsToUpdateText = true
        }
        
        if needsToUpdateText || self.textView.text != viewModel.text {
            self.textView.text = viewModel.text
        }
        
        let textInsets = style.textInsets(viewModel: viewModel, isSelected: self.selected)
        if self.textView.textContainerInset != textInsets { self.textView.textContainerInset = textInsets }
        
        if let body = viewModel.quotedBody{
            self.quoteMessageView.isHidden = false
            let quotedViewColor = style.baseColor(viewModel: viewModel)
            self.quoteMessageView.setIndicatorColor(quotedViewColor)
            self.quoteMessageView.nameView.textColor = quotedViewColor
            self.quoteMessageView.messageView.textColor = quotedViewColor
            self.quoteMessageView.nameView.text = viewModel.quotedUser
            self.quoteMessageView.messageView.text = body
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
            preferredMaxLayoutWidth: preferredMaxLayoutWidth, isQuoteMessage: self.textMessageViewModel.quotedBody != nil
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
        // See https://github.com/badoo/Chatto/issues/129
        return NSTextStorage(string: self.layoutContext.text, attributes: [
            NSAttributedStringKey.font: self.layoutContext.font,
            NSAttributedStringKey(rawValue: "NSOriginalFont"): self.layoutContext.font
            ])
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
