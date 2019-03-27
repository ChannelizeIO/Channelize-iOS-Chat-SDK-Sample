//
//  AudioMessagePresenter.swift
//  ChattoAdditions
//
//  Created by Ashish on 12/09/18.
//  Copyright © 2018 Badoo. All rights reserved.
//

open class AudioMessagePresenter<ViewModelBuilderT, InteractionHandlerT>
    : BaseMessagePresenter<AudioBubbleView, ViewModelBuilderT, InteractionHandlerT> where
    ViewModelBuilderT: ViewModelBuilderProtocol,
    ViewModelBuilderT.ViewModelT: AudioMessageViewModelProtocol,
    InteractionHandlerT: BaseMessageInteractionHandlerProtocol,
InteractionHandlerT.ViewModelT == ViewModelBuilderT.ViewModelT {
    public typealias ModelT = ViewModelBuilderT.ModelT
    public typealias ViewModelT = ViewModelBuilderT.ViewModelT
    
    public let audioCellStyle: AudioMessageCollectionViewCellStyleProtocol
    
    public init (
        messageModel: ModelT,
        viewModelBuilder: ViewModelBuilderT,
        interactionHandler: InteractionHandlerT?,
        sizingCell: AudioMessageCollectionViewCell,
        baseCellStyle: BaseMessageCollectionViewCellStyleProtocol,
        audioCellStyle: AudioMessageCollectionViewCellStyleProtocol) {
        self.audioCellStyle = audioCellStyle
        super.init(
            messageModel: messageModel,
            viewModelBuilder: viewModelBuilder,
            interactionHandler: interactionHandler,
            sizingCell: sizingCell,
            cellStyle: baseCellStyle
        )
    }
    
    public final override class func registerCells(_ collectionView: UICollectionView) {
        collectionView.register(AudioMessageCollectionViewCell.self, forCellWithReuseIdentifier: "audio-message")
    }
    
    public final override func dequeueCell(collectionView: UICollectionView, indexPath: IndexPath) -> UICollectionViewCell {
        return collectionView.dequeueReusableCell(withReuseIdentifier: "audio-message", for: indexPath)
    }
    
    open override func createViewModel() -> ViewModelBuilderT.ViewModelT {
        let viewModel = self.viewModelBuilder.createViewModel(self.messageModel)
        let updateClosure = { [weak self] (old: Any, new: Any) -> Void in
            self?.updateCurrentCell()
        }
        viewModel.avatarImage.observe(self, closure: updateClosure)
        viewModel.transferDirection.observe(self, closure: updateClosure)
        viewModel.fileProgress.observe(self, closure: updateClosure)
        viewModel.transferStatus.observe(self, closure: updateClosure)
        viewModel.fileStatus.observe(self, closure: updateClosure)
        return viewModel
    }
    
    public var audioCell: AudioMessageCollectionViewCell? {
        if let cell = self.cell {
            if let audioCell = cell as? AudioMessageCollectionViewCell {
                return audioCell
            } else {
                assert(false, "Invalid cell was given to presenter!")
            }
        }
        return nil
    }
    
    open override func configureCell(_ cell: BaseMessageCollectionViewCell<AudioBubbleView>, decorationAttributes: ChatItemDecorationAttributes, animated: Bool, additionalConfiguration: (() -> Void)?) {
        guard let cell = cell as? AudioMessageCollectionViewCell else {
            assert(false, "Invalid cell received")
            return
        }
        
        super.configureCell(cell, decorationAttributes: decorationAttributes, animated: animated) { () -> Void in
            cell.audioMessageViewModel = self.messageViewModel
            cell.audioMessageStyle = self.audioCellStyle
            additionalConfiguration?()
        }
    }
    
    public func updateCurrentCell() {
        if let cell = self.audioCell, let decorationAttributes = self.decorationAttributes {
            self.configureCell(cell, decorationAttributes: decorationAttributes, animated: self.itemVisibility != .appearing, additionalConfiguration: nil)
        }
    }
}
