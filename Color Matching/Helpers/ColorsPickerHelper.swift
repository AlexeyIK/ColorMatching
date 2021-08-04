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
        
//        var pickedCards: [ColorModel] = []
        
        var relevantCards = colorsData.filter({ $0.difficulty.rawValue <= 1 && hardness == .easy || $0.difficulty.rawValue == hardness.rawValue })
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
