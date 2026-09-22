//
//  StatCard.swift
//  OsmosAdsDemo
//
// Created by Bhushan Sangale on 21/09/26.
//

import SwiftUI

struct StatCard: View {

    let icon: String
    let title: String
    let value: Int

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            Image(systemName: icon)
                .font(.system(size: 18, weight: .semibold))
                .foregroundStyle(AppColors.accent)
                .frame(width: 36, height: 36)
                .background(AppColors.accent.opacity(0.10))
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .accessibilityHidden(true)

            VStack(alignment: .leading, spacing: 3) {
                Text("\(value)")
                    .font(.system(size: 24, weight: .bold))

                Text(title)
                    .font(.system(size: 12, weight: .medium))
                    .foregroundStyle(AppColors.secondary)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(16)
        .background(AppColors.card)
        .clipShape(
            RoundedRectangle(cornerRadius: AppRadius.medium)
        )
        .shadow(
            color: .black.opacity(0.04),
            radius: 10,
            y: 4
        )
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(title): \(value)")
    }
}
