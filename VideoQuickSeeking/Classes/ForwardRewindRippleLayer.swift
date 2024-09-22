//
//  ForwardRewindRippleLayer.swift
//  ForwardRewindPlayerView
//
//  Created by Hai Pham on 29/06/2022.
//

import Foundation

class ForwardRewindRippleLayer: CALayer {
    private lazy var rippleMinWidthRatio: CGFloat = 2/3 // = 8/12
    private lazy var rippleControlPointRatio: CGFloat = rippleMinWidthRatio + 1/6 // = 8/12 + 2/12 = 10/12
    
    // MARK: - Variables
    private let direction: FRDirection
    private var maskLayer = CAShapeLayer()
    private lazy var bezierPath: UIBezierPath = {
        return createBezierPath()
    }()
    
    private lazy var rippleLayer: FRRippleLayer = {
        let rippleLayer = FRRippleLayer(superLayer: self)
        rippleLayer.setRippleColor(color: .lightGray, withRippleAlpha: 0.2, withBackgroundAlpha: 0.2)
        return rippleLayer
    }()
    
    override var bounds: CGRect {
        didSet {
            self.superLayerDidResize()
        }
    }
    
    // MARK: - Constructors
    private override init(layer: Any) {
        self.direction = .rewind
        super.init()
    }
    
    init(direction: FRDirection) {
        self.direction = direction
        super.init()
        self.setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private methods
    private func setup() {
        self.mask = maskLayer
        
        self.addSublayer(self.rippleLayer)
    }
    
    private func superLayerDidResize() {
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        bezierPath = createBezierPath()
        maskLayer.path = bezierPath.cgPath
        CATransaction.commit()
    }
    
    private func createBezierPath() -> UIBezierPath {
        let bezierPath = UIBezierPath()
        switch direction {
        case .rewind:
            bezierPath.move(to: .init(x: bounds.minX, y: bounds.maxY))
            bezierPath.addLine(to: .init(x: rippleMinWidthRatio * bounds.width, y: bounds.maxY))
            bezierPath.addQuadCurve(to: .init(x: rippleMinWidthRatio * bounds.width, y: bounds.minY),
                                    controlPoint: .init(x: rippleControlPointRatio*bounds.width,
                                                        y: bounds.midY))
            bezierPath.addLine(to: .init(x: bounds.minX, y: bounds.minY))
        case .forward:
            bezierPath.move(to: .init(x: bounds.maxX, y: bounds.maxY))
            bezierPath.addLine(to: .init(x: (1 - rippleMinWidthRatio) * bounds.width, y: bounds.maxY))
            bezierPath.addQuadCurve(to: .init(x: (1 - rippleMinWidthRatio) * bounds.width, y: bounds.minY),
                                    controlPoint: .init(x: (1-rippleControlPointRatio) * bounds.width,
                                                        y: bounds.midY))
            bezierPath.addLine(to: .init(x: bounds.maxX, y: bounds.minY))
        }
        bezierPath.close()
        return bezierPath
    }
    
    // MARK: - Public methods
    public func didTouch(at point: CGPoint) {
        self.rippleLayer.startEffects(atLocation: point)
    }
    
    public func stopEffects() {
        self.rippleLayer.stopEffects()
    }
    
    public func rippleMaxWidth() -> CGFloat {
        let rippleMaxWidthRatio: CGFloat = (rippleMinWidthRatio + rippleControlPointRatio)/2 // = 9/12
        return rippleMaxWidthRatio * bounds.width
    }
    
    public func setRippleStyle(color: UIColor,
                               withRippleAlpha rippleAlpha: CGFloat,
                               withBackgroundAlpha backgroundAlpha: CGFloat) {
        self.rippleLayer.setRippleColor(color: color,
                                        withRippleAlpha: rippleAlpha,
                                        withBackgroundAlpha: backgroundAlpha)
    }
}
