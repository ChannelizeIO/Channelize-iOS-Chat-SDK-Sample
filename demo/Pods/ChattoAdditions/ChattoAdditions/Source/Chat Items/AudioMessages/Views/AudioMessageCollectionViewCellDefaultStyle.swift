//
//  AudioMessageCollectionViewCellDefaultStyle.swift
//  ChattoAdditions
//
//  Created by Ashish on 12/09/18.
//  Copyright © 2018 Badoo. All rights reserved.
//

import UIKit

open class AudioMessageCollectionViewCellDefaultStyle: AudioMessageCollectionViewCellStyleProtocol {

    typealias Class = AudioMessageCollectionViewCellDefaultStyle
    
    public struct BubbleMasks {
        public let incomingTail: () -> UIImage
        public let incomingNoTail: () -> UIImage
        public let outgoingTail: () -> UIImage
        public let outgoingNoTail: () -> UIImage
        public let tailWidth: CGFloat
        public init(
            incomingTail: @autoclosure @escaping () -> UIImage,
            incomingNoTail: @autoclosure @escaping () -> UIImage,
            outgoingTail: @autoclosure @escaping () -> UIImage,
            outgoingNoTail: @autoclosure @escaping () -> UIImage,
            tailWidth: CGFloat) {
            self.incomingTail = incomingTail
            self.incomingNoTail = incomingNoTail
            self.outgoingTail = outgoingTail
            self.outgoingNoTail = outgoingNoTail
            self.tailWidth = tailWidth
        }
    }
    
    public struct Sizes {
        public let audioSizeLandscape: CGSize
        public let audioSizePortrait: CGSize
        public init(
            audioSizeLandscape: CGSize,
            audioSizePortrait: CGSize) {
            self.audioSizeLandscape = audioSizeLandscape
            self.audioSizePortrait = audioSizePortrait
        }
    }
    
    let bubbleMasks: BubbleMasks
    let sizes: Sizes
    let baseStyle: BaseMessageCollectionViewCellDefaultStyle
    public init(
        bubbleMasks: BubbleMasks = Class.createDefaultBubbleMasks(),
        sizes: Sizes = Class.createDefaultSizes(),
        baseStyle: BaseMessageCollectionViewCellDefaultStyle = BaseMessageCollectionViewCellDefaultStyle()) {
        self.bubbleMasks = bubbleMasks
        self.sizes = sizes
        self.baseStyle = baseStyle
    }
    
    lazy private var maskImageIncomingTail: UIImage = self.bubbleMasks.incomingTail()
    lazy private var maskImageIncomingNoTail: UIImage = self.bubbleMasks.incomingNoTail()
    lazy private var maskImageOutgoingTail: UIImage = self.bubbleMasks.outgoingTail()
    lazy private var maskImageOutgoingNoTail: UIImage = self.bubbleMasks.outgoingNoTail()
    
    
    lazy private var pauseIcon: UIImage = {
        return UIImage(named: "pause_icon", in: Bundle(for: Class.self), compatibleWith: nil)!
    }()
    
    lazy private var playIcon: UIImage = {
        return UIImage(named: "play_icon", in: Bundle(for: Class.self), compatibleWith: nil)!
    }()
    
    open func maskingImage(viewModel: AudioMessageViewModelProtocol) -> UIImage {
        switch (viewModel.isIncoming, viewModel.decorationAttributes.isShowingTail) {
        case (true, true):
            return self.maskImageIncomingTail
        case (true, false):
            return self.maskImageIncomingNoTail
        case (false, true):
            return self.maskImageOutgoingTail
        case (false, false):
            return self.maskImageOutgoingNoTail
        }
    }
    
    open func borderImage(viewModel: AudioMessageViewModelProtocol) -> UIImage? {
        return self.baseStyle.borderImage(viewModel: viewModel)
    }
    
    open func pauseIconImage(viewModel: AudioMessageViewModelProtocol) -> UIImage {
        return self.pauseIcon
    }
    
    open func playIconImage(viewModel: AudioMessageViewModelProtocol) -> UIImage {
        return self.playIcon
    }
    
    public func audioViewTintColot(viewModel: AudioMessageViewModelProtocol) -> UIColor {
        return self.baseStyle.baseColorOutgoing
    }
    
    open func tailWidth(viewModel: AudioMessageViewModelProtocol) -> CGFloat {
        return self.bubbleMasks.tailWidth
    }
    
    open func bubbleSize(viewModel: AudioMessageViewModelProtocol) -> CGSize {
        return self.sizes.audioSizePortrait
    }
    
    open func progressIndicatorColor(viewModel: AudioMessageViewModelProtocol) -> UIColor {
        return viewModel.isIncoming ? self.baseStyle.baseColorIncoming : self.baseStyle.baseColorOutgoing
    }
    
    open func overlayColor(viewModel: AudioMessageViewModelProtocol) -> UIColor? {
        let showsOverlay = (viewModel.transferStatus.value == .transfering || viewModel.status == MessageViewModelStatus.sending || viewModel.status == MessageViewModelStatus.failed)
        return showsOverlay ? UIColor.black.withAlphaComponent(0.70) : nil
    }
    
}

public extension AudioMessageCollectionViewCellDefaultStyle { // Default values
    
    static public func createDefaultBubbleMasks() -> BubbleMasks {
        return BubbleMasks(
            incomingTail: UIImage(named: "bubble-incoming-tail", in: Bundle(for: Class.self), compatibleWith: nil)!,
            incomingNoTail: UIImage(named: "bubble-incoming", in: Bundle(for: Class.self), compatibleWith: nil)!,
            outgoingTail: UIImage(named: "bubble-outgoing-tail", in: Bundle(for: Class.self), compatibleWith: nil)!,
            outgoingNoTail: UIImage(named: "bubble-outgoing", in: Bundle(for: Class.self), compatibleWith: nil)!,
            tailWidth: 6
        )
    }
    
    static public func createDefaultSizes() -> Sizes {
        return Sizes(
            audioSizeLandscape: CGSize(width: 210, height: 50),
            audioSizePortrait: CGSize(width: 170, height: 40)
        )
    }
    
}
