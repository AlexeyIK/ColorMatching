//
//  ColorsPickerHelper.swift
//  Color Matching
//
//  Created by Alexey on 23.07.2021.
//

import Foundation

public class ColorsPickerHelper {
    
    static let shared = ColorsPickerHelper()
    
    func getColors(byHardness hardness: Hardness, shuffle: Bool = false, excludeBnW: Bool = false) -> [ColorModel] {

        var relevantCards: [ColorModel] = []
        
        switch hardness {
        case .easy:
            relevantCards = colorsData.filter({ 0...1 ~= $0.difficulty.rawValue })
        case .normal:
            relevantCards = colorsData.filter({ 1...2 ~= $0.difficulty.rawValue })
        case .hard:
            relevantCards = colorsData.filter({ 2...3 ~= $0.difficulty.rawValue })
        default:
            relevantCards = colorsData.filter({ $0.difficulty.rawValue == -1 })
        }
        
        relevantCards = relevantCards.filter({ $0.name != "" })
        
        if excludeBnW {
            relevantCards = relevantCards.filter({ $0.hexCode != "ffffff" && $0.hexCode != "000000" })
        }
        
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
