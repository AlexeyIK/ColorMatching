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
            return Color.init(hue: doubleValue.0 / 100, saturation: doubleValue.1 / 100, brightness: doubleValue.2 / 100, opacity: doubleValue.3)
    }
}

enum ColorValueType {
    case rgba
    case hsba
}
