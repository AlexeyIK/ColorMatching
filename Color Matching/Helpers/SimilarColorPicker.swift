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
    
    func getSimilarColors(colorRef: ColorModel, for hardness: Hardness, variations: Int = 2,
                          withRef packRef: Bool = false, noClamp: Bool = false, isRussianOnly: Bool = true,
                          useTrueColors: Bool = false) -> [ColorModel] {
        
        var similarColors: [ColorModel] = []
        
//        print("Saturation clamp: \(hardnessCardPickerParameters[hardness]!.saturationRange) | Value clamp: \(hardnessCardPickerParameters[hardness]!.valueRange)")
        
        for i in 0..<variations {
            var hueStep: Int = 0
            var hueOffset: Int = 0
            var saturationOffset: Int = 0
            var valueOffset: Int = 0
            var newHue: Int = 0
            
            let delimiter: Int = Int(ceil(Float(i + 1) / 2))
            
            switch hardness {
                case .easy:
                    hueStep = 90
                    hueOffset = 30 / delimiter
                    saturationOffset = 30
                    valueOffset = 30
                    break
                    
                case .normal:
                    hueStep = 60
                    hueOffset = 20 / delimiter
                    saturationOffset = 20
                    valueOffset = 20
                    break
                
                case .hard:
                    hueStep = 30
                    hueOffset = 15 / delimiter
                    saturationOffset = 10
                    valueOffset = 20
                    break
                
                case .hell:
                    break
            }
//            print("current delimiter: \(delimiter)")
            
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
            
            var colorResult: ColorModel?
            // получаем похожий цвет, если получится
            if useTrueColors {
                let newColorHSV = findTrueSimilarColor(hue: newHue,
                                                       saturation: colorRef.colorHSV[1]!,
                                                       value: colorRef.colorHSV[2]!,
                                                       hueOffset: hueOffset, satOffset: saturationOffset, valOffset: valueOffset,
                                                       satClamp: noClamp ? 0...100 : hardnessCardPickerParameters[hardness]!.saturationRange,
                                                       valueClamp: noClamp ? 0...100 : hardnessCardPickerParameters[hardness]!.valueRange)
                
//                print("new sim color: \(newColorHSV)")
                
                colorResult = ColorModel(id: -variations, name: "-", englishName: "-", hexCode: "", colorRGB: HSVConvertToRGB(newColorHSV), colorHSV: newColorHSV, difficulty: .unknown, isGuessed: false)
            }
            else {
                colorResult = findSimilarColorByOffset(hue: newHue,
                                                     saturation: colorRef.colorHSV[1]!,
                                                     value: colorRef.colorHSV[2]!,
                                                     hueOffset: hueOffset, satOffset: saturationOffset, valOffset: valueOffset,
                                                     satClamp: noClamp ? 0...100 : hardnessCardPickerParameters[hardness]!.saturationRange,
                                                     valueClamp: noClamp ? 0...100 : hardnessCardPickerParameters[hardness]!.valueRange,
                                                     isRussianOnly: isRussianOnly)
            }
            
            // если цвет получен, то добавляем его в выдачу
            if let simColor = colorResult {
//                print("Sim color: \(simColor.colorHSV)")
                similarColors.append(simColor)
            }
        }
        
        if packRef {
            similarColors.append(colorRef)
        }
        
        return similarColors
    }
    
    private func findTrueSimilarColor(hue refHue: Int, saturation satRef: Int, value valueRef: Int,
                                      hueOffset: Int = 30, satOffset: Int = 10, valOffset: Int = 10,
                                      satClamp: ClosedRange<Int> = 0...100, valueClamp: ClosedRange<Int> = 0...100) -> [Int] {
        var rndHue = Int.random(in: refHue - hueOffset...refHue + hueOffset)
        if rndHue < 0 {
            rndHue += 360
        }
        if rndHue > 360 {
            rndHue -= 360
        }
        
        let newHue = rndHue
        let newSaturation = Int.random(in: satRef - satOffset...satRef + satOffset).clamped(to: satClamp)
        let newValue = Int.random(in: valueRef - valOffset...valueRef + valOffset).clamped(to: valueClamp)
        
        return [newHue, newSaturation, newValue]
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
