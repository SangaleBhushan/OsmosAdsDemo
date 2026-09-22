//
//  AdCardView.swift
//  OsmosAdsDemo
//
// Created by Bhushan Sangale on 21/09/26.
//

import SwiftUI

struct AdCardView: View {

    let ad: Ad
    let onTap: () -> Void

    private var imageAspectRatio: CGFloat {
        guard ad.width > 0, ad.height > 0 else {
            return 1
        }

        return CGFloat(ad.width) / CGFloat(ad.height)
    }

    var body: some View {

        VStack(alignment: .leading, spacing: 0) {

            // MARK: - Banner

            AsyncImage(url: ad.imageURL) { phase in

                switch phase {

                case .empty:
                    ZStack {
                        Color.gray.opacity(0.08)

                        ProgressView()
                    }

                case .success(let image):
                    image
                        .resizable()
                        .scaledToFit()

                case .failure:
                    ZStack {
                        Color.gray.opacity(0.08)

                        VStack(spacing: 8) {

                            Image(systemName: "photo")
                                .font(.system(size: 26))

                            Text("Image unavailable")
                                .font(.caption)
                        }
                        .foregroundStyle(AppColors.secondary)
                    }

                @unknown default:
                    EmptyView()
                }
            }
            .aspectRatio(
                imageAspectRatio,
                contentMode: .fit
            )
            .frame(maxWidth: .infinity)
            .background(
                Color.gray.opacity(0.06)
            )
            .clipped()
            .accessibilityLabel("Sponsored advertisement")

            // MARK: - Content

            VStack(alignment: .leading, spacing: 12) {

                HStack {

                    Text("SPONSORED")
                        .font(
                            .system(
                                size: 10,
                                weight: .bold
                            )
                        )
                        .tracking(1)
                        .foregroundStyle(
                            AppColors.secondary
                        )

                    Spacer()

                    Image(systemName: "ellipsis")
                        .foregroundStyle(
                            AppColors.secondary
                        )
                        .accessibilityHidden(true)
                }

                Text("Featured Offer")
                    .font(
                        .system(
                            size: 19,
                            weight: .bold
                        )
                    )
                    .foregroundStyle(
                        AppColors.primary
                    )

                Text(
                    "Discover this sponsored offer from OSMOS."
                )
                .font(.system(size: 14))
                .foregroundStyle(
                    AppColors.secondary
                )
                .lineLimit(2)

                Button(action: onTap) {

                    HStack {

                        Text("View Details")
                            .font(
                                .system(
                                    size: 14,
                                    weight: .semibold
                                )
                            )

                        Spacer()

                        Image(
                            systemName: "arrow.up.right"
                        )
                        .font(
                            .system(
                                size: 13,
                                weight: .bold
                            )
                        )
                    }
                    .foregroundStyle(.white)
                    .padding(.horizontal, 16)
                    .frame(height: 46)
                    .frame(maxWidth: .infinity)
                    .background(
                        AppColors.primary
                    )
                    .clipShape(
                        RoundedRectangle(
                            cornerRadius: 12
                        )
                    )
                }
                .buttonStyle(.plain)
                .accessibilityLabel(
                    "View sponsored ad details"
                )
            }
            .padding(16)
        }
        .background(AppColors.card)
        .clipShape(
            RoundedRectangle(
                cornerRadius: AppRadius.large
            )
        )
        .shadow(
            color: .black.opacity(0.07),
            radius: 18,
            y: 8
        )
    }
}
