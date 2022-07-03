//
//  DispatchQueue+Extensions.swift
//
//  Created by Hai Pham on 03/05/2022.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import Foundation

extension DispatchQueue {
    func debounce(interval: Int,
                  action: @escaping (() -> Void)) -> () -> Void {
        var lastFireTime = DispatchTime.now()
        let dispatchDelay = DispatchTimeInterval.milliseconds(interval)

        return {
            lastFireTime = DispatchTime.now()
            let dispatchTime: DispatchTime = DispatchTime.now() + dispatchDelay

            self.asyncAfter(deadline: dispatchTime) {
                let when: DispatchTime = lastFireTime + dispatchDelay
                let now = DispatchTime.now()
                if now.rawValue >= when.rawValue {
                    action()
                }
            }
        }
    }
}
