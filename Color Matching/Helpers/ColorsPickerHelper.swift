//
//  ColorsPickerHelper.swift
//  Color Matching
//
//  Created by Alexey on 23.07.2021.
//

import Foundation

public class ColorsPickerHelper {
    
    static let shared = ColorsPickerHelper()
    
    func getColors(byHardness hardness: Hardness) -> [ColorModel] {
        
        var pickedCards: [ColorModel] = []
        
        colorsData.forEach { (color) in
            // проверяем, что цвет находится в зонах saturation и value, допустимых для уровня сложности
            if let saturationRange = hardnessCardPickerParameters[hardness]?.saturationRange,
               let valueRange = hardnessCardPickerParameters[hardness]?.valueRange {
                if saturationRange.contains(color.colorHSV[1]!) && valueRange.contains(color.colorHSV[2]!) {
                    pickedCards.append(color)
                }
            }
        }
        
        return pickedCards
    }
}
