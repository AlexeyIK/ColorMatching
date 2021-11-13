//
//  RequestAppStoreRate.swift
//  HueQueue
//
//  Created by Алексей Кузнецов on 13.11.2021.
//

import StoreKit

enum AppStoreReviewManager {
    static func requestReviewIfAppropriate(window: UIWindowScene) {
        SKStoreReviewController.requestReview(in: window)
    }
}
