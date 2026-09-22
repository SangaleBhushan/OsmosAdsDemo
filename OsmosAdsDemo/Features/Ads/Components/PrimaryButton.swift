//
//  PrimaryButton.swift
//  OsmosAdsDemo
//
// Created by Bhushan Sangale on 21/09/26.
//

import SwiftUI

struct PrimaryButton: View {

    let title: String
    let icon: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 10) {
                Image(systemName: icon)
                Text(title)
            }
            .font(.system(size: 15, weight: .semibold))
            .foregroundStyle(.white)
            .frame(maxWidth: .infinity)
            .frame(height: 54)
            .background(AppColors.primary)
            .clipShape(
                RoundedRectangle(cornerRadius: AppRadius.medium)
            )
        }
        .buttonStyle(.plain)
        .accessibilityLabel(title)
    }
}
