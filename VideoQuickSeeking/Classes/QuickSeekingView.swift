//
//  ForwardRewindPlayerView.swift
//
//  Created by Hai Pham on 03/05/2022.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import UIKit
import Foundation

private struct Constants {
    static let animationDuration: TimeInterval = 0.7
    static let debounceDurationInMilliSecondas: Int = 900
}

open class QuickSeekingView: UIView {
    
    // MARK: - Variables
    private lazy var forwardView: ForwardRewindView = {
        let forwardView = ForwardRewindView(direction: .forward,
                                            seekingDuration: self.seekingDuration)
        return forwardView
    }()
    private lazy var rewindView: ForwardRewindView = {
        let rewindView = ForwardRewindView(direction: .rewind,
                                           seekingDuration: self.seekingDuration)
        return rewindView
    }()
    private lazy var debouncedFunction: (() -> Void) = {
        let debouncedFunction = DispatchQueue.main.debounce(interval: Constants.debounceDurationInMilliSecondas) { [weak self] in
            self?.resetView()
        }
        return debouncedFunction
    }()
    
    public override var tintColor: UIColor! {
        didSet {
            self.forwardView.tintColor = tintColor
            self.rewindView.tintColor = tintColor
        }
    }
    
    private var direction: FRDirection = .forward
    private var iteration = 1
    var seekingDuration = 10
    
    // MARK: - Constructors
    init() {
        super.init(frame: .zero)
        self.setupView()
    }
    
    /// Constructor
    ///
    /// - Parameter seekingDuration: Number of second for each forward/rewind
    public init(seekingDuration: Int = 10) {
        super.init(frame: .zero)
        self.seekingDuration = seekingDuration
        self.setupView()
    }
    
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        self.setupView()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupView()
    }
    
    // MARK: - Lifecycle
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        self.rewindView.frame = CGRect(x: 0,
                                       y: 0,
                                       width: self.bounds.width/2,
                                       height: self.bounds.height)
        self.forwardView.frame = CGRect(x: self.bounds.width/2,
                                        y: 0,
                                        width: self.bounds.width/2,
                                        height: self.bounds.height)
    }
    
    // MARK: - Public
    
    /// Perform foward/rewind animation
    ///
    /// - Parameters:
    ///   - direction: Forward or Rewind
    ///   - point: Position of touch point
    ///   - shouldResetSeekingCounter: Should reset seeking counter if seeking to the begining/end of the video
    public func animate(direction: FRDirection,
                        at point: CGPoint,
                        shouldResetSeekingCounter: Bool = false) {
        if self.direction != direction || shouldResetSeekingCounter {
            self.resetView()
        }

        self.direction = direction
        switch direction {
        case .rewind:
            self.rewindView.animate(iteration: iteration,
                                    at: self.convert(point, to: rewindView))
        case .forward:
            self.forwardView.animate(iteration: iteration,
                                     at: self.convert(point, to: forwardView))
        }
        
        self.animateTransparentOverlay()
    }
    
    /// Get the direction(Forward/Rewind) of touch point
    ///
    /// - Parameter point: Position of touch point
    /// - Returns: Direction(Forward/Rewind) or nil if the point is in outside
    public func directionOfPoint(point: CGPoint) -> FRDirection? {
        let point = self.convert(point, to: self.rewindView)
        if self.rewindView.bounds.contains(point) {
            return .rewind
        } else {
            let point = self.convert(point, to: self.forwardView)
            if self.forwardView.bounds.contains(point) {
                return .forward
            }
        }
        return nil
    }
    
    /// Set ripple style for forward/rewind
    ///
    /// - Parameters:
    ///   - color: Color of ripple
    ///   - rippleAlpha: Alpha of ripple
    ///   - backgroundAlpha: Alpha of ripple background
    public func setRippleStyle(color: UIColor,
                               withRippleAlpha rippleAlpha: CGFloat,
                               withBackgroundAlpha backgroundAlpha: CGFloat) {
        [self.forwardView, self.rewindView].forEach { view in
            view.setRippleStyle(color: color,
                                withRippleAlpha: rippleAlpha,
                                withBackgroundAlpha: backgroundAlpha)
        }
    }
    
    // MARK: - Private
    
    private func setupView() {
        self.isUserInteractionEnabled = false
                
        self.rewindView.tintColor = tintColor
        self.addSubview(rewindView)
        
        self.forwardView.tintColor = tintColor
        self.addSubview(forwardView)
    }
    
    private func resetView() {
        self.iteration = 1
    }
    
    private func animateTransparentOverlay() {
        self.iteration += 1
        self.debouncedFunction()
    }
}
