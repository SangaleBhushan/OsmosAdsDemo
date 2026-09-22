//
//  AppColors.swift
//  OsmosAdsDemo
//
// Created by Bhushan Sangale on 21/09/26.
//

import SwiftUI

/// Dynamic colors keep the dashboard readable in both light and dark mode.
enum AppColors {

    static let background = Color(uiColor: .systemGroupedBackground)
    static let card = Color(uiColor: .secondarySystemGroupedBackground)
    static let primary = Color(uiColor: .label)
    static let secondary = Color(uiColor: .secondaryLabel)

    static let accent = Color(
        red: 0.32,
        green: 0.25,
        blue: 0.85
    )

    static let success = Color.green
    static let warning = Color.orange
    static let error = Color.red
}
