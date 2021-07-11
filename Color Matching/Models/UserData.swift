//
//  UserData.swift
//  Color Matching
//
//  Created by Alexey on 11.07.2021.
//

import Foundation
import SwiftUI
import Combine

final class UserData: ObservableObject {
    @Published var isShowingFavorites: Bool = false
    @Published var skateparks = skateparkData
}
