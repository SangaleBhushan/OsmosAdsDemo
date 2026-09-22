//
//  AdLoadingView.swift
//  OsmosAdsDemo
//
// Created by Bhushan Sangale on 21/09/26.
//

import SwiftUI

struct AdLoadingView: View {

    var body: some View {
        VStack(spacing: 16) {
            RoundedRectangle(cornerRadius: 18)
                .fill(Color.gray.opacity(0.12))
                .frame(height: 190)
                .shimmer()

            RoundedRectangle(cornerRadius: 6)
                .fill(Color.gray.opacity(0.12))
                .frame(height: 20)

            RoundedRectangle(cornerRadius: 6)
                .fill(Color.gray.opacity(0.10))
                .frame(height: 14)
                .padding(.trailing, 80)
        }
        .padding(16)
        .background(AppColors.card)
        .clipShape(
            RoundedRectangle(cornerRadius: AppRadius.large)
        )
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("Loading advertisements")
    }
}
