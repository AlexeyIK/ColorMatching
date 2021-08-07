//
//  ColorsPickerHelper.swift
//  Color Matching
//
//  Created by Alexey on 23.07.2021.
//

import Foundation

public class ColorsPickerHelper {
    
    static let shared = ColorsPickerHelper()
    
    func getColors(byHardness hardness: Hardness, shuffle: Bool = false) -> [ColorModel] {

        var relevantCards = colorsData.filter({ hardness == .easy && 0...1 ~= $0.difficulty.rawValue || $0.difficulty.rawValue == hardness.rawValue })
        relevantCards = relevantCards.filter({ $0.name != "" })
        if (shuffle) {
            relevantCards = relevantCards.shuffled()
        }
        
//        relevantCards.forEach { (color) in
//            // проверяем, что цвет находится в зонах saturation и value, допустимых для уровня сложности
//            if let saturationRange = hardnessCardPickerParameters[hardness]?.saturationRange,
//               let valueRange = hardnessCardPickerParameters[hardness]?.valueRange {
//                if saturationRange.contains(color.colorHSV[1]!) && valueRange.contains(color.colorHSV[2]!) {
//                    pickedCards.append(color)
//                }
//            }
//        }
        
        return relevantCards
    }
}
