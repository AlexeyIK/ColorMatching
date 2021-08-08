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

//struct RGB {
//    // Percent
//    let r: Float // [0,1]
//    let g: Float // [0,1]
//    let b: Float // [0,1]
//
//    static func hsv(r: Float, g: Float, b: Float) -> HSV {
//        let min = r < g ? (r < b ? r : b) : (g < b ? g : b)
//        let max = r > g ? (r > b ? r : b) : (g > b ? g : b)
//
//        let v = max
//        let delta = max - min
//
//        guard delta > 0.00001 else { return HSV(h: 0, s: 0, v: max) }
//        guard max > 0 else { return HSV(h: -1, s: 0, v: v) } // Undefined, achromatic grey
//        let s = delta / max
//
//        let hue: (Float, Float) -> Float = { max, delta -> Float in
//            if r == max { return (g-b)/delta } // between yellow & magenta
//            else if g == max { return 2 + (b-r)/delta } // between cyan & yellow
//            else { return 4 + (r-g)/delta } // between magenta & cyan
//        }
//
//        let h = hue(max, delta) * 60 // In degrees
//
//        return HSV(h: (h < 0 ? h+360 : h) , s: s, v: v)
//    }
//
//    static func hsv(rgb: RGB) -> HSV {
//        return hsv(rgb.r, g: rgb.g, b: rgb.b)
//    }
//
//    var hsv: HSV {
//        return RGB.hsv(self)
//    }
//}
//
//struct RGBA {
//    let a: Float
//    let rgb: RGB
//
//    init(r: Float, g: Float, b: Float, a: Float) {
//        self.a = a
//        self.rgb = RGB(r: r, g: g, b: b)
//    }
//}
//
//struct HSV {
//    let h: Float // Angle in degrees [0,360] or -1 as Undefined
//    let s: Float // Percent [0,1]
//    let v: Float // Percent [0,1]
//
//    static func rgb(h: Float, s: Float, v: Float) -> RGB {
//        if s == 0 { return RGB(r: v, g: v, b: v) } // Achromatic grey
//
//        let angle = (h >= 360 ? 0 : h)
//        let sector = angle / 60 // Sector
//        let i = floor(sector)
//        let f = sector - i // Factorial part of h
//
//        let p = v * (1 - s)
//        let q = v * (1 - (s * f))
//        let t = v * (1 - (s * (1 - f)))
//
//        switch(i) {
//        case 0:
//            return RGB(r: v, g: t, b: p)
//        case 1:
//            return RGB(r: q, g: v, b: p)
//        case 2:
//            return RGB(r: p, g: v, b: t)
//        case 3:
//            return RGB(r: p, g: q, b: v)
//        case 4:
//            return RGB(r: t, g: p, b: v)
//        default:
//            return RGB(r: v, g: p, b: q)
//        }
//    }
//
//    static func rgb(hsv: HSV) -> RGB {
//        return rgb(hsv.h, s: hsv.s, v: hsv.v)
//    }
//
//    var rgb: RGB {
//        return HSV.rgb(self)
//    }
//
//    /// Returns a normalized point with x=h and y=v
//    var point: CGPoint {
//        return CGPoint(x: CGFloat(h/360), y: CGFloat(v))
//    }
//}
