//
//  ZVActivityIndicatorView.swift
//  ZVActivityIndicatorView
//
//  Created by zevwings on 24/01/2018.
//  Copyright © 2018 zevwings. All rights reserved.
//

public class ZVActivityIndicatorView: UIView {
    
    public private(set) var isAnimating: Bool = false
    public var duration: TimeInterval = 1.25
    public var timingFunction: CAMediaTimingFunction?

    public var strokeWidth: CGFloat = 1.0 {
        didSet {
            animationLayer?.lineWidth = strokeWidth
            updateAnimationLayer()
        }
    }
    
    public var strokColor: UIColor? = .white {
        didSet {
            animationLayer?.strokeColor = strokColor?.cgColor
        }
    }
    
    public var hidesWhenStopped: Bool = true {
        didSet {
            isHidden = (!isAnimating && hidesWhenStopped)
        }
    }
    
    public var progress: CGFloat = 0.0 {
        didSet {
            animationLayer?.strokeEnd = progress
        }
    }

    private var animationLayer: CAShapeLayer?
    private var isObserved: Bool = false
    
    deinit {
        removeObserver()
    }
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        prepare()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        prepare()
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        updateAnimationLayer()
    }
}

extension ZVActivityIndicatorView {

    override public var tintColor: UIColor! {
        get {
            return strokColor
        }
        set {
            strokColor = newValue
            animationLayer?.strokeColor = strokColor?.cgColor
        }
    }
}

public extension ZVActivityIndicatorView {
    
    func startAnimating() {
        
        guard isAnimating == false else { return }
        
        let animation = CABasicAnimation()
        animation.keyPath = "transform.rotation"
        animation.duration = duration / 0.375
        animation.fromValue = 0
        animation.toValue = CGFloat(2 * Double.pi)
        animation.repeatCount = Float.infinity
        animation.isRemovedOnCompletion = false
        animationLayer?.add(animation, forKey: "com.zevwings.animation.rotate")
        
        let headAnimation = CABasicAnimation()
        headAnimation.keyPath = "strokeStart"
        headAnimation.duration = duration / 1.5
        headAnimation.fromValue = 0
        headAnimation.toValue = 0.25
        headAnimation.timingFunction = timingFunction;
        
        let tailAnimation = CABasicAnimation()
        tailAnimation.keyPath = "strokeEnd"
        tailAnimation.duration = duration / 1.5
        tailAnimation.fromValue = 0
        tailAnimation.toValue = 1
        tailAnimation.timingFunction = timingFunction;
        
        let endHeadAnimation = CABasicAnimation()
        endHeadAnimation.keyPath = "strokeStart";
        endHeadAnimation.beginTime = duration / 1.5
        endHeadAnimation.duration = duration / 3.0
        endHeadAnimation.fromValue = 0.25
        endHeadAnimation.toValue = 1.0
        endHeadAnimation.timingFunction = timingFunction;
        
        let endTailAnimation = CABasicAnimation()
        endTailAnimation.keyPath = "strokeEnd"
        endTailAnimation.beginTime = duration / 1.5
        endTailAnimation.duration = duration / 3.0
        endTailAnimation.fromValue = 1.0
        endTailAnimation.toValue = 1.0
        endTailAnimation.timingFunction = timingFunction;
        
        let animations = CAAnimationGroup()
        animations.duration = duration
        animations.animations = [headAnimation, tailAnimation, endHeadAnimation, endTailAnimation]
        animations.repeatCount = Float.infinity
        animations.isRemovedOnCompletion = false
        animationLayer?.add(animations, forKey: "com.zevwings.animation.stroke")
        
        isAnimating = true
        if hidesWhenStopped { isHidden = false }
    }
    
    func stopAnimating() {
        
        guard isAnimating else { return }
        
        animationLayer?.removeAnimation(forKey: "com.zevwings.animation.rotate")
        animationLayer?.removeAnimation(forKey: "com.zevwings.animation.stroke")
        
        isAnimating = false;
        if hidesWhenStopped { isHidden = true }
    }
    
}

private extension ZVActivityIndicatorView {
    
    func prepare() {
        
        self.backgroundColor = .clear

        self.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        
        if !isObserved { addObserver() }
        
        if (animationLayer == nil) {
            animationLayer = CAShapeLayer()
            layer.addSublayer(animationLayer!)
        }
        
        animationLayer?.fillColor = nil
        animationLayer?.strokeColor = strokColor?.cgColor
        animationLayer?.lineWidth = strokeWidth
        animationLayer?.strokeStart = 0
        animationLayer?.strokeEnd = 0.0
    }
    
    func updateAnimationLayer() {
        
        guard frame != .zero else { return }
        animationLayer?.frame = .init(x: 0, y: 0, width: frame.width, height: frame.height)

        let center = CGPoint(x: bounds.midX, y: bounds.midY)
        let radius = min(bounds.width / 2, bounds.height / 2) - strokeWidth / 2
        let startAngle: CGFloat = 0.0
        let endAngle = CGFloat(2 * Double.pi)
        
        let bezierPath = UIBezierPath(arcCenter: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
        
        animationLayer?.path = bezierPath.cgPath
    }
    
    func addObserver() {
        guard isObserved == false else { return }
        isObserved = true
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(resetAnimating),
                                               name: NSNotification.Name.UIApplicationDidBecomeActive,
                                               object: nil)
    }
    
    func removeObserver() {
        guard isObserved else { return }
        isObserved = false
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func resetAnimating() {
        
        if isAnimating {
            stopAnimating()
            startAnimating()
        }
    }
}
