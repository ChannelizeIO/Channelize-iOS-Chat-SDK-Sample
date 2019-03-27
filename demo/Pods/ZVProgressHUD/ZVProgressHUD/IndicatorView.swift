//
//  ZVStateView.swift
//  ZVProgressHUD
//
//  Created by zevwings on 2017/7/13.
//  Copyright © 2017年 zevwings. All rights reserved.
//

import UIKit
import ZVActivityIndicatorView

public class IndicatorView: UIView {

    public enum IndicatorType {
        case none
        case error, success, warning
        case indicator(style: AnimationType)
        case progress(value: Float)
        case image(value: UIImage, dismissAtomically: Bool)
        case animation(value: [UIImage], duration: TimeInterval)
    }
    
    public enum AnimationType {
        case flat
        case native
    }
    
    var strokeWidth: CGFloat = 3.0 {
        didSet {
            flatActivityIndicatorView?.strokeWidth = strokeWidth
        }
    }
    
    var indcatorType: IndicatorType = .none {
        didSet {
            switch indcatorType {
            case .indicator(let style):
                switch (style) {
                case .native:
                    configNativeActivityIndicatorView()
                    break
                case .flat:
                    configFlatActivityIndicatorView()
                    break
                }
                break
            case .progress(let value):
                configProgressIndicatorView(with: value)
                break
            case .error, .success, .warning:
                configImageIndicatorView(indcatorType.resource)
                break
            case .image(let value, _):
                configImageIndicatorView(value)
                break
            case .animation(let value, let duration):
                configImageIndicatorView(value, animationDuration: duration)
                break
            default:
                break
            }
            isHidden = indcatorType.shouldHidden
        }
    }
    
    private var imageIndicaotorView: UIImageView?
    private var nativeActivityIndicatorView: UIActivityIndicatorView?
    private var flatActivityIndicatorView: ZVActivityIndicatorView?
    private var progressIndicatorView: ProgressView?
    
    convenience init() {
        self.init(frame: .zero)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        isUserInteractionEnabled = false
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Override

extension IndicatorView {
    
    override public var tintColor: UIColor! {
        didSet {
            imageIndicaotorView?.tintColor = tintColor
            nativeActivityIndicatorView?.color = tintColor
            flatActivityIndicatorView?.tintColor = tintColor
            progressIndicatorView?.strokeColor = tintColor
        }
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        let subViewFrame = CGRect(origin: .zero, size: frame.size)
        
        imageIndicaotorView?.frame = subViewFrame
        flatActivityIndicatorView?.frame = subViewFrame
        nativeActivityIndicatorView?.frame = subViewFrame
        progressIndicatorView?.frame = subViewFrame
    }
}

// MARK: - Private Method

private extension IndicatorView {
    
    func configImageIndicatorView(_ value: Any, animationDuration: TimeInterval = 0.0) {

        flatActivityIndicatorView?.stopAnimating()
        flatActivityIndicatorView?.removeFromSuperview()
        
        nativeActivityIndicatorView?.stopAnimating()
        nativeActivityIndicatorView?.removeFromSuperview()
        
        imageIndicaotorView?.stopAnimating()
        imageIndicaotorView?.animationImages = nil
        imageIndicaotorView?.image = nil
        
        progressIndicatorView?.removeFromSuperview()
        
        if imageIndicaotorView == nil {
            imageIndicaotorView = UIImageView(frame: .zero)
            imageIndicaotorView?.isUserInteractionEnabled = false
        }

        if imageIndicaotorView?.superview == nil {
            addSubview(imageIndicaotorView!)
        }
        
        if let resource = value as? String {
            
            guard let path = Bundle(for: ZVProgressHUD.self).path(forResource: "Resource", ofType: "bundle") else { return }
            let bundle = Bundle(path: path)
            guard let fileName = bundle?.path(forResource: resource, ofType: "png") else { return }
            let image = UIImage(contentsOfFile: fileName)?.withRenderingMode(.alwaysTemplate)
            imageIndicaotorView?.tintColor = tintColor
            imageIndicaotorView?.image = image
        } else if let image = value as? UIImage {
            
            imageIndicaotorView?.image = image
        } else if let animationImages = value as? [UIImage] {
            
            if animationImages.isEmpty {
                imageIndicaotorView?.image = nil
            } else if animationImages.count == 1 {
                imageIndicaotorView?.image = animationImages[0]
            } else {
                imageIndicaotorView?.animationImages = animationImages
                imageIndicaotorView?.animationDuration = animationDuration
                imageIndicaotorView?.startAnimating()
            }

            imageIndicaotorView?.animationImages = animationImages
            imageIndicaotorView?.startAnimating()
        }
    }
    
    func configProgressIndicatorView(with value: Float) {
        
        flatActivityIndicatorView?.stopAnimating()
        flatActivityIndicatorView?.removeFromSuperview()
        
        imageIndicaotorView?.animationImages = nil
        imageIndicaotorView?.image = nil
        imageIndicaotorView?.stopAnimating()
        imageIndicaotorView?.removeFromSuperview()
        
        nativeActivityIndicatorView?.stopAnimating()
        nativeActivityIndicatorView?.removeFromSuperview()

        if progressIndicatorView == nil {
            progressIndicatorView = ProgressView(frame: .zero)
            progressIndicatorView?.strokeColor = tintColor
        }
        
        if progressIndicatorView?.superview == nil {
            addSubview(progressIndicatorView!)
        }

        progressIndicatorView?.updateProgress(value)
    }
    
    private func configNativeActivityIndicatorView() {
        
        flatActivityIndicatorView?.stopAnimating()
        flatActivityIndicatorView?.removeFromSuperview()
        
        imageIndicaotorView?.animationImages = nil
        imageIndicaotorView?.image = nil
        imageIndicaotorView?.stopAnimating()
        imageIndicaotorView?.removeFromSuperview()

        progressIndicatorView?.removeFromSuperview()

        if nativeActivityIndicatorView == nil {
            nativeActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
            nativeActivityIndicatorView?.color = tintColor
            nativeActivityIndicatorView?.hidesWhenStopped = true
        }
        
        if nativeActivityIndicatorView?.superview == nil {
            addSubview(nativeActivityIndicatorView!)
        }
        
        nativeActivityIndicatorView?.startAnimating()
    }
    
    private func configFlatActivityIndicatorView() {
        
        nativeActivityIndicatorView?.stopAnimating()
        nativeActivityIndicatorView?.removeFromSuperview()
        
        imageIndicaotorView?.image = nil
        imageIndicaotorView?.animationImages = nil
        imageIndicaotorView?.stopAnimating()
        imageIndicaotorView?.removeFromSuperview()
        
        progressIndicatorView?.removeFromSuperview()

        if flatActivityIndicatorView == nil {
            flatActivityIndicatorView = ZVActivityIndicatorView()
            flatActivityIndicatorView?.tintColor = tintColor
            flatActivityIndicatorView?.hidesWhenStopped = true
            flatActivityIndicatorView?.strokeWidth = strokeWidth
        }
        
        if flatActivityIndicatorView?.superview == nil {
            addSubview(flatActivityIndicatorView!)
        }
        
        flatActivityIndicatorView?.startAnimating()
    }
}

// MARK: - IndicatorView.IndicatorType

extension IndicatorView.IndicatorType {
    
    var resource: String {
        switch self {
        case .error:
            return "error"
        case .success:
            return "success"
        case .warning:
            return "warning"
        default:
            return ""
        }
    }
    
    var shouldHidden: Bool {
        switch self {
        case .none:
            return true
        default:
            return false
        }
    }
    
    var progressValueChecker: (Bool, Float) {
        switch self {
        case .progress(let value):
            return (true, value)
        default:
            return (false, 0.0)
        }
    }
}

