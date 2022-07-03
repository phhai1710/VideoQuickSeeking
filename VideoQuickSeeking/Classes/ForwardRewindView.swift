//
//  ForwardRewindView.swift
//
//  Created by Hai Pham on 03/05/2022.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import UIKit

public class ForwardRewindView: UIView {
    
    // MARK: - Constants
    static let animationDuration: TimeInterval = 0.3
    static let animationDelay: TimeInterval = 0.1
    
    static let imageViewSize: CGFloat = 20
    static let textLabelHeight: CGFloat = 20
    static let viewPadding: CGFloat = 5
    // MARK: - Variables
    
    private let direction: FRDirection
    private lazy var textLabel: UILabel = {
        let textLabel = UILabel()
        textLabel.textColor = tintColor
        textLabel.alpha = 0
        textLabel.textAlignment = .center
        textLabel.text = "\(self.seekingDuration)s"
        return textLabel
    }()

    private let imageView1 = UIImageView()
    private let imageView2 = UIImageView()
    private let imageView3 = UIImageView()
    private var imageViews: [UIImageView] { [imageView1, imageView2, imageView3] }
    private let containerView = UIView()
    private let imagesContainerView = UIView()
    
    private let seekingDuration: Int
    private lazy var debouncedFunction: (() -> Void) = {
        let debouncedFunction = DispatchQueue.main.debounce(interval: 900) { [weak self] in
            guard let strongSelf = self else { return }
            UIView.animate(withDuration: ForwardRewindView.animationDuration) { [weak self] in
                guard let strongSelf = self else { return }
                strongSelf.textLabel.alpha = 0
            }
            strongSelf.forwardRewindSubLayer.stopEffects()
        }
        return debouncedFunction
    }()
    private lazy var forwardRewindSubLayer: ForwardRewindRippleLayer = {
        let forwardRewindSubLayer = ForwardRewindRippleLayer(direction: direction)
        return forwardRewindSubLayer
    }()

    // MARK: - Constructors
    
    init(direction: FRDirection,
         seekingDuration: Int = 10) {
        self.direction = direction
        self.seekingDuration = seekingDuration
        super.init(frame: .zero)
        self.setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override var tintColor: UIColor! {
        didSet {
            self.imageViews.forEach { $0.tintColor = self.tintColor }
            self.textLabel.textColor = self.tintColor
        }
    }
    
    // MARK: - Lifecycle
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        self.imageViews.enumerated().forEach { index, imageView in
            imageView.frame = CGRect(x: CGFloat(index) * ForwardRewindView.imageViewSize,
                                     y: 0,
                                     width: ForwardRewindView.imageViewSize,
                                     height: ForwardRewindView.imageViewSize)
        }
        self.imagesContainerView.frame = CGRect(x: 0,
                                                y: 0,
                                                width: CGFloat(imageViews.count) * ForwardRewindView.imageViewSize,
                                                height: ForwardRewindView.imageViewSize)
        
        self.textLabel.frame = CGRect(x: 0,
                                      y: imagesContainerView.frame.maxY + ForwardRewindView.viewPadding,
                                      width: imagesContainerView.frame.width,
                                      height: ForwardRewindView.textLabelHeight)
        
        let containerHeight = self.textLabel.frame.maxY - self.imagesContainerView.frame.minY
        let containerWidth = self.imagesContainerView.frame.width
        let containerX: CGFloat
        switch direction {
        case .rewind:
            containerX = (forwardRewindSubLayer.rippleMaxWidth() - containerWidth)/2
        case .forward:
            containerX = (bounds.width - forwardRewindSubLayer.rippleMaxWidth()) + (forwardRewindSubLayer.rippleMaxWidth() - containerWidth)/2
        }
        self.containerView.frame = CGRect(x: containerX,
                                          y: (bounds.height - containerHeight)/2,
                                          width: containerWidth,
                                          height: containerHeight)
        
        self.forwardRewindSubLayer.frame = self.bounds
    }
    
    public func setRippleStyle(color: UIColor,
                               withRippleAlpha rippleAlpha: CGFloat,
                               withBackgroundAlpha backgroundAlpha: CGFloat) {
        self.forwardRewindSubLayer.setRippleStyle(color: color,
                                                  withRippleAlpha: rippleAlpha,
                                                  withBackgroundAlpha: backgroundAlpha)
    }
    
    // MARK: - Private methods
    
    private func setupView() {
        self.isUserInteractionEnabled = false
        self.layer.addSublayer(self.forwardRewindSubLayer)
                
        let triangle = UIImage(named: self.direction.iconName,
                               in: ImageHelper.podsBundle,
                               compatibleWith: nil)?
            .withRenderingMode(.alwaysTemplate)
        
        self.imageViews.forEach { imageView in
            imageView.alpha = 0
            imageView.image = triangle
            imageView.contentMode = .scaleAspectFit
            imageView.tintColor = self.tintColor
            self.imagesContainerView.addSubview(imageView)
        }
        self.containerView.addSubview(self.imagesContainerView)
        self.containerView.addSubview(self.textLabel)
        self.addSubview(self.containerView)
    }
    
    private func animateView(_ view: UIView,
                             offset: Int = 0,
                             shouldHide: Bool = true) {
        UIView.animate(withDuration: ForwardRewindView.animationDuration,
                       delay: Double(offset) * ForwardRewindView.animationDelay,
                       animations: { [weak view] in
                        view?.alpha = 1
        }, completion: { finished in
            UIView.animate(withDuration: ForwardRewindView.animationDuration,
                           delay: 4 * ForwardRewindView.animationDelay,
                           animations: { [weak view] in
                            if shouldHide {
                                view?.alpha = 0
                            }
            })
        })
    }
    
    // MARK: - Public methods
    
    func animate(iteration: Int, at point: CGPoint) {
        self.debouncedFunction()
        
        self.textLabel.text = "\(self.seekingDuration * iteration)s"
        self.animateView(self.textLabel, shouldHide: false)
        
        let imageViewsToAnimate = self.direction.orderImageViewss(self.imageViews)
        imageViewsToAnimate.enumerated().forEach { offset, imageView in
            self.animateView(imageView, offset: offset)
        }
        self.forwardRewindSubLayer.didTouch(at: point)
    }
}
