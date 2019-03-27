//
//  ZVProgressHUD.swift
//  ZVProgressHUD
//
//  Created by zevwings on 2017/7/12.
//  Copyright © 2017年 zevwings. All rights reserved.
//

public typealias ZVProgressHUDCompletionHandler = () -> ()

public extension Notification.Name {
    
    static let ZVProgressHUDReceivedTouchUpInsideEvent = Notification.Name("com.zevwings.progresshud.touchup.inside")
    
    static let ZVProgressHUDWillAppear = Notification.Name("com.zevwings.progresshud.willAppear")
    static let ZVProgressHUDDidAppear = Notification.Name("com.zevwings.progresshud.didAppear")
    
    static let ZVProgressHUDWillDisappear = Notification.Name("com.zevwings.progresshud.willDisappear")
    static let ZVProgressHUDDidDisappear = Notification.Name("com.zevwings.progresshud.didDisappear")
}

open class ZVProgressHUD: UIControl {
    
    private struct AnimationDuration {
        static let fadeIn: TimeInterval = 0.15
        static let fadeOut: TimeInterval = 0.15
        static let keyboard: TimeInterval = 0.25
    }
    
    public enum DisplayType {
        case indicator(title: String?, type: IndicatorView.IndicatorType)
        case text(value: String)
    }
    
    public enum DisplayStyle {
        case light
        case dark
        case custom(backgroundColor: UIColor, foregroundColor: UIColor)
    }
    
    public enum MaskType {
        case none
        case clear
        case black
        case custom(color: UIColor)
    }
    
    internal static let shared = ZVProgressHUD(frame: .zero)
    
    internal var displayStyle: DisplayStyle = .light
    internal var maskType: MaskType = .none
    
    internal var maxSupportedWindowLevel: UIWindow.Level = UIWindow.Level.normal
    internal var fadeInAnimationTimeInterval: TimeInterval = AnimationDuration.fadeIn
    internal var fadeOutAnimationTImeInterval: TimeInterval = AnimationDuration.fadeOut
    
    internal var minimumDismissTimeInterval: TimeInterval = 3.0
    internal var maximumDismissTimeInterval: TimeInterval = 10.0
    
    internal var cornerRadius: CGFloat = 8.0
    internal var offset: UIOffset = .zero
    
    internal var font: UIFont = .systemFont(ofSize: 16.0)
    
    internal var strokeWith: CGFloat = 3.0
    internal var indicatorSize: CGSize = .init(width: 48.0, height: 48.0)
    internal var animationType: IndicatorView.AnimationType = .flat

    internal var contentInsets: UIEdgeInsets = .init(top: 12.0, left: 12.0, bottom: 12.0, right: 12.0)
    internal var titleEdgeInsets: UIEdgeInsets = .init(top: 0, left: 0, bottom: 0, right: 0 )
    internal var indicatorEdgeInsets: UIEdgeInsets = .init(top: 8.0, left: 8.0, bottom: 8.0, right: 8.0)

    private var displayType: DisplayType?
    
    private var containerView: UIView?
    
    private var _fadeOutTimer: Timer?
    private var _fadeInDeleyTimer: Timer?
    private var _fadeOutDelayTimer: Timer?
    
    private lazy var maskLayer: CALayer = { [unowned self] in
        let maskLayer = CALayer()
        return maskLayer
    }()
    
    private lazy var baseView: UIControl = {
        let baseView = UIControl()
        baseView.backgroundColor = .clear
        baseView.alpha = 0
        return baseView
    }()
    
    private lazy var indicatorView: IndicatorView = {
        let indicatorView = IndicatorView()
        indicatorView.isUserInteractionEnabled = false
        indicatorView.alpha = 0
        return indicatorView
    }()
    
    private lazy var titleLabel: UILabel = { [unowned self] in
        
        let titleLabel = UILabel(frame: .zero)
        titleLabel.minimumScaleFactor = 0.5
        titleLabel.textAlignment = .center
        titleLabel.isUserInteractionEnabled = false
        titleLabel.font = self.font
        titleLabel.backgroundColor = .clear
        titleLabel.lineBreakMode = .byTruncatingTail
        titleLabel.numberOfLines = 0
        titleLabel.alpha = 0
        return titleLabel
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        alpha = 0
        backgroundColor = .clear
        
        addTarget(self, action: #selector(overlayRecievedTouchUpInsideEvent(_:)), for: .touchUpInside)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ZVProgressHUD {
    
    func show(with displayType: DisplayType, in superview: UIView? = nil, delay delayTimeInterval: TimeInterval = 0) {
        
        OperationQueue.main.addOperation { [weak self] in
            
            guard let strongSelf = self else { return }
            
            if strongSelf.superview != superview {
                strongSelf.indicatorView.removeFromSuperview()
                strongSelf.titleLabel.removeFromSuperview()
                strongSelf.baseView.removeFromSuperview()
                strongSelf.removeFromSuperview()
            }
            
            strongSelf.fadeOutTimer = nil
            strongSelf.fadeInDeleyTimer = nil
            strongSelf.fadeOutDelayTimer = nil
            
            if let sv = superview {
                strongSelf.containerView = sv
            } else {
                strongSelf.containerView = strongSelf.keyWindow
            }
            
            strongSelf.updateViewHierarchy()

            strongSelf.titleLabel.font = strongSelf.font
            strongSelf.indicatorView.strokeWidth = strongSelf.strokeWith
            strongSelf.baseView.layer.cornerRadius = strongSelf.cornerRadius
            strongSelf.baseView.backgroundColor = strongSelf.displayStyle.backgroundColor

            // set property form maskType
            strongSelf.isUserInteractionEnabled = strongSelf.maskType.isUserInteractionEnabled
            strongSelf.maskLayer.backgroundColor = strongSelf.maskType.backgroundColor
            
            // set property form displayStyle
            strongSelf.titleLabel.textColor = strongSelf.displayStyle.foregroundColor
            strongSelf.indicatorView.tintColor = strongSelf.displayStyle.foregroundColor
            
            // set property form displayType
            strongSelf.displayType = displayType
            strongSelf.titleLabel.text = displayType.title
            strongSelf.titleLabel.isHidden = displayType.title.isEmpty
            strongSelf.indicatorView.indcatorType = displayType.indicatorType
            
            // display
            if delayTimeInterval > 0 {
                strongSelf.fadeInDeleyTimer = Timer.scheduledTimer(timeInterval: delayTimeInterval, target: strongSelf, selector: #selector(strongSelf.fadeIn), userInfo: nil, repeats: false)
            } else {
                strongSelf.fadeIn()
            }
        }
    }
    
    func dismiss(with delayTimeInterval: TimeInterval = 0, completion: ZVProgressHUDCompletionHandler? = nil) {
        
        if delayTimeInterval > 0 {
            fadeOutDelayTimer = Timer.scheduledTimer(timeInterval: delayTimeInterval, target: self, selector: #selector(fadeOut(with:)), userInfo: completion, repeats: false)
        } else {
            fadeOut(with: completion)
        }
    }
    
    @objc private func dismiss(_ timer: Timer?) {
        dismiss()
    }
    
    @objc private func fadeIn() {
        
        guard let displayType = displayType else { return }
        
        let displayTimeInterval = getDisplayTimeInterval(for: displayType)
        
        updateSubviews()
        placeSubviews()
        
        if self.alpha != 1.0 {
            
            // send the notification HUD will appear
            NotificationCenter.default.post(name: .ZVProgressHUDWillAppear, object: self, userInfo: nil)
            
            let animationBlock = {
                self.alpha = 1.0
                self.baseView.alpha = 1.0
                self.indicatorView.alpha = 1.0
                self.titleLabel.alpha = 1.0
            }
            
            let completionBlock = {
                
                guard self.alpha == 1.0 else { return }
                
                self.fadeInDeleyTimer = nil
                
                // register keyboard notification and orientation notification
                self.registerNotifications()
                
                // send the notification HUD did appear
                NotificationCenter.default.post(name: .ZVProgressHUDDidAppear, object: self, userInfo: nil)
                
                if displayTimeInterval > 0 {
                    self.fadeOutTimer = Timer.scheduledTimer(timeInterval: displayTimeInterval, target: self, selector: #selector(self.dismiss(_:)), userInfo: nil, repeats: false)
                    RunLoop.main.add(self.fadeOutTimer!, forMode: RunLoop.Mode.common)
                } else {

                    if displayType.indicatorType.progressValueChecker.0 &&
                        displayType.indicatorType.progressValueChecker.1 >= 1.0 {
                        self.dismiss()
                    }
                }
            }
            
            if fadeInAnimationTimeInterval > 0 {
                UIView.animate(withDuration: fadeInAnimationTimeInterval,
                               delay: 0,
                               options: [.allowUserInteraction, .curveEaseOut, .beginFromCurrentState],
                               animations: {
                                   animationBlock()
                               }, completion: { _ in
                                   completionBlock()
                               })
            } else {
                animationBlock()
                completionBlock()
            }
        } else {
            
            if displayTimeInterval > 0 {
                fadeOutTimer = Timer.scheduledTimer(timeInterval: displayTimeInterval, target: self, selector: #selector(self.dismiss(_:)), userInfo: nil, repeats: false)
                RunLoop.main.add(fadeOutTimer!, forMode: RunLoop.Mode.common)
            } else {
                if displayType.indicatorType.progressValueChecker.0 &&
                    displayType.indicatorType.progressValueChecker.1 >= 1.0 {
                    dismiss()
                }
            }
        }
    }
    
    @objc private func fadeOut(with data: Any?) {
        
        var completion: ZVProgressHUDCompletionHandler?
        if let timer = data as? Timer {
            completion = timer.userInfo as? ZVProgressHUDCompletionHandler
        } else {
            completion = data as? ZVProgressHUDCompletionHandler
        }
        
        OperationQueue.main.addOperation { [weak self] in
            
            guard let strongSelf = self else { return }
            
            // send the notification HUD will disAppear
            NotificationCenter.default.post(name: .ZVProgressHUDWillDisappear, object: self, userInfo: nil)
            
            let animationBlock = {
                strongSelf.alpha = 0
                strongSelf.baseView.alpha = 0
                strongSelf.baseView.backgroundColor = .clear
                strongSelf.indicatorView.alpha = 0
                strongSelf.titleLabel.alpha = 0
            }
            
            let completionBlock = {
                
                guard strongSelf.alpha == 0 else { return }
                
                strongSelf.fadeOutTimer = nil
                strongSelf.fadeOutDelayTimer = nil
                
                // update view hierarchy
                strongSelf.indicatorView.removeFromSuperview()
                strongSelf.titleLabel.removeFromSuperview()
                strongSelf.baseView.removeFromSuperview()
                strongSelf.removeFromSuperview()

                strongSelf.containerView = nil
                
                // remove notifications from self
                NotificationCenter.default.removeObserver(strongSelf)
                
                // send the notification HUD did disAppear
                NotificationCenter.default.post(name: .ZVProgressHUDDidDisappear, object: self, userInfo: nil)
                
                // execute completion handler
                completion?()
            }
            
            if strongSelf.fadeOutAnimationTImeInterval > 0 {
                UIView.animate(withDuration: strongSelf.fadeOutAnimationTImeInterval,
                               delay: 0,
                               options: [.allowUserInteraction, .curveEaseOut, .beginFromCurrentState],
                               animations: {
                                   animationBlock()
                               }, completion: { _ in
                                   completionBlock()
                               })
            } else {
                animationBlock()
                completionBlock()
            }
            
            strongSelf.setNeedsDisplay()
        }
    }
    
    private func updateViewHierarchy() {

        if superview == nil {
            containerView?.addSubview(self)
        } else {
            containerView?.bringSubviewToFront(self)
        }
        
        if maskLayer.superlayer == nil {
            layer.addSublayer(maskLayer)
        }
        
        if baseView.superview == nil {
            addSubview(baseView)
        } else {
            bringSubviewToFront(baseView)
        }
        
        if indicatorView.superview == nil {
            baseView.addSubview(indicatorView)
        } else {
            baseView.bringSubviewToFront(indicatorView)
        }
        
        if titleLabel.superview == nil {
            baseView.addSubview(titleLabel)
        } else {
            baseView.bringSubviewToFront(titleLabel)
        }
    }
    
    private func getDisplayTimeInterval(for displayType: DisplayType) -> TimeInterval {
        
        var displayTimeInterval: TimeInterval = displayType.dismissAtomically ? 3.0 : 0
        
        guard displayTimeInterval > 0 else { return 0 }
        
        displayTimeInterval = max(Double(displayType.title.count) * 0.06 + 0.5, minimumDismissTimeInterval)
        displayTimeInterval = min(displayTimeInterval, maximumDismissTimeInterval)
        
        return displayTimeInterval
    }
    
    private func registerNotifications() {
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(placeSubviews(_:)),
                                               name: UIApplication.didChangeStatusBarOrientationNotification,
                                               object: nil)

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(placeSubviews(_:)),
                                               name: UIApplication.didBecomeActiveNotification,
                                               object: nil)

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(placeSubviews(_:)),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(placeSubviews(_:)),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(placeSubviews(_:)),
                                               name: UIResponder.keyboardDidShowNotification,
                                               object: nil)

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(placeSubviews(_:)),
                                               name: UIResponder.keyboardDidHideNotification,
                                               object: nil)
    }
}

// MARK: - Update Subviews

private extension ZVProgressHUD {
    
    func updateSubviews() {
        
        guard let containerView = containerView else { return }
        
        frame = .init(origin: .zero, size: containerView.frame.size)
        maskLayer.frame = .init(origin: .zero, size: containerView.frame.size)
        
        if !indicatorView.isHidden {
            indicatorView.frame = CGRect(origin: .zero, size: indicatorSize)
        }
        
        var labelSize: CGSize = .zero
        if !titleLabel.isHidden, let title = titleLabel.text as NSString?, title.length > 0 {
            let maxSize: CGSize = .init(width: frame.width * 0.618, height: frame.width * 0.618)
            let attributes: [NSAttributedString.Key: Any] = [NSAttributedString.Key.font: font]
            let options: NSStringDrawingOptions = [.usesFontLeading, .truncatesLastVisibleLine, .usesLineFragmentOrigin]
            labelSize = title.boundingRect(with: maxSize, options: options, attributes: attributes, context: nil).size
            titleLabel.frame = CGRect(origin: .zero, size: labelSize)
        }
        
        let labelHeight = titleLabel.isHidden ? 0 : labelSize.height + titleEdgeInsets.top + titleEdgeInsets.bottom
        let indicatorHeight = indicatorView.isHidden ? 0 : indicatorSize.height + indicatorEdgeInsets.top + indicatorEdgeInsets.bottom
        
        let contentHeight = labelHeight + indicatorHeight + contentInsets.top + contentInsets.bottom
        let contetnWidth = max(labelSize.width + titleEdgeInsets.left + titleEdgeInsets.right, indicatorSize.width + indicatorEdgeInsets.left + indicatorEdgeInsets.right) + contentInsets.left + contentInsets.right

        let contentSize: CGSize = .init(width: contetnWidth, height: contentHeight)
        let oldOrigin = self.baseView.frame.origin
        baseView.frame = .init(origin: oldOrigin, size: contentSize)
        
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        
        let centerX: CGFloat = contetnWidth / 2.0
        var centerY: CGFloat = contentHeight / 2.0

        // Indicator
        if labelHeight > 0 && !indicatorView.isHidden {
            centerY = contentInsets.top + indicatorEdgeInsets.top + indicatorSize.height / 2.0
        }
        indicatorView.center = .init(x: centerX, y: centerY)
        
        // Label
        if indicatorHeight > 0 && !titleLabel.isHidden {
            centerY = contentInsets.top + indicatorHeight + titleEdgeInsets.top + labelSize.height / 2.0
        }
        titleLabel.center = .init(x: centerX, y: centerY)
        
        CATransaction.commit()
    }
    
    @objc func placeSubviews(_ notification: Notification? = nil) {
        
        guard let containerView = containerView else { return }

        frame = .init(origin: .zero, size: containerView.frame.size)
        maskLayer.frame = .init(origin: .zero, size: containerView.frame.size)
        
        var keybordHeight: CGFloat = 0
        var animationDuration: TimeInterval = 0
        
        let orientation = UIApplication.shared.statusBarOrientation
        
        if let notification = notification, let keyboardInfo = notification.userInfo {

            let keyboardFrame = keyboardInfo[UIResponder.keyboardFrameBeginUserInfoKey] as? CGRect
            animationDuration = keyboardInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval ?? 0
            if notification.name == UIResponder.keyboardWillShowNotification || notification.name == UIResponder.keyboardDidShowNotification {
                if orientation == .portrait {
                    keybordHeight = keyboardFrame?.height ?? 0
                }
            }
        } else {
            keybordHeight = visibleKeyboardHeight
        }
        
        let orenitationFrame = frame
        var statusBarFrame: CGRect = .zero
        if containerView == self.keyWindow {
            statusBarFrame = UIApplication.shared.statusBarFrame
        }
        
        var activeHeight = orenitationFrame.height
        if keybordHeight > 0 {
            activeHeight += statusBarFrame.height * 2
        }
        
        activeHeight -= keybordHeight
        
        let posX = orenitationFrame.width / 2.0 + offset.horizontal
        let posY = activeHeight * 0.45 + offset.vertical
        let center: CGPoint = .init(x: posX, y: posY)
        
        if notification != nil {
            UIView.animate(withDuration: animationDuration,
                           delay: 0,
                           options: [.allowUserInteraction, .beginFromCurrentState],
                           animations: {
                               self.baseView.center = center
                               self.baseView.setNeedsDisplay()
                           })
        } else {
            baseView.center = center
        }
    }
}

// MARK: - Event Handler

private extension ZVProgressHUD {
    
    @objc func overlayRecievedTouchUpInsideEvent(_ sender: UIControl) {
        NotificationCenter.default.post(name: .ZVProgressHUDReceivedTouchUpInsideEvent, object: self, userInfo: nil)
    }
}

// MARK: - Getter & Setter

private extension ZVProgressHUD {
    
    var fadeOutTimer: Timer? {
        get {
            return _fadeOutTimer
        }
        set {
            if _fadeOutTimer != nil {
                _fadeOutTimer?.invalidate()
                _fadeOutTimer = nil
            }
            
            if newValue != nil {
                _fadeOutTimer = newValue
            }
        }
    }
    
    var fadeInDeleyTimer: Timer? {
        get {
            return _fadeInDeleyTimer
        }
        set {
            if _fadeInDeleyTimer != nil {
                _fadeInDeleyTimer?.invalidate()
                _fadeInDeleyTimer = nil
            }
            
            if newValue != nil {
                _fadeInDeleyTimer = newValue
            }
        }
    }
    
    var fadeOutDelayTimer: Timer? {
        get {
            return _fadeOutDelayTimer
        }
        set {
            if _fadeOutDelayTimer != nil {
                _fadeOutDelayTimer?.invalidate()
                _fadeOutDelayTimer = nil
            }
            
            if newValue != nil {
                _fadeOutDelayTimer = newValue
            }
        }
    }
    
    var keyWindow: UIWindow? {
        var keyWindow: UIWindow?
        UIApplication.shared.windows.forEach { (window) in
            if  window.screen == UIScreen.main,
                window.isHidden == false,
                window.alpha > 0,
                window.windowLevel >= UIWindow.Level.normal,
                window.windowLevel <= maxSupportedWindowLevel {
                keyWindow = window
                return
            }
        }
        return keyWindow
    }
    
    var visibleKeyboardHeight: CGFloat {
        
        var visibleKeyboardHeight: CGFloat = 0.0
        var keyboardWindow: UIWindow?
        UIApplication.shared.windows.reversed().forEach { window in
            let windowName = NSStringFromClass(window.classForCoder)
            if #available(iOS 9.0, *) {
                if windowName == "UIRemoteKeyboardWindow" {
                    keyboardWindow = window
                    return
                }
            } else {
                if windowName == "UITextEffectsWindow" {
                    keyboardWindow = window
                    return
                }
            }
        }
        
        var possibleKeyboard: UIView?
        keyboardWindow?.subviews.forEach({ subview in
            let viewClassName = NSStringFromClass(subview.classForCoder)
            if viewClassName.hasPrefix("UI") && viewClassName.hasSuffix("InputSetContainerView") {
                possibleKeyboard = subview
                return
            }
        })
        
        possibleKeyboard?.subviews.forEach({ subview in
            let viewClassName = NSStringFromClass(subview.classForCoder)
            if viewClassName.hasPrefix("UI") && viewClassName.hasSuffix("InputSetHostView") {
                let convertedRect = possibleKeyboard?.convert(subview.frame, to: self)
                let intersectedRect = convertedRect?.intersection(self.bounds)
                visibleKeyboardHeight = intersectedRect?.height ?? 0.0
                return
            }
        })
        
        return visibleKeyboardHeight
    }
}

// MARK: - ZVProgressHUD.DisplayType

extension ZVProgressHUD.DisplayType {

    var dismissAtomically: Bool {

        switch self {
        case .text:
            return true
        case .indicator(_, let type):
            switch type {
            case .success, .error, .warning:
                return true
            case .image(_, let dismissAtomically):
                return dismissAtomically
            default:
                return false
            }
        }
    }
    
    var title: String {
        
        switch self {
        case .text(let value):
            return value
        case .indicator(let title, _):
            return title ?? ""
        }
    }
    
    var indicatorType: IndicatorView.IndicatorType {
        
        switch self {
        case .text:
            return .none
        case .indicator(_, let type):
            return type
        }
    }    
}

// MARK: - ZVProgressHUD.DisplayStyle

extension ZVProgressHUD.DisplayStyle {
    
    var foregroundColor: UIColor {
        switch self {
        case .dark:
            return .white
        case .light:
            return UIColor(white: 0.2, alpha: 1)
        case .custom(let color):
            return color.foregroundColor
        }
    }
    
    var backgroundColor: UIColor {
        switch self {
        case .dark:
            return UIColor(white: 0, alpha: 0.75)
        case .light:
            return .white
        case .custom(let color):
            return color.backgroundColor
        }
    }
}

// MARK: - ZVProgressHUD.MaskType

extension ZVProgressHUD.MaskType {
    
    var backgroundColor: CGColor {
        switch self {
        case .none, .clear: return UIColor.clear.cgColor
        case .black: return UIColor.init(white: 0, alpha: 0.3).cgColor
        case .custom(let color): return color.cgColor
        }
    }
    
    var isUserInteractionEnabled: Bool {
        switch self {
        case .none: return false
        default: return true
        }
    }
}

