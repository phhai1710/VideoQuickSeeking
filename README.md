# VideoQuickSeeking

[![CI Status](https://img.shields.io/travis/phhai1710/VideoQuickSeeking.svg?style=flat)](https://travis-ci.org/phhai1710/VideoQuickSeeking)
[![Version](https://img.shields.io/cocoapods/v/VideoQuickSeeking.svg?style=flat)](https://cocoapods.org/pods/VideoQuickSeeking)
[![License](https://img.shields.io/cocoapods/l/VideoQuickSeeking.svg?style=flat)](https://cocoapods.org/pods/VideoQuickSeeking)
[![Platform](https://img.shields.io/cocoapods/p/VideoQuickSeeking.svg?style=flat)](https://cocoapods.org/pods/VideoQuickSeeking)

![VideoQuickSeeking](https://github.com/phhai1710/VideoQuickSeeking/blob/master/Resources/sample.gif?raw=true)

Youtube-like double tap to forward/rewind animation with ripple effect.

Please feel free to make pull requests.

  
## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

## Installation

VideoQuickSeeking is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'VideoQuickSeeking'
```
## Usage In Swift
``` Swift
let quickSeekingView = QuickSeekingView(seekingDuration: 10)
```
To achieve ripple effect, add QuickSeekingView onto the top of video player view. Handle double tap gesture of video player view and pass it to QuickSeekingView.
```Swift
let doubleTapGesture = UITapGestureRecognizer(target: self, action: #selector(doubleTap))
doubleTapGesture.numberOfTapsRequired = 2
<video_player_view>.addGestureRecognizer(doubleTapGesture)

@objc private func doubleTap(_ sender: UIGestureRecognizer) {
    let point = sender.location(in: self.quickSeekingView)
    // Pass touch point to QuickSeekingView here
}
```

The following methods are available on QuickSeekingView.

### 1. setRippleStyle
Set the expected style of ripple effect
```Swift
func setRippleStyle(color: UIColor,
                    withRippleAlpha rippleAlpha: CGFloat, 
                    withBackgroundAlpha backgroundAlpha: CGFloat)
```

### 2. directionOfPoint
Get the direction(Forward/Rewind) of the current point
```Swift
func directionOfPoint(point: CGPoint) -> FRDirection?
```

### 3. animate
Perform ripple effect at a specific point
```Swift
func animate(direction: FRDirection, at point: CGPoint,shouldResetSeekingCounter: Bool = false)
```
## Author

Hai Pham, phhai1710@gmail.com

## Inspired
This project reuse [RippleLayer](https://github.com/twho/material-design-widgets-lite-ios/blob/master/MaterialDesignWidgets/MaterialDesignWidgets/RippleLayer.swift) of [Twho](https://github.com/twho)

## License

VideoQuickSeeking is available under the MIT license. See the LICENSE file for more info.
