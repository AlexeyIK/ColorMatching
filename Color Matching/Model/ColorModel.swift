//
//  ColorModel.swift
//  Color Matching
//
//  Created by Alexey on 11.07.2021.
//

import Foundation

struct ColorModel: Codable, Hashable, Identifiable {
    var id: Int
    var name: String
    var englishName: String
    var hexCode: String
    var colorRGB: [Int?]
    var colorHSV: [Int?]
}
