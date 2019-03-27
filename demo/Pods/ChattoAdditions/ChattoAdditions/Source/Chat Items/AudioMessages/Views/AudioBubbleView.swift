//
//  AudioBubbleView.swift
//  ChattoAdditions
//
//  Created by Ashish on 12/09/18.
//  Copyright © 2018 Badoo. All rights reserved.
//

public protocol AudioBubbleViewStyleProtocol {
    func maskingImage(viewModel: AudioMessageViewModelProtocol) -> UIImage
    func borderImage(viewModel: AudioMessageViewModelProtocol) -> UIImage?
    func playIconImage(viewModel: AudioMessageViewModelProtocol) -> UIImage
    func pauseIconImage(viewModel: AudioMessageViewModelProtocol) -> UIImage
    func audioViewTintColot(viewModel: AudioMessageViewModelProtocol) -> UIColor
    func bubbleSize(viewModel: AudioMessageViewModelProtocol) -> CGSize
}

public class AudioBubbleView: UIView, MaximumLayoutWidthSpecificable, BackgroundSizingQueryable {
    
    public var viewContext: ViewContext = .normal
    public var animationDuration: CFTimeInterval = 0.33
    public var preferredMaxLayoutWidth: CGFloat = 0
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInit()
    }
    
    private func commonInit() {
        self.autoresizesSubviews = false
        self.addSubview(self.audioButton)
        self.addSubview(self.bubbleImageView)
        self.addSubview(self.progressView)
        self.addSubview(self.durationLabel)
        self.addSubview(self.progressIndicatorView)
    }
    
    private var borderImageView: UIImageView = UIImageView()
    private lazy var bubbleImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.addSubview(self.borderImageView)
        return imageView
    }()
    
    private lazy var audioButton: UIImageView = {
        let iconView = UIImageView()
        iconView.contentMode = .scaleAspectFit
        return iconView
    }()
    
    private lazy var progressView: UIProgressView = {
        let voiceView = UIProgressView()
        voiceView.progressViewStyle = .default
        voiceView.setProgress(0.3, animated: false)
        return voiceView
    }()
    
    private lazy var durationLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 12)
        return label
    }()
    
    public private(set) var progressIndicatorView: CircleProgressIndicatorView = {
        return CircleProgressIndicatorView(size: CGSize(width: 20, height: 20))
    }()
    
    var audioMessageViewModel: AudioMessageViewModelProtocol! {
        didSet {
            self.updateViews()
        }
    }
    
    var audioMessageViewStyle: AudioBubbleViewStyleProtocol! {
        didSet {
            self.updateViews()
        }
    }
    
    public private(set) var isUpdating: Bool = false
    public func performBatchUpdates(updateClosure: @escaping () -> Void, animated: Bool, completion: (() ->())?) {
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
            UIView.animate(withDuration: self.animationDuration, animations: updateAndRefreshViews, completion: { (finished) -> Void in
                completion?()
            })
        } else {
            updateAndRefreshViews()
        }
    }
    
    public func updateViews() {
        if self.viewContext == .sizing { return }
        if isUpdating { return }
        guard let viewModel = self.audioMessageViewModel, let style = self.audioMessageViewStyle else { return }
        
        
        self.audioButton.tintColor = style.audioViewTintColot(viewModel: viewModel)
        self.borderImageView.image = style.borderImage(viewModel: viewModel)
        self.durationLabel.textColor = style.audioViewTintColot(viewModel: viewModel)
        self.progressView.tintColor = style.audioViewTintColot(viewModel: viewModel)
        
        self.progressIndicatorView.progressLineColor = style.audioViewTintColot(viewModel: viewModel)
        
        self.durationLabel.text = viewModel.duration
        
        updateProgressIndicator()
        
        switch viewModel.fileStatus.value {
        case .playing:
            self.audioButton.image = style.pauseIconImage(viewModel: viewModel)
            self.progressView.setProgress(viewModel.fileProgress.value, animated: true)
        case .stopped:
            self.audioButton.image = style.playIconImage(viewModel: viewModel)
            self.progressView.setProgress(0, animated: true)
        case .pause:
            self.audioButton.image = style.playIconImage(viewModel: viewModel)
            self.progressView.setProgress(viewModel.fileProgress.value, animated: true)
        }
    }
    
    private func updateProgressIndicator() {
        let transferStatus = self.audioMessageViewModel.transferStatus.value
        self.progressIndicatorView.isHidden = [TransferStatus.idle, TransferStatus.success, TransferStatus.failed].contains(self.audioMessageViewModel.transferStatus.value)
        
        self.durationLabel.isHidden = !self.progressIndicatorView.isHidden
        
        self.progressIndicatorView.progressLineWidth = 1
        
        switch transferStatus {
        case .idle, .success, .failed:
            break
        case .transfering:
            self.progressIndicatorView.progressStatus = .starting
        }
    }
    
    // MARK: Layout
    public override func layoutSubviews() {
        super.layoutSubviews()
        let layout = self.calculateAudioBubbleLayout(maximumWidth: self.preferredMaxLayoutWidth)
        self.bubbleImageView.bma_rect = layout.bubbleFrame
        self.borderImageView.bma_rect = self.bubbleImageView.bounds
        self.audioButton.frame = layout.iconFrame
        self.progressView.frame = layout.progressViewFrame
        self.durationLabel.frame = layout.progressLableFrame
        self.progressIndicatorView.center = self.durationLabel.center
    }
    
    public override func sizeThatFits(_ size: CGSize) -> CGSize {
        return self.calculateAudioBubbleLayout(maximumWidth: size.width).size
    }
    
    public var canCalculateSizeInBackground: Bool {
        return true
    }
    
    private func calculateAudioBubbleLayout(maximumWidth: CGFloat) -> AudioBubbleLayoutModel {
        let layoutContext = AudioBubbleLayoutModel.LayoutContext(audioMessageViewModel: self.audioMessageViewModel, style: self.audioMessageViewStyle, containerWidth: maximumWidth)
        let layoutModel = AudioBubbleLayoutModel(layoutContext: layoutContext)
        layoutModel.calculateLayout()
        
        return layoutModel
    }
}


private class AudioBubbleLayoutModel {
    var bubbleFrame:CGRect = CGRect.zero
    var iconFrame: CGRect = CGRect.zero
    var progressViewFrame: CGRect = CGRect.zero
    var progressLableFrame: CGRect = CGRect.zero
    var size: CGSize = CGSize.zero
    
    struct LayoutContext {
        let duration:String
        let bubbleSize: CGSize
        let preferredMaxLayoutWidth: CGFloat
        let iconSize: CGSize
        let isIncoming: Bool
        
        init(duration:String,
             bubbleSize: CGSize,
             iconSize: CGSize,
             isIncoming: Bool,
             preferredMaxLayoutWidth width: CGFloat) {
            self.duration = duration
            self.bubbleSize = bubbleSize
            self.iconSize = iconSize
            self.isIncoming = isIncoming
            self.preferredMaxLayoutWidth = width
        }
        
        init(audioMessageViewModel model: AudioMessageViewModelProtocol,
             style: AudioBubbleViewStyleProtocol,
             containerWidth width: CGFloat) {
            self.init(duration: model.duration!,
                      bubbleSize: style.bubbleSize(viewModel: model),
                      iconSize: style.playIconImage(viewModel: model).size,
                      isIncoming : model.isIncoming,
                      preferredMaxLayoutWidth: width)
        }
    }
    
    let layoutContext: LayoutContext
    init(layoutContext: LayoutContext) {
        self.layoutContext = layoutContext
    }
    
    func calculateLayout() {
        let size = self.layoutContext.bubbleSize
        self.bubbleFrame = CGRect(origin: .zero, size: size)
        let duration = self.layoutContext.duration as NSString
        let font = UIFont.systemFont(ofSize: 12)
        let fontAttributes = [NSAttributedString.Key.font: font]
        let labelSize = duration.size(withAttributes: fontAttributes)
        
        if layoutContext.isIncoming {
            self.iconFrame = CGRect(x: 10, y: 5, width: 30, height: 30)
            let labelFrame = CGRect(x: size.width-labelSize.width-10, y: (size.height-labelSize.height)/2, width: labelSize.width+5, height: labelSize.height)
            let xOffset:CGFloat = iconFrame.width+15
            let width = size.width - (xOffset+labelFrame.width+15)
            self.progressLableFrame = labelFrame
            self.progressViewFrame = CGRect(x: xOffset, y: size.height/2, width: width, height: 15)
        } else {
            self.iconFrame = CGRect(x: 5, y: 5, width: 30, height: 30)
            let labelFrame = CGRect(x: size.width-labelSize.width-15, y: (size.height-labelSize.height)/2, width: labelSize.width+5, height: labelSize.height)
            let xOffset:CGFloat = iconFrame.width+10
            let width = size.width - (xOffset+labelFrame.width+20)
            self.progressLableFrame = labelFrame
            self.progressViewFrame = CGRect(x: xOffset, y: size.height/2, width: width, height: 15)
        }
        self.size = size
    }
    
}
