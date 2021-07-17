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
    var difficulty: Difficulty
    
    enum Difficulty: CustomStringConvertible, Codable, Hashable {
        case base
        case popular
        case hard
        case unreal
        case unknown(value: String)
        
        var description: String {
            switch self {
                case .base:
                    return "базовый"
                case .popular:
                    return "популярный"
                case .hard:
                    return "сложный"
                case .unreal:
                    return "немыслимый"
                default:
                    return "не определена"
            }
        }
        
        init(from decoder: Decoder) throws {
            let container = try decoder.singleValueContainer()
            let value = try? container.decode(String.self)
            switch value {
                case "1": self = .base
                case "2": self = .popular
                case "3": self = .hard
                case "4": self = .unreal
                default: self = .unknown(value: value ?? "-")
            }
        }
        
        func encode(to encoder: Encoder) throws {
            var container = encoder.singleValueContainer()
            switch self {
                case .base: try container.encode("1")
                case .popular: try container.encode("2")
                case .hard: try container.encode("3")
                case .unreal: try container.encode("4")
                default: try container.encode("")
            }
        }
    }
}
