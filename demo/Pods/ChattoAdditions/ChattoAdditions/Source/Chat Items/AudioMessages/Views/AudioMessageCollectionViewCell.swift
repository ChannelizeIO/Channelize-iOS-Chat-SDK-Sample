//
//  AudioMessageViewCell.swift
//  ChattoAdditions
//
//  Created by Ashish on 12/09/18.
//  Copyright © 2018 Badoo. All rights reserved.
//

import UIKit

public typealias AudioMessageCollectionViewCellStyleProtocol = AudioBubbleViewStyleProtocol

public final class AudioMessageCollectionViewCell: BaseMessageCollectionViewCell<AudioBubbleView> {
    
    static func sizingCell() -> AudioMessageCollectionViewCell {
        let cell = AudioMessageCollectionViewCell(frame: CGRect.zero)
        cell.viewContext = .sizing
        return cell
    }
    
    public override func createBubbleView() -> AudioBubbleView {
        return AudioBubbleView()
    }
    
    override public var viewContext: ViewContext {
        didSet {
            self.bubbleView.viewContext = self.viewContext
        }
    }
    
    public var audioMessageViewModel: AudioMessageViewModelProtocol! {
        didSet {
            self.messageViewModel = self.audioMessageViewModel
            self.bubbleView.audioMessageViewModel = self.audioMessageViewModel
        }
    }
    
    public var audioMessageStyle: AudioMessageCollectionViewCellStyleProtocol! {
        didSet {
            self.bubbleView.audioMessageViewStyle = self.audioMessageStyle
        }
    }
    
    public override func performBatchUpdates(_ updateClosure: @escaping () -> Void, animated: Bool, completion: (() -> Void)?) {
        super.performBatchUpdates({ () -> Void in
            self.bubbleView.performBatchUpdates(updateClosure: updateClosure, animated: false, completion: nil)
        }, animated: animated, completion: completion)
    }
}
