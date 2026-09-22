//
//  AdStatsView.swift
//  OsmosAdsDemo
//
// Created by Bhushan Sangale on 21/09/26.
//

import SwiftUI

struct AdStatsView: View {

    let loaded: Int
    let impressions: Int
    let clicks: Int

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("AD ACTIVITY")
                .font(.system(size: 12, weight: .bold))
                .foregroundStyle(AppColors.secondary)
                .tracking(1)

            HStack(spacing: 12) {
                StatCard(
                    icon: "rectangle.on.rectangle",
                    title: "Loaded",
                    value: loaded
                )

                StatCard(
                    icon: "eye",
                    title: "Impressions",
                    value: impressions
                )

                StatCard(
                    icon: "arrow.up.right",
                    title: "Clicks",
                    value: clicks
                )
            }
        }
    }
}
