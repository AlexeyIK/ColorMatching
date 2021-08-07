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
    
    func getSimilarColors(colorRef: ColorModel, for hardness: Hardness, variations: Int = 2, withRef packRef: Bool = false, noClamp: Bool = false, isRussianOnly: Bool = true) -> [ColorModel] {
        
        var similarColors: [ColorModel] = []
        
        for i in 0..<variations {
            var hueStep = 0
            var hueOffset = 0
            var saturationOffset = 0
            var valueOffset = 0
            var newHue = 0
            
            switch hardness {
                case .easy:
                    hueStep = 90
                    hueOffset = 30
                    saturationOffset = 10
                    valueOffset = 10
                    break
                    
                case .normal:
                    hueStep = 60
                    hueOffset = 20
                    saturationOffset = 10
                    valueOffset = 10
                    break
                
                case .hard:
                    hueStep = 30
                    hueOffset = 15
                    saturationOffset = 20
                    valueOffset = 30
                    break
                
                case .hell:
                    break
            }
        
            let delimiter: Int = Int(ceil(Float(i + 1) / 2))
            print("current delimiter: \(delimiter)")
            
            // смотрим не вышло ли значение Hue за рамки от 0 до 360 градусов
            if i % 2 == 0 {
                newHue = colorRef.colorHSV[0]! + hueStep / delimiter
                if newHue > 360 {
                    newHue -= 360
                }
            }
            else {
                newHue = colorRef.colorHSV[0]! - hueStep / delimiter
                if newHue < 0 {
                    newHue += 360
                }
            }
            
            // получаем похожий цвет, если получится
            let colorResult = findSimilarColorByOffset(hue: newHue,
                                                     saturation: colorRef.colorHSV[1]!,
                                                     value: colorRef.colorHSV[2]!,
                                                     hueOffset: hueOffset, satOffset: saturationOffset, valOffset: valueOffset,
                                                     satClamp: noClamp ? 0...100 : hardnessCardPickerParameters[.easy]!.saturationRange,
                                                     valueClamp: noClamp ? 0...100 : hardnessCardPickerParameters[.easy]!.valueRange,
                                                     isRussianOnly: isRussianOnly)
            // если цвет получен, то добавляем его в выдачу
            if let simColor = colorResult {
                similarColors.append(simColor)
            }
        }
        
//        print("new hues: \(similarColor1?.colorHSV[0]), \(similarColor2?.colorHSV[0]); new saturations: \(similarColor1?.colorHSV[1]), \(similarColor2?.colorHSV[1]), new values: \(similarColor1?.colorHSV[2]), \(similarColor2?.colorHSV[2])")
        
        if packRef {
            similarColors.append(colorRef)
        }
        
        return similarColors
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

        if iterations > 5 {
            print("iterations: \(iterations)")
        }
        
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
