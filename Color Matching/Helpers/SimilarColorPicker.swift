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
    
    func getSimilarColors(colorRef: ColorModel, for hardness: Hardness, withRef packRef: Bool = false, noClamp: Bool = false, isRussianOnly: Bool = true) -> [ColorModel] {
        
        var result: [ColorModel] = []
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
                                                         satClamp: noClamp ? 0...100 : hardnessCardPickerParameters[.easy]!.saturationRange,
                                                         valueClamp: noClamp ? 0...100 : hardnessCardPickerParameters[.easy]!.valueRange,
                                                         isRussianOnly: isRussianOnly)
                
                similarColor2 = findSimilarColorByOffset(hue: newHue2, saturation: colorRef.colorHSV[1]!, value: colorRef.colorHSV[2]!,
                                                         hueOffset: hueOffset, satOffset: saturationOffset, valOffset: valueOffset,
                                                         satClamp: noClamp ? 0...100 : hardnessCardPickerParameters[.easy]!.saturationRange,
                                                         valueClamp: noClamp ? 0...100 : hardnessCardPickerParameters[.easy]!.valueRange,
                                                         isRussianOnly: isRussianOnly)
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
                                                         satClamp: noClamp ? 0...100 : hardnessCardPickerParameters[.normal]!.saturationRange,
                                                         valueClamp: noClamp ? 0...100 : hardnessCardPickerParameters[.normal]!.valueRange,
                                                         isRussianOnly: isRussianOnly)
                
                similarColor2 = findSimilarColorByOffset(hue: newHue2, saturation: colorRef.colorHSV[1]!, value: colorRef.colorHSV[2]!,
                                                         hueOffset: hueOffset, satOffset: saturationOffset, valOffset: valueOffset,
                                                         satClamp: noClamp ? 0...100 : hardnessCardPickerParameters[.normal]!.saturationRange,
                                                         valueClamp: noClamp ? 0...100 : hardnessCardPickerParameters[.normal]!.valueRange,
                                                         isRussianOnly: isRussianOnly)
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
                                                         satClamp: noClamp ? 0...100 : hardnessCardPickerParameters[.hard]!.saturationRange,
                                                         valueClamp: noClamp ? 0...100 : hardnessCardPickerParameters[.hard]!.valueRange,
                                                         isRussianOnly: isRussianOnly)
                
                similarColor2 = findSimilarColorByOffset(hue: newHue2, saturation: colorRef.colorHSV[1]!, value: colorRef.colorHSV[2]!,
                                                         hueOffset: hueOffset, satOffset: saturationOffset, valOffset: valueOffset,
                                                         satClamp: noClamp ? 0...100 : hardnessCardPickerParameters[.hard]!.saturationRange,
                                                         valueClamp: noClamp ? 0...100 : hardnessCardPickerParameters[.hard]!.valueRange,
                                                         isRussianOnly: isRussianOnly)
                break
            
            case .hell:
                break
        }
        
//        print("new hues: \(similarColor1?.colorHSV[0]), \(similarColor2?.colorHSV[0]); new saturations: \(similarColor1?.colorHSV[1]), \(similarColor2?.colorHSV[1]), new values: \(similarColor1?.colorHSV[2]), \(similarColor2?.colorHSV[2])")
        
        if (similarColor1 != nil) {
            result.append(similarColor1!)
        }
        if (similarColor2 != nil) {
            result.append(similarColor2!)
        }
        if packRef {
            result.append(colorRef)
        }
        
        return result
    }
    
    private func findSimilarColorByOffset(hue refHue: Int, saturation satRef: Int, value valueRef: Int,
                                          hueOffset: Int = 30, satOffset: Int = 10, valOffset: Int = 10,
                                          satClamp: ClosedRange<Int> = 0...100, valueClamp: ClosedRange<Int> = 0...100, isRussianOnly: Bool = true) -> ColorModel? {
        var similarColor: ColorModel?
        var newHue = refHue
        var iterations = 0
        let shuffledColorData = isRussianOnly ? ShuffleCards(cardsArray: colorsData.filter({ $0.name != "" })) : ShuffleCards(cardsArray: colorsData.filter({ $0.englishName != "" }))
        
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

//        print("iterations: \(iterations)")
        
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
        
//        print("iterations: \(iterations)")
        
        return similarColor
    }
}
