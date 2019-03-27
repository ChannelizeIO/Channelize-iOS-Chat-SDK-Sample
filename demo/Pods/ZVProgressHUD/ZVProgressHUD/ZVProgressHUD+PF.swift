//
//  ZVProgressHUD+Public.swift
//  ZVProgressHUD
//
//  Created by zevwings on 2018/2/25.
//  Copyright © 2018年 zevwings. All rights reserved.
//

import Foundation

public extension ZVProgressHUD {
    
    class var displayStyle: DisplayStyle {
        get {
            return shared.displayStyle
        }
        set {
            shared.displayStyle = newValue
        }
    }
    
    class var maskType: MaskType {
        get {
            return shared.maskType
        }
        set {
            shared.maskType = newValue
        }
    }
    
    class var maxSupportedWindowLevel: UIWindow.Level {
        get {
            return shared.maxSupportedWindowLevel
        }
        set {
            shared.maxSupportedWindowLevel = newValue
        }
    }
    
    class var fadeInAnimationTimeInterval: TimeInterval {
        get {
            return shared.fadeInAnimationTimeInterval
        }
        set {
            shared.fadeInAnimationTimeInterval = newValue
        }
    }
    
    class var fadeOutAnimationTImeInterval: TimeInterval {
        get {
            return shared.fadeOutAnimationTImeInterval
        }
        set {
            shared.fadeOutAnimationTImeInterval = newValue
        }
    }
    
    class var minimumDismissTimeInterval: TimeInterval {
        get {
            return shared.minimumDismissTimeInterval
        }
        set {
            shared.minimumDismissTimeInterval = newValue
        }
    }
    
    class var maximumDismissTimeInterval: TimeInterval {
        get {
            return shared.maximumDismissTimeInterval
        }
        set {
            shared.maximumDismissTimeInterval = newValue
        }
    }
    
    class var cornerRadius: CGFloat {
        get {
            return shared.cornerRadius
        }
        set {
            shared.cornerRadius = newValue
        }
    }
    
    class var offset: UIOffset {
        get {
            return shared.offset
        }
        set {
            shared.offset = newValue
        }
    }
    
    class var font: UIFont {
        get {
            return shared.font
        }
        set {
            shared.font = newValue
        }
    }
    
    class var strokeWith: CGFloat {
        get {
            return shared.strokeWith
        }
        set {
            shared.strokeWith = newValue
        }
    }
    
    class var indicatorSize: CGSize {
        get {
            return shared.indicatorSize
        }
        set {
            shared.indicatorSize = newValue
        }
    }
    
    class var animationType: IndicatorView.AnimationType {
        get {
            return shared.animationType
        }
        set {
            shared.animationType = newValue
        }
    }
    
    class var contentInsets: UIEdgeInsets {
        get {
            return shared.contentInsets
        }
        set {
            shared.contentInsets =  newValue
        }
    }
    
    class var titleEdgeInsets: UIEdgeInsets {
        get {
            return shared.titleEdgeInsets
        }
        set {
            shared.titleEdgeInsets = newValue
        }
    }
    
    class var indicatorEdgeInsets: UIEdgeInsets {
        get {
            return shared.indicatorEdgeInsets
        }
        set {
            shared.indicatorEdgeInsets = newValue
        }
    }
}

public extension ZVProgressHUD {
    
    /// show a toast
    ///
    /// - Parameters:
    ///   - text: toast content
    ///   - superview: super view, if superview is nil, show on main window
    ///   - delayTimeInterval: the view will show delay the `delayTimeInterval`
    class func showText(_ text: String,
                        in superview: UIView? = nil,
                        delay delayTimeInterval: TimeInterval = 0.0) {
        
        show(with: .text(value: text), in: superview, delay: delayTimeInterval)
    }
    
    /// show a success message
    ///
    /// - Parameters:
    ///   - title: the success message remind users what you want
    ///   - superview: super view, if superview is nil, show on main window
    ///   - delayTimeInterval: the view will show delay the `delayTimeInterval`
    class func showSuccess(with title: String = "",
                           in superview: UIView? = nil,
                           delay delayTimeInterval: TimeInterval = 0.0) {
        
        let displayType: DisplayType = .indicator(title: title, type: .success)
        show(with: displayType, in: superview, delay: delayTimeInterval)
    }
    
    
    /// show a error message
    ///
    /// - Parameters:
    ///   - title: the error message remind users what you want
    ///   - superview: super view, if superview is nil, show on main window
    ///   - delayTimeInterval: the view will show delay the `delayTimeInterval`
    class func showError(with title: String = "",
                         in superview: UIView? = nil,
                         delay delayTimeInterval: TimeInterval = 0.0) {
        
        let displayType: DisplayType = .indicator(title: title, type: .error)
        show(with: displayType, in: superview, delay: delayTimeInterval)
    }
    
    /// show a warning message
    ///
    /// - Parameters:
    ///   - title: the warning message remind users what you want
    ///   - superview: super view, if superview is nil, show on main window
    ///   - delayTimeInterval: the view will show delay the `delayTimeInterval`
    class func showWarning(with title: String = "",
                           in superview: UIView? = nil,
                           delay delayTimeInterval: TimeInterval = 0.0) {
        
        let displayType: DisplayType = .indicator(title: title, type: .warning)
        show(with: displayType, in: superview, delay: delayTimeInterval)
    }
    
    /// show a waiting alert
    ///
    /// - Parameters:
    ///   - title: the message remind users what you want
    ///   - superview: super view, if superview is nil, show on main window
    ///   - delayTimeInterval: the view will show delay the `delayTimeInterval`
    class func show(with title: String = "",
                    in superview: UIView? = nil,
                    delay delayTimeInterval: TimeInterval = 0.0) {
        
        let displayType: DisplayType = .indicator(title: title, type: .indicator(style: animationType))
        show(with: displayType, in: superview, delay: delayTimeInterval)
    }
    
    /// show the progress of some task
    ///
    /// - Parameters:
    ///   - progress: the progress of your task
    ///   - title: the message remind users what you want
    ///   - superview: super view, if superview is nil, show on main window
    ///   - delayTimeInterval: the view will show delay the `delayTimeInterval`
    class func showProgress(_ progress: Float,
                            title: String = "",
                            in superview: UIView? = nil,
                            delay delayTimeInterval: TimeInterval = 0.0) {
        
        let displayType: DisplayType = .indicator(title: title, type: .progress(value: progress))
        show(with: displayType, in: superview, delay: delayTimeInterval)
    }
    
    /// show a custom image
    ///
    /// - Parameters:
    ///   - image: your image
    ///   - title: the message remind users what you want
    ///   - superview: super view, if superview is nil, show on main window
    ///   - dismissAtomically: if `true` the `HUD` will dissmiss atomically
    ///   - delayTimeInterval: the view will show delay the `delayTimeInterval`
    class func showImage(_ image: UIImage,
                         title: String = "",
                         in superview: UIView? = nil,
                         dismissAtomically: Bool = true,
                         delay delayTimeInterval: TimeInterval = 0.0) {
        
        let displayType: DisplayType = .indicator(title: title, type: .image(value: image, dismissAtomically: dismissAtomically))
        show(with: displayType, in: superview, delay: delayTimeInterval)
    }
    
    /// show the animation waiting alert
    ///
    /// - Parameters:
    ///   - images: animation image array
    ///   - duration: animation duration @see UIImage
    ///   - title: the message remind users what you want
    ///   - superview: super view, if superview is nil, show on main window
    ///   - delayTimeInterval: the view will show delay the `delayTimeInterval`
    class func showAnimation(_ images: [UIImage],
                             duration: TimeInterval = 0.0,
                             title: String = "",
                             in superview: UIView? = nil,
                             delay delayTimeInterval: TimeInterval = 0.0) {
        
        guard images.count > 0 else { return }
        var animationDuration = duration
        if animationDuration == 0 { animationDuration = Double(images.count) * 0.1 }
        let displayType: DisplayType = .indicator(title: title, type: .animation(value: images, duration: animationDuration))
        show(with: displayType, in: superview, delay: delayTimeInterval)
    }
    
    /// show custom display type @see ZVProgressHUD.DisplayType
    ///
    /// - Parameters:
    ///   - displayType: ZVProgressHUD.DisplayType
    ///   - superview: super view, if superview is nil, show on main window
    ///   - delayTimeInterval: the view will show delay the `delayTimeInterval`
    class func show(with displayType: DisplayType,
                    in superview: UIView? = nil,
                    delay delayTimeInterval: TimeInterval = 0.0) {
        
        shared.show(with: displayType, in: superview, delay: delayTimeInterval)
    }
    
    /// dismiss the hud
    ///
    /// - Parameters:
    ///   - delay: the view will dissmiss delay the `delayTimeInterval`
    ///   - completion: dismiss completion handler
    class func dismiss(delay: TimeInterval = 0.0, completion: ZVProgressHUDCompletionHandler? = nil) {
        shared.dismiss(with: delay, completion: completion)
    }
}
