//
//  ColorConverter.swift
//  Color Matching
//
//  Created by Alexey on 19.07.2021.
//

import Foundation
import SwiftUI

func ConvertColor(colorType: ColorValueType, value: (Int, Int, Int, Double)) -> Color {
    
    var doubleValue: (Double, Double, Double, Double)
    doubleValue.0 = Double(value.0)
    doubleValue.1 = Double(value.1)
    doubleValue.2 = Double(value.2)
    doubleValue.3 = Double(value.3)
    
    switch colorType {
        case .rgba:
            return Color.init(red: doubleValue.0 / 255, green: doubleValue.1 / 255, blue: doubleValue.2 / 255, opacity: doubleValue.3)
        case .hsba:
            return Color.init(hue: doubleValue.0 / 360, saturation: doubleValue.1 / 100, brightness: doubleValue.2 / 100, opacity: doubleValue.3)
    }
}

func ConvertColor(rgb value: [Int?]) -> Color {
    let r = Double(value[0] ?? 0)
    let g = Double(value[1] ?? 0)
    let b = Double(value[2] ?? 0)
    
    return Color.init(red: r / 255, green: g / 255, blue: b / 255)
}

enum ColorValueType {
    case rgba
    case hsba
}
