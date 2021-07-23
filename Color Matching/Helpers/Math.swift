//
//  Math.swift
//  Color Matching
//
//  Created by Alexey on 22.07.2021.
//

import Foundation

extension Comparable {
    /// make sure the value is in defined range
    func clamped(to limits: ClosedRange<Self>) -> Self {
        return min(max(self, limits.lowerBound), limits.upperBound)
    }
}

/// shortest angle distance
func angleDistance(a: Int, b: Int) -> Int {
    let diff = abs(b - a) % 360
    let distance = diff > 180 ? 360 - diff : diff
    return distance;
}
