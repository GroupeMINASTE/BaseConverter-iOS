//
//  DigiAnalyticsExtension.swift
//  BaseConverter
//
//  Created by Nathan FALLET on 16/05/2021.
//  Copyright © 2021 Nathan FALLET. All rights reserved.
//

import DigiAnalytics

extension DigiAnalytics {
    
    #if DEBUG
    static let shared = DigiAnalytics(baseURL: "https://debug.baseconverter.nathanfallet.me/")
    #else
    static let shared = DigiAnalytics(baseURL: "https://app.baseconverter.nathanfallet.me/")
    #endif
    
}
