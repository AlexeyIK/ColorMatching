//
//  Hardness.swift
//  Color Matching
//
//  Created by Alexey on 23.07.2021.
//

import Foundation

enum Hardness: Int  {
    case easy = 1
    case normal = 2
    case hard = 3
    case hell = 4
}

struct HardnessParams {
    let saturationRange: ClosedRange<Int>
    let valueRange: ClosedRange<Int>
}

let hardnessCardPickerParameters: [Hardness: HardnessParams] = [
    .easy: HardnessParams(saturationRange: 80...100, valueRange: 20...85),
    .normal: HardnessParams(saturationRange: 60...100, valueRange: 15...90),
    .hard: HardnessParams(saturationRange: 60...100, valueRange: 10...95),
    .hell: HardnessParams(saturationRange: 5...10, valueRange: 10...95) // поправить позже
]
