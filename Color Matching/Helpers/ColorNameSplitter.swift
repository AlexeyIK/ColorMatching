//
//  ColorNameSplitter.swift
//  HueQueue
//
//  Created by Алексей Кузнецов on 09.11.2021.
//

import Foundation

func SplitNames(_ colorNames: String) -> [String.SubSequence]
{
    return colorNames.split(separator: "/")
}

func GetFirstName(_ colorNames: String) -> String
{
    let names = SplitNames(colorNames)
    
    if names.count > 0 {
        return String(names.first!)
    }
    
    return colorNames
}

func GetRandomName(_ colorNames: String) -> String
{
    let names = SplitNames(colorNames)
    
    if names.count > 1 {
        let randomName = String(names.randomElement()!)
        return randomName
    }
    
    return colorNames
}
