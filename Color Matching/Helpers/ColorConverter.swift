//
//  ColorConverter.swift
//  Color Matching
//
//  Created by Alexey on 19.07.2021.
//

import Foundation
import SwiftUI

func ColorConvert(colorType: ColorValueType, value: (Int, Int, Int, Double)) -> Color {
    
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

func ColorConvert(rgb value: [Int?]) -> Color {
    let r = Double(value[0] ?? 0)
    let g = Double(value[1] ?? 0)
    let b = Double(value[2] ?? 0)
    
    return Color.init(red: r / 255, green: g / 255, blue: b / 255)
}

func RBGConvertToHSV(_ value: [Int?]) -> [Int] {
    let r = CGFloat(value[0] ?? 0 / 255)
    let g = CGFloat(value[1] ?? 0 / 255)
    let b = CGFloat(value[2] ?? 0 / 255)
    
    let rgb: UIColor = UIColor.init(red: r, green: g, blue: b, alpha: 1)
    var hsvaFloat: (h: CGFloat, s: CGFloat, v: CGFloat, a: CGFloat) = (0, 0, 0, 0)
    rgb.getHue(&(hsvaFloat.h), saturation: &(hsvaFloat.s), brightness: &(hsvaFloat.v), alpha: &(hsvaFloat.a))
    
    return [Int(hsvaFloat.h * 360), Int(hsvaFloat.s * 100), Int(hsvaFloat.v * 100)]
}

func HSVConvertToRGB(_ value: [Int?]) -> [Int] {
    let h = CGFloat(value[0] ?? 0) / 360
    let s = CGFloat(value[1] ?? 0) / 100
    let v = CGFloat(value[2] ?? 0) / 100
    
    let hsva: UIColor = UIColor.init(hue: h, saturation: s, brightness: v, alpha: 1)
    var rgbaFloat: (r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat) = (0, 0, 0, 0)
    hsva.getRed(&(rgbaFloat.r), green: &(rgbaFloat.g), blue: &(rgbaFloat.b), alpha: &(rgbaFloat.a))
    
    return [Int(rgbaFloat.r * 255), Int(rgbaFloat.g * 255), Int(rgbaFloat.b * 255)]
}

func HSVConvertToRGB(_ value: [Double?]) -> [Double] {
    let h = CGFloat(value[0] ?? 0)
    let s = CGFloat(value[1] ?? 0)
    let v = CGFloat(value[2] ?? 0)
    
    let hsva: UIColor = UIColor.init(hue: h, saturation: s, brightness: v, alpha: 1)
    var rgbaFloat: (r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat) = (0, 0, 0, 0)
    hsva.getRed(&(rgbaFloat.r), green: &(rgbaFloat.g), blue: &(rgbaFloat.b), alpha: &(rgbaFloat.a))
    
    return [Double(rgbaFloat.r), Double(rgbaFloat.g), Double(rgbaFloat.b)]
}

enum ColorValueType {
    case rgba
    case hsba
}
