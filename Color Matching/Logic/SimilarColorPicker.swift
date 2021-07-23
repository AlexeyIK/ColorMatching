//
//  SimilarColorPicker.swift
//  Color Matching
//
//  Created by Alexey on 23.07.2021.
//

import Foundation
import SwiftUI

public class SimilarColorPicker {
    
    static let shared = SimilarColorPicker()
    
    private init() { }
    
    func getSimilarColors(colorRef: ColorModel, for hardness: Hardness) -> [ColorModel?] {
        
        var similarColor1: ColorModel?
        var similarColor2: ColorModel?
        
        switch hardness {
            case .easy:
                let hueStep = 90
                let hueOffset = 30
                let saturationOffset = 10
                let valueOffset = 10
                
                var newHue1 = (colorRef.colorHSV[0]! - hueStep)
                if newHue1 < 0 {
                    newHue1 = newHue1 + 360
                }
                var newHue2 = (colorRef.colorHSV[0]! + hueStep)
                if newHue2 > 360 {
                    newHue2 = newHue2 - 360
                }
                
                similarColor1 = findSimilarColorByOffset(hue: newHue1, saturation: colorRef.colorHSV[1]!, value: colorRef.colorHSV[2]!,
                                                         hueOffset: hueOffset, satOffset: saturationOffset, valOffset: valueOffset,
                                                         satClamp: hardnessCardPickerParameters[.easy]!.saturationRange, valueClamp: hardnessCardPickerParameters[.easy]!.valueRange)
                
                similarColor2 = findSimilarColorByOffset(hue: newHue2, saturation: colorRef.colorHSV[1]!, value: colorRef.colorHSV[2]!,
                                                         hueOffset: hueOffset, satOffset: saturationOffset, valOffset: valueOffset,
                                                         satClamp: hardnessCardPickerParameters[.easy]!.saturationRange, valueClamp: hardnessCardPickerParameters[.easy]!.valueRange)
                break
                
            case .normal:
                let hueStep = 60
                let hueOffset = 20
                let saturationOffset = 10
                let valueOffset = 10
            
                var newHue1 = (colorRef.colorHSV[0]! - hueStep)
                if newHue1 > 360 {
                    newHue1 = newHue1 + 360
                }
                var newHue2 = (colorRef.colorHSV[0]! + hueStep)
                if newHue2 > 360 {
                    newHue2 = newHue1 - 360
                }
                
                similarColor1 = findSimilarColorByOffset(hue: newHue1, saturation: colorRef.colorHSV[1]!, value: colorRef.colorHSV[2]!,
                                                         hueOffset: hueOffset, satOffset: saturationOffset, valOffset: valueOffset,
                                                         satClamp: hardnessCardPickerParameters[.normal]!.saturationRange, valueClamp: hardnessCardPickerParameters[.normal]!.valueRange)
                
                similarColor2 = findSimilarColorByOffset(hue: newHue2, saturation: colorRef.colorHSV[1]!, value: colorRef.colorHSV[2]!,
                                                         hueOffset: hueOffset, satOffset: saturationOffset, valOffset: valueOffset,
                                                         satClamp: hardnessCardPickerParameters[.normal]!.saturationRange, valueClamp: hardnessCardPickerParameters[.normal]!.valueRange)
                break
            
            case .hard:
                let hueStep = 20
                let hueOffset = 15
                let saturationOffset = 20
                let valueOffset = 30
                
                var newHue1 = (colorRef.colorHSV[0]! - hueStep)
                if newHue1 < 0 {
                    newHue1 = newHue1 + 360
                }
                var newHue2 = (colorRef.colorHSV[0]! + hueStep)
                if newHue2 > 360 {
                    newHue2 = newHue2 - 360
                }
                
                similarColor1 = findSimilarColorByOffset(hue: newHue1, saturation: colorRef.colorHSV[1]!, value: colorRef.colorHSV[2]!,
                                                         hueOffset: hueOffset, satOffset: saturationOffset, valOffset: valueOffset,
                                                         satClamp: hardnessCardPickerParameters[.hard]!.saturationRange, valueClamp: hardnessCardPickerParameters[.hard]!.valueRange)
                
                similarColor2 = findSimilarColorByOffset(hue: newHue2, saturation: colorRef.colorHSV[1]!, value: colorRef.colorHSV[2]!,
                                                         hueOffset: hueOffset, satOffset: saturationOffset, valOffset: valueOffset,
                                                         satClamp: hardnessCardPickerParameters[.hard]!.saturationRange, valueClamp: hardnessCardPickerParameters[.hard]!.valueRange)
                break
            
            case .hell:
                break
        }
        
        print("new hues: \(similarColor1?.colorHSV[0]), \(similarColor2?.colorHSV[0]); new saturations: \(similarColor1?.colorHSV[1]), \(similarColor2?.colorHSV[1]), new values: \(similarColor1?.colorHSV[2]), \(similarColor2?.colorHSV[2])")
        
        return [similarColor1, similarColor2]
    }
    
    private func findSimilarColorByOffset(hue refHue: Int, saturation satRef: Int, value valueRef: Int,
                                          hueOffset: Int = 30, satOffset: Int = 10, valOffset: Int = 10,
                                          satClamp: ClosedRange<Int> = 0...100, valueClamp: ClosedRange<Int> = 0...100) -> ColorModel? {
        var similarColor: ColorModel?
        var newHue = refHue
        var iterations = 0
        let shuffledColorData = ShuffleCards(cardsArray: colorsData)
        
        repeat {
            iterations += 1

            shuffledColorData.forEach({ color in
                if angleDistance(a: color.colorHSV[0]!, b: newHue) <= hueOffset &&
                    // saturation offsets
                    color.colorHSV[1]! >= (satRef - satOffset).clamped(to: satClamp) &&
                    color.colorHSV[1]! <= (satRef + satOffset).clamped(to: satClamp) &&
                    // value offsets
                    color.colorHSV[2]! >= (valueRef - valOffset).clamped(to: valueClamp) &&
                    color.colorHSV[2]! <= (valueRef + valOffset).clamped(to: valueClamp)
                {
                    similarColor = color
                }
            })
            
            if (similarColor == nil) {
                newHue = Int((Angle.degrees(Double(newHue) - 1)).degrees)
            }
        } while similarColor == nil && iterations < 30

        print("iterations: \(iterations)")
        
        return similarColor
    }
    
    private func findSimilarColorByRange(refHue hue: Int, satRef: Int, satRange: ClosedRange<Int>, valRange: ClosedRange<Int>) -> ColorModel? {
        var newHue = hue
        var similarColor: ColorModel?
        var iterations = 0
        
        repeat {
            iterations += 1
            
            colorsData.forEach({ color in
                if color.colorHSV[0] == newHue &&
                    color.colorHSV[1]! < satRange.upperBound && color.colorHSV[1]! > satRange.lowerBound &&
                    color.colorHSV[2]! > valRange.lowerBound && color.colorHSV[2]! < valRange.upperBound
                {
                    similarColor = color
                }
            })
        
            if (similarColor == nil) {
                newHue = Int((Angle.degrees(Double(newHue) - 1)).degrees)
            }
        } while similarColor == nil && iterations < 30
        
        print("iterations: \(iterations)")
        
        return similarColor
    }
}
