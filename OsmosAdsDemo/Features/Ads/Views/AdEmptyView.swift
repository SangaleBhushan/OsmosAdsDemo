//
//  AdEmptyView.swift
//  OsmosAdsDemo
//
// Created by Bhushan Sangale on 21/09/26.
//

import SwiftUI

struct AdEmptyView: View {

    let message: String
    let retry: () -> Void

    init(message: String = "We couldn't load an advertisement right now.",retry: @escaping () -> Void) {
        self.message = message
        self.retry = retry
    }

    var body: some View {
        VStack(spacing: 18) {
            Image(systemName: "rectangle.slash")
                .font(.system(size: 38))
                .foregroundStyle(AppColors.secondary)
                .accessibilityHidden(true)

            VStack(spacing: 6) {
                Text("Ad not available")
                    .font(.system(size: 18, weight: .bold))

                Text(message)
                    .font(.system(size: 13))
                    .foregroundStyle(AppColors.secondary)
                    .multilineTextAlignment(.center)
            }

            Button("Try Again", action: retry)
                .font(.system(size: 14, weight: .semibold))
                .foregroundStyle(AppColors.accent)
        }
        .frame(maxWidth: .infinity)
        .padding(32)
        .background(AppColors.card)
        .clipShape(RoundedRectangle(cornerRadius: AppRadius.large))
    }
}
